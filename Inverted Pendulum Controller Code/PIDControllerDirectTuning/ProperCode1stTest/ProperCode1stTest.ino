#include "TimerOne.h"
#include "PID_v1.h"

//PINS
#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5

//Physical values
#define La 0.33
#define Lalpha 0.533

//Conversion value
#define deg2rad (31.415926 / 1800.0)

//Mapping value
//These values by were found by curve fitting on geogebra
#define mappingSlopeArm (63.11/204.8)
#define mappingConstArm (117.39)

#define mappingSlopeStick (63.88/204.8)
#define mappingConstStick (170.11)

//Analog reading of the potentiometer
double posStick, posArm;

//Actual interesting value of the stick and the arm
double distStick, angleArm ,angleStick;

//Set point for the controllers
double setPointDist=0, setPointThetaA;

//Error for each controller
double errorArm, errorStick;

//Output inner loop
double current;

//Controllers state
bool outerState=false, innerState=false;

//Characteristics of the controllers
double KpInner=0, KpOuter=0;
double KiInner=0, KiOuter=0;
double KdInner=0, KdOuter=0;

//PID ENABLING
PID outerController(&distStick, &setPointThetaA, &setPointDist, KpOuter, KiOuter, KdOuter, DIRECT);
PID innerController(&angleArm, &current, &setPointThetaA, KpInner, KiInner, KdInner, DIRECT);

//PWM signal
int PWM;

void void setup()
{
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

  //PID initialization
  myPID.SetMode(AUTOMATIC);
  myPID.SetOutputLimits(-11, 11);
  myPID.SetSampleTime(5);
  myPD.SetSampleTime(5);
  myPD.SetMode(AUTOMATIC);
  myPD.SetOutputLimits(-0.7, 0.7);

  //Serial intialization
  Serial.begin(57600);
}

//Functions to simplify the program
void actualizeFeedbackValue(){
	//Actual position of the arm and the stick
	posArm = analogRead(A0);
	posStick = analogRead(A1);

	//Mapping the value of the potentiometer to physical value (stick distance and arm angle)
	angleArm = (mappingSlopeArm*posArm-mappingConstArm)*deg2rad; 
	angleStick = (mappingSlopeStick*posStick-mappingConstStick)*deg2rad;
	//angle stick relative to the arm so change to it to correspond of the upright angle
	angleStick = angleArm+angleStick;
	distStick = La * sin(angleArm) + Lalpha * sin(angleStick)
}


void void loop()
{
	actualizeFeedbackValue();

	//Outer loop control
	outerController.compute();
	//Minus the output of the controller
	if (outerState == true){
		setPointThetaA = -setPointThetaA;
	}

	//Inner loop control
	innerState = innerController.compute();
	//Conversion from current to PWM signal
	if (innerState == true){
		PWM = 512+current*512/11;
		//Minus the output
		PWM = 1024-PWM;
	}

	//Mesure so that the arm does not do circles
	if (posArm < 100 || posArm > 750) PWM = 512;

	//Sending the PWM to the controller
	Timer1.setPwmDuty(PWM_PIN, PWM);
}