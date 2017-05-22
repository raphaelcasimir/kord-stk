%----------------------------------------
%           Motorregulator P            |
%----------------------------------------
clc;clear
pol_valgt=-300;

%Overføringsfunktion for rodkurveplot L_m(s) (Overføringsfunktionen for
%motoren Hmm og forstørker H_f)
Hmm=tf([148],[1 10]);
H_f=1.31;

%Overføringsfunktionen for motor og forstærker til brug i rlocus.
L_m=series(Hmm,H_f)

%Rodkurveplottet laves og derfra vælges kpm vha. rlocfind kommandoen
figure(1)
sgrid('new');
rlocus(L_m);
[Kpm, p_m] = rlocfind(L_m, pol_valgt);

%Overføringsfunktionen for motoren kan nu findes som
%lukketsløjfeoverføringsfuntionen af L_m*Kpm og enhedstilbagekoblingen:
H_FM=feedback(series(L_m, Kpm), 1);

disp ('-------------------------------------')
disp ('      Motor overføringsfunktion      ')
disp ('-------------------------------------')
disp (sprintf('Kpm værdi valgt fra rootlocus: %f\n', Kpm))
H_FM
disp ('-------------------------------------')

armregulator