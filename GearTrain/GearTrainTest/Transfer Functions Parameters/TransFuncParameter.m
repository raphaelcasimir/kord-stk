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
ls=0.4;
Ms=0.334;
Ma=0.288;
Bas=0;%1e-3;
g=9.8;

%%Transfer Function Creation
s=tf('s');

%% Controller
ControllerA = 6.6+1.1*(100)/(1+100/s);%/(15+s);

ControllerB = 400+25*(100)/(1+100/s)+900/s;

%% ThetaA/U parameters

A=(Jm+Jgear)/N^3+ls*Ms*la/8-Ja;

B=((Kt*Ke)/Rm+Bgear+Bm)/N^3;

C=(-3*g)/(2*ls)*((Jgear+Jm)/N^3-Ja)-g*la*(Ms/4+Ma);

D=3*g/(2*ls*N^3)*(Bgear+Kt*Ke/Rm+Bm);

E=-3*g^2*la/(4*ls)*(Ma+Ms);

Fua=(-Kt/Rm*(s^2-3/2*g/ls))/(A*s^4+B*s^3+C*s^2+D*s+E)

%% Without ThetaS

F=1/N^3*(Jm+Jgear)-Ja+ls*la*Ms/2;
G=1/N^3*(Kt*Ke/Rm+Bgear+Bm);
H=g*la*(Ms+Ma);
Fua2=(Kt/Rm)/(s^2*F+s*G+H)
%% ThetaS/ThetaA

Fsa=(la*3*g/(2*ls))/(s^2-3*g/(2*ls))

sys=Fua2
pidTuner(Fsa)
figure (1)
rlocus(sys);
hold on;
rlocus(-Fsa,'--');
hold off;

cont=Controller*sys
figure (2)
rlocus(ControllerB*sys);
hold on;
cl=feedback((-ControllerA*(ControllerB*Fua2/(1+ControllerB*Fua2))*Fsa),1);
pzmap(cl);
hold off;

% figure (3)
% margin(60*Fua2*ControllerA)
% figure (4)
% margin(-Fsa)