close all;
windowNames = {
    'Blackman',
    'Blackman-Harris',
    'Gaussian',
    'Cosine',
    'Hann',
    'Rect' };
 nWindows=length(windowNames);
 
 lineStys = {
     '+-';
     'o-';
     '.-';
     'x-';
     's-';
     'd-';
     '^-';
     'v-';
     '>-';
     '<-';
     'p-';
     'h-';
     '*-';
     };

a=AnalyticalRectangularModalCavity(1:10);
c={};

iQFFT=1;
for iWindow=1:nWindows
    n=['convFFT.',windowNames{iWindow},'Window.mat'];
    fi=fullfile('data',n);
    c{iWindow,iQFFT}=load(fi);
    c{iWindow,iQFFT} = c{iWindow,iQFFT}.convFFT;
end

iQFFT=2;
for iWindow=1:nWindows
    n=['convFFT.',windowNames{iWindow},'.noQFFT.mat'];
    fi=fullfile('QFFT',n);
    c{iWindow,iQFFT}=load(fi);
    c{iWindow,iQFFT} = c{iWindow,iQFFT}.convFFT;
end

%%
close all
iWindow=1;
qffts = {'FFT','QFFT'};


for iWindow=1:nWindows
    for iFreq=3:10
        figure(iWindow)
        subplot(4,2,iFreq-2);
        iQFFT=1;
        dn = [windowNames{iWindow},' ', qffts{iQFFT}];
        lineSty = lineStys{iQFFT};
        h = plot(log10(c{iWindow,iQFFT}.T),log10(c{iWindow,iQFFT}.error(iFreq,:)./a(iFreq)),lineSty,'displayName',dn,'lineWidth',2,'color','r');
        hold all;
        iQFFT=2;
        dn = [windowNames{iWindow}, qffts{iQFFT}];
        lineSty = lineStys{iQFFT};
        h = plot(log10(c{iWindow,iQFFT}.T),log10(c{iWindow,iQFFT}.error(iFreq,:)./a(iFreq)),lineSty,'displayName',dn,'lineWidth',2,'color','k');

        legend show
        xlim([1.5,4]);
        xlabel(latexLog10math('T'));
        ylabel(latexLog10rm('Frequency Error'));
        title(['f=',num2str(iFreq)]);
    end
    
    saveas(gcf,sprintf('QFFT/%s.fig',windowNames{iWindow}));
end


%