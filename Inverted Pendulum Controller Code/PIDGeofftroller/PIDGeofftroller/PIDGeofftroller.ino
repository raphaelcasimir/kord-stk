#include <TimerOne.h>
#include <PID_v1.h>

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

// Setup Parameters
float ArmLength = 0.31;
float SmallStickLength = 0.4;
float BigStickLength = 0.8;

// Potentiometers
int Arm = 0;
int Stick = 0;
int OldArm = 0;
int OldStick = 0;

// Time Contants 
unsigned long previousTime;
int SampleTime = 1;       // in Millis

double outMin = -9;
double outMax = 9;       // Output limits 
double kp, ki, kd;       // PID gains
double Input, Output;
double Setpoint = 0;
double ITerm;
double lastInput = 0;

void Initialize()
{
   lastInput = Input;
   ITerm = Output;
   if(ITerm > outMax) ITerm= outMax;
   else if(ITerm < outMin) ITerm= outMin;
}

void SetTunings(double Kp, double Ki, double Kd)
{
  double SampleTimeInSec = ((double)SampleTime)/1000;
   kp = Kp;
   ki = Ki * SampleTimeInSec;
   kd = Kd / SampleTimeInSec;
}
 
void Compute()
{
   unsigned long now = millis();
   int timeChange = (now - lastTime);
   if(timeChange>=SampleTime)
   {
      /*Compute all the working error variables*/
      double error = Setpoint - Input;
      ITerm+= (ki * error);
      if(ITerm > outMax) ITerm= outMax;
      else if(ITerm < outMin) ITerm= outMin;
      double dInput = (Input - lastInput);
 
      /*Compute PID Output*/
      Output = kp * error + ITerm- kd * dInput;
      if(Output > outMax) Output = outMax;
      else if(Output < outMin) Output = outMin;
 
      /*Remember some variables for next time*/
      lastInput = Input;
      lastTime = now;
   }
}

void setup() {
  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(2000);
  Timer1.stop();        //stop the counter
  Timer1.restart();     //set the clock to zero
  pinMode(PWM_PIN, OUTPUT);
  Timer1.pwm(PWM_PIN, 512, 2000);   // setup to 500Hz and 50% Duty cycle


  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, LOW);  // disable ESCON to clear any errors
  delay(2000);
  digitalWrite(ENABLE_PIN, HIGH);  // enable ESCON
  Serial.begin(57600);            // enable serial comm
  previousTime = millis();    // take initial timestamp.
}

void loop() {
  Initialize();
  SetTunings(5,0,0); 
  // Collect position of Arm & Stick
  Arm = analogRead(A0); 
  //Stick = analogRead(A1);
  Stick = 0;
  // Map the value from potentiometer to degrees
  float MapArm = map(Arm, 90, 670, -90 * 3.1415926 * 10, 90 * 3.1415926 * 10);
  MapArm = MapArm / 1800;
  float MapStick = map(Stick, 248, 823, -90 * 3.1415926 * 10, 90 * 3.1415926 * 10);
  MapStick = MapStick / 1800;

  // Determine Input = distance alpha
  Input = ArmLength*sin(MapArm) + (2/3*BigStickLength*sin(MapStick));

  // Calculate Output
  Compute();
  



  
}
