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
C1 = (s+2)/(s+1000);
C2 = (s+50)/(s+1100);
CTRLC1 = 1*H*Servo*C1;
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

h=rlocusplot(H1); 
p=getoptions(h);

% p=pzoptions;

p.ylabel.FontSize = 14;
p.xlabel.FontSize = 14;
p.title.FontSize = 16;
p.title.String = 'Root Locus of the Rocket Angle with Servomotors';
p.ticklabel.FontSize = 12;
p.xlim=[-30 15];
p.ylim=[-45 45];

setoptions(h,p);
% h=pzplot(H,p)

axIm = findall(gcf,'String','Imaginary Axis (seconds^{-1})');
axRe = findall(gcf,'String','Real Axis (seconds^{-1})');
set(axIm,'String','Imaginary Axis');
set(axRe,'String','Real Axis');
qq=findall(gcf,'type','line');
% qq(end-5).LineWidth=3;
qq(end-4).LineWidth=3;
qq(end-3).LineWidth=3;
qq(end-2).LineWidth=3;
qq(end-1).LineWidth=2;
qq(end-1).MarkerSize=18;
qq(end).LineWidth=2;
qq(end).MarkerSize=18;