% Test af fuld observer vs reduceret observer

load datafullobs.mat
data1=ans;
tid1=data1(1,:); pind1=data1(3,:); arm1=data1(2,:); input1=data1(4,:);

load datareducedobs.mat
data2=ans;
tid2=data2(1,:); pind2=data2(3,:); arm2=data2(2,:);input2=data2(4,:);

pind1 = (pind1*180)/pi;
arm1 = (arm1*180)/pi;
pind2 = (pind2*180)/pi;
arm2 = (arm2*180)/pi;
input1 = (input1*180)/pi;
input2 = (input2*180)/pi;

figure(1);
plot(tid1,pind1,tid1,arm1,tid1,input1)
figure(2);
plot(tid2,pind2,tid2,arm2,tid2,input2)
