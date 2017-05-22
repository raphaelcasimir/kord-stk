%----------------------------------------
%           Motorregulator P            |
%----------------------------------------
clc;clear
pol_valgt=-300;

%Overf�ringsfunktion for rodkurveplot L_m(s) (Overf�ringsfunktionen for
%motoren Hmm og forst�rker H_f)
Hmm=tf([148],[1 10]);
H_f=1.31;

%Overf�ringsfunktionen for motor og forst�rker til brug i rlocus.
L_m=series(Hmm,H_f)

%Rodkurveplottet laves og derfra v�lges kpm vha. rlocfind kommandoen
figure(1)
sgrid('new');
rlocus(L_m);
[Kpm, p_m] = rlocfind(L_m, pol_valgt);

%Overf�ringsfunktionen for motoren kan nu findes som
%lukketsl�jfeoverf�ringsfuntionen af L_m*Kpm og enhedstilbagekoblingen:
H_FM=feedback(series(L_m, Kpm), 1);

disp ('-------------------------------------')
disp ('      Motor overf�ringsfunktion      ')
disp ('-------------------------------------')
disp (sprintf('Kpm v�rdi valgt fra rootlocus: %f\n', Kpm))
H_FM
disp ('-------------------------------------')

armregulator