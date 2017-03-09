x=-25*pi/180:0.0001:25*pi/180;
X=-10*pi/180:0.0001:10*pi/180;


%% approximation with cos=<1-x^2/2
figure
plot(x*180/pi,(cos(x)-(1-x.^2/2))*100, '--', x*180/pi,(sin(x)-x)*100);

xlabel('Angle [°]'); ylabel('Error [%]');
axis tight;
grid on;

%% Approximation with cos=>1
figure
plot(X*180/pi,(cos(X)-(1))*100, '--', X*180/pi,(sin(X)-X)*100);

xlabel('Angle [°]'); ylabel('Error [%]');
axis tight;
grid on;