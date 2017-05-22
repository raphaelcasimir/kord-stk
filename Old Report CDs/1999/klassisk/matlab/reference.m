% ;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- Mode: Matlab -*- ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
% ;; 
% ;; lead.m --- h
% ;; 
% ;; ----------------------------------------------------------------------
% ;; $Locker: schroder $
% ;; $Revision: 1.1 $
% ;; ----------------------------------------------------------------------
% ;; Author          : Claus Schroder
% ;; Created On      : Mon May 24 10:25:54 1999
% ;; Last Modified By: 
% ;; Last Modified On: Wed May 26 13:57:27 1999
% ;; 
% ;; Update Count    : 3
% ;; 
% ;; ----------------------------------------------------------------------
% ;; 
% ;; Publisher  : P6-632
% ;; Project    : Balancerende pind
% ;; 
% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
% Lead-regulering af balancerende pind
% Anvendes også til simulink-modellen lead.mdl

delete leadreg.txt
diary leadreg.txt
clear;
N1=14/40;
N2=12/40;
Jtot=9.98e-4;
B=1.64e-3;
Km=4.97e-2;
Ra=0.98;
Keff=1.3146;

Mp=0.0823;
dp=1;
da=0.2917;
g=9.81;
Ip=(1/12)*Mp*dp^2;

%******************************************************
%        Pindens overføringsfunktion
%******************************************************
nump=[0.5*Mp*da*dp+0.25*Mp*dp^2 0 -0.5*Mp*dp*g];
denp=[Ip-0.25*Mp*dp^2 0 0.5*Mp*dp*g];
nump=nump/denp(1);
denp=denp/denp(1);
sysp=tf(nump,denp);
sysp=(sysp+1);

%******************************************************
%        Nulpunktsplomberng
%******************************************************
numpf=[-29.43];
denpf=[1 0 -29.43];%-14.6909
%numpf=[-11,4640];
%denpf=[1 0 -19.62];
syspf=tf(numpf,denpf);
syspf=syspf;

%******************************************************
%        Motorens overføringsfunktion
%******************************************************
numm=[(Km*Keff)/(B*Ra+Km^2)];
denm=[(Jtot*Ra)/(Ra*B+Km^2) 1];
numm=numm/denm(1);
denm=denm/denm(1);
sysm=tf(numm,denm);

numd=[0.18 6];
dend=[0.03 0];
D=tf(numd,dend);
D=10;
Asys=D*sysm;
Lmsys=feedback(Asys,1);
%transfer gear
numg=N1*(N2^2);
deng=[1 0];
sysg=tf(numg,deng);
%bode(sysg*sysm*sysp)
NMsys=Lmsys*sysg;

P=800;
sysarm=feedback(NMsys*P,1);

%********regulatorer*******
num1=[1 5.4249];
num2=[1 3];
num3=[1 20];
reg1=tf(num1,[1 50]);
reg2=tf(num2,[1 0.001]);
reg3=tf(num3,[1 6.2]);
reg=reg1;
%**********************

%åbensløjfe
system=sysarm*syspf*reg;
rlocus(system*-1)
axis([-20 10 -65 65]);
sgrid(0.7,5.2);

k=-1*rlocfind(system)
[numr,denr]=tfdata(k*reg,'v');
system=k*system;
% lukket sløjfe
clsystem=feedback(system,1);

figure
pzmap(clsystem);
axis([-30 15 -20 20]);
disp('Pole');
pole(clsystem)
disp('Zero');
tzero(clsystem)

figure
margin(system);
[Gm,Pm,wGm, wpm]=margin(system);
k
Pm
figure
impulse(clsystem, 1.5)
kdc=dcgain(clsystem);
[num,den]=tfdata(k*reg,'v');
tf(num,den)
[numd,dend]=c2dm(num,den,0.0125,'zoh');
sysd=tf(numd,dend,0.0125)

diary off





