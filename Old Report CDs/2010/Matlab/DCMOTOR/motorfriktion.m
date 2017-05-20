% Friktion

s = tf('s');
H= (1/10)/(s+1/10);
Y = lsim(H,strom,time);

k = 1;
timeInt = int32(time*1000);

for n = 1:length(time)
    if  timeInt(n) == timeSort(k)
         stromSortFilter(k) = int32(Y(n)*1000);
         k = k + 1;
    end 
    if k == 101
        break
    end
end

stromSortFilter = double(stromSortFilter) / 1000;
Km = 0.03079;
Y = stromSortFilter * Km;
Xtacho = (double(tachoSort)/1000) * (1000/3) * 2 * pi / 60;
Xspan = (double(motorSort)/1000)

Xfit = 0:1:307;
Yfit=0.00005*Xfit+0.036;

figure(1)
plot(Xtacho,Y,Xfit,Yfit,Xtacho,Y,'x')
figure(2)
plot(Xspan,stromSortFilter)
Varufilt = double(stromSort) / 1000;
figure(3)
plot(Xspan,Varufilt)