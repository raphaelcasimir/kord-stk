% Jm
% Bm
% Rm
% Km

function y=simpind(u,t,par)
s=tf('s');
Gomega=par(4)/(par(1)*par(3)*s+par(4)^2+par(2)*par(3));
yomega=lsim(Gomega,u,t);
Gi=(par(1)*s+par(2))/(par(3)*(par(1)*s+par(2))+par(4)^2);
yi=lsim(Gi,u,t);
y=[yomega,yi];


