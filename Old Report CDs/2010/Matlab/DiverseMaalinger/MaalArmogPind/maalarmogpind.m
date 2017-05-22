% Behandling af målinger på vinkelsensor ved arm og pind

Varm = [-13.46 -10.32 -6.15 -1.97 2.26 6.49 10.83];
Aarm = [135 90 45 0 -45 -90 -135];
Vpind = [-7.61 -3.6 0.33 4.37 8.31];
Apind = [90 45 0 -45 -90];

figure(1);
plot(Vpind,Apind,'x');
figure(2);
plot(Varm,Aarm,'x');

aarm = -10.95;
barm = -19.27;

apind = -11.3;
bpind = 4.069;