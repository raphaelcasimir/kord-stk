clear all;

x=-25*pi/180:0.0001:25*pi/180;
X=-10*pi/180:0.0001:10*pi/180;


for k=1:3491;
	if (k ~= 0)
		Y(k)=(sin(-10*pi/180+k*0.0001)-(-10*pi/180+k*0.0001))/(-10*pi/180+k*0.0001)*100;
	else
		Y(k)=0;
	end
end

for k=1:8727;
	if (k~=0)
		y(k)=(sin(-25*pi/180+k*0.0001)-(-25*pi/180+k*0.0001))/(-25*pi/180+k*0.0001)*100;
	else
		y(k)=0;
	end
end

%% approximation with cos=<1-x^2/2
figure
plot(x*180/pi,(cos(x)-(1-x.^2/2))*100, '--', x*180/pi,y);

xlabel('Angle [°]'); ylabel('Error [%]');
axis tight;
grid on;

%% Approximation with cos=>1
figure
plot(X*180/pi,(cos(X)-(1))*100, '--',X*180/pi,Y); 

xlabel('Angle [°]'); ylabel('Error [%]');
axis tight;
grid on;

