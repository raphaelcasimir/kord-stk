%K�rsel af SENSTOOLS for uline�r model for motor, gear og arm:
clear;

%Parametre fra model:
par0=[0.4 0.4 0.00006 0.037 -1.1]; %Ra1, Ra3, T_f, T_tf

%%% Hent m�ledata
load measmotor_ul

process = 'motor_ul'

%K�r SENSTOOLS:
mainest