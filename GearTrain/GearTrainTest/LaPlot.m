clear all;
%% READ MEASURED DATA
[FileA,PathA]=uigetfile('*','Select measured frequency response file');
FullFileA = fullfile(PathA,FileA);
[T V]=textread(FullFileA,'%f,%f','headerlines',2);


%% Plotting the current in respect to time
R= 0.05; %Value of the shunt resistor
Ra=0.8; %Value of the internal restor of the DC motor
I=V/R;
figure
plot (T, I);
%plot(T,V);
xlabel('Time [s]'); ylabel('Current [A]');
axis tight;
grid;


%% Finding tau
AfterStep=4.7; %value deduced by the mean of the end values used brushing function of matlab to get the data
%BeforeStep=-0.357100000000000; %value deduced by the mean of the values before the step

%Step=AfterStep-BeforeStep;

[idx idx]=min(abs(I-AfterStep*0.632));

tau=T(idx)+1.55;

%% Findind La

La=tau*Ra*10^3