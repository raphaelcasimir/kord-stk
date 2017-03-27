function  y=simJm(u,t,par)
% y=simktau(u,t,par) simulates K/(1+s*tau) using lsim
% par=[K tau]
% Example: par=[2 3] inputt='inputsq' f1=.02 maintests
%
% 31/10-02,MK

% DC-Motor Parameters
Rm = 0.85;
Bm = 0.0005;
Kt = 0.044;
Ke = 0.0046;

Jm=par(1); Lm=par(2);
nc=Kt; dc=[Jm*Lm Jm*Rm+Bm*Lm Bm*Rm+Kt*Ke];
t=t(1:length(t));
y=lsim(nc,dc,u,t);
