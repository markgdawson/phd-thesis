close all;

A=[5];
omega = 1;
T=100000;
t=1:1:T;

nPhases = 25;
phases = linspace(0,2*pi,nPhases);

% decaying
decayConst = 1000;
decayTerm = exp(-t./decayConst);

SigNoPhase = A.*exp(1i.*omega.*t).*decayTerm;
FNoPhase = fft(SigNoPhase);
    
for iPhase = 1:nPhases
    phi=phases(iPhase);

    Sig = SigNoPhase.*exp(1i.*phi);

    % I only measure real part...
    SigReal = real(Sig);

%     figure(1)
%     plot(t,SigReal);
%     hold all
%     xlim([0,10]);

    F=fft(Sig);

    Freal = real(F);
    Fimag = imag(F);

    figure(1)
    subplot(ceil(nPhases/5),5,iPhase);
    xrange=1.4*10^4:1.8*10^4;
    plot(xrange,Freal(xrange),'displayName','real');
    hold all
    plot(xrange,Fimag(xrange),'displayName','imag');
    title(sprintf('phi = %g',phi));
    
    FwithPhase_nophase = FNoPhase.*exp(1i*phi);
    Freal_nophase = real(FwithPhase_nophase);
    Fimag_nophase = imag(FwithPhase_nophase);
    
    figure(2)
    subplot(ceil(nPhases/5),5,iPhase);
    xrange=1.4*10^4:1.8*10^4;
    plot(xrange,abs(Freal_nophase(xrange) - Freal(xrange)),'displayName','real');
    hold all
    plot(xrange,abs(Fimag_nophase(xrange) - Fimag(xrange)),'displayName','imag');
    title(sprintf('phi = %g',phi));
end