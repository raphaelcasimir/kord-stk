
%% Program til indsamling af måledata


%clc
%clear
tg.start
pause(140)
tg.stop

data = tg.get('OutputLog');
time = tg.get('TimeLog');

%% Data gemmes i variabler
arm      = data(:,1);
pind     = data(:,2);
input     = data(:,3);


%% Gem Data
save(datestr(now,'dd-mm-yy HH-MM-SS'),'time','arm','pind','input');
