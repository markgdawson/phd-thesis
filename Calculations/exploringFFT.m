clearvars
fs = 0.1;
N = 1030;
%%
X=linspace(0,10*pi,N);
Y=sin(X);
bFilter = 0.42 - 0.5*cos(2*pi*X/X(end)) + 0.08*cos(4*pi*X/X(end));
YF = Y.*bFilter;
%plot(X,YF)
%%

FY=fft(Y);

% zero padding (not filtered)
NZ = 10000;
YZ=zeros(1,NZ);
YZ(1,1:size(Y,2)) = Y;

% zero padding (filtered)
NZ = 10000;
YZF=zeros(1,NZ);
YZF(1,1:size(Y,2)) = YF;

FYZ = fft(YZ);
FYZF = fft(YZF);

%% my code
sig.dt = fs;
sig.amplitude = Y';
sig.nOfComponents = 1;
sig.cacheFile = '';
sig.nOfTimeSteps = size(Y,2);

specPOW2=Spectrum(sig,'components',1,'pow2',true);
specNOPOW2=Spectrum(sig,'components',1,'pow2',false);
specNOPOW2MORE=Spectrum(sig,'components',1,'pow2',false,'NFFT',1000000);
specNOPOW2EVENMORE=Spectrum(sig,'components',1,'pow2',false,'NFFT',100000000);

skipSteps = 4;
sig.amplitude = sig.amplitude(1:skipSteps:sig.nOfTimeSteps,1);
sig.nOfTimeSteps = length(sig.amplitude(:,1));
sig.dt = diff(sig.amplitude(1:2,:);

specNOPOW2EVENMOREHALF=Spectrum(sig,'components',1,'pow2',false,'NFFT',100000000);
%%
figure
plot((1./N).*(1:N),abs(FY)./max(abs(FY)),'.-','markerSize',10,'displayName','fft(Y)')
hold all;
plot((1./NZ).*(1:NZ),abs(FYZ)./max(abs(FYZ)),'.-','markerSize',10,'displayName','fft(YZ)')
plot((1./NZ).*(1:NZ),abs(FYZF)./max(abs(FYZF)),'.-','markerSize',10, 'displayName','fft(YZF)');
xlim([0,0.02])
legend show

figure
xlims=[0,0.1];
specPOW2.plot('xlim',xlims,'displayName',sprintf('NFFT=%d',specPOW2.NFFT));
hold all
specNOPOW2.plot('xlim',xlims,'displayName',sprintf('NFFT=%d',specNOPOW2.NFFT));
specNOPOW2MORE.plot('xlim',xlims,'displayName',sprintf('NFFT=%d',specNOPOW2MORE.NFFT));
specNOPOW2EVENMORE.plot('xlim',xlims,'displayName',sprintf('NFFT=%d',specNOPOW2EVENMORE.NFFT));
a=legend
delete(a)
specNOPOW2EVENMOREHALF.plot('xlim',xlims,'displayName',sprintf('NFFT=%d',specNOPOW2EVENMORE.NFFT));
legend show