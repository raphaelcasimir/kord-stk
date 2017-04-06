Kt=0.0293;
Ke=0.0355;
Jm=2.9e-5;
Jgear=0.153e-3;
Ja=10.3e-3;
Js=1.95e-3;
Lm=1.42e-4;
Rm=1.02;
Bm=1.59e-4;
Bgear=1.11e-3;
N=0.027;
la=0.33;
Ls=0.4;
Ms=0.17;
Ma=0.106;
Bas=0;
g=9.8;

%%Transfer Function Creation
s=tf('s');

%% OmegaM/U parameters

A=-2*Ja*Lm*N+2*Lm*Jm+Lm*Ms*la*Ls*N+2*Lm*Jgear

B=-2*Ja*N*Rm+2*Bm*Lm+2*Jm*Rm+2*Bgear+Jgear*Rm+Ms*N*g*Ls*Rm;

C=Lm*Ms*N*g*Ls*la+Lm*Ma*g*la-Lm*N*Ms*g*Ls+2*Bm*Rm+2*Bgear*Rm+2*Kt*Ke;

D=Ms*N*Rm*g*la*Ls+Ma*N*Rm*g*la-N*Ms*g*Rm*Ls;

Fuo=2*Kt*s/(A*s^3+B*s^2+C*s+D)

%% ThetaA/OmegaM parameters

Foa=N/s

%% ThetaS/ThetaA

Fsa=(-3*la*s^2/(2*Ls)+3*Bas*s/(Ms*Ls^2))/(s^2+3*Bas*s/(Ms*Ls^2)-3*g/(2*Ls))