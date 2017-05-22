
%% Program til indsamling af måledata


%clc
%clear
tg.start
pause(10)
tg.stop

data = tg.get('OutputLog');
time = tg.get('TimeLog');

%% Data gemmes i variabler
arm      = data(:,1);
pind     = data(:,2);
tacho    = data(:,3);
Vdiff    = data(:,4);
motor    = data(:,5);
input    = data(:,6);

%% Udregn Stømmen
R1 = 1000;
R2 = 100000;
strom = (Vdiff/((-R2)/R1))/0.005;

%% Sortering
k = 1;
g = 4900;
timeInt = int32(time*1000);

for n = 1:length(time)
    if  timeInt(n) == g
         timeSort(k) = timeInt(n);
         motorSort(k) = int32(motor(n)*1000);
         stromSort(k) = int32(strom(n)*1000);
         armSort(k) = int32(arm(n)*1000);
         pindSort(k) = int32(pind(n)*1000);
         tachoSort(k) = int32(tacho(n)*1000);
         k = k + 1;
         g = g + 5000;
    end 
end
timeSort = timeSort';
motorSort = motorSort';
stromSort = stromSort';
armSort = armSort';
pindSort = pindSort';
tachoSort = tachoSort';

%% Gem Data
save(datestr(now,'dd-mm-yy HH-MM-SS'),'timeSort','armSort','pindSort','tachoSort','stromSort','motorSort','time','motor','arm','strom','pind','tacho','input');
