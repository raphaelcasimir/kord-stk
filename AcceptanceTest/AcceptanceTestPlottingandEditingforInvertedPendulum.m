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

UpLimitStick=0.087222222;
DownLimitStick=-0.087222222;

UpLimitArm=0.785;
DownLimitArm=-0.785;


ArmAngle=deg2rad(ArmAngle.*mappingSlopeArm+mappingConstArm);
AngleStick=deg2rad(AngleStick.*mappingSlopeStick+mappingConstStick)+ArmAngle;

%plot
figure ('Name','AngleArm')
h1=plot(t,ArmAngle,'MarkerSize', 18, 'LineWidth', 3);
hold on;
h2=refline(0,UpLimitArm);
set(h2,'LineStyle','--','MarkerSize',18,'LineWidth',3,'Color','r');
h3=refline(0,DownLimitArm);
set(h3,'LineStyle','--','MarkerSize',18,'LineWidth',3,'Color','r');
h4=refline(0,max(ArmAngle));
set(h4,'LineStyle','--','MarkerSize',18,'LineWidth',2,'Color','b');
h5=refline(0,min(ArmAngle));
set(h5,'LineStyle','--','MarkerSize',18,'LineWidth',2,'Color','b');
xlabel('Time seconds', 'FontSize', 14);
xlabel('Time seconds', 'FontSize', 14);
ylabel('Arm Angle radians', 'FontSize', 14);
ylim([-0.85 0.85]);
title('Angle of the Arm over Time', 'FontSize', 16)
legend([h1 h2 h4],{'Angle of the Arm','Requirement', 'Maximum & Minimum Angle of the Arm'},'FontSize',12)
hold off;
%p=getoptions(h);
%p.ylabel.FontSize = 14;
%p.xlabel.FontSize = 14;
%p.title.FontSize = 16;
%p.title.String = 'Angle of the Arm over the Time';
%p.ticklabel.FontSize = 12;

figure ('Name','AngleStick')
h1=plot(t,AngleStick, 'MarkerSize', 18, 'LineWidth', 3);
hold on;
h2=refline(0,UpLimitStick);
set(h2,'LineStyle','--','MarkerSize',18,'LineWidth',3,'Color','r');
h3=refline(0,DownLimitStick);
set(h3,'LineStyle','--','MarkerSize',18,'LineWidth',3,'Color','r');
h4=refline(0,max(AngleStick));
set(h4,'LineStyle','--','MarkerSize',18,'LineWidth',2,'Color','b');
h5=refline(0,min(AngleStick));
set(h5,'LineStyle','--','MarkerSize',18,'LineWidth',2,'Color','b');
xlabel('Time seconds', 'FontSize', 14);
ylabel('Stick Angle radians', 'FontSize', 14);
ylim([-0.1 0.1]);
title('Angle of the Stick over Time', 'FontSize', 16)
legend([h1 h2 h4],{'Angle of the Stick','Requirement', 'Maximum & Minimum Angle of the Stick'},'FontSize',12)
hold off;