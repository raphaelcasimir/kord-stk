clear;clc

%0.0108 rise
%5% overshoot

Hm=tf([148],[1 10]);
Hf=1.31;
Hfm=series(Hm,Hf);

Ki=50;
L_m=tf([193.88 0],[1 10 193.88*Ki]);

rlocus(L_m)
pol_valgt_m=-250;
[Kpm, p_m]=rlocfind(L_m, pol_valgt_m);

disp('----------------')
disp('Kpm-værdien er: ')
Kpm
disp('----------------')
disp(' ')
disp('----------------')
disp(' ')
disp('Polerne ligger i: ')
p_m
disp('----------------')
disp(' ')
disp(' ')


Dm=tf([Kpm Ki],[1 0]);

H_FM=feedback(series(Dm,Hfm),1);

figure(8)
step(H_FM)

disp('################################################################')
disp('Endelig overføringsfunktion for forstærker, motor og regulator : ')
H_FM
disp('################################################################')
armregulator