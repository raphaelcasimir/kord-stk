%Kørsel af SENSTOOLS for ulineær model for motor, gear og arm:
clear;

%Parametre fra model:
par0=[0.4 0.4 0.00006 0.037 -1.1]; %Ra1, Ra3, T_f, T_tf

%%% Hent måledata
load measmotor_ul

process = 'motor_ul'

%Kør SENSTOOLS:
mainest