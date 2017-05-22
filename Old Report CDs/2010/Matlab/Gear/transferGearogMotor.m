% Simulering af gear:

clc;

s = tf('s');

Km = 0.03064036479;
Bg = 0.002904890866;
Rm = 0.5963029219;
Jm = 0.0001527153806;
Bm = 0.00003310913430;
Jg = 0.001285393252;


T = Km/((Jm+Jg)*Rm*s+(Bm+Bg)*Rm+Km^2)

eig(T)