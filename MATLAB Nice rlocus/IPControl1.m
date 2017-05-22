clear all
Kt = 0.0293;     % Motor constant
Ke = 0.0355;     % Motor constant
Jm = 2.9*10^-5;     % Moment of inertia
Ja = 10.3*10^-3;
Jg = 1.53*10^-4;
Lm = 0; %1.42*10^-4;     % Inductance
Rm = 0.82;  % Resistance
Bm = 1.59*10^-4;     % Friction
Bg = 1.11*10^-3;
N = 0.3;   % Gear ratio
la = 0.33;  % Length of arm
ls = 1.1;   % Length of stick
Ms = 0.17;  % Mass of stick
Ma = 0.288; % Mass of arm
Bas = 0.0;   % Friction between A&S
g = 9.8;    % Standard gravitational acceleration

Ga2=tf([Kt/Rm], [(Jm+Jg) (Ke*Kt/Rm+Bg+Bm)]);
Ga=tf(Kt/Rm, [(Jm+Jg)/N^3-Ja (Ke*Kt/Rm+Bg+Bm)/N^3 g*la*(Ms+Ma)]);
Gb=tf(N^3,[1 0]);
Gc=tf([3*la/(2*ls) 3*Bas/(Ms*ls^2) 0],[1 3*Bas/(Ms*ls^2) -3*g/(2*ls)]); % Negative gain
Gre=tf([-la*3*g/(2*ls)],[1 0 -3*g/(2*ls)]);
s=tf([1 0],1);
% Da = 1;
% Db = 1;
% Dc = tf([1 5],[1 -1]);
%%
figure
h=rlocusplot(Gb); %Gre*(s+6)
p=getoptions(h);
p.ylabel.FontSize = 14;
p.xlabel.FontSize = 14;
p.title.FontSize = 16;
p.title.String = 'Root Locus of Voltage to Arm Angle';
p.ticklabel.FontSize = 12;
p.xlim=[-3 1];
setoptions(h,p);
axIm = findall(gcf,'String','Imaginary Axis (seconds^{-1})');
axRe = findall(gcf,'String','Real Axis (seconds^{-1})');
set(axIm,'String','Imaginary Axis');
set(axRe,'String','Real Axis');
qq=findall(gcf,'type','line');
qq(6).LineWidth=3;
qq(7).LineWidth=3;
qq(7).MarkerSize=18;

figure
CL=feedback(905*Gb,1);
pzmap(CL);

figure
step(CL);

%%
figure
CL=feedback(Gre*(s+6),1);
pzmap(CL);
%%
P=pzoptions;
P.ylabel.FontSize = 14;
P.xlabel.FontSize = 14;
P.title.FontSize = 16;
P.title.String = 'Pole-Zero Plot of Outer Loop Controller in Feedback';
P.ticklabel.FontSize = 12;
TF=feedback(Gre*(s+6)/(s+120)*100,1);
h=pzplot(TF,P);
axIm = findall(gcf,'String','Imaginary Axis (seconds^{-1})');
axRe = findall(gcf,'String','Real Axis (seconds^{-1})');
set(axIm,'String','Imaginary Axis');
set(axRe,'String','Real Axis');
qq=findall(gcf,'type','line');
qq(7).MarkerSize=12; %Poles
qq(7).LineWidth=2;
qq(6).MarkerSize=12; %Zeros
qq(6).LineWidth=2;
%%
h=rlocusplot(Gb); 
p=getoptions(h);
p.ylabel.FontSize = 14;
p.xlabel.FontSize = 14;
p.title.FontSize = 16;
p.title.String = 'Root Locus of Arm Loop';
p.ticklabel.FontSize = 12;
p.xlim=[-60 8];
p.ylim=[-25 25];
setoptions(h,p);
axIm = findall(gcf,'String','Imaginary Axis (seconds^{-1})');
axRe = findall(gcf,'String','Real Axis (seconds^{-1})');
set(axIm,'String','Imaginary Axis');
set(axRe,'String','Real Axis');
qq=findall(gcf,'type','line');
%qq(end-5).LineWidth=3;
%qq(end-4).LineWidth=3;
qq(end-3).LineWidth=3;
qq(end-2).LineWidth=3;
qq(end-1).LineWidth=2;
qq(end-1).MarkerSize=18;
qq(end).LineWidth=2;
qq(end).MarkerSize=18;

%%

step(9.28*Gb*Ga2);