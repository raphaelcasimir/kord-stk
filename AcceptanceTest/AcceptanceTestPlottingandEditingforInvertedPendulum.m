clear all;

%% READ MEASURED DATA
[FileA,PathA]=uigetfile('*','Select Acceptance Test data file');
FullFileA = fullfile(PathA,FileA);
[ArmAngle AngleStick]=textread(FullFileA,'%f,%f');

%Crop the last part where the power is cut
ArmAngle=ArmAngle(1:15000);
AngleStick=AngleStick(1:15000);

%% Plot Data
%Time axis 2 ms for each print
t=0:0.002:(length(ArmAngle)-1)*0.002;

%Converting it back from analog value to radians
mappingSlopeArm=(63.11/204.8);
mappingConstArm=(-117.0);

mappingSlopeStick=(66.66/204.8);
mappingConstStick=(-163.9);

UpLimitStick=zeros(length(ArmAngle));
DownLimitStick=zeros(length(ArmAngle));

UpLimitArm=zeros(length(ArmAngle));
DownLimitArm=zeros(length(ArmAngle));

for i=1:length(UpLimitArm)
	UpLimitStick(i)=0.087222222;
	DownLimitStick(i)=-0.087222222;
	UpLimitArm(i)=0.785;
	DownLimitArm(i)=-0.785;
end


ArmAngle=deg2rad(ArmAngle.*mappingSlopeArm+mappingConstArm);
AngleStick=deg2rad(AngleStick.*mappingSlopeStick+mappingConstStick)+ArmAngle;

%plot
figure ('Name','AngleArm')
plot(t,ArmAngle,t,UpLimitArm ,'--', 'MarkerSize', 18, 'LineWidth', 3);
xlabel('Time seconds', 'FontSize', 14);
ylabel('Arm Angle radians', 'FontSize', 14);
ylim([-0.85 0.85]);
title('Angle of the Arm over Time', 'FontSize', 16)
%p=getoptions(h);
%p.ylabel.FontSize = 14;
%p.xlabel.FontSize = 14;
%p.title.FontSize = 16;
%p.title.String = 'Angle of the Arm over the Time';
%p.ticklabel.FontSize = 12;

figure ('Name','AngleStick')
plot(t,AngleStick, 'MarkerSize', 18, 'LineWidth', 3);
xlabel('Time seconds', 'FontSize', 14);
ylabel('Stick Angle radians', 'FontSize', 14);
ylim([-0.1 0.1]);
title('Angle of the Stick over Time', 'FontSize', 16)