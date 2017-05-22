%% Simulering af motor

Km = 0.03079;
Rm = 0.5963029219;
Jm = 0.0001311869133;
Bm = 0.00005;

motormodel

sim('motormodel')

load motorsimu
Hastighed=ans;
Tid=Hastighed(1,:); Hast=Hastighed(2,:);

load motorsimu1
Stromsimu=ans;
Stromans=Stromsimu(2,:);

%% Senstools

Km = 0.0253;
Rm = 1.1482;
Jm = 5.7988e-005;
Bm = 9.9188e-005;

sim('motormodel')

load motorsimu
Hastighedsens=ans;
Hastsens=Hastighedsens(2,:);

load motorsimu1
Stromsens=ans;
Stromanssens=Stromsens(2,:);

%%Plot

X = double(time);
Y = double(tacho) * (1000/3) * 2 * pi / 60;
Y2 = double(strom);

figure(1)
plot(X,Y,Tid,Hast,Tid,Hastsens);
figure(2)
plot(X,Y2,Tid,Stromans,Tid,Stromanssens);