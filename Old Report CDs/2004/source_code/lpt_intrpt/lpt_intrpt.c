#if defined(CONFIG_MODVERSIONS) && ! defined(MODVERSIONS)
   #include <linux/modversions.h> /* Will be explained later */
   #define MODVERSIONS
#endif
#include <linux/kernel.h>  /* We're doing kernel work */
#include <linux/module.h>  /* Specifically, a module  */
#define __NO_VERSION__     /* It's not THE file of the kernel module */
#include <linux/version.h> /* Not included by module.h because of __NO_VERSION__ */

#include <asm/io.h>
#include <asm/delay.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
#include <stdio.h>
#include <unistd.h>
#include <linux/interrupt.h>
#include <linux/ioport.h>

#define LPT_BASE		0x278
#define LPT_DATA		LPT_BASE+0 //Output (DATA)
#define LPT_STATUS		LPT_BASE+1 //Input  (STATUS)
#define LPT_CONTROL		LPT_BASE+2 //Output (Control)
#define	LPT_RANGE		0x8
#define LPT_IRQ         7
#define LPT_MAJOR_NUM   110
#define LPT_DEVICE_NAME	"Samplecontroller"

#define BASE_ADDRESS 0x2E8			//Base Address of I/O-card
#define ADGCR BASE_ADDRESS + 1	

int n_intrpts=0;

struct file_operations LPT_Fops =
{
  NULL,       /* seek    */
  NULL,       /* read    */
  NULL,       /* write   */
  NULL,       /* readdir */  
  NULL,       /* select  */
  NULL,       /* ioctl   */  
  NULL,       /* mmap    */
  NULL,       /* open    */
  NULL,       /* flush   */
  NULL        /* close   */
};

static void lpt_intrpt(int irq, void *dev_id, struct pt_regs *regs)
{
    n_intrpts++;
    //    printk("Regulering nummer: (%d)\n", n_intrpts);
    outb(0x00, ADGCR);	                //Initiate conversion on channel 0 (Gain=1, Channel=0)
}

int __init lpt_start(void)
{
    int base_err = 0, reg_err=0;
    printk("Samplingcontroller loaded\n");
        
    base_err = check_region(LPT_BASE, LPT_RANGE);

    if (base_err != 0)
    {
        printk("Fejl: Porten bliver brugt af andet modult.\n");
    }
    else
    {
        request_region(LPT_BASE, LPT_RANGE, LPT_DEVICE_NAME);
        free_irq(LPT_IRQ, NULL);
        request_irq(LPT_IRQ, lpt_intrpt, SA_SHIRQ, LPT_DEVICE_NAME, "Samplingcontroller");
        reg_err = register_chrdev(LPT_MAJOR_NUM, LPT_DEVICE_NAME, &LPT_Fops);
    }
    outb(0x10, LPT_CONTROL); //Slå IRQ på ACK til   
    return reg_err;
}

void __exit lpt_exit(void)
{
    release_region(LPT_BASE, LPT_RANGE);
    free_irq(LPT_IRQ, "Samplingcontroller");
    unregister_chrdev(LPT_MAJOR_NUM, LPT_DEVICE_NAME); // Driveren fjernes
    printk("Antal interrupts: %d\n", n_intrpts);
    printk("Samplingcontroller unloaded\n");
}

MODULE_LICENSE("GPL");
module_init(lpt_start);
module_exit(lpt_exit);

