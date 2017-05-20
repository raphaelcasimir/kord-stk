% Gear2 - Behandling af data:

Speed = (((tacho*1000)/3)*2*pi)/60;
FinalSpeed = 158;
InitSpeed = 62;

DiffSpeed = FinalSpeed-InitSpeed;

tk = DiffSpeed*0.63+InitSpeed;

TKY = [tk tk];
timeTKY = [4 6.3187];

timeTKX = [6.3187 6.3187];
TKX = [0 tk];

plot(time,Speed,timeTKY,TKY,timeTKX,TKX)