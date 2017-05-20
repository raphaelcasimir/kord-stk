% Armposregulering

Km = 0.022141706562986;
Rm = 0.807790757873553;
Js = 2.686970843428432e-04;
Bs = 1.748817703686052e-04;
tauf = 0.064;
initU = 1.7;
kff =  (3*la)/(2*lp);
N = 12/40;
ma = 0.298;
mp = 0.082;
lp = 1.1509;
la = 0.3384;
g = 9.816;
bp = 0;

pindreg
sim('pindreg')
