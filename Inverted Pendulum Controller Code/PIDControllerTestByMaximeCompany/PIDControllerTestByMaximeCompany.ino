#include "TimerOne.h"
/*
Husk at installere bibliotek Sketch installer bibliotek - addlibrary   find zip fil. arduino pakker det ud.
forstÃ¸rrelsesglas giver seriel data,  klik autoscroll fra, og CTRL+A for at markere modtaget data, kopier over i editor.
Husk ESCON(motordriver) bliver reset ved arduino opstart. og sÃ¥fremt den har en error nustillies denne. Dette gÃ¸res af sikerhedshensyn kun ved opstart.
*/
// PWM to ESCON(motor driver) Scaling
// duty cycle <10% = invalid, motor driver will shut down
// duty cycle 10% = -10A
// duty cycle 50% = 0A
// duty cycle 90% = +10A
// duty cycle >90% = invalid, motor driver will shut down
// PWM = 8bit, 0-255,  127/128 = 50
#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5
unsigned long previousMillis = 0;
int squareCount = 0;
int timecount = 0;

int posArm = 0;
int posStick = 0;

float OldposArm = 0;
float OldposStick = 0;
int OldOldposArm = 0;
int OldOldposStick = 0;

float errorThetaA = 0;
float errorDist = 0;
float OlderrorDist = 0;
float olderrorArm = 0;
float oldolderrorArm = 0;
float oldcontroller = 0;

float integral = 0;

float wantedDist = 0;
float setThetaA;


float lastTime = 0;
float controller;
float calcedPWM = 0;
const float mintime = 0.001; // looptime in ms.
float looptime = 0.0;
float setpoint = 377;
float setpointStick = 535;
// Outer loop gain
float pgain = 6.6;
float igain = 0;
float dgain = 1.1;
// Inner loop gain
float pgainInner = 4;
float igainInner = 9;
float dgainInner = 4;


void setup()
{
  // put your setup code here, to run once:
  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(2000);
  Timer1.stop(); // stop the counter
  Timer1.restart(); // set the clock to zero
  pinMode(PWM_PIN, OUTPUT);
  Timer1.pwm(PWM_PIN, 512, 2000); // setup to 500Hz and 50% Duty cycle
  // to change PWM use the following function
  // Timer1.setPwmDuty(PWM_PIN, 512);
  // we setup this pwm signal before enabling the ESCON, sÃ¥ that it gets a valid pwm from the start.
  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, LOW); // disable ESCON to clear any errors
  delay(2000);
  digitalWrite(ENABLE_PIN, HIGH); // enable ESCON
  Serial.begin(57600); // enable serial comm
  previousMillis = millis(); // take initial timestamp.
}

void loop()
{
  // put your main code here, to run repeatedly:
  posArm = analogRead(A0); // read position from potentiometer
  posStick = analogRead(A1);
  // Serial.println(setpoint)
  // Serial.println(pos);        // print for debug
  // Serial.println(posStick);        // print for debug
  // Serial.print(" ,setp : ");
  // Serial.print(setpoint);
  // Controller
  // int errorThetaA = 0;
  // int errorDist = 0;

  //Mapping the value of the potentiometer to degrees
  float MappedPotArm = map(posArm, 88, 669, -90, 90);
  float MappedPotStick = map(posStick, 265, 811, -90, 90); // 263 806
  
  // Converting to radient
  MappedPotArm = (MappedPotArm * 31.415926) / 1800;
  MappedPotStick = (MappedPotStick * 31.415926) / 1800;

  // Determining ThetaS as defeined in the model
  MappedPotStick = MappedPotArm + MappedPotStick;


  // Locking the loop time of the PID
  if ((millis() - lastTime >= mintime*1000)||(lastTime==0))
  {
    looptime=(millis() - lastTime)/1000;
    lastTime=millis();

    // Stick controller yet checked if it works
    //errorDist = wantedDist - ((0.31 * sin(MappedPotArm)) + (0.533 * sin(MappedPotStick))); // Error in distance from 0 radians
    //setThetaA = (pgain * errorDist) + dgain *looptime * (errorDist - OlderrorDist);
    float setThetaA = 0; //Let us first do the PID part

    //Error of the arm
    float errorArm = (-setThetaA - MappedPotArm);

    // First attempt derive an equation from the z-domain
    //controller = -(errorArm * (pgainInner + dgainInner / (looptime)) + olderrorArm * (igainInner - dgainInner * 2 / (0.005) - pgainInner) + oldolderrorArm * dgainInner / (0.005) + oldcontroller);
    
    // Secound attempt parrallel pid
    integral += errorArm*looptime;
    if(integral > 5)
    integral=5;
    if(integral < -5)
    integral=-5;
    float diff=(errorArm - olderrorArm)/looptime;

    controller = pgainInner * errorArm + dgainInner *diff + igainInner * integral;


    // Max Current of the controller
    if (controller >= 9)
      controller = 9;
    if (controller <= -9)
      controller = -9;

    // PWM transformation
    calcedPWM = (512 + ((controller * 512) / 10));

    // Debug
    /*Serial.println("controller");
    Serial.println(controller);*/
    /*Serial.println("looptime");
    Serial.println(looptime*1000);
    Serial.println("PWM");
    Serial.println(calcedPWM);*/
    // Update the ancient values
    OlderrorDist = errorDist;
    olderrorArm = errorArm;
    oldolderrorArm = olderrorArm;
    oldcontroller = controller;
  }

  
  if (posArm < 235 || posArm > 528)
  {
    calcedPWM = 1024 - 512;
  }
  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
  OldposArm = posArm;
  OldposStick = posStick;
}