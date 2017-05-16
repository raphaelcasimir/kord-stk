// Libraries
#include "TimerOne.h"
//PINS
#define PWM_PIN 9
#define ENABLE_PIN 7
#define POTMETERARM A0
#define POTMETERSTICK A1
#define CURRENT_INPUT A5
//Variables
double sampleTime = 500; //in ms

double outerkp = -1, outerki = 0, outerkd = 0; // Outer loop PID controller. All should be negative for Inverted Pendulum
double innerkp = -100, innerki = 0, innerkd = 0; // Inner loop PID controller. All should be negative for Inverted Pendulum

double refArmMax = 0.7, refArmMin = -0.7; //in radians
double refVoltMax = 10*0.8, refVoltMin = -10*0.8; //in voltage

double errorDist, intErrorDist = 0, lastMeasDist = 0;
double errorArm, intErrorArm = 0, lastAngleArm = 0;

double refDist = 0, potArm, potStick, measDist;
double refArm = 0.4, angleArm, angleStick; //In radians
double refVolt = 0;

//Time variables
double now,previous=0;

void calcPID()
{
	// Outer loop controller first
	// Compute error values
	measDist = (0.31 * sin(angleArm)) + (0.533 * sin(angleStick));
	errorDist = refDist - measDist;
	
	intErrorDist += outerki * errorDist; //Integral part
	if(intErrorDist > refArmMax) intErrorDist = refArmMax;
	else if(intErrorDist < refArmMin) intErrorDist = refArmMin;
	
	double dMeasDist = measDist - lastMeasDist; //Derivative part
	
	// Compute output
	/*refArm = outerkp * errorDist + intErrorDist - outerkd * dMeasDist; // Negative derivative. dSet - dMeas = -dMeas when setpoint doesn't change;
	if(refArm > refArmMax) refArm = refArmMax;
	else if(refArm < refArmMin) refArm = refArmMin;*/
	

	// Update previous values
	lastMeasDist = measDist;
	
	// Inner loop controller
	// Compute error values
	errorArm = refArm - angleArm;
	
	intErrorArm += innerki * errorArm; //Integral part
	if(intErrorArm > refVoltMax) intErrorArm = refVoltMax;
	else if(intErrorArm < refVoltMin) intErrorArm = refVoltMin;
	
	double dAngleArm = angleArm - lastAngleArm; //Derivative part
	
	//Compute output
	refVolt = innerkp * errorArm + intErrorArm - innerkd * dAngleArm;
	if(refVolt > refVoltMax) refVolt = refVoltMax;
	else if(refVolt < refVoltMin) refVolt = refVoltMin;
	
	//Update previous values
	lastAngleArm = angleArm;
	
	//Calculate and set output PWM
	double calcedPWM = 512 + refVolt*0.8*360.8/11; // 0.8 motor resistance and PWM sets current.
	Timer1.setPwmDuty(PWM_PIN, calcedPWM);
}

void setup() {
  // setup timerOne, we use this library to get 10bit resolution for PWM.
  Timer1.initialize(2000);
  Timer1.stop();        //stop the counter
  Timer1.restart();     //set the clock to zero
  Timer1.pwm(PWM_PIN, 512, 2000);
  Timer1.attachInterrupt(calcPID, sampleTime);
  noInterrupts();
  
  //PINMODE
  pinMode(PWM_PIN, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  
  //Enable ESCON driver
  digitalWrite(ENABLE_PIN, LOW);  // disable ESCON to clear any errors
  delay(2000);
  digitalWrite(ENABLE_PIN, HIGH);  // enable ESCON
  Serial.begin(9600);
  
  //PID initialization
  outerki = outerki / (sampleTime / 1000.0); outerkd = outerkd / (sampleTime / 1000.0); // kp isn't dependant on the derivative or integral
  innerki = innerki / (sampleTime / 1000.0); innerkd = innerkd / (sampleTime / 1000.0);
  interrupts();
}

void loop() 
{
	now=millis();
	potArm = analogRead(POTMETERARM);
	potStick = analogRead(POTMETERSTICK);
	
	angleArm = ((63.11 * (potArm / 204.8) - 117.39) * 31.415926) / 1800;
	angleStick = angleArm + ((63.88 * (potStick / 204.8) - 170.11) * 31.415926) / 1800;

	//Angle of stick is measured compared to vertical axis but the pot reads in comparison to the arm.

	//to check if it moves
	if (now-previous>=5000){
		refArm=-refArm;
		previous=now;
	}
}