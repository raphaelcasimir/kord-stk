function y=simmga3hzb(u,t,par)
% Input til SENSTOOLS for måledata
% mga3hza, Måleserie B, 3 Hz

d1=par(1); d2=par(2); d3=par(3);
nc=[2.816]; dc=[d1 d2 d3];
  
t=[0 t(1:length(t)-1)];
y=lsim(nc,dc,u,t); 