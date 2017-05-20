%Kørsel af SENSTOOLS:
clear;

%%%% Modeldata og overføringsfunktion:
Km = 0.0296; N = 1/37.04; Jtot = 6.6*10^(-4);
Ra = 0.43; f = 0.000066; Ke = 0.0296;
La = 0.30;
Fg = -1.11; %Hvis minus foran tallet = tyngdekraften stabiliserer armen.

Nummga = [Km*N];
Denmga = [Jtot*Ra f*Ra+Km^2  -Fg*N*La/2*Ra];
Sysmga = tf(Nummga/0.0002838, Denmga/0.0002838)  %tyngdekraft nedad når
                                                   %armen står i nul
                                                   %opad! Ligesom normal
                                                   %opstilling af systemet.
%pole(Sysmga)

%%%% State-Space model, samme som ovenstående.

A = [(f+Km*Ke/Ra)/(-Jtot) Fg*La/(2*Jtot); N 0];
B = [Km/(Ra*Jtot);0];
C = [0 1];
D = 0;

[Num, Den] = ss2tf(A,B,C,D);
SSsys = tf(Num,Den)

%%%% Til check om systemet opfører sig korrekt ved impuls-input
%impulse(SSsys,'r')
%hold on
%impulse(Sysmga,'g')
%hold off


%%% Hent måledata
load measmga3hzb




%%%% Plotning til rapport %%%%

%System baseret på nye SENSTOOLS parametre:
%SysMod=tf([2.816],[0.5345 12.125 5.9237])
SysMod=tf([2.816],[0.6749 5.7989 1.5306])

plot(t,u,'y')
hold on
plot(t,y,'r')
o = lsim(Sysmga,u,t);
p = lsim(SysMod,u,t);
plot(t,o,'g')
plot(t,p,'b')
hold off
xlabel('Tid [sek]');
ylabel('Vinkel [rad], Spænding [V]');
axis([0 30 -7 7]);
legend('Inputsignal','Målt output','Modeloutput','SENSTOOLS model',0);






%Nye SENSTOOLS par0 parametre:
%par0=[0.0002 0.0020 0.0003];

%Parametre fra model:
par0=[Den(1) Den(2) Den(3)]

process = 'mga3hzb'

%Kør SENSTOOLS:
%mainest