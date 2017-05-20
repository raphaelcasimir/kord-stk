% Hoved program til parameterestimation: 
% pare=[R K I B]
% Data findes i maal35rf
% process='dcml2', simulation program: sidcml2


path(path,'/pack-share/ftp/pub/senstools/senstoolsm');
clear,clc, format compact
maal35rf
whos
t=(1:length(volt))/20;
Ua=volt-Ia;
plot(t,Ua,t,Ia,t,tach),  
title('Measured signals: Ua, Ia and tach'),
pause (4)
y=[Ia(:)/1.03 tach(:)/0.03];  u=Ua;
save dedcml2 u y t
process='dcml2'
par0=[0.57 .0294 4.269e-4 1.8e-4];
mest
diamest
format short e, pare, format, pause(5)
format compact
disp('* - * - * - * - * - * - * - *'),
pause(4), disp('Sensitivity measures:')
 [Smin,Simin,R]=sens(Hrn)
