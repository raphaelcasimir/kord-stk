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

#include "dt2811.h"

void dt2811_init()
{
	outb(0x00, ADCSR);	//Inittialize I/O-card
	udelay(110);        //Wait min 100 us
	inb(ADDAT_LOW);		//Read both register to clear them plus the A/D done bit
	inb(ADDAT_HIGH);	//
//	outb(0x33, TMRCTR);	//Set internal clock to 100 Hz
//	outb(0x1B, TMRCTR);	//Set internal clock to 200 Hz
//	outb(0x13, TMRCTR);	//Set internal clock to 300 Hz
//	outb(0x0A, TMRCTR);	//Set internal clock to 600 Hz
//	outb(0x15, ADCSR);	//Set I/O-card to MODE 1 (continuos conversion, internal clock, internal trigger, interrupt enable)
	outb(0x14, ADCSR);	//Set I/O-card to MODE 0 (single conversion, interrupt enable)
}

int dt2811_read_ADC()
{
	unsigned char low_byte, high_byte;
	int ret_val;
	low_byte = inb(ADDAT_LOW);
	high_byte = inb(ADDAT_HIGH);
	ret_val = (high_byte * 256) + low_byte;
	return ret_val;
}  

void dt2811_write_DAC(int nDA, int dig_val)
{
	int high_val, low_val;
	int tmp;
	
	tmp = dig_val;
	high_val = (tmp >> 8);
	low_val = (dig_val & 0xFF);
	
	switch(nDA)
	{
	case 0:
		printk("Not yet implemented!\n");
	break;
	case 1:
		outb(low_val, DADAT_LOW);
		outb(high_val, DADAT_HIGH);
	break;
	}
}

//outb(0x11, ADCSR);	//Set I/O-card to MODE 0 (single conversion, internal clock disabled)
//outb(0x14, ADCSR);	//Set I/O-card to MODE 0 (single conversion, internal clock, externel trigger, interrupt enable)
