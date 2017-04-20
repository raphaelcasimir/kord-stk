Kt=0.0293;
Ke=0.0355;
Jm=2.9e-5;
Jgear=0.153e-4;
Ja=10.3e-3;
Js=1.95e-3;
Lm=1.56e-4;
Rm=1.02;
Bm=1.59e-4;
Bgear=1.11e-3;
N=0.3;
la=0.33;
Ls=0.4;
Ms=0.334;
Ma=0.288;
Bas=0;%1e-3;
g=9.8;

%%Transfer Function Creation
s=tf('s');

%% Controller
Controller=(1+s)*(6.06217782649108-s)*(6.06217782649107+s)/(6.06217782649107-s)*(6.06217782649107+s)%/(15+s);

%% ThetaA/U parameters

A=(Jm-Jgear)/N^3+Ls*Ms*la/2+Ja;

B=((Kt*Ke)/Rm-Bgear)/N^3-(Ms*g*la*3)/4;

C=(3*g)/(2*Ls)*((Jgear-Jm)/N^3-la*Ma/2)-7/4*Ms*g*la;

D=3*g/(2*Ls)*(Bgear/N^3-Kt*Ke/(Rm*N^3)+3/4*g*Ms*la);

E=3*g*la/(2*Ls)*(Ma/2+g*Ms);

Fua=(1/Rm*Kt*(s^2-3/2*g/Ls))/(A*s^4+B*s^3+C*s^2+D*s+E)

%% ThetaS/ThetaA

Fsa=(3*la*s^2/(2*Ls)+3*Bas*s/(Ms*Ls^2))/(s^2+3*Bas*s/(Ms*Ls^2)-3*g/(2*Ls))

sys=Fua*Fsa

figure (1)
rlocus(sys);

cont=Controller*sys
figure (2)
rlocus(cont)