% TilstandsRegulering

clc;

%% Konstanter:
Km = 0.022141706562986;
Rm =0.807790757873553;
Js = 2.686970843428432e-04;
bs = 1.748817703686052e-04;
tauf = 0.064;
initU = 1.7;
N = 12/40;
ma = 0.298;
mp = 0.082;
lp = 1.1509;
la = 0.3384;
g = 9.816;
bp = 0;
Jt = Js+((1/3)*ma*la^2*N^6);
%0.034/(0.830*(0.000107+0.000297+0.01097*N^6))
%% State-space matricer:

A = [((-(Km^2)/(Rm*Jt))-(bs/Jt)) 0 0 0
    N^3 0 0 0
    0 1 0 ((3*g)/(lp*2))
    0 0 1 0];
B = [1.292*(Km/(Jt*Rm))
    0
    0
    0];
C = [1 0 0 0
    0 1 0 0
    0 (-(3*la)/(lp*2)) 0 (-(9*g*la)/(4*lp^2))];
D = 0;

% A = [-4.339 0 0 0
%     0.027 0 0 0
%     0 1 0 14.484
%     0 0 1 0];
% B = [-4.396
%     0
%     0
%     0];
% C = [1 0 0 0
%     0 1 0 0
%     0 -0.445 0 -6.316];
% D = 0;

%% Staspace-model og poler:
sys = ss(A,B,C,D);
%F = [1 1 1 1];
%eig(A+B*F)
%disp('Poler �bensl�jfe:');
eig(A);

%step(sys,10);

%% Er modellen styrbar?:

Con = [B A*B (A^2)*B (A^3)*B];

rank(Con);

% Den er Styrbar

%% Feedback controller

p = 0.004;
%Q = 1/([8.163*10^-6 0 0 0;0 1.621 0 0;0 0 211.899 0;0 0 0 847.595]^2);
Q = p*(C')*C;
R = 1;

F = -lqr(A,B,Q,R);
%disp('Poler lukketsl�jfe:')
poles = eig(A+B*F)


%% Observerbarhed:

O = [C;C*A;C*A^2;C*A^3];

rank(O);

% Den er Observerbar

%% Full order Observer

%po = 2*poles;
%po = poles;
po = [-35 -36 -37 -38];
L = (-place(A',C',po))';

full = [A+B*F B*F ; zeros(size(A)) A+L*C];
eig(full);

%% Reduced Observer

Aro = [0 ((3*g)/(lp*2));1 0];
Bro = [1;0];
Cro = [0 -(9*la*g)/(4*lp^2)];
Dro = [-(3*la)/(2*lp)];

Oro = [Cro;Cro*Aro];
rank(Oro);
t2 = inv(Oro)*[0;1];
t1 = Aro*t2;
T = [t1 t2]; 

Aroo = inv(T)*Aro*T;
Croo = Cro*T;

Lroo = [0-61;-12.7935-930];
Ljuhuu = T*Lroo;

Lro = (-place(Aro',Cro',[-35;-36]))';

%% Integral 

H = [0 1 0]*C;

Ae = [A [0;0;0;0];H 0];
Be = [B;0];
Ce = [H 0];

Fe = -place(Ae,Be,[poles' -10]);

F = Fe(:,1:4);
Fi = Fe(:,5);

JFJF = [Fe(:,1:4) Fi*7];
eig(Ae+Be*JFJF);

%% Zero assignment
% 
% Aza = A + B*F + L*C;
% Cza = -F;
% 
% Mbla = -place((A+B*F+L*C)',-F',poles)';
% 
% eig(Aza + Mbla*Cza);
% 
% Acl = [A B*F;-L*C A+B*F+L*C];
% Bcl = [B;Mbla];
% Ccl = [C [0 0 0 0;0 0 0 0;0 0 0 0]];
% 
% syscl = ss(Acl,Bcl,Ccl,0);
% %step(syscl,100)
% 
% Nninv = Ccl*inv(Acl)*Bcl;
% N = -inv(Nninv(2,:));
% 
% M = Mbla*N;

%% Anti Windup

Aw = A+L*C;
Cw = F;

M = -place(Aw',Cw',[poles])';

%% Sensor kalibrering

aarm = -15.836;
barm = -90.0053;

apind = -16.85;
bpind = 1.1;




