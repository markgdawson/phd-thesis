clear 
N=16;
k = N/4;
T=5;
fs = N/T;
% select an omegak
omegak = (2*pi*k*fs)/N;

omegaf = 0:0.01:(2*pi*(N-1)*fs)/N;

domega = omegaf - omegak;
Sx = sin(domega*N*T/2)./sin(domega*T/2);
%.*exp(1i*(domega)*(N-1)*T/2);
plot(omegaf,abs(Sx));
hold all
%N
%T
%domega=omgak + range

%xlim([omegakall(1),omegakall(end)]);
% plot(omegakall,omegakall.*0,'.','markerSize',20);
%plot(omegaf,abs(sin(domega*N*T/2)./sin(domega*T/2)),'.-')