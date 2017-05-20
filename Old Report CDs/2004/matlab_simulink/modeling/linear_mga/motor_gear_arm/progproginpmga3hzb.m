%Progproginpmga3hzb laver program data for maininp:
%progdatainpmga3hzb.mat

clear

process='mga3hzb';
inputt='inpsqw';
par=[1 3.1872 6.8108];

h = 0.01;
for n=1:100
  f1v(n)=n/20;
end  
%f1v=[0.5 1 1.5 2 2.5 3 3.5 4];
amv=[5*1.31];

save progdatainpmga3hzb process inputt par h f1v amv

%%%%% til plotning af gns af individuelle sensivitetsplots:

% Simingns = (Simin(1,(:))+Simin(2,(:))+Simin(3,(:)))/3;
% plot(f1v, Simingns);