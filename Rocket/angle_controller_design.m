clear;

K_p=45;

f_t=3;
l_Cg=0.06;
m_r=0.250;
l_Es=0.085;

opt=stepDataOptions('StepAmplitude',2/180*pi);

Num=f_t*l_Cg*1/(m_r*l_Es^2);
Den=[1 0 0]; %s^2

sys=tf(Num, Den)

sys_cl=feedback(sys,1)

sys_ctrl=0.2*sys_cl*tf([1/99.65 1],[1]) % Adding a d controller

% figure(1);
% rlocus(sys_cl);
% 
% figure(2);
% margin(sys)
% 
step(sys_ctrl,opt);
t=0:0.001:1;
S = stepinfo(sys_ctrl,'RiseTimeLimits',[0.05,0.95])

