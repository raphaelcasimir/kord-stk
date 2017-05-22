% Beregning af ankermodstandskarakteristik
% Skal bruges sammen med maal.m

%------------------------------------Konstanter-------------------------------
clear;
maal
Kemf = 0.0294;
omega= tach*((2*pi*1000)/180);

%---------------------------------Plot af måledata----------------------------
Uemf=Kemf*omega;
Ua=volt-Ia-Uemf;
plot(Ua,Ia);
grid;

hold on;

%-------------------------------Polyfit af midt sektion-------------------------
for i=1:1:size(Ua)
  if Ua(i)<-0.9 nr1=i; end;
  if Ua(i)<1  nr2=i; end; 
end;

temp1=Ia(nr1:nr2);
temp2=Ua(nr1:nr2);

z=polyfit(temp2,temp1,1);   
y1=z(1)*temp2+z(2);
plot(temp2,y1);

Ra=z(1);

%-------------------------------Polyfit af 2. sektion-------------------------
for i=1:1:size(Ua)
  if Ua(i)<-1.7 nr1=i; end; 
  if Ua(i)<1.78  nr2=i; end;
end;

temp1=Ia(1:nr1);
temp2=Ua(1:nr1);

z=polyfit(temp2,temp1,1);
y1=z(1)*temp2+z(2);
plot(temp2,y1);

Ra1=z(1);

temp1=Ia(nr2:size(Ia));
temp2=Ua(nr2:size(Ua));

z=polyfit(temp2,temp1,1);
y1=z(1)*temp2+z(2);
plot(temp2,y1);

Ra2=z(1);

ylabel('Ia, ankertrøm [A]')
xlabel('Ua, ankerpænding [V]')
title('Ankermodstands karakteristik  målt uden gear')
text(0.5,0.1,['Ra,0=',num2str(Ra),'Ohm']);
text(-2.5,-0.65,['Ra,neg=',num2str(Ra1),'Ohm']);
text(2,0.4,['Ra,pos=',num2str(Ra2),'Ohm']);