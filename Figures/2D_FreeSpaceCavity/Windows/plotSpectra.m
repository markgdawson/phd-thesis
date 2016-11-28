f=dir('data/spectrum.*.xlim*.fig');
for i=1:10
    close all;
    uiopen(sprintf('data/%s',f(i).name),1);
    ca=gca;
    ca.XTick=[0,0.5,1,1.5,2];
    ca.XTickLabel={'0','0.5','1','1.5','2'};
    ca.Children(1).Color='r'; %p=2
    
    delete(legend);
    latexExportFigure('save', ['spectra/',f(i).name],'type','pdf');
end
    