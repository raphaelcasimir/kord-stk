clear all;

Kt=0.0293;
Ke=0.0355;
Jm=2.9e-5;
Jgear=0.153e-3;
Ja=10.3e-3;
Js=1.95e-3;
Lm=1.56e-4;
Rm=0.82;
Bm=1.59e-4;
Bgear=1.11e-3;
N=0.3;
La=0.33;
Ls=0.4;
Ms=0.334;
Ma=0.288;
Bas=0;%1e-3;
g=9.8;
Lalpha=2/3*Ls;

%%Transfer Function Creation
	s=tf('s');

%% Without ThetaS

	F=(Jm+Jgear)*Rm;%-N^3*Ja;
	G=(Kt*Ke/Rm+Bgear+Bm)*Rm;
	H=0;%g*La*(Ms+Ma*N^3);
	Fuw=Kt/(s*F+G)

%% Wm to Theta A
	Fwa=N^3/s

%% DistanceAlpha/ThetaA

	Fda=(s^2*(La-Lalpha*3*La/(2*Ls))-La*3*g/(2*Ls))/(s^2-3*g/(2*Ls))


%% Controller Design

	Karm=905;
	Kmotor=10;
	Kstick=8.85;
	ControllerArm=Karm%*(45+s)/(180+s);
	ControllerMotor=Kmotor%*(1+0.1*100/(1+s/100));
	ControllerStick=-Kstick*(6.06+s)/(11.06+s)
	ControllerStickz=tf([-9.07 -31.75],[1 9.27],0.0001)
    


%% Full transfer functions of the system
	ControlledSysMotor = feedback(ControllerMotor*Fuw,1)
	ControlledSysArm = feedback(ControllerArm*ControlledSysMotor*Fwa,1)
	ControlledSysStick = feedback(ControlledSysArm*Fda,ControllerStick)


%% Root locus to simulate diffent controllers
	figure ('Name','Root Locus Motor, Arm & Stick')
		rlocus(ControllerMotor*Fuw/Kmotor);
	hold on;
		rlocus(ControllerArm*ControlledSysMotor*Fwa/Karm,'--');
		rlocus(ControllerStick*ControlledSysArm*Fda/Kstick,'o');
	legend('MotorLoop','ArmLoop','StickLoop','Location','southwest')
	hold off;

	figure ('Name','Root Locus Arm');
	hold on
		rlocus(ControllerArm*ControlledSysMotor*Fwa/Karm);
	legend('ArmLoop','Location','southwest')
	hold off

	figure ('Name','Root Locus Motor');
	hold on
		rlocus(ControllerMotor*Fuw/Kmotor);
	legend('ArmLoop','Location','southwest')
	hold off
	figure ('Name','Root Locus Stick');
	hold on
		rlocus(ControllerStick*Fda/Kstick);
	legend('StickLoop','Location','southwest')
	hold off


%% Poles mapping

	figure ('Name','Actual poles localization Arm&Stick')
		pzmap(ControlledSysArm,'g');
	hold on;
		pzmap(ControlledSysStick,'r');
		pzmap(ControlledSysMotor,'b');
	legend('ArmLoop','StickLoop','MotorLoop' ,'Location','southwest')
	hold off;

%% Step response
	figure ('Name','Step response Arm&Stick')
		step(ControlledSysArm);
	hold on
        step(ControlledSysMotor);
        step(feedback(ControllerStick*feedback(ControllerArm*ControlledSysMotor*Fwa,1)*Fda,1))

	legend('ArmLoop','MotorLoop','whole system' ,'Location','southwest')
	hold off
   
    figure ('Name','disturbance Stick')
    margin(ControlledSysStick);

    figure ('Name','disturbance Stick whole system')
    impulse(feedback(feedback(ControllerArm*ControlledSysMotor*Fwa,1)*Fda,ControllerStick))

%% Natural frequencies and their influence
	[WnArm,zetaArm] = damp(ControlledSysArm)
	[WnStick,zetaStick] = damp(ControlledSysStick)



% figure ('Name',3)
% margin(60*Fua2*ControllerA)
% figure ('Name',4)
% margin(-Fda)


%pidTuner(Fda)


%% Thetas loop try

Fus = Fuw*Fwa*(-3*La/(2*Ls)*s^2/(s^2-3*g/(2*Ls)))

ControllerFus=-(1+0.003*100/(1+100/s)+0.75/s)

figure ('Name','Root Locus thetaS');
rlocus(Fus*ControllerFus)