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
double pos;
double posStick;

double setpoint;
double setpointStick = 547;
double setpointRad = 0;
double OutputController, OutputPD;
double calcedPWM ;
double errorDist = 0, errorArm = 0;
double kpPID = 400, kiPID = 90, kdPID = 10;
double kpPD = 9, kiPD = 16, kdPD = 1;
double oldTime, now;
double MappedPotArm;
//PID ENABLING
PID myPD(&errorDist, &OutputPD, &setpointRad, kpPD, kiPD, kdPD, DIRECT);
PID myPID(&MappedPotArm, &OutputController, &setpoint, kpPID, kiPID, kdPID, DIRECT); //PID myPID(&errorArm, &OutputController, &OutputPD, kpPID, kiPID, kdPID, DIRECT);


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
  myPID.SetOutputLimits(-408, 408);
  myPID.SetSampleTime(10);
  myPD.SetSampleTime(20);
  myPD.SetMode(AUTOMATIC);
  myPD.SetOutputLimits(-0.7, 0.7);

}

void loop() {
  now = millis();
  double x;
  for(int i = 0; i < 10; i++)
  {
    x += analogRead(A0);
  }
  pos = x/10;
  //pos = analogRead(A0);  // read position from potentiometer
  //posStick = analogRead(A1);
  //Serial.println(posStick);
  //Map to radians
  MappedPotArm = ((63.11*(pos/204.8)-117.39) * 31.415926) / 1800;
  double MappedPotStick = ((63.88*(posStick/204.8)-170.11) * 31.415926) / 1800;
  double MappedPotTotal = MappedPotArm + MappedPotStick;
  errorDist = setpointRad - ((0.31 * sin(MappedPotArm)) + (0.533 * sin(MappedPotTotal))); // Error in distance from 0 radians

  int PDState = myPD.Compute();
  if (PDState == 1)
  {
    // errorArm = ((-OutputPD) - MappedPotArm);
    PDState = 0;
  }
  if (now-oldTime > 5000 && now-oldTime < 10000)
  {
    setpoint = -0.3;
  }
  else if(now-oldTime > 10000)
  {
    oldTime=now;
    setpoint=0.3;
  }
  int PIDState = myPID.Compute();
  if (PIDState == 1)
  {
    calcedPWM = 512 + (OutputController);
    calcedPWM = 1024 - calcedPWM;
    PIDState = 0;
    //Serial.println(calcedPWM);
  }

  if (calcedPWM > 916)
    calcedPWM = 916;
  if (calcedPWM < 105)
    calcedPWM = 105;

  if (pos < 100 || pos > 750)
  {
    calcedPWM = 512;
  }
  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
  //  Serial.print("  ");
  //  Serial.println(OutputPD);
}



