
X2 = 3.9:0.2:9.5;

Y3 = 32 * X2 - 43.72

Y1 = double(tachoSort)/3* 2 * pi / 60;
Y2 = double(tachomaalSort)* 2 * pi / 60;
X = double(motorSort) / 1000;

plot(X,Y1,X,Y2,X2,Y3)