%Kørsel af SENSTOOLS:
clear;


%%%% Modeldata og overføringsfunktion:
Km = 0.0296; N = 1/37.04; Jtot = 6.6*10^(-4);
Ra = 0.43; f = 0.000066; Ke = 0.0296;
La = 0.30;
Fg = -1.11; %Hvis minus foran tallet = tyngdekraften stabiliserer armen.

Numm = [Km];
Denm = [Jtot*Ra f*Ra+Km*Km];
Sysm = tf(Numm,Denm)


%%%% State-Space model, samme som ovenstående.


%%% Hent måledata
load measm3hzb1


%%%% Plotning til rapport %%%%

%System baseret på nye 3hz SENSTOOLS parametre:
%SysMod=tf([2.816],[0.5345 12.125 1])

%plot(t,u,'y')
%hold on
%plot(t,y,'r')
%o = lsim(Sysmga,u,t);
%p = lsim(SysMod,u,t);
%plot(t,o,'g')
%plot(t,p,'b')
%hold off
%xlabel('Tid [sek]');
%ylabel('Vinkel [rad], Spænding [V]');
%axis([0 15 -7 7]);
%legend('Inputsignal','Målt output','Modeloutput','SENSTOOLS model',0);

%Parametre fra model:
par0=[Denm(1) Denm(2)]

process = 'm3hzb1'


%Kør SENSTOOLS:
%mainest