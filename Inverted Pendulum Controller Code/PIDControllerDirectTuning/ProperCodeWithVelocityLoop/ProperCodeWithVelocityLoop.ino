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
#define Lalpha 0.733

//Conversion value
#define analog2digit (1/204.6)

#define deg2rad (31.415926 / 1800.0)
#define avgFactor (2.0/10.0)

#define curr0 512
#define volt2amp 1.0
#define amp2pwm (409.6/11.0)

#define vel0 2.5
#define volt2rpm (3000.0/1.5)
#define rpm2radSec (31.415926/300)

//Mapping value
//These values by were found by curve fitting on geogebra
#define mappingSlopeArm (63.11/204.6)
#define mappingConstArm (117.39)

#define mappingSlopeStick (66.66/204.6)
#define mappingConstStick (170.46)

//Limits for safety
#define refArmMax 0.9
#define refArmMin -0.9

#define refCurrentMin (-11.0)
#define refCurrentMax (11.0)

#define setVelocityMin (-3000.0*rpm2radSec)
#define setVelocityMax (3000.0*rpm2radSec)

// Time constant
#define sampleTime 10000.0 //in micro seconds

//Controller characteristics
#define KpInner -236.0
#define KiInner (-0.0/1000000.0*sampleTime)
#define KdInner (-0.0*1000000.0/sampleTime)

#define gO -12.0
#define zO 3.58
#define pO 17.89

#define gI -1400.0
#define zI 70.0
#define pI 60.0

#define gV 0.4
#define zV 125
#define pV 40

#define KpOuter 0.0
#define KiOuter 0.0
#define KdOuter 0.0

#define KpVel 0.2
#define KpVelFeedBack 1.5
#define KiVel (50/1000000.0*sampleTime)

#define KpCurr 1.1

//Analog reading of the potentiometer
double posStick=0, posArm=0;

//Actual interesting value of the stick and the arm
double distStick, angleArm ,angleStick, dVelocity=0, velocity=0;
double lastDistStick=0, lastAngleArm=0, lastVelocity=0;

//Set point for the controllers
double setPointDist=0, refArm=0, lastRefArm=0, setVelocity=0, lastSetVelocity=0, refCurrent=0, lastRefCurrent=0;

//Controllers state
bool outerState=false, innerState=false;

//Value of the controllers
double intErrorArm=0, 	intErrorDist=0;
double dAngleArm=0, 	ddistStick=0;
double errorArm=0,		errorDist=0;
double errorVelocity=0, intErrorVelocity=0;
double errorCurrent=0;

//PWM signal
int PWM;

