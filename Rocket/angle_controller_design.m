clear;
s=tf('s');
K_p=45;

f_t=3;
l_Cg=0.06;
m_r=0.250;
l_Es=0.085;
Tau=0.04;

opt=stepDataOptions('StepAmplitude',2/180*pi);

H=(f_t*l_Cg*1/(m_r*l_Es^2))/s^2;

Servo=1/(s*Tau+1);

C1=(s+2)/(s+1000);
C2=(s+50)/(s+1100);
CTRL=5000*H*Servo*C1*C2;

rlocus(CTRL);
grid on;

S = stepinfo(feedback(CTRL,1),'RiseTimeLimits',[0.05,0.95])
step(feedback(CTRL,1))
%%margin(CTRL);