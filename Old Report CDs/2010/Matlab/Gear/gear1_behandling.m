% Gear 1 - Filtrering af data

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

stromSortFilter = double(stromSortFilter)/1000;
motorSortFilter = double(motorSort)/1000;
tachoSortFilter = double(tachoSort)/1000 *(1000/3) * 2 * pi / 60;

stromSort = double(stromSort)/1000;
motorSort = (double(motorSort)/1000);

Km = 0.03064036479;
Tf = Km*stromSortFilter;

figure(1);
plot(motorSortFilter,stromSortFilter);
figure(2);
plot(motorSort,stromSort);

bg = 0.002938;

