#include <dos.h>
#include <stdio.h>

#define BASE     0x0218
#define ADCSR    BASE
#define ADGCR    BASE+1
#define ADDAC0L  BASE+2
#define ADDAC0H  BASE+3
#define DAC1L    BASE+4
#define DAC1H    BASE+5
#define TMRCTR   BASE+7

#define HW_INTR 0
#define SW_INTR HW_INTR+8
#define CRYSTAL_FREQ 1193180.0

static void interrupt (*oldIntr)(void);

static int round(float x) {

  if (x-(int)x < 0.5) return (int)x;
  else return (int)x+1;

}

float dt2811_setFreq(float freq) {

  unsigned int timer_denum;
  unsigned char timer_low;
  unsigned char timer_high;

  timer_denum = round(CRYSTAL_FREQ / freq);

  /* Set low and high byte of denumerator */
  timer_low = timer_denum & 0xff;
  timer_high = timer_denum >> 8;

  /* Set 8253 on mode 3 (square wave) and low byte first */
  outportb(0x43, 0x36);

  /* Set timer denumerator */
  outportb(0x40, timer_low);
  outportb(0x40, timer_high);

  /* Return actual frequency */
  return (CRYSTAL_FREQ/timer_denum);

}

void dt2811_init() {

  unsigned char value;

  outportb(ADCSR,0); /* Reset Channel Status Register */
  delay(100); /* Wait */
  inport(ADDAC0L);
  inportb(ADDAC0H);
  inport(DAC1L);
  inportb(DAC1H);
  value = (MODE&3)|0x10;
  outportb(ADCSR, value); /* Set mode, clear error, interrupt */
  printf("\nDT2811 initialized with %xh", value);

}

void dt2811_setChannel(short channel, float value) {

  unsigned int outData;
  unsigned char outDataLow, outDataHigh;
  outData = (unsigned int)( (value+5)*409.5 );
  outDataLow = outData;
  outDataHigh = outData >> 8;

  switch(channel) {
  case 0: outportb(ADDAC0L, outDataLow);
	  outportb(ADDAC0H, outDataHigh);
	  break;
  case 1: outportb(DAC1L, outDataLow);
	  outportb(DAC1H, outDataHigh);
	  break;
  default: printf("\nD/A write error: Illegal channel %d",channel);
  }

}

void installIntrVect( void interrupt (*interruptRoutine)(void) ) {

  disable();
  oldIntr = getvect(SW_INTR); /* save pointer for existing routine */
  setvect(SW_INTR, interruptRoutine); /* Set vector table */
  enable();

}

void uninstallIntrVect() {

  disable();
  setvect(SW_INTR, oldIntr); /* Install old routine */
  outportb(0x40, 0xff); /* Reset timer denumerator */
  outportb(0x40, 0xff);
  enable();

}

static void dt2811_startSampling(int channel) {

  outportb(ADGCR, (GAIN << 6) | (channel & 0xf)); /* Make convertion */

}

float dt2811_getChannel(int channel) {

  unsigned int adcsr;
  unsigned int inData,inDataLow,inDataHigh;

  dt2811_startSampling(channel);
  do
    adcsr = inportb(ADCSR);
  while( !( ((adcsr & 0x80) >> 7) || ((adcsr & 0x40) >> 6) ) );
  if ( !(adcsr & 0xbf) )
    printf("\nA/D read error: Try lowering sample frequency");
  else {
    inDataLow = inportb(ADDAC0L);
    inDataHigh = (inportb(ADDAC0H) << 8) & 0x0f00;
    inData = inDataLow | inDataHigh;
    return (inData/409.5 - 5);
    }

}
