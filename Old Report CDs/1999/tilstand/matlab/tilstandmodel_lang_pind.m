%-----------------------Tilstandsregulering med lang pindmodel dp=1.-------------


clear;
diary on;
format short;

%---------------------------------------Konstanter-------------------------------

N1=14/40;               %Gear 1
N2=12/40;               %Gear 2
Jtot=9.98e-4;           %Totale inertimoment
b=1.64e-3;              %Coloumb friktion
Kemf=4.97e-2;           %Elektro mortoriske kraft
Km=4.97e-2;             %Motor konstant
Ra=0.98;                %Anker modstand
Keff=1.3146;            %Effekt forstaerker


T=0.025;                %Samplingstiden
ref=0;                  %Reference
w0=5.0;                 %Båndbredden

k1=14.69268;            %-B
k2=1.43688;             %-(A-1)
k3=6.41894;             %A*B

%------------------------------Kontinuert tilstandsmodel------------------------------- 
disp('Kontunuert tilstandsmodel')
A=[0 1 0 0; 
  k1 0 1 0; 
  0 0 0 N1*N2^2; 
  0 0 0 -(Kemf*Km/(Ra*Jtot)+b/Jtot)]

B=[0;
   0;
   0;
   (Keff*Km)/(Ra*Jtot)]

C=[-k3 0 -k2 0;1 0 0 0; 0 1 0 0;0 0 1 0;0 0 0 1] %De ekstra output er de enkelte tilstandsvar.

D=[0;0;0;0;0]

%--------------------------------Diskret tilstandsmodel-------------------------------
disp('Diskret tilstandsmodel')
[Phi, Gamma]=c2d(A,B,T)

%---------------------------Polplacering 4. ordens Bessel poler-----------------------
disp('Polplacering med Bessel ploer')
s=[(-0.6573 -j*0.8302) (-0.6573 +j*0.8302) (-0.9047 -j*0.2711) (-0.9047 +j*0.2711)]

ps=w0*s

pz=exp(ps*T)

%----------------------------------Kontroloven u=-Kx-----------------------------------
disp('Kontrolloven')
K=acker(Phi, Gamma, pz)

%----------------------------------Estimator design-------------------------------------
disp('Estimator design')
A_r =[0 1;
      k1 0];

B_r =[0; 1];

[Phi_r, Gamma_r] = c2d(A_r, B_r, T)

pse=mean(real(ps))*3;

pze=exp(pse*T)

Lr=(Phi_r(2,2) -pze)/Phi_r(1,2)

kr1=Phi_r(2,1)-Lr*Phi_r(1,1)
kr2=Phi_r(2,2)-Lr*Phi_r(1,2) 
kr3=Gamma_r(2)-Lr*Gamma_r(1)

%----------------------------------Reference gain N-------------------------------------
disp('Reference gain N')
I=eye(4);
Ntemp=inv([Phi-I Gamma;C(1,:) 0])*[0;0;0;0;1];
Nx=Ntemp(1:4);
Nu=Ntemp(5);
N=Nu+K*Nx


diary off;































































































