function y=sidcml3(u,t,par)

% y=[i,wv]=simdcml3(u,t,par) simulerer en ulineær dc-motor med 
% input u og outputs i and wv.  
%       
% par=[Rnp R0 U1 K J B T0]
%
% 23/4-99,KBP

h=t(2)-t(1);  par=par(:)';
G1=1/par(1);
G0=1/par(2);
U1=par(3);
T0=par(7);
K=par(4);
J=par(5);
B=par(6);
a=-B/J;
b=1/J;
c=1;
d=0;

%Initialisering af strøm, vinkelhastighed og tilstand.
i=0;
w=0;
x=0;

%Diskretisering af den dynamiske del af det mekaniske system
%dvs w/Ti=1/(pJ+B) ved brug af first oder hold, hvor p=d/dt. 

[a,b,c,d] = c2dm(-B/J,1/J,1,0,h,'tustin');

%forløkken svarer til matlabs filter funktion

for jj=1:1:length(u)
 e = u(jj) - w*K;     %Back emf trækkes fra
 
	%Strømmen udregnes
      i(jj) = G0*e + (abs(e)>U1)*(e - U1*sign(e))*(G1-G0); 

Tm =  i(jj)*K;                     % Det udviklede motormoment   
  
   % Ulineær friktion: 
   Ti = Tm - T0*sign(w);              % Korrekt hvis motoren kører. 
   wny = c*x + d*Ti;                  % Simulering af den lineære dynamiske  
   x = a*x + b*Ti;                    % del vha. state space.
      if (sign(wny)~=sign(w))         % Hvis disse betingelser er opfyldt
                                      % forbliver motoren standset.     
        if (abs(Tm)<=T0)              
              wny = 0;   x = 0; 
          end 
      end 
   w = wny; 
 
   wv(jj) = w;  

end;


% Output calculation:

y=[i(:) wv(:)];

