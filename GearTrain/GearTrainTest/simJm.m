function  y=simJm(u,t,par)
% y=simktau(u,t,par) simulates K/(1+s*tau) using lsim
% par=[K tau]
% Example: par=[2 3] inputt='inputsq' f1=.02 maintests
%
% 31/10-02,MK

% DC-Motor Parameters
Rm = 1.02;
Kt = 1.00;
Ke = 1.34;
Lm = 1.42E-04;
Bm = 0.67;

Jm=par(1);
nc=Kt; dc=[Jm*Lm Jm*Rm+Bm*Lm Bm*Rm+Kt*Ke];
t=t(1:length(t));
y=lsim(nc,dc,u,t);
