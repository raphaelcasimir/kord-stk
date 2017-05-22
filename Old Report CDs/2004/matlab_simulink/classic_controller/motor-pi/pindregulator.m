%------------------------------------------------------
%                    Pindregulator (LEAD)             |  
%------------------------------------------------------

%Overføringsfunktion for pind
Gp=tf([-0.7962 0 0],[1 0 -27.87]);

%1. rodkurveplot. L_s_1(s) er en serie forbindelse af Ham(s) og Gp(s) når
%Dp=Kpp

 L_s_1=series(H_AM, Gp);
 %figure(6)
 %sgrid(Zeta, Omega_n, 'new')
 %rlocus(L_s_1);

%1. plot viser at der ligger 2 sammenfaldende nulpunkter i origo, og en pol
%i højre halvplan. For at polen i højre halvplan kan flyttes over i venstre
%halvplan, plomberes nulpunkterne i origo. Der laves en intern feedforward
%plombering ved pindens overgføringsfunktion, hvor C=0.265424.


%2. rodkurveplot. L_s_2(s) er en serie forbindelse af Ham(s) og Gp(s) når
%Dp=Kpp. Her er der sat inter feedforward plombering på Gp(s) således det
%dobbelte nulpunkt i origo elemineres.

Gp=Gp+0.7962; %intern feedforward plombering på Gp
L_s_2=series(H_AM, Gp);
%figure(4)
%sgrid(Zeta, Omega_n, 'new')
%rlocus(-L_s_2);
%figure(5)
%rlocus(L_s_2);

%2. plot viser at de to nulpunkter i origo er elemineret, og at det nu er
%muligt at flytte den pol der befinder sig i højre halvplan over i venstre
%halvplan vha. et lead netværk.


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
disp ('      SYSTEM-overføringsfkt          ')
disp ('-------------------------------------')
disp ('Valgt Kpp-værdi:')
Kpp
disp ('Systempoler:')
P_system
disp ('Systemoverføringsfunktion:')
H_system
disp ('-------------------------------------')
