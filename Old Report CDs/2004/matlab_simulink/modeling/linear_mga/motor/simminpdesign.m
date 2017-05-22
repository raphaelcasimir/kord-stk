function y=simminpdesign(u,t,par)
% Input til SENSTOOLS for måledata


d1=par(1); d2=par(2); d3=par(3);
nc=[104.3 0]; dc=[d1 d2 d3];
  
t=[0 t(1:length(t)-1)];
y=lsim(nc,dc,u,t); 