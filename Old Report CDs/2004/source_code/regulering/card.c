#include <linux/kernel.h>       /* We're doing kernel work */
#include <linux/module.h>       /* Specifically, a module */
#include <linux/init.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
#include <time.h>
#include <linux/interrupt.h>
#include <linux/ioport.h>
#include <asm/io.h>

//#include "ss_itae_bw5.h"        // statespace ITAE bandwidth 5 rad/s
//#include "ss_itae_bw7.h"        // statespace ITAE bandwidth 7 rad/s
//#include "ss_itae_bw2pi.h"        // statespace ITAE bandwidth 2pi rad/s
//#include "ss_lqr_a.h"           // statespace LQR with Q = eye(4)
#include "ss_lqr_b.h"           // statespace LQR iteration
//#include "ss_lqr_c.h"           // statespace LQR iteration2
//#include "ss_lqr_a_long.h"      // statespace LQR iteration long stick

#include "classic_defs.h"
//#include "classic_p.h"
#include "classic_pi.h"
//#include "classic_pi_2.h"
//#include "classic_pi_3.h"

#include "dt2811.h"

static void dt2811_irq_handler(int irq, void *dev_id, struct pt_regs *regs);
static int regulator_classical(float omega_value, float theta_a_value, float theta_p_value, float theta_a_ref);
static int regulator_statespace(float omega_value, float theta_a_value, float theta_p_value, float theta_a_ref);
static int dt2811_open(struct inode *, struct file *);
static int dt2811_release(struct inode *, struct file *);
static ssize_t dt2811_read(struct file *, int *, size_t, loff_t *);
static ssize_t dt2811_write(struct file *, const char *, size_t, loff_t *);

#define DEVICE_NAME "regulator_device"		/* Used to pass values to User Space */
#define BASE_ADDRESS 0x2E8
#define RANGE 10
#define IRQ_NUM 5
#define DEVICE_NAME_MODULE "Regulator"
#define MAJOR_NUM 254

static int sample_data[4];
static int dt2811_is_open=0;
static int channel=0;
static int newsample=0;
int samplenumber=0;
int ad0_val=0, ad1_val=0, ad2_val=0;

int start=0;
float ramp=0.0;
float slope=0.0; //Hældningen på den lineære rampe

int regmode=0;
MODULE_PARM(regmode, "i");

/*----------------------------------------------------------------------------------------
								    Character Device START
----------------------------------------------------------------------------------------*/
/* Funktioner der køres når de respektive filoperationer sker på /dev/regulator_device */
static struct file_operations regulator_fops = {
	.read = dt2811_read, 
	.write = dt2811_write,
	.open = dt2811_open,
	.release = dt2811_release
};
/* Kaldes når read() eksekveres i userspace, på filen /dev/dt2811_buffer */
static ssize_t dt2811_read(struct file *filp, int *buffer, size_t length, loff_t *offset)
{
	int i=0;
	if(newsample==1)
	{
	    for (i=0; i<=length;)
        {
            put_user(sample_data[i], buffer+i);
            i++;
    	}
    	newsample=0;
	}
	return i;
}
/* Kaldes når open() eksekveres i userspace */
static int dt2811_open(struct inode *inode, struct file *file)
{
	if (dt2811_is_open)
	{
		printk("Device already open!\n");
		return -EBUSY;
	}
	dt2811_is_open++;
	MOD_INC_USE_COUNT;
	return 0;
}
/* Kaldes når close() eksekveres i userspace */
static int dt2811_release(struct inode *inode, struct file *file)
{
	dt2811_is_open--;
	MOD_DEC_USE_COUNT;
	return 0;
}
/* Kaldes når write() eksekveres i userspace */
static ssize_t dt2811_write(struct file *filp, const char *buff, size_t len, loff_t *off)
{
	printk("dt2811_write\n");
	printk (" ->Sorry, this operation is not supported.\n");
	return -EINVAL;
}
/*----------------------------------------------------------------------------------------
							     	Character Device END
----------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------------------
										MODUL START
----------------------------------------------------------------------------------------*/
static void dt2811_irq_handler(int irq, void *dev_id, struct pt_regs *regs)
{
    channel++;	

	switch(channel)
	{
	case 1:
	    ad0_val = dt2811_read_ADC()-5;
	    sample_data[0]=ad0_val;
	    outb(0x01, ADGCR);	                  //Initiate conversion on channel 1 (Gain=1, Channel=1)
	break;
	case 2:
	    ad1_val = dt2811_read_ADC();
   	    sample_data[1]=ad1_val;
	    outb(0x02, ADGCR);	                  //Initiate conversion on channel 2 (Gain=1, Channel=2)
	break;
	case 3:
	    ad2_val = dt2811_read_ADC();
   	    sample_data[2]=ad2_val;
   	    sample_data[4]=samplenumber;

   	    samplenumber++;
   	    if((samplenumber==100)) start=1;
   	    if((start==1)) ramp=ramp+slope;
    	if((samplenumber==1000)) samplenumber=1;

	    newsample=1;
		channel=0;
		if(regmode==0) Motor_volt = regulator_classical(ad0_val, ad1_val, ad2_val, ramp);
		if(regmode==1) Motor_volt = regulator_statespace(ad0_val, ad1_val, ad2_val, ramp);
   	    sample_data[3]=Motor_volt;
        dt2811_write_DAC(1, Motor_volt);		
	break;
	}
}

