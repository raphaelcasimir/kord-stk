#include <TimerOne.h>
#include <PID_v1.h>
/*
  Husk at installere bibliotek Sketch installer bibliotek - addlibrary   find zip fil. arduino pakker det ud.
  forstÃ¸rrelsesglas giver seriel data,  klik autoscroll fra, og CTRL+A for at markere modtaget data, kopier over i editor.
  Husk ESCON(motordriver) bliver reset ved arduino opstart. og sÃ¥fremt den har en error nustillies denne. Dette gÃ¸res af sikerhedshensyn kun ved opstart.

*/

//  PWM to ESCON(motor driver) Scaling
//  duty cycle <10% = invalid, motor driver will shut down
//  duty cycle 10% = -11A
//  duty cycle 50% = 0A
//  duty cycle 90% = +11A
//  duty cycle >90% = invalid, motor driver will shut down
//  PWM = 8bit, 0-255,  127/128 = 50


#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5
double pos = 0;
int posStick = 0;
unsigned long previousMillis = 0;
int squareCount = 0;
int timecount = 0;

const long looptime = 5;  // looptime in ms.
double setpoint = 381;
float setpointStick = 535;
float pgain = 5;
double OutputController = 0;
double OutputController2 = 0;
double calcedPWM = 0;

PID myPID(&pos, &OutputController, &setpoint,2,5,1, DIRECT);  
PID myPID2(&pos, &OutputController2, &setpoint,2,5,1, REVERSE); 

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
  myPID.SetMode(AUTOMATIC);
  myPID2.SetMode(AUTOMATIC);
  myPID.SetOutputLimits(0, 512);
  myPID2.SetOutputLimits(0, 512);
}


void loop() {

  // put your main code here, to run repeatedly:
  pos = analogRead(A0);  // read position from potentiometer
//  posStick = analogRead(A1);

  
  //Serial.println(setpoint)
  //Serial.println(pos);        // print for debug
  //Serial.println(posStick);        // print for debug
  //Serial.print(" ,setp : ");
  //Serial.print(setpoint);



  myPID.Compute();
  myPID2.Compute();
   //calcedPWM = 512 + (((setpoint - pos) + (setpointStick - posStick)) * pgain);
   //calcedPWM = 512 + calcedPWM;
  if(OutputController2 > 2)
  {
  calcedPWM = 512 - (OutputController2);
  }
  if(OutputController > 2)
  {
  calcedPWM = 512 - (-OutputController);
  }
  // limit pwm til valid range with 90% and 10%
  if (calcedPWM > 916)
    calcedPWM = 916;
  if (calcedPWM < 105)
    calcedPWM = 105;
  if (pos < 235 || pos > 528)
  {
    calcedPWM = 512;
  }
  // invert signal to make the controller go the other towards center.
  calcedPWM = 1024 - calcedPWM;
  Serial.println(calcedPWM);
  Timer1.setPwmDuty(PWM_PIN, calcedPWM);
  // vent til looptime er gÃ¥et.
  while ((previousMillis + looptime) > millis())
  {} // wait
  previousMillis = millis(); // take new timestamp
}

