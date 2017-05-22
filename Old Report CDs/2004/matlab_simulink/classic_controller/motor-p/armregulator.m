%------------------------------------------------------------
%                       Armregulator (P)                    |
%------------------------------------------------------------

%Gearing og integrator:
G_N=tf([1/37.04], [1 0]);

%Rodkurveoverføringsfunktionen for arm+motor- regulatoren L_am(s) kan findes som en
%serieforbindelse af motoroverføringsfunktionen (Hm), og Gearingen (G_N).
%(Husk at køre motorregulator.m først for at lave Hm!:-)
L_AM=series(H_FM, G_N);

%Rodkurveplottet laves nu og der returneres en Kpa vha. rlocfind kommandoen
figure(2)
rlocus(L_AM);
pol_valgt_a=-40;
[Kpa, p_am] = rlocfind(L_AM, pol_valgt_a);

%Nu er der valgt en Kpa fra rodkurveplottet. Denne bruges i
%overføringsfunktionen for arm+motor- systemet Ham(s) nu kan beregnes som
%følgende:

H_AM=feedback(series(Kpa, L_AM),1);
figure(3)
step(H_AM)

disp ('--------------------------------------------------------------------------')
disp ('                         Arm+Motor- overføringsfkt                        ')
disp ('--------------------------------------------------------------------------')
disp (sprintf('Kpa værdi valgt fra rootlocus: %f\n', Kpa))
H_AM_regulatorpoler = pole(H_AM)
disp ('endelig overføringsfunktion for arm+(motor+regulator)+regulator:')
H_AM
disp ('--------------------------------------------------------------------------')
pindregulator