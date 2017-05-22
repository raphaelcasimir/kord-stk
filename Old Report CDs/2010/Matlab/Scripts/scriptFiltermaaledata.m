% Sortering
clc

k = 1;
g = 4900;
timeInt = int32(time*1000);

for n = 1:length(time)
    if  timeInt(n) == g
         timeSort(k) = g;
         motorSort(k) = int32(motor(n)*1000);
         stromSort(k) = int32(strom(n)*1000);
         k = k + 1;
         g = g + 5000;
    end 
end
