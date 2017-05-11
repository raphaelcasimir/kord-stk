%% This script measures the error produced by using F2 instead of the accurate gimbal angle F1.

clear;
clc;

b=70; % Linking bar length
R1=10; % Servo arm radius
R2=20; % Gimbal arm radius

Max_Servo_Angle=50;

a=[(-Max_Servo_Angle/180)*pi:0.001:(Max_Servo_Angle/180)*pi];

F1=asin( (R1*sin(a)-b+sqrt(b^2-(R1*(1-cos(a))).^2))/R2 ); % Accurate calculation
F2=(R1/R2)*a; % Approximation

plot(a,F1);
hold on;
plot(a,F2);

a=(Max_Servo_Angle/180)*pi;
F1=asin( (R1*sin(a)-b+sqrt(b^2-(R1*(1-cos(a))).^2))/R2 );
F2=(R1/R2)*a;

disp('Error in degrees:');
disp(abs(F1-F2)/pi*180);