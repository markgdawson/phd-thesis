close all;
plotNames = {
    'Blackman',
    'Blackman-Harris',
    'Gaussian',
    'Cosine',
    'Hann',
    'Rect' };
 nPlots=length(plotNames);
 
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

for i=1:nPlots
    n=['convFFT.',plotNames{i},'Window.mat'];
    fi=fullfile('data',n);
    c{i}=load(fi);
    c{i} = c{i}.convFFT;
end

for iFreq=3:10
    figure(iFreq)
    for i=1:nPlots
        dn = plotNames{i};
        lineSty = lineStys{i};
        plot(log10(c{i}.T),log10(c{i}.error(iFreq,:)./a(iFreq)),lineSty,'displayName',dn,'lineWidth',2);
        hold all;
    end
    legend show
    xlim([1.5,4]);
    xlabel(latexLog10math('T'));
    ylabel(latexLog10rm('Frequency Error'));
    figReverseLineOrder
    
    ca=gca;
    ca.Children(4).Color='k';
    ca.Children(3).Color=[0.4940    0.1840    0.5560];
    
    
    latexExportFigure('save',sprintf('conv/F%d',iFreq),'type','pdf','legopt',true);
end