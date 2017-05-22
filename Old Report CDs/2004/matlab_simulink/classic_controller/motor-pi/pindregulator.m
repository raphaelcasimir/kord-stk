%------------------------------------------------------
%                    Pindregulator (LEAD)             |  
%------------------------------------------------------

%Overf�ringsfunktion for pind
Gp=tf([-0.7962 0 0],[1 0 -27.87]);

%1. rodkurveplot. L_s_1(s) er en serie forbindelse af Ham(s) og Gp(s) n�r
%Dp=Kpp

 L_s_1=series(H_AM, Gp);
 %figure(6)
 %sgrid(Zeta, Omega_n, 'new')
 %rlocus(L_s_1);

%1. plot viser at der ligger 2 sammenfaldende nulpunkter i origo, og en pol
%i h�jre halvplan. For at polen i h�jre halvplan kan flyttes over i venstre
%halvplan, plomberes nulpunkterne i origo. Der laves en intern feedforward
%plombering ved pindens overgf�ringsfunktion, hvor C=0.265424.


%2. rodkurveplot. L_s_2(s) er en serie forbindelse af Ham(s) og Gp(s) n�r
%Dp=Kpp. Her er der sat inter feedforward plombering p� Gp(s) s�ledes det
%dobbelte nulpunkt i origo elemineres.

Gp=Gp+0.7962; %intern feedforward plombering p� Gp
L_s_2=series(H_AM, Gp);
%figure(4)
%sgrid(Zeta, Omega_n, 'new')
%rlocus(-L_s_2);
%figure(5)
%rlocus(L_s_2);

%2. plot viser at de to nulpunkter i origo er elemineret, og at det nu er
%muligt at flytte den pol der befinder sig i h�jre halvplan over i venstre
%halvplan vha. et lead netv�rk.


%3. rodkurveplot. Her er Dp=Kpp*H_Lead. Det vil sige at L_s_3(s) er en
%serieforbindelse af H_Lead=(s+z)/(s+p), Ham(s) og Gp(s) (Gp(s) eer feedforward
%plomberet)

pol_valgt_p=-17.2;
z=6.0; p=100;
H_Lead=tf([1 z],[1 p]);

L_s_3=series(series(H_Lead, H_AM),Gp);
figure(6)
%sgrid(Zeta, Omega_n, 'new')
rlocus(-L_s_3);
%figure(7)
%sgrid(Zeta, Omega_n, 'new')
%rlocus(L_s_3);



[Kpp, P_system] = rlocfind(-L_s_3, pol_valgt_p);

H_system=feedback(series(L_s_3, Kpp), 1);

disp ('-------------------------------------')
disp ('      SYSTEM-overf�ringsfkt          ')
disp ('-------------------------------------')
disp ('Valgt Kpp-v�rdi:')
Kpp
disp ('Systempoler:')
P_system
disp ('Systemoverf�ringsfunktion:')
H_system
disp ('-------------------------------------')
