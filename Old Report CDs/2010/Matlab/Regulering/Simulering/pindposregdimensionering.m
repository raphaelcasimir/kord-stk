% pindposregulering

Km = 0.022141706562986;
Rm = 0.807790757873553;
Js = 2.686970843428432e-04;
Bs = 1.748817703686052e-04;
N = 12/40;
la = 0.3384;
lp = 1.1509;
ma = 0.2988;
g = 9.82;

s = tf('s');

Gpold = ((-3*la*s^2)/(2*lp))/(-s^2+((3*g)/(2*lp)));
Gp = (((3*g)/(2*lp))*(-3*la)/(2*lp))/(-s^2+((3*g)/(2*lp)));
kipp = 1;
Dp = kipp*(s+(3*g/(lp*2))^(1/2))/(s+2*((3*g)/(lp*2))^(1/2));



%T = (Gp*Dp)/(1+Gp*Dp);

% margin(G*D);
%figure(2);
%step(T);
%stepinfo(T)
%figure(3)
%rlocus(Dg*Gg);
figure(4)
rlocus(Gp*Dp);