void setup()
{
  noInterrupts();
  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(350);
  Timer1.stop();        //stop the counter
  Timer1.restart();     //set the clock to zero
  Timer1.pwm(PWM_PIN, 512, 350);
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
	// Distance for the stick

	distStick = 3*La/(2*1.1) * angleArm + angleStick;

	// Outer loop controller first
	// Compute error values
	errorDist = setPointDist - distStick;
	
	//Integral part
	//intErrorDist += KiOuter * errorDist;
	//Limiting the integral part
	//if(intErrorDist > refArmMax) intErrorDist = refArmMax;
	//else if(intErrorDist < refArmMin) intErrorDist = refArmMin;
	
	//Derivative part
	//ddistStick = distStick - lastDistStick;
	
	// Compute output
	/*refArm = KpOuter * errorDist + intErrorDist - KdOuter * ddistStick; // Negative derivative. dSet - dMeas = -dMeas when setpoint doesn't change;
	if(refArm > refArmMax) refArm = refArmMax;
	else if(refArm < refArmMin) refArm = refArmMin;*/
	refArm = gO*(2*1000000/sampleTime+zO)/(2*1000000/sampleTime+pO)*errorDist + gO*(zO-2*1000000/sampleTime)/(2*1000000/sampleTime+pO)*lastDistStick - (pO-2*1000000/sampleTime)/(2*1000000/sampleTime+pO)*lastRefArm;
	/*if(refArm > refArmMax) refArm = refArmMax;
	else if(refArm < refArmMin) refArm = refArmMin;*/

	// Update previous values
	lastDistStick = errorDist;
	lastRefArm = refArm;
	

	// Inner loop controller
	// Compute error values
	errorArm = refArm - angleArm;
	
	//Integral part
	intErrorArm += KiInner * errorArm;
	//Limiting the integral part
	if(intErrorArm > setVelocityMax) intErrorArm = setVelocityMax;
	else if(intErrorArm < setVelocityMin) intErrorArm = setVelocityMin;
	
	//Derivative part
	dAngleArm = angleArm - lastAngleArm;
	
	//Compute output
	//setVelocity = gI*(2*1000000/sampleTime+zI)/(2*1000000/sampleTime+pI)*errorArm + gI*(zI-2*1000000/sampleTime)/(2*1000000/sampleTime+pI)*lastAngleArm - (pI-2*1000000/sampleTime)/(2*1000000/sampleTime+pI)*lastSetVelocity;
	setVelocity = KpInner * errorArm; //+ intErrorArm - KdInner * dAngleArm;
	if(setVelocity > setVelocityMax) setVelocity = setVelocityMax;
	else if(setVelocity < setVelocityMin) setVelocity = setVelocityMin;


	//Update previous values
	lastAngleArm = errorArm;
	lastSetVelocity=setVelocity;

	//	Velocity loop
	errorVelocity=setVelocity-velocity*KpVelFeedBack;

	//Integral part
	//intErrorVelocity += KiVel * errorVelocity;
	

	// Derivative part
	//dVelocity = velocity - lastVelocity;
	//Limiting the integral part
	if(intErrorVelocity > refCurrentMax) intErrorVelocity = refCurrentMax;
	else if(intErrorVelocity < refCurrentMin) intErrorVelocity = refCurrentMin;

	//Compute output
	//refCurrent = gV*(2*1000000/sampleTime+zV)/(2*1000000/sampleTime+pV)*errorVelocity + gV*(zV-2*1000000/sampleTime)/(2*1000000/sampleTime+pV)*lastVelocity - (pV-2*1000000/sampleTime)/(2*1000000/sampleTime+pV)*lastRefCurrent;
	refCurrent=errorVelocity*KpVel;//+dVelocity*KdVel;
	if(refCurrent > refCurrentMax) refCurrent = refCurrentMax;
	else if(refCurrent < refCurrentMin) refCurrent = refCurrentMin;

	//Update previous values
	lastVelocity=errorVelocity;
	lastRefCurrent=refCurrent;

	//Current loop
	//errorCurrent=refCurrent-current;

	//output
	//setCurrent=KpCurr*errorCurrent;

	//Calculate and set output PWM
	PWM = round(curr0 + refCurrent*amp2pwm); // 0.82 motor resistance and PWM sets current.
	Timer1.setPwmDuty(PWM_PIN,PWM);
}

//Functions to simplify the program
void actualizeFeedbackValue(){
	//Actual current
	//current=(analogRead(CURRENT_INPUT)*analog2digit-2.5)*10/1.5; //10 amp for 1.5

	//Actual angular velocity of the motor
	velocity=((analogRead(VELOCITY_INPUT)&0xFFFC)*analog2digit-2.5)*volt2rpm*rpm2radSec;

	//Actual position of the arm and the stick
	posArm=int(posArm*(1-avgFactor)+analogRead(POTMETERARM)*avgFactor); // 
	posStick=int(posStick*(1-avgFactor)+analogRead(POTMETERSTICK)*avgFactor); // 

	//Mapping the value of the potentiometer to physical value (stick distance and arm angle)
	angleArm = (mappingSlopeArm*posArm-mappingConstArm)*deg2rad;
	angleStick = (mappingSlopeStick*posStick-mappingConstStick)*deg2rad;
	//angle stick relative to the arm so change to it to correspond of the upright angle
	angleStick = angleArm+angleStick;
	Serial.println(angleStick);
}


bool test=true;
double previous=0;
void loop()
{
	actualizeFeedbackValue();
	/*double now=millis();
	//to check if it moves
	if (now-previous>=5000){
		if (test==true) refArm=0.7;
		else refArm=-0.7;
		test=!test;
		previous=now;
	}*/
}





//If jacob solution has problem
/*





//to check if it moves
	if (now-previous>=5000){
		if (test==true) refArm=0.4;
		else refArm=-0.4;
		test=!test;
		previous=now;
	}
#include "PID_v1.h"

//PID ENABLING
PID outerController(&distStick, &refArm, &setPointDist, KpOuter, KiOuter, KdOuter, DIRECT);
PID innerController(&angleArm, &current, &refArm, KpInner, KiInner, KdInner, DIRECT);

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
		refArm = -refArm;
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
