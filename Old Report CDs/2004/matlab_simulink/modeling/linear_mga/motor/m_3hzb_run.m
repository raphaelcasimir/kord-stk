%Kørsel af SENSTOOLS:
clear;

%%%% system fra rapport: motor inkl. påvirkning fra gear+arm %%%%
Fg = 1 % minus hvis tyngdekraft peger nedad -> ustabilt system
Numm = [104.3 0];
Denm = [1 3.187 Fg*6.811];
Sysm = tf(Numm,Denm)

%%%% State-Space model, samme som ovenstående.


%%% Hent måledata
load measm3hzb


%%%% Plotning til rapport %%%%

%System baseret på nye 3hz SENSTOOLS parametre:
%SysMod=tf([2.816],[0.5345 12.125 1])

plot(t,u,'y')
hold on
plot(t,y,'r')
o = lsim(Sysm,u,t);
%p = lsim(SysMod,u,t);
plot(t,o,'g')
%plot(t,p,'b')
hold off
xlabel('Tid [sek]');
ylabel('Vinkelhastighed [rad/sek], Spænding [V]');
axis([0 5 -65 65]);
legend('Inputsignal [V]','Målt output [rad/sek]','Modeloutput [rad/sek]');


%Parametre fra model:
par0=[Denm(1) Denm(2) Denm(3)]

process = 'm3hzb'


%Kør SENSTOOLS:
%mainest