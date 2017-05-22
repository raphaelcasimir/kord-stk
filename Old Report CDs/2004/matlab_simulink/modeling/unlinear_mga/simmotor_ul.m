function  y = simmotor_ul(u,t,par)

toer=par(4);
Km=0.0296;
Ke=Km;
f = par(3);%0.00006023;
J = 0.00066;
Fg = par(5);% -1.1;
La = 0.3;
N = 1/(37.04);
h = t(2) - t(1);

nn = length(u);
x1 = zeros(nn,1);
x2 = zeros(nn,1);
x3 = zeros(nn,1);

%Startbetingelser for model n=1
x1(1)=0;
x2(1)=0;
x3(1)=0; 


for jj = 2:nn
    
    
    Ra=1.8;   %Beregning af Ra 
    if u(jj) < -1
        Ra=par(1);
    end
    if u(jj) > 1
        Ra=par(2);
    end
    
    
    mm = (u(jj)-x2(jj-1)*Ke)*(Km/Ra);
    T_tf = mm;
    if mm < -toer
        T_tf = -toer;
    end
    if mm > toer
        T_tf = toer;
    end
    
    x1(jj)=(1/J)*(((-Ke*Km)/Ra)*x2(jj-1)-(f*x2(jj-1)+T_tf)+((Fg*La)/2)*sin(x3(jj-1))+(Km/Ra)*u(jj));
    x2(jj)=x2(jj-1)+x1(jj)*h;
    x3(jj)=x3(jj-1)+x2(jj)*N*h;
    
end

y=x2;