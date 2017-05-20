function y=simm3hzb1(u,t,par)
% Input til SENSTOOLS for måledata Med 1.ordens model..
% m2hza, Måleserie B, 2 Hz samplefrekvens=100hz

d1=par(1); d2=par(2);
nc=[0.0296]; dc=[d1 d2];
  
t=[0 t(1:length(t)-1)];
y=lsim(nc,dc,u,t); 