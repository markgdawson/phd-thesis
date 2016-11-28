close all;
file='spectrum2x4';
file='spectrum8x16';

s=load(file);
s=s.s;
lineSty = getLineStylesForP;
for p=1:numel(s)
    plotSpectrum(s{p}.spectrum,['$ p = ',num2str(p),'$'],lineSty{p}(1:2))
end
legend show
figReverseLineOrder
xlim([0,2])
xlabel('Frequency')
ylabel(latexLog10rm('Frequency Amplitude'))
ca = gca;
ca.XTick=[0,0.5,1,1.5,2];
ca.XTickLabel={'0','0.5','1','1.5','2'};
latexExportFigure('save',file,'type','pdf');
