
%% Program til indsamling af måledata

%clc
%clear
tg.start
pause(100)
tg.stop

data = tg.get('OutputLog');
time = tg.get('TimeLog');

%% Data gemmes i variabler
strommaal    = data(:,1);
Vdiff      = data(:,2);
motor      = data(:,3);

%% Udregn Stømmen
R1 = 1000;
R2 = 100000;
strom = (Vdiff/((-R2)/R1))/0.005;

strommaal = strommaal/0.1;

%% Sortering
k = 1;
g = 900;
timeInt = int32(time*1000);

for n = 1:length(time)
    if  timeInt(n) == g
         timeSort(k) = timeInt(n);
         motorSort(k) = int32(motor(n)*1000);
         stromSort(k) = int32(strom(n)*1000);
         strommaalSort(k) = int32(strommaal(n)*1000);
         k = k + 1;
         g = g + 1000;
    end 
end
timeSort = timeSort';
motorSort = motorSort';
stromSort = stromSort';
strommaalSort = strommaalSort';

%% Gem Data
save(datestr(now,'dd-mm-yy HH-MM-SS'),'timeSort','strommaalSort','stromSort','motorSort','time','motor','strom','strommaal');
