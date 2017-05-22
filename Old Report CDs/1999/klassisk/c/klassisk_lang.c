#include "dt2811.h"

#define ARMVINKEL 0
#define PINDVINKEL 1
#define TACHO 2
#define MOTORU 0
#define TACHO_TO_W 0.03
#define PIND_NUL  0.653354
#define ARM_NUL 1.4784
#define RAD_PR_VOLT_PIND 0.7272
#define RAD_PR_VOLT_ARM 0.78539816
#define k 6
#define ka 2
#define Q 0.4167
#define C 0.235         /* Original C=0.4375 */

static volatile int tick=0;
static void interrupt routine(void);

float tachoToAngelVelocity(float v) {

  return (v/TACHO_TO_W);

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

  while(!escape()){
    tacho=tachoToAngelVelocity( dt2811_getChannel(TACHO) );
    arm=armToAngel( dt2811_getChannel(ARMVINKEL) );
    pind=pindToAngel( dt2811_getChannel(PINDVINKEL) );
    lodret=arm+pind;
    printf("\rTachometer = %7.4f  Arm = %7.4f   Pind = %7.4f   Lodret = %7.4f",tacho,arm,pind, lodret);
  }

}

void resetOutput() {

  dt2811_setChannel(MOTORU, 0);

}

void checkAndStop() {

  float arm = 0;

  arm = armToAngel( dt2811_getChannel(ARMVINKEL) );
  if ( (arm > 1.5) || (arm < -1.5) ) {
    resetOutput();
    uninstallIntrVect();
    printf("\nArmvinkel = %f rad. Emergency stop!", arm);
    exit(0);
  }

}

void regulator(){

  float Wm,thetaArm,thetaPind,thetalodret,thetalodretf;
  static float ypind1=0,ypind2=0,e1=0, e2=0;
  static float u=0,e_Wm1=0,yWm1=0;
  float ypind,e_arm,yarm,e_Wm,yWm,e;

  Wm=tachoToAngelVelocity(dt2811_getChannel(TACHO));    /* læser motor hastighed */
  thetaArm=armToAngel(dt2811_getChannel(ARMVINKEL));    /* læser armvinkel */
  thetaPind=pindToAngel(dt2811_getChannel(PINDVINKEL)); /* læser pindvinkel */

  thetalodret=thetaPind+thetaArm; 		        /* pindens vinkel til lodret */
  thetalodretf=thetalodret+(thetaArm*C);

  e=0-thetalodretf;

  /* pind regulator output beregnes */
  ypind = (0.7501*ypind1)-(19.79*e)+(18.97*e1);

  /* gamle vaerdier gemmes */
  e2=e1;
  e1=e;
  ypind1=ypind;
  ypind2=ypind1;

  /* armregulator output beregnes */
  e_arm=ypind-thetaArm;

  yarm=800*e_arm;

  /* vinkelhastigheds regulator output beregnes */
  e_Wm=yarm-(Wm*-1);

  yWm=((e_Wm*k) - (e_Wm1*k) + yWm1 + (Q*k*e_Wm1) - (Q*ka*yWm1) + (Q*ka*u));

  e_Wm1=e_Wm;
  yWm1=yWm;
  
  u=yWm;

  if (u>0) u+=1.6;   /* kompensering for deadzone */
  if (u<0) u-=1.6;   /* -----------"------------- */
  if (u>5) u= 5;      /* -------anti windup------- */
  if (u<-5)u=-5;      /* -----------"------------- */


 dt2811_setChannel(MOTORU,u);
 printf("\r Var=%f", thetaArm);

}

void startRegulering() {

  float freq;

  dt2811_init();
  freq=dt2811_setFreq(80);
  printf("\nFrequency = %f\n", freq);
  installIntrVect(routine);
  while(!escape()){
    if (tick==1) {
      regulator();
      tick--;
    }
    checkAndStop(); /* Nødstop */
    if (tick>1) {
    printf("\nLower sampling frequency!");
    tick=0;
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
