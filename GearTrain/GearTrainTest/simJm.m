function  y=simJm(u,t,par)
% y=simktau(u,t,par) simulates K/(1+s*tau) using lsim
% par=[K tau]
% Example: par=[2 3] inputt='inputsq' f1=.02 maintests
%
% 31/10-02,MK

% DC-Motor Parameters
Rm = 0.78;
Lm = 0.2;
Bm = 0.0005;
Kt = 0.027;
Ke = 0.044;

J=par(1);
nc=Kt; dc=[Jm*Lm Jm*Rm+Bm*Lm Bm*Rm+Kt*Ke];
t=[0 t(1:length(t)-1)];
y=lsim(nc,dc,u,t);
