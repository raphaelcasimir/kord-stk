%% Simulering af Gear

Km = 0.03079;
Rm = 0.5963029219;
Js = 0.0005365;
Bs = 0.0000936;

simuleGearogMotor

sim('simuleGearogMotor')

load GearMotorsimu1
Hastighed=ans;
Tid=Hastighed(1,:); Hast=Hastighed(2,:);

load GearMotorsimu2
Stromsimu=ans;
Stromans=Stromsimu(2,:);

%% Senstools

Km = 0.022141706562986;
Rm = 0.807790757873553;
Js = 2.686970843428432e-04;
Bs = 1.748817703686052e-04;

simuleGearogMotor

sim('simuleGearogMotor')

load GearMotorsimu1
Hastighedsens=ans;
Hastsens=Hastighedsens(2,:);

load GearMotorsimu2
Stromsens=ans;
Stromanssens=Stromsens(2,:);

%%Plot

X = double(time);
Y = double(tacho) * (1000/3) * 2 * pi / 60;
Y2 = double(strom) - 0.593;

figure(1)
plot(X,Y,Tid,Hast,Tid,Hastsens);
figure(2)
plot(X,Y2,Tid,Stromans,Tid,Stromanssens);