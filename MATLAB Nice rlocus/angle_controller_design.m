clear;

%%          Initialization

s=tf('s');
K_p=45;

f_t=3;
l_Cg=0.10;   % 0.06
m_r=0.180;
l_Es=0.03;   % 0.085
Tau=0.04;

opt=stepDataOptions('StepAmplitude',2/180*pi);

%%          Transfer functions

H = (f_t*l_Cg*1/(m_r*l_Es^2))/s^2;

Servo = 1/(s*Tau+1);

H1 = H*Servo;
C1 = (s+1.7)/(s+68);
C2 = (s+50)/(s+1100);
D_Rocket = 1*H1*C1;
CTRL = 1*H*Servo*C1*C2;

%%          Root locus / step response / bodeplot

% rlocus(H)
% rlocus(Servo)
% rlocus(H1)
% rlocus(CTRLC1)
% rlocus(CTRL)
% grid on;

% S = stepinfo(feedback(Servo,1),'RiseTimeLimits',[0.05,0.95])
% step(feedback(Servo,1))
% S = stepinfo(feedback(CTRL,1),'RiseTimeLimits',[0.05,0.95])
% step(feedback(CTRL,1))
% margin(CTRL);     %bodeplot


%%          Nice diagrams to use in report

%       Try 1

% semilogx(w/(2*pi),20*log10(abs(high4_max)), 'Linewidth', 4)
%     set(gca,'xscale','log', 'FontSize', 24)
% end
% xlabel('Frequency [Hz]', 'FontSize', 24)
% ylabel('Amplitude [dB]', 'FontSize', 24)
% title('8 digital bandpass filters', 'FontSize', 32)
% legend('20-47', '47-112', '112-267', '267-632', '632-1500', '1500-3557', '3557-8433', '8433-20000')
% set(gca, 'Ylim', [-100 0], 'Xlim', [2 2*10^5])
% grid on

%       Try 2
% 

h=rlocusplot(D_Rocket); 
p=getoptions(h);

% p=pzoptions;

p.ylabel.FontSize = 14;
p.xlabel.FontSize = 14;
p.title.FontSize = 16;
p.title.String = 'Root Locus of the Rocket with a Lead Controller';
p.ticklabel.FontSize = 12;
p.xlim=[-80 5];
p.ylim=[-30 30];

setoptions(h,p);
% h=pzplot(H,p)

axIm = findall(gcf,'String','Imaginary Axis (seconds^{-1})');
axRe = findall(gcf,'String','Real Axis (seconds^{-1})');
set(axIm,'String','Imaginary Axis');
set(axRe,'String','Real Axis');
qq=findall(gcf,'type','line');
qq(end-5).LineWidth=3;
qq(end-4).LineWidth=3;
qq(end-3).LineWidth=3;
qq(end-2).LineWidth=3;
qq(end-1).LineWidth=2;
qq(end-1).MarkerSize=12;
qq(end).LineWidth=2;
qq(end).MarkerSize=12;

%%
%step(feedback(Gre*DLead*8.85,1));
h=stepplot(feedback(D_Rocket*0.404,1));% h=impulseplot(feedback(1,Gre*DLead*8.8*feedback(Garm*900*feedback(Gmotor*1.35,1),1)));
title('Step Response of Rocket with Lead Controller')
p=getoptions(h);
p.ylabel.FontSize = 14;
p.xlabel.FontSize = 14;
p.ticklabel.FontSize = 10;
%p.xlim=[0 0.045];
setoptions(h,p);
qq=findall(gcf,'type','line');
%qq(end-5).LineWidth=3;
%qq(end-4).LineWidth=3;
%qq(end-3).LineWidth=3;
%qq(end-2).LineWidth=3;
qq(end-1).LineWidth=2;
qq(end-1).MarkerSize=12;
qq(end).LineWidth=2;
qq(end).MarkerSize=12;

