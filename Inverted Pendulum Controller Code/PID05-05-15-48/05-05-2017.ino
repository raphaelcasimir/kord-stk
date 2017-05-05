// Libraries
#include <TimerOne.h>
#include <PID_v1.h>
//PINS
#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5
//Variables
double pos = 377;
double posStick = 535;

double setpoint = 381;
double setpointStick = 535;
double setpointRad = 0;
double OutputController = 0, OutputPD = 0;
double calcedPWM;
double errorDist, errorArm;
double pgainLow = 6.6;
double kpPID = 400, kiPID = 900, kdPID = 25;
double kpPD = 6.6, kiPD = 0, kdPD = 1.1;
//PID ENABLING
PID myPD(&errorDist, &OutputPD, &setpointRad, kpPD, kiPD, kdPD, DIRECT);
PID myPID(&errorArm, &OutputController, &OutputPD, kpPID, kiPID, kdPID, DIRECT);


void setup() {
  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(2000);
  Timer1.stop();        //stop the counter
  Timer1.restart();     //set the clock to zero
  Timer1.pwm(PWM_PIN, 512, 2000);
  //PINMODE
  pinMode(PWM_PIN, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  //Enable ESCON driver
  digitalWrite(ENABLE_PIN, LOW);  // disable ESCON to clear any errors
  delay(2000);
  digitalWrite(ENABLE_PIN, HIGH);  // enable ESCON
  Serial.begin(57600);
  //PID initialization
  myPID.SetMode(AUTOMATIC);
  myPID.SetOutputLimits(-404, 404);
  myPID.SetSampleTime(5);
  myPD.SetMode(AUTOMATIC);
  myPD.SetOutputLimits(-10, 10);
  myPD.SetSampleTime(0.01);
}

void loop() {
  pos = analogRead(A0);  // read position from potentiometer
  posStick = analogRead(A1);
  
  //Map to radians
  double MappedPotArm = map(pos, 89, 670, -90, 90);
  MappedPotArm = (MappedPotArm * 31.415926) / 1800;
  double MappedPotStick = map(posStick, 248, 823, -90, 90);
  MappedPotStick = (MappedPotStick * 31.415926) / 1800;
  double MappedPotTotal = MappedPotArm + MappedPotStick;
  //Serial.println(MappedPotTotal);
  errorDist = setpointRad - ((0.31 * sin(MappedPotArm)) + (0.533 * sin(MappedPotTotal))); // Error in distance from 0 radians

  int PDState = myPD.Compute();
  
  if (PDState == 1)
  {
      errorArm = ((-OutputPD) - MappedPotArm);
  }
  //Serial.println(errorArm);
  int PIDState = myPID.Compute(); 
//  if (PIDState == 0 && pos < 380 && pos > 375 && posStick < 538 && pos > 532 )
//  {
//    calcedPWM = 512 - (((setpoint - pos) + (setpointStick - posStick)) * pgainLow);
//    calcedPWM = 1024 - calcedPWM;
//  }
  if (PIDState == 1)
  {
    calcedPWM = 512 + (OutputController);
    calcedPWM = 1024 - calcedPWM;
    PIDState = 0;
  }
  //Stop if more than some degrees
  if (pos < 200 || pos > 570)
  {
    calcedPWM = 512;
  }
  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
}



