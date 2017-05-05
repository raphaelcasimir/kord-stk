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
double pos = 0;
double posStick = 0;

double setpoint = 377;
double OutputController = 0;
double calcedPWM;
double pgainLow = 3;
double kp = 400, ki = 900, kd = 25;
//PID ENABLING
PID myPID(&pos, &OutputController, &setpoint, kp, ki, kd, DIRECT);

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
  myPID.SetSampleTime(10);
}

void loop() {
  pos = analogRead(A0);  // read position from potentiometer
  int PIDState = myPID.Compute();

  if (PIDState == 0 && pos < 381 && pos > 374)
  {
    calcedPWM = 512 + ((setpoint - pos) * pgainLow);
    calcedPWM = 1024 - calcedPWM;
    Serial.println("test");
  }
  if (PIDState == 1)
  {
    calcedPWM = 512 + (OutputController);
    calcedPWM = 1024 - calcedPWM;
    PIDState = 0;
  }

  //Stop if more than 2136 degrees
  if (pos < 170 || pos > 600)
  {
    calcedPWM = 512;
  }

  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
}



//  if(pos < setpoint)
//  {
//  myPID.SetControllerDirection(DIRECT);
//  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
//  }
//  if(pos > setpoint)
//  {
//  myPID.SetControllerDirection(REVERSE);
//  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
//  }

