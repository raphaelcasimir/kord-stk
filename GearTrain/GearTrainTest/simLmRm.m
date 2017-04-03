function  y=simLmRm(u,t,par)
% y=simktau(u,t,par) simulates K/(1+s*tau) using lsim
% par=[K tau]
% Example: par=[2 3] inputt='inputsq' f1=.02 maintests
%
% 31/10-02,MK

% DC-Motor Parameters

Lm=par(1); Rm=par(2);
nc=[1] ; dc=[Lm Rm];
t=t(1:length(t));
y=lsim(nc,dc,u,t);
