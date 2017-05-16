#include "TimerOne.h"

//PINS
#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5
#define VELOCITY_INPUT A4

//Physical values
#define La 0.33
#define Lalpha 0.533

//Conversion value
#define analog2volt 204.8

#define deg2rad (31.415926 / 1800.0)
#define avgFactor (2.0/6.0)

#define curr0 512
#define volt2amp 0.82
#define amp2pwm (460.0/10.0)

#define vel0 2.5
#define volt2rpm (6000.0/1.5)
#define rpm2radSec (300/31.415926)

//Mapping value
//These values by were found by curve fitting on geogebra
#define mappingSlopeArm (63.11/204.8)
#define mappingConstArm (117.39)

#define mappingSlopeStick (63.88/204.8)
#define mappingConstStick (170.11)

//Limits for safety
#define setPointThetaAMax 0.7
#define setPointThetaAMin -0.7

#define refVoltMin (-10*0.8)
#define refVoltMax (10*0.8)

// Time constant
#define sampleTime 5000.0 //in micro seconds

//Controller characteristics
#define KpInner -50.0
#define KiInner (-15.0/1000000.0*sampleTime)
#define KdInner (-2.0*1000000.0/sampleTime)

#define KpOuter 0.0
#define KiOuter 0.0
#define KdOuter 0.0

#define KpVel 0.0

#define KpCurr 0.0

//Analog reading of the potentiometer
double posStick=0, posArm=0;

//Actual interesting value of the stick and the arm
double distStick, angleArm ,angleStick;
double lastDistStick=0, lastAngleArm=0;
double velocity=0;
double current=0;

//Set point for the controllers
double setPointDist=0, setPointThetaA=0, setVelocity=0, setCurrent;

//Output current loop
double refVolt;

//Controllers state
bool outerState=false, innerState=false;

//Value of the controllers
double intErrorArm=0, 	intErrorDist=0;
double dAngleArm=0, 	ddistStick=0;
double errorArm=0,		errorDist=0;
double errorVelocity=0;
double errorCurrent=0;

//PWM signal
int PWM;

void setup()
{
  noInterrupts();
  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(200);
  Timer1.stop();        //stop the counter
  Timer1.restart();     //set the clock to zero
  Timer1.pwm(PWM_PIN, 512, 200);
  Timer1.attachInterrupt(calcPID, sampleTime);

  //PINMODE
  pinMode(PWM_PIN, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);

  //Enable ESCON driver
  digitalWrite(ENABLE_PIN, LOW);  // disable ESCON to clear any errors
  delay(2000);
  digitalWrite(ENABLE_PIN, HIGH);  // enable ESCON

  //Serial intialization
  Serial.begin(57600);
  
  //Interrupts start
  interrupts();
}

void calcPID()
{
	// Outer loop controller first
	// Compute error values
	errorDist = setPointDist - distStick;
	
	//Integral part
	intErrorDist += KiOuter * errorDist;
	//Limiting the integral part
	if(intErrorDist > setPointThetaAMax) intErrorDist = setPointThetaAMax;
	else if(intErrorDist < setPointThetaAMin) intErrorDist = setPointThetaAMin;
	
	//Derivative part
	ddistStick = distStick - lastDistStick;
	
	// Compute output
	/*setPointThetaA = KpOuter * errorDist + intErrorDist - KdOuter * ddistStick; // Negative derivative. dSet - dMeas = -dMeas when setpoint doesn't change;
	if(setPointThetaA > setPointThetaAMax) setPointThetaA = setPointThetaAMax;
	else if(setPointThetaA < setPointThetaAMin) setPointThetaA = setPointThetaAMin;*/
	
	// Update previous values
	lastDistStick = distStick;
	

	// Inner loop controller
	// Compute error values
	errorArm = setPointThetaA - angleArm;
	
	//Integral part
	intErrorArm += KiInner * errorArm;
	//Limiting the integral part
	if(intErrorArm > refVoltMax) intErrorArm = refVoltMax;
	else if(intErrorArm < refVoltMin) intErrorArm = refVoltMin;
	
	//Derivative part
	dAngleArm = angleArm - lastAngleArm;
	
	//Compute output
	setVelocity = KpInner * errorArm + intErrorArm - KdInner * dAngleArm;
	if(refVolt > refVoltMax) refVolt = refVoltMax;
	else if(refVolt < refVoltMin) refVolt = refVoltMin;
	
	//Update previous values
	lastAngleArm = angleArm;

	//	Velocity loop
	errorVelocity=setVelocity-velocity;

	//Compute output
	refVolt=KpVel*errorVelocity;

	//Current loop
	errorCurrent=refVolt-current*volt2amp;

	//output
	setCurrent=KpCurr*errorCurrent;

	//Calculate and set output PWM
	PWM = curr0 + int(setCurrent*amp2pwm); // 0.8 motor resistance and PWM sets current.
	Timer1.setPwmDuty(PWM_PIN, 540);
	//Serial.println(setCurrent);
}

//Functions to simplify the program
void actualizeFeedbackValue(){
	//Actual current
	current=analogRead(CURRENT_INPUT);

	//Actual angular velocity of the motor
	velocity=(analogRead(VELOCITY_INPUT)/analog2volt-2.5)*volt2rpm*rmp2radsec;

	//Actual position of the arm and the stick
	posArm=int(posArm*(1-avgFactor)+analogRead(POTMETERARM)*avgFactor);
	posStick=int(posStick*(1-avgFactor)+analogRead(POTMETERSTICK)*avgFactor);

	//Mapping the value of the potentiometer to physical value (stick distance and arm angle)
	angleArm = (mappingSlopeArm*posArm-mappingConstArm)*deg2rad;
	angleStick = (mappingSlopeStick*posStick-mappingConstStick)*deg2rad;
	//angle stick relative to the arm so change to it to correspond of the upright angle
	angleStick = angleArm+angleStick;
	distStick = La * sin(angleArm) + Lalpha * sin(angleStick);
	Serial.println(velocity);
}

bool test=true;
double previous=0;
void loop()
{
	double now=millis();
	actualizeFeedbackValue();
	//to check if it moves
	/*if (now-previous>=15000){
		if (test==true) setPointThetaA=0;
		else setPointThetaA=0.6;
		test=!test;
		previous=now;
	}*/
}





//If jacob solution has problem
/*
#include "PID_v1.h"

//PID ENABLING
PID outerController(&distStick, &setPointThetaA, &setPointDist, KpOuter, KiOuter, KdOuter, DIRECT);
PID innerController(&angleArm, &current, &setPointThetaA, KpInner, KiInner, KdInner, DIRECT);

void setup{
	//PID initialization
  	myPID.SetMode(AUTOMATIC);
  	myPID.SetOutputLimits(-11, 11);
  	myPID.SetSampleTime(5);
  	myPD.SetSampleTime(5);
  	myPD.SetMode(AUTOMATIC);
  	myPD.SetOutputLimits(-0.7, 0.7);
}

void loop(){
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
}*/
