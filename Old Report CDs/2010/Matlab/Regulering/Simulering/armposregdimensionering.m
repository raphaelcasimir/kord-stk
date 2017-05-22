% Armposregulering

Km = 0.022141706562986;
Rm = 0.807790757873553;
Js = 2.686970843428432e-04;
Bs = 1.748817703686052e-04;
N = 12/40;
la = 0.3384;
ma = 0.2988;
Kpim = 0.2;
Ti = (Js*Rm+(1/3)*ma*la^2*N^6*Rm)/(Bs*Rm+Km^2);

s = tf('s');

Gm = ((1.292*Km)/((Js*Rm+ma*la^2*N^6*Rm*1/3)*s+Bs*Rm+Km^2));
Dm = Kpim*(1+1/(Ti*s));
CLm = (Dm*Gm)/(Dm*Gm+1);

Gg = (N^3)/s;

Kpg = 236;
Dg = Kpg;

T = (CLm*Gg*Dg)/(1+CLm*Gg*Dg);

figure(1)
rlocus(CLm*Gg);
figure(2)
rlocus(Gg);
figure(3)
step(T);
stepinfo(T)