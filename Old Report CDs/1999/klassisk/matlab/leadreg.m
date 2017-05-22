% Regulering af balancerende pind, med lineær model. 

%-------------------------------Konstanter----------------------------------
delete leadlag.txt
diary leadlag.txt
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

%-------------------------Pindens overføringsfunktion-----------------------
nump=[0.5*Mp*da*dp+0.25*Mp*dp^2 0 -0.5*Mp*dp*g];
denp=[Ip-0.25*Mp*dp^2 0 0.5*Mp*dp*g];
nump=nump/denp(1);
denp=denp/denp(1);
sysp=tf(nump,denp);
sysp=(sysp+1);

%---------------------------Nulpunkts plombering----------------------------
numpf=[-29.43];
denpf=[1 0 -29.43];%-14.6909
%numpf=[-11,4640];
%denpf=[1 0 -19.62];
syspf=tf(numpf,denpf);
syspf=syspf;

%--------------------------Motorens overføringsfunktion---------------------
numm=[(Km*Keff)/(B*Ra+Km^2)];
denm=[(Jtot*Ra)/(Ra*B+Km^2) 1];
numm=numm/denm(1);
denm=denm/denm(1);
sysm=tf(numm,denm);

%-------------------------------Motorens regulatorer------------------------
numd=[0.18 6];
dend=[0.03 0];
D=tf(numd,dend);
D=10;
Asys=D*sysm;
Lmsys=feedback(Asys,1);

%-----------------------------Gearets overføingfunktion---------------------
numg=N1*(N2^2);
deng=[1 0];
sysg=tf(numg,deng);
%bode(sysg*sysm*sysp)
NMsys=Lmsys*sysg;

%-----------------------------Hastigheds regulatorer------------------------
P=800;
sysarm=feedback(NMsys*P,1);

%-------------------------------Pindenss regulatorer------------------------
num1=[1 5.4249];
den1=[1 50];
reg=tf(num1,den1);


%-------------------------------Generering af plots------------------------
system=sysarm*syspf*reg;           % Åbensløjfen
rlocus(system*-1)
axis([-20 10 -65 65]);
sgrid(0.7,5.2);

k=-1*rlocfind(system)
[numr,denr]=tfdata(k*reg,'v');
system=k*system;

clsystem=feedback(system,1);      % Lukketsløjfen

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





