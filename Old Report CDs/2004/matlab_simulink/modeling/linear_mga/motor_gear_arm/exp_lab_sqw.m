%Design af inputsignal til labopstilling
%Udkommentér de signaler du ikke vil have.
clear

%%% ønskede signalegenskaber %%%
% frekvens i hz: 
frq = 3 ;
% Antal samples:
ns = 3000;
% Amplitude i V:
amp = [5];



%%% data for I/O-kortet.

%timestep=sampleperioden for I/O-kortet i sek:
h = 0.01;
%Max sample værdi:
maxs=4094;
%Max spændingsinterval output:
maxv=10;

% Output filnavn:
file='inp_m_3hz.txt';


disp(sprintf('Forsøgstid: %d sekunder\n',ns*h))

%Firkantsignal med konstant amplitude:
res1=inpsqw(frq,amp,ns,h);

for n=1:length(res1),
  res1(n) = maxs/2+res1(n)*maxs/maxv+1;
  if res1(n)==1
      res1(n)=0;
  end    
end  

%Der fratrækkes q samples i starten:
q=8;
for n=1:ns-q,
 res1(n)= res1(q+n);
end


%Firkantsignal med stigende amplitude (rampe) - husk definer amp array.
%res=inpsqramp(frq,amp,ns,h);


%verificering af inputsignal
plot(res1);

%skrivning til txt fil:
disp(sprintf('Skriver til fil... \n'))

dlmwrite(file,res1',', ');

disp(sprintf('Filen %s er skrevet \n',file))
