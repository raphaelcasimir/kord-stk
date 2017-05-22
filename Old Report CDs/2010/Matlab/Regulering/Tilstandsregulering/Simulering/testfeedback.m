% Test af fuld observer vs reduceret observer

load datafeedback.mat
data1=ans;
tid1=data1(1,:); pind1=data1(3,:); arm1=data1(2,:);

pind1 = (pind1*180)/pi;
arm1 = (arm1*180)/pi;

figure(1);
plot(tid1,pind1,tid1,arm1)

