% Coloumb-, viskose- og statisk-friktion
% Anvendes sammen med maal.m

maal;
Kemf = 0.036;
omega= tach*((2*pi*1000)/180);

Uemf=Kemf*omega;

T=Ia*Kemf;
Ua=volt-Ia-Uemf;
t=[1000];
plot(omega,T);
grid;


xlabel('Vinkelhastighed [rad/sek]')
ylabel('Motormoment [Nm]')
title('Statisk-, coloumb- og viskosefriktion')


