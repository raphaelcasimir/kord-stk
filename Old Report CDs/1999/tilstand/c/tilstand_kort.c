#include "dt2811.h"

#define ARMVINKEL 0
#define PINDVINKEL 1
#define TACHO 2
#define MOTORU 0
#define TACHO_TO_W 34.9065
#define PIND_NUL 0.657689
#define ARM_NUL 1.470465
#define RAD_PR_VOLT_PIND 0.733465
#define RAD_PR_VOLT_ARM 0.6815

static float K[4]={2462.3371, 449.8459, 71.1232, 0.1839};
static float N=12.544;
static float Lr=11.35039;
static float Ke[3]={-10.7169, 0.72458, 0.021524};

static volatile int tick=0;
static void interrupt routine(void);

float tachoToAngelVelocity(float v) {

  return (TACHO_TO_W*v*-1);

}

float pindToAngel(float v) {

  return ((v-PIND_NUL)*RAD_PR_VOLT_PIND);

}

float armToAngel(float v) {

  return ((v-ARM_NUL)*RAD_PR_VOLT_ARM);

}

static void interrupt routine(void) {

  tick++;
  outportb(0x20, 0x20); /* EOI */

}

static int escape(){

  char c;
  if(kbhit()) c = getch();
    else return 0;
  if(c==27) return 1;
    else return 0;

}

void printInput() {
  
  float tacho,arm,pind, lodret;

  tacho=tachoToAngelVelocity( dt2811_getChannel(TACHO) );
  arm=armToAngel( dt2811_getChannel(ARMVINKEL) );
  pind=pindToAngel( dt2811_getChannel(PINDVINKEL) );
  lodret=arm+pind;
  printf("Tachometer = %7.4f  Arm = %7.4f   Pind = %7.4f   Lodret = %7.4f",tacho,arm,pind, lodret);

}

void resetOutput() {

  dt2811_setChannel(MOTORU, 0);

}

void stop() {

  resetOutput();
  uninstallIntrVect();
  printf("\nStop!");
  exit(0);

}

void regulator(){

  static float x1=0,x1e=0,x2e=0,x2m=0,thetaArm,thetaPind,u;

  x1=tachoToAngelVelocity(dt2811_getChannel(TACHO));    /* læser motor hastighed */
  thetaArm=armToAngel(dt2811_getChannel(ARMVINKEL));    /* læser armvinkel */

  /* Nødstop */
  if ( (thetaArm < -2.8) || (thetaArm > 2.8) ) stop();
  
  thetaPind=pindToAngel(dt2811_getChannel(PINDVINKEL)); /* læser pind vinkel */

  x1e=-1/25.7542*(thetaPind + 1.8751*thetaArm);
  x2e=x2m + Lr*x1e;
  u=-(K[0]*x1e+K[1]*x2e+K[2]*thetaArm+K[3]*x1); /* input spændingen til motoren bregnes */

  if (u>0) u+=1.6;  /* kompensering for deadzone */
  if (u<0) u-=1.6;  /* ------------"------------ */
  if (u>5) u=5;
  if (u<-5) u=-5;
  dt2811_setChannel(MOTORU,u);

  x2m=Ke[0]*x1e+Ke[1]*x2e+Ke[2]*thetaArm;
  printf("\n%f", u);

}

void startRegulering() {

  float freq;

  dt2811_init();
  freq=dt2811_setFreq(40);
  printf("\nFrequency = %f", freq);
  installIntrVect(routine);
  while(!escape()){
    if (tick==1) {
      regulator();
      tick--;
    }
    if (tick>1) {
      printf("\nLower sampling frequency!");
      stop();
    }
  }
  uninstallIntrVect();
  resetOutput();

}

int main(){

  printf("\n\nProgram start!");
  startRegulering();
  resetOutput();
  printf("\nClean exit...");
  return 0;

}






















































































































