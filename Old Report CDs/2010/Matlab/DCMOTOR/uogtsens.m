% u og t til senstools laves

Zout
sim('Zout')

load Zout
Hastighed=ans;
Tid=Hastighed(1,:); Hast=Hastighed(2,:);

plot(Tid,Hast)