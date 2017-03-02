clear all;
%% READ MEASURED DATA
[FileA,PathA]=uigetfile('*','Select measured frequency response file');
FullFileA = fullfile(PathA,FileA);
[T V]=textread(FullFileA,'%f%f','headerlines',2);


%% Plotting the current in respect to time
R= 0.01; %Value of the shunt resistor
Ra=0.43; %Value of the internal restor of the DC motor
I=V/R; 
plot (T, I);
xlabel('Time [s]'); ylabel('Current [A]');
axis tight;
grid;


%% Finding tau
AfterStep=20.470600000000000; %value deduced by the mean of the end values used brushing function of matlab to get the data
BeforeStep=-0.357100000000000; %value deduced by the mean of the values before the step

Step=AfterStep-BeforeStep;

[idx idx]=min(abs(I-AfterStep*0.632));

tau=T(idx)-T(1);

%% Findind La

La=tau*Ra*10^6