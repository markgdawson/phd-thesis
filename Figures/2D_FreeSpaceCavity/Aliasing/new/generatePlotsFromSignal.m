% s=16;signal.amplitude=amp(1:s:end,:);signal.dt_=0.025*s;signal.dt
tickstr = {}; for i =1:length([0:0.25:4]); j=[0:0.25:4]; tickstr{i} = num2str(j(i));end;
tickstrY = {}; for i =1:length([-18:2:0]); j=[-18:2:0]; tickstrY{i} = num2str(j(i));end;

spec=Spectrum(signal);
figure;
spec.plot('lineSty','b');
title(sprintf('dt = %g',signal.dt));
xlim([0,4]);

a=gca;
a.XTick=[0:0.25:4];
a.XTickLabel = tickstr;

ylim([-18,0]);a=gca;a.YTick=[-18:2:0];a.YTickLabel=tickstrY;
latexExportFigure('save',sprintf('4x8_p3_dt=%g',sig.dt),'class','spectrum')