Kt=0.0293;
Ke=0.0355;
Jm=2.9e-5;
Jgear=0.153e-4;
Ja=10.3e-3;
Js=1.95e-3;
Lm=1.56e-4;
Rm=1.02;
Bm=1.59e-4;
Bgear=1.11e-3;
N=0.3;
La=0.33;
Ls=0.4;
Ms=0.334;
Ma=0.288;
Bas=0;%1e-3;
g=9.8;

%%Transfer Function Creation
	s=tf('s');

%% ThetaA/U parameters

	A=(Jm+Jgear)/N^3+Ls*Ms*La/8-Ja;

	B=((Kt*Ke)/Rm+Bgear+Bm)/N^3;

	C=(-3*g)/(2*Ls)*((Jgear+Jm)/N^3-Ja)-g*La*(Ms/4+Ma);

	D=3*g/(2*Ls*N^3)*(Bgear+Kt*Ke/Rm+Bm);

	E=-3*g^2*La/(4*Ls)*(Ma+Ms);

	Fua=(-Kt/Rm*(s^2-3/2*g/Ls))/(A*s^4+B*s^3+C*s^2+D*s+E)

%% Without ThetaS

	F=(Jm+Jgear)-N^3*Ja;
	G=(Kt*Ke/Rm+Bgear+Bm);
	H=g*La*(Ms+Ma*N^3);
	Fuw=(Kt/Rm)*s/(s^2*F+s*G+H)

%% Wm to Theta A
	Fwa=N^3/s;

%% DistanceAlpha/ThetaA

	Fda=(-La*3*g/(2*Ls))/(s^2-3*g/(2*Ls))


%% Controller Design

	Karm=358;
	Kmotor=1;
	Kstick=22.8;
	ControllerArm=Karm*((1+1*100/(1+100/s)+1/s)+1/s);
	ControllerMotor=Kmotor*((1+0.01*100/(1+100/s)+1/s)+1/s);
	ControllerStick=-Kstick*(1+0.1*100/(1+100/s)+1/s)


%% Full transfer functions of the system
	ControlledSysStick = feedback(ControllerStick*Fda,1)
	ControlledSysArm = feedback(ControllerArm*Fwa,1)
	ControlledSysMotor = feedback(ControllerMotor*Fuw,1)


%% Root locus to simulate diffent controllers
	figure ('Name','Root Locus Motor, Arm & Stick')
		rlocus(ControllerArm*Fwa/Karm);
	hold on;
		rlocus(ControllerStick*Fda/Kstick,'--');
		rlocus(ControllerMotor*Fuw/Kmotor,'o');
	legend('ArmLoop','StickLoop','MotorLoop','Location','southwest')
	hold off;

	figure ('Name','Root Locus Arm');
	hold on
		rlocus(ControllerArm*Fwa/Karm);
	legend('ArmLoop','Location','southwest')
	hold off

	figure ('Name','Root Locus Motor');
	hold on
		rlocus(ControllerMotor*Fwa/Kmotor);
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
	legend('ArmLoop','StickLoop','Location','southwest')
	hold off;

	figure ('Name','Step response Arm&Stick')
		step(ControlledSysArm);
	hold on
		step(ControlledSysStick);
	legend('ArmLoop','StickLoop','Location','southwest')
	hold off

%% Natural frequencies and their influence
	[WnArm,zetaArm] = damp(ControlledSysArm)
	[WnStick,zetaStick] = damp(ControlledSysStick)



% figure ('Name',3)
% margin(60*Fua2*ControllerA)
% figure ('Name',4)
% margin(-Fda)


%pidTuner(Fda)
