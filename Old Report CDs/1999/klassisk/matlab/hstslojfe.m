% Beregning af regulatorer til hastighedssløjfe og generering af bode-, step-
% og 3D-plots

%------------------------------------Konstanter-------------------------------
clear;
N1=14/40;
N2=12/40;
Jtot=9.98e-4;
B=1.64e-3;
Km=4.97e-2;
Ra=0.98;
Keff=1.3146;

%-----------------------------Motorens overføringsfunktion-------------------
numm=[(Keff*Km)/(B*Ra+Km^2)];
denm=[(Jtot*Ra)/(Ra*B+Km^2) 1];
sysm=tf(numm,denm);

%------------------------------Hastighedsregulator Dw(s)---------------------
k=6
Ti=0.03
num=k*([Ti 1]);
den=([Ti 0]);
D=tf(num,den)


[numd,dend] = c2dm(num,den,0.0125,'zoh') % Diskretisering af regulator
Dd          = tf(numd,dend,0.0125)
forward     = sysm*D;                    % Åbensløjfe
closed      = feedback(forward,1);       % Lukketsløjfe
[num,den]   = tfdata(closed,'v');

%--------------------------Løkker til beregning af data----------------------
[mag,phase,W]=bode(closed);
magdb=20*log10(mag);

for f=1:1:length(mag)
if magdb(f)>=-3 knaek= W(f);
end;
end;
knaek

omegan=1/sqrt(den(1));
zeta=(den(2)*omegan)/2;
alfa=1/(num(2)*zeta*omegan);
margin(closed);
figure
step(closed);
figure

Ti=(0.001:0.005:0.125);
k=(0.01:0.4:10);

for j=1:1:25 % 				K-sløjfe
  for i=1:1:25 % 			Ti-sløjfe

    num=k(j)*([Ti(i) 1]);
    den=([Ti(i) 0]);
    D=tf(num,den);

    Asys=D*sysm;
    Lsys=feedback(Asys,1);
    [mag,phase,W]=bode(Lsys);
    magdb=20*log10(mag);
    top=max(magdb);

    for f=1:1:length(mag)
      if magdb(f)>=top-3 knaek(i,j) = W(f);
   end;
  end;

  [num,den]=tfdata(Lsys,'v');
  num=num/den(1);
  den=den/den(1);
  num=num/num(3);
  den=den/den(3);

  omegan(i,j)=sqrt(1/(den(1)));

  Tr(i,j)=1.8/omegan(i,j);
  zeta(i,j)=den(2)*omegan(i,j)/2;
  Ts(i,j)=4.6/(zeta(i,j)*omegan(i,j));
  alfa(i,j)=1/(num(2)*zeta(i,j)*omegan(i,j));
 end;
end;

%--------------------------------Generering af plots-------------------------
waterfall(k,Ti,omegan);
view([-150,20])
colormap([0 0 0]);
axis([0 10 0 0.130 0 500])
zlabel('Systemets egenfrekvens [rad/s]')
ylabel('T_i integrationstiden [s]')
xlabel('Forstærkning K')

figure
waterfall(k,Ti,knaek);
view([-150,20])
colormap([0 0 0]);
axis([0 10 0 0.130 0 350])
zlabel('-3db frekvensen [rad/s]')
ylabel('T_i integrationstiden [s]')
xlabel('Forstærkning K_\omega')
 
figure
waterfall(k,Ti,Tr);
axis([0 10 0 0.130 0.002 0.02])
view([60,20]);
colormap([0 0 0]);
zlabel('Risetime i [sek]')
ylabel('T_i integrationstiden [sek]')
xlabel('Forstærkning K_\omega')
 
figure
waterfall(k,Ti,Ts);
axis([0 10 0 0.130 0.02 0.2])
colormap([0 0 0]);
view([65,20])
zlabel('Indsvningningstid t_s  [sek]')
ylabel('T_i integrationstiden [sek]')
xlabel('Forstærkning K_\omega')
 
figure
waterfall(k,Ti,zeta);
axis([0 10 0 0.130 0 4.5])
view([120,20]);
colormap([0 0 0]);
zlabel('Dæmpningsfaktor \zeta')
ylabel('T_i integrationstiden [sek]')
xlabel('Forstærkning K_\omega')

figure
waterfall(k,Ti,alfa);
axis([0 10 0 0.130 0 7])
view([120,20]);
colormap([0 0 0]);
zlabel(' \alpha koefficienten')
ylabel('T_i integrationstiden [sek]')
xlabel('Forstærkning K_\omega')


