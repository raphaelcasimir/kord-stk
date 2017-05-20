Km = 0.022141706562986;
Rm = 0.807790757873553;
Js = 2.686970843428432e-04;
Bs = 1.748817703686052e-04;
N = 12/40;
la = 0.3384;
lp = 1.1509;
ma = 0.2988;
g = 9.82;
kff =  (3*la)/(2*lp);
tauf = 0.064;
initU = 1.7;
s = tf('s');

Gpold = ((-3*la*s^2)/(2*lp))/(-s^2+((3*g)/(2*lp)));
Gm = (Km*1.292)/(((Js*Rm)+(ma*(la^2)*(N^6)*Rm*1/3))*s+Bs*Rm+Km^2);
Gg = N^3/s;
Gp = (((3*g)/(2*lp))*(-3*la)/(2*lp))/(-s^2+((3*g)/(2*lp)));

Kpim = 0.1;
Ti = (Js*Rm+(1/3)*ma*la^2*N^6*Rm)/(Bs*Rm+Km^2);
Dm = Kpim*(1+1/(Ti*s));
CLm = feedback(series(Gm,Dm),1);

Kpg = 300;
Dg = Kpg;

kipp =12;
ki=(3*g/(lp*2))^(1/2);
kd=(3*g/(lp*2))^(1/2);
Dp = kipp*((s+kd)/(s+5*ki));

CLmg = feedback(CLm*Gg*Dg,1);
CLmgp = feedback(CLmg*Gp*Dp,1);

%figure(1)
%step(CLmgp,20)
%figure(2)
%pzmap(CLmgp)
%figure(3)
%step(CLmgp)
%stepinfo(CLm)
%stepinfo(CLmg)
%stepinfo(CLmgp)
%pindreg
%sim('pindreg')
% figure(4)
% rlocus(CLmg*Gp*Dp)

aarm = -15.836;
barm = -90.0053;

apind = -16.85;
bpind = 1.1;
