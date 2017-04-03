function  y=simJm(u,t,par)
% y=simktau(u,t,par) simulates K/(1+s*tau) using lsim
% par=[K tau]
% Example: par=[2 3] inputt='inputsq' f1=.02 maintests
%
% 31/10-02,MK

% DC-Motor Parameters
Rm = 1.02;
Kt = 0.025;
Ke = 0.0343;
Lm = 1.42E-04;
Bm = 1.2e-4;
Jm=2.9e-5;

Jgear=1.53e-1;
N=12/40;

Bgear=par(1); %Jgear=par(2);
nc=Kt; dc=[Jgear*Lm Lm*(Bgear*(N^2+N^3+N^4)+Jm+Jgear*Rm) ((Bgear*(N^2+N^3+N^4)+Jm)*Rm+Bm*Lm)* Bm*Rm+Kt*Ke];
t=t(1:length(t));
y=lsim(nc,dc,u,t);