/* Kaldes når modulet insmod'es i kernen */
static int __init card_start(void)
{
	int base_err=0, regerr=0;
	printk("\nClassic regulator loaded\n");
	
	regerr = register_chrdev(MAJOR_NUM, DEVICE_NAME, &regulator_fops);
	printk("Character device 1: /dev/regulator_device c %d 0\n", MAJOR_NUM);
	if (MAJOR_NUM<0) printk ("Registering the character device failed with Major: %d\n", regerr);
	base_err = check_region(BASE_ADDRESS, RANGE);
    if((base_err==0)) printk("Region free\n");
	else printk("Base adress not free, returned %d\n", base_err);
	dt2811_init();										        // Initialize the I/O-card
	request_region(BASE_ADDRESS, RANGE, DEVICE_NAME_MODULE);	// Området beslaglægges  
	free_irq(IRQ_NUM, NULL);							        // Interrruptet frigives
	request_irq(IRQ_NUM, dt2811_irq_handler, SA_SHIRQ, DEVICE_NAME_MODULE, "Classic-controller");
	
    return 0;
}

/* Kaldes når modulet rmmod'es fra kernen */
static void __exit card_exit(void)
{
	int ret;
	ret = unregister_chrdev(MAJOR_NUM, DEVICE_NAME);
	if(ret<0) printk("Fejl i frigoerelse af character device: %d\n", ret);
	release_region(BASE_ADDRESS, RANGE);
	free_irq(IRQ_NUM, "Classic-controller");
	dt2811_write_DAC(1, 2048); //Stop motor
	printk("Classic controller unloaded\n");
}
  
int regulator_classical(float omega_value, float theta_a_value, float theta_p_value, float theta_a_ref)
{
	float omega_m, theta_a, theta_p;					/*values measured on the system*/
	float R_arm, R_m, e_pind, e_arm, e_m, V_out;	/*input and output for the regulators*/
	int V_f_u;
    
	//recalculating from IO-card value to omega_m, theta_a and theta_p
	omega_m=-((10.0/4095.0*omega_value-5.0)/0.0295);
	theta_a=-((theta_a_value-2010.0)*(4.5/5.0)*(6.28319/4095.0));
	theta_p=((theta_p_value-1850.0)*(4.5/5.0)*(6.28319/4095.0))+theta_a+(theta_a*K_ff);
	
	/*first the error on the angle of the stick is calculated*/
	e_pind=(-theta_p);
	
	/*The output of the lead compensator is calculated*/
	//R_arm=(0.4724*R_arm1+K_p*e_pind-0.9789*K_p*e_pind1);   //Lead network for P-regulator
	R_arm=(0.6065*R_arm1+K_p*e_pind-0.9764*K_p*e_pind1);   //Lead network for PI-regulator
	
	/*values is calculated for use in next iteration*/
	R_arm1=R_arm;
	e_pind1=e_pind;
	
    /*The error on the angle is calculated*/
	e_arm=R_arm-theta_a+theta_a_ref;
	
    /*The output from the arm regulator is calculated*/
	R_m=e_arm*K_a;
	
    /*the error on the motors rotation is calculated*/
	e_m=R_m-omega_m;
	
    /*The output from the motor regulator is calculated, (the final output from the regulator) (motorregulator)*/
	//V_f=e_m*K_m; //P-regulator 200Hz
	
    V_f=V_f1+1.438*e_m-1.188*e_m1;            //PI-regulator 200Hz
    V_f_u=V_f;
    if(V_f>5.0*Kaw) V_f=5.0*Kaw;                 //-----------------------//
    if(V_f<-5.0*Kaw) V_f=-5.0*Kaw;               //|Integrator Antiwindup|//
    if((V_f>-5.0*Kaw)&(V_f<5.0*Kaw)) V_f=V_f;    //-----------------------//
    e_m1=e_m;
    V_f1=V_f;

    //the output value V_out is calculated
    V_out=(4095.0/10.0*(V_f+5.0));
    
    V_ud=V_out;
    if(V_out>4095.0) V_ud=4095;
    if(V_out<0.0) V_ud=0;
	return V_ud;
}

int regulator_statespace(float omega_value, float theta_a_value, float theta_p_value, float theta_a_ref)
{   
	// converting IO-card values til radians
	x1=-((10.0/4095.0*omega_value-5.0)/0.0295);              // motorspeed [rad/s]
	x2=-((theta_a_value-2010.0)*(4.5/5.0)*(6.28319/4095.0)); // arm angle [rad]
	y=((theta_p_value-1850.0)*(4.5/5.0)*(6.28319/4095.0));   // arm->pind angle [rad]
	
	// calculating x3 and x4 (reduced order estimator)
	x4=(y-((a-1)*x2))/(-a*b);
	x3=xm + Lr*x4;
	
    // temporary value stored in xm for next sample
    xm=(phi21-Lr*phi11)*x4 + (gam2-Lr*gam1)*x2 +  (phi22 - Lr*phi12)*x3;
	
	// The statespace claculated value to be written to the motor i volts
	u_volt= (-k1*x1 - k2*x2 - k3*x3 - k4*x4)+n_bar*theta_a_ref;
	
	if(u_volt>0) u_volt=u_volt+V_deadzone;
	if(u_volt<0) u_volt=u_volt-V_deadzone;
	
    //the output value V_out is calculated
    u=(4095.0/10.0*(u_volt+5.0));
	
    V_SS = u;
    if(u>4095.0) V_SS=4095;
    if(u<0.0) V_SS=0;
	
	return V_SS;
}

MODULE_LICENSE("GPL");
module_init(card_start);
module_exit(card_exit);

/*
------------------------------------------------------------------------------------------
										MODUL END
------------------------------------------------------------------------------------------
*/

