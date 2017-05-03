#include <TimerOne.h>

/*
  Husk at installere bibliotek Sketch installer bibliotek - addlibrary   find zip fil. arduino pakker det ud.
  forstÃ¸rrelsesglas giver seriel data,  klik autoscroll fra, og CTRL+A for at markere modtaget data, kopier over i editor.
  Husk ESCON(motordriver) bliver reset ved arduino opstart. og sÃ¥fremt den har en error nustillies denne. Dette gÃ¸res af sikerhedshensyn kun ved opstart.

*/

//  PWM to ESCON(motor driver) Scaling
//  duty cycle <10% = invalid, motor driver will shut down
//  duty cycle 10% = -10A
//  duty cycle 50% = 0A
//  duty cycle 90% = +10A
//  duty cycle >90% = invalid, motor driver will shut down
//  PWM = 8bit, 0-255,  127/128 = 50


#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5


unsigned long previousMillis = 0;
int squareCount = 0;
int timecount = 0;

int pos = 0;
int posStick = 0;
float Oldpos = 0;
float OldposStick = 0;

int OldOldpos = 0;
int OldOldposStick = 0;

float errorThetaA = 0;
float errorDist = 0;
float OlderrorDist = 0;
float olderrorArm = 0;
float oldolderrorArm = 0;
float oldcontroller = 0;
float integral = 0;

float calcedPWM = 0;

const float looptime = 25;  // looptime in ms.
float setpoint = 380;
float setpointStick = 535;
//Outer loop gain
float pgain = 6.6;
float igain = 0;
float dgain = 1.1;
//Inner loop gain
float pgainInner = 400;
float igainInner = 900;
float dgainInner = 25;

void setup() {
  // put your setup code here, to run once:

  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(2000);
  Timer1.stop();				//stop the counter
  Timer1.restart();			//set the clock to zero
  pinMode(PWM_PIN, OUTPUT);
  Timer1.pwm(PWM_PIN, 512, 2000);   // setup to 500Hz and 50% Duty cycle
  // to change PWM use the following function
  // Timer1.setPwmDuty(PWM_PIN, 512);
  // we setup this pwm signal before enabling the ESCON, sÃ¥ that it gets a valid pwm from the start.

  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, LOW);  // disable ESCON to clear any errors
  delay(2000);
  digitalWrite(ENABLE_PIN, HIGH);  // enable ESCON
  Serial.begin(57600);            // enable serial comm
  previousMillis = millis();    // take initial timestamp.
}


void loop() {

  // put your main code here, to run repeatedly:
  pos = analogRead(A0);  // read position from potentiometer
  posStick = analogRead(A1);

  //Serial.println(setpoint)
  //Serial.println(pos);        // print for debug
  //Serial.println(posStick);        // print for debug
  //Serial.print(" ,setp : ");
  //Serial.print(setpoint);


  //Controller
  //int errorThetaA = 0;
  //int errorDist = 0;
  float MappedPotArm = map(pos, 90, 670, -90 * 3.1415926 * 10, 90 * 3.1415926 * 10);
  MappedPotArm = MappedPotArm / 1800;
  float MappedPotStick = map(posStick, 248, 823, -90 * 3.1415926 * 10, 90 * 3.1415926 * 10);
  MappedPotStick = MappedPotStick / 1800;
  //Serial.println(MappedPotStick);

  //First try - maximefuckovic
  errorDist = 0 - ((0.31 * sin(MappedPotArm)) + (0.533 * sin(MappedPotStick))); // Error in distance from 0 radians
   float setThetaA = (pgain * errorDist) + (dgain / 0.005) * (errorDist - OlderrorDist);
   float errorArm = (-setThetaA - MappedPotArm);
   float controller = errorArm * (pgainInner + dgainInner / (0.005)) + olderrorArm * (igainInner - dgainInner * 2 / (0.005) - pgainInner) + oldolderrorArm * dgainInner / (0.005) + oldcontroller;
    Serial.println(controller);
//  if (controller>=12) controller=12;
//
//  if (controller<=-12) controller=-12;

  // Second try - jacob
//  float setThetaA = errorDist * (pgain + dgain / (looptime/1000.0)) - OlderrorDist * dgain / (looptime/1000.0);
//  float errorArm = (-setThetaA - MappedPotArm);
//  integral = integral+errorArm;
//  if(integral > 1)
//  integral=1;
//  if(integral < -1)
//  integral=-1;
//  float controller = ((pgainInner * errorArm) + (dgainInner / (looptime*0.001) * (errorArm - olderrorArm)) + (igainInner * looptime*0.001 * (errorArm+olderrorArm)));

  calcedPWM = (512 + ((controller * 10) / 512));


  OlderrorDist = errorDist;
  olderrorArm = errorArm;
  oldolderrorArm = olderrorArm;
  // limit pwm til valid range with 90% and 10%
  if (calcedPWM > 916)
    calcedPWM = 916;
  if (calcedPWM < 105)
    calcedPWM = 105;

  // invert signal to make the controller go the other towards center.
  calcedPWM = 1024 - calcedPWM;
   oldcontroller =controller;
  //  if (posStick < 480 ||  posStick > 580)
  //  {
  //     calcedPWM = 1024 - 512;
  //  }
  if (pos < 235 || pos > 528)
  {
    calcedPWM = 1024 - 512;
  }
  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
  Oldpos = pos;
  OldposStick = posStick;
  //  // vent til looptime er gÃ¥et.
  while ((previousMillis + looptime) > millis())
  {
  } // wait
  previousMillis = millis(); // take new timestamp
}
