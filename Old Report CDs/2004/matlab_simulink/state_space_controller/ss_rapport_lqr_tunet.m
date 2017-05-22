%system fra Rapport:
clc
clear

%------- SYSTEMOVERSIGT -----------------

a=-0.7962;  b=-27.87;     %parametre for kort pind
%a=-0.7962/2;  b=-27.87/2;     %parametre for lang pind

%Udregnet tilstandsmodel for hele systemet (fra rapport)
A = [-10 0 0 0;
    0.027 0 0 0;
    0 1 0 -b; 
    0 0 1 0];
B = [148*1.31; 0; 0; 0];
C = [0 (a-1) 0 (-a*b)];
D=0;
 
%i kontinuert tid:
%disp('Open-loop system (kontinuert tid:')
sysc = ss(A,B,C,D);                 %SS continous open-loop model for system

%i diskret tid:
disp('Samplingsperiode:')
Ts = 1/50                          %samplingsperiode
disp('Open-loop system (diskretiseret:')
sysd = c2d(sysc,Ts)                 %SS discrete open-loop model for system (ZOH)
 


%--------- POLE PLACEMENT ITAE ----------

%prototypepoler via ITAE v?lges
wb = 7.26;                           %systemets ?mskede BW i rad/sek
w0 = wb/sqrt(0.563355);              %Frekvens til beregning af prototypepoler

%poler i s-plan:
%disp('De ?nskede closed-loop poler (kontinuert):');
pc_itae=[-0.424*w0+1.263*j*w0 -0.424*w0-1.263*j*w0 -0.626*w0+0.4141*j*w0 -0.626*w0-0.4141*j*w0]

%poler i z-plan
%disp('De ?nskede closed-loop poler (diskretiseret):')
pcd_itae=[exp(pc_itae(1)*Ts) exp(pc_itae(2)*Ts) exp(pc_itae(3)*Ts) exp(pc_itae(4)*Ts)]

%Tilbagekoblingsmatrix K bestemmes:
%disp('Tilbagekoblingsmatrix K (kontinuert):');
K_itae_c = acker(sysc.a,sysc.b,pc_itae);    %K i kontinuert system
%disp('Tilbagekoblingsmatrix K (diskret):')
K_itae_d = acker(sysd.a,sysd.b,pcd_itae);  %K i diskret system

%-------- LQR POLE PLACEMENT ----------------

Q = [1000 0 0 0;
     0 10000 0 0;
     0 0 1 0;
     0 0 0 1];      %Tunet til kort pind!!!

R = 1;

K_lqr_c = lqr(sysc.a,sysc.b,Q,R);
K_lqr_d= dlqr(sysd.a,sysd.b,Q,R);

%---------- CLOSED-LOOP SYSTEM ------------

%Closed Loop system i kontinuert tid for ITAE:
%disp('Closed-loop system (kontinuert):');
syscr_itae = ss(sysc.a-sysc.b*K_itae_c,sysc.b,sysc.c,0);

%Closed Loop system i diskret tid for ITAE
%disp(sprintf('Closed-loop system (diskretiseret), samplingsperiode= %f sek',Ts))
sysdr_itae = ss(sysd.a-sysd.b*K_itae_d,sysd.b,sysd.c,0,Ts);


%Closed Loop system i kontinuert tid for LQR
%disp('Closed-loop system (kontinuert):');
syscr = ss(sysc.a-sysc.b*K_lqr_c,sysc.b,sysc.c,0);

%Closed Loop system i diskret tid for LQR
%disp(sprintf('Closed-loop system (diskretiseret), samplingsperiode= %f sek',Ts))
sysdr = ss(sysd.a-sysd.b*K_lqr_d,sysd.b,sysd.c,0,Ts);

%poler i Closed-loop i LQR:
pc_lqr = pole(syscr)
pcd_lqr = pole(sysdr)

%----------- REDUCED ORDER ESTIMATOR DESIGN -----
%Reduced order estimator design til ukendte tilstande x3 og x4:

%x4 findes ud fra svarligningen (C-matrix) direkte, og skal ikke estimeres:

%x3 estimeres ud fra mini-loop: x2=input, x4=output:
Aloop = [0 1;
        -b 0];
Bloop = [0;1];
Cloop = [1 0]; %output=x4
Dloop = 0;

loopsys = ss(Aloop,Bloop,Cloop,D);
loopsysd = c2d(loopsys,Ts);

estpole = 4*real(-max(abs(real(pc_lqr)))); %estimatorpolen= 4* den hurtigste Closed Loop pol
estpoled = exp(estpole*Ts); %estimatorpoler diskretiseret
estpoled = exp(estpole*Ts); %estimatorpoler diskretiseret

disp('Estimator gain (diskret):')
Lr = (acker(loopsysd.a(2,2)',loopsysd.a(1,2)',estpoled))' %estimator feedback findes

%----------------------------------



%--------- REFERENCE INPUT DESIGN --------

%reference input (Nbar) design til step:

I = eye(4);                                    %enhedsmatrix 4x4
temp = inv([sysd.a-I sysd.b;
        sysd.c sysd.d])*[0;0;0;0;1] ;           %[Nx;Nu] vektor

Nx = [temp(1,1);temp(2,1);temp(3,1);temp(4,1)]; %Nx findes
Nu = temp(5,1);                                %Nu findes
disp('Reference-input (diskret):')
Nbar = Nu + K_lqr_d*Nx                        %Input reference 
