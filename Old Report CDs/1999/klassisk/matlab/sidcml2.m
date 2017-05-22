function y=sidcml2(u,t,par)

% y=[i,w]=simdcml2(u,t,par) simulerer en lineær dc-motor med 
% input u and outputs i og w.  
% w/u = K/R/(J*s+B+K^2/R),  i/u=(J*s+B)/R/(J*s+B+K^2/R)      
% par=[R K J B]
%
% 23/4-94,KBP
% Diskretisering vha. rampinvariant transf:

h=t(2)-t(1);  par=par(:)';
nw=par(2)/par(1); dw=[par(3) par(4)+par(2)^2/par(1)];
ni=[par(3) par(4)]/par(1);
[nwz,dwz] = c2dm(nw,dw,h,'tustin');    
[niz,diz] = c2dm(ni,dw,h,'tustin');	
     
% Output beregning ved brug af filter funktionen:
w = filter(nwz,dwz,u);
i = filter(niz,diz,u);
y=[i w];
