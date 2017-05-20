%2nd Filter projekt
clc;
fn = 100;
A = 1;
si = 0.7;

wn = 2*pi*fn;
s = tf('s');
T =  wn^2/(s^2+2*si*wn*s+wn^2);

subplot(1,2,1);
bode(T)
subplot(1,2,2);
step(T,0.03)
stepinfo(T)