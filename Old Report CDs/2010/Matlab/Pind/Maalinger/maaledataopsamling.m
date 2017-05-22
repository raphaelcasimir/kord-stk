
%% Program til indsamling af måledata


%clc
%clear
aarm = 15.836;
barm = 90.928;

tg.start
pause(60)
tg.stop

data = tg.get('OutputLog');
time = tg.get('TimeLog');

%% Data gemmes i variabler
arm      = data(:,1);
pind     = data(:,2);


%% Gem Data
save(datestr(now,'dd-mm-yy HH-MM-SS'),'time','arm','pind');
