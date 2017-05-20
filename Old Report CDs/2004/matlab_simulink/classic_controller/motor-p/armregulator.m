%------------------------------------------------------------
%                       Armregulator (P)                    |
%------------------------------------------------------------

%Gearing og integrator:
G_N=tf([1/37.04], [1 0]);

%Rodkurveoverf�ringsfunktionen for arm+motor- regulatoren L_am(s) kan findes som en
%serieforbindelse af motoroverf�ringsfunktionen (Hm), og Gearingen (G_N).
%(Husk at k�re motorregulator.m f�rst for at lave Hm!:-)
L_AM=series(H_FM, G_N);

%Rodkurveplottet laves nu og der returneres en Kpa vha. rlocfind kommandoen
figure(2)
rlocus(L_AM);
pol_valgt_a=-40;
[Kpa, p_am] = rlocfind(L_AM, pol_valgt_a);

%Nu er der valgt en Kpa fra rodkurveplottet. Denne bruges i
%overf�ringsfunktionen for arm+motor- systemet Ham(s) nu kan beregnes som
%f�lgende:

H_AM=feedback(series(Kpa, L_AM),1);
figure(3)
step(H_AM)

disp ('--------------------------------------------------------------------------')
disp ('                         Arm+Motor- overf�ringsfkt                        ')
disp ('--------------------------------------------------------------------------')
disp (sprintf('Kpa v�rdi valgt fra rootlocus: %f\n', Kpa))
H_AM_regulatorpoler = pole(H_AM)
disp ('endelig overf�ringsfunktion for arm+(motor+regulator)+regulator:')
H_AM
disp ('--------------------------------------------------------------------------')
pindregulator