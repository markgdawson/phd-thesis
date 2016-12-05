% note TM is better than TE (coupling to initial condition) iComp=3:5
close all;
clearvars;

saveFigures = false; % false / save dir

%% line styles
line.nefemHRef.color = [0,0.498,0];
line.nefemHRef.sty = '--d';
line.nefemPRef.color = [0,0,1];
line.nefemPRef.sty = '--^';
line.NefemVsFemPRef.FEM.sty = '-^';
line.NefemVsFemPRef.NEFEM.sty = '--^';
line.NefemVsFemPRef.FEM.color = [0,0,1];
line.NefemVsFemPRef.NEFEM.color = [0,0,1];

%% setup
nefemStrs={'FEM','NEFEM'};
ISO=1;
NEFEM=2;

nH = 5;
nP = 4;
nElem = [4, 16, 64, 256, 1024];
h = 0.5.^[1:5];
nFreqMax = 10;
nComponentsMax = 6;
iType = 1;
axX = 140; 
axY = -7;
pPlot = 1:4;
lineSty = {'k-o', 'r-s'; 'k--o', 'r--s'};

conv = cell(2,nP,nH,nComponentsMax);
finalError = zeros(nH,nP,2,nFreqMax,nComponentsMax);
analyticalFreqs = AnalyticalCircularModalCavity(1:nFreqMax);

TE = 1;
TM = 2;
CF = 3;

modeStrs = { 'TE','TM','CF'};
modeCompMap = { [1 2 6], [4 5 3], 1:6 };

%% config
plotCPUAndNDOF=ISO;
plotFreq = 1;
plotComp = 3;
setFontSize = false;
doResizeImage = false;


foundFiles = false(2,nH,nP,nComponentsMax);
dataFiles = cell(2,nH,nP,nComponentsMax);
dataDirs = cell(2,nH,nP);

for iNefem=1:2
    for iH=1:nH
        for iP=1:nP
            for iMode=1:3
                dataDir = sprintf('blueice/%s/%s/H%d_p%d_%s',nefemStrs{iNefem},modeStrs{iMode},iH,iP,modeStrs{iMode});
                if(exist(dataDir,'dir'))
                    dataDirs{iNefem,iH,iP} = dataDir;
                    % read uPoint.skipStepDefault file if exists
                    skipStepDefaultFile = fullfile(dataDir,'uPoint.skipStepDefault');
                    if(exist(skipStepDefaultFile,'file'))
                        skipSteps = importdata(skipStepDefaultFile);
                        dataDir = fullfile(dataDir,sprintf('skip%d',skipSteps));
                    end
                    
                    for iCompMode = 1:length(modeCompMap{iMode})
                        iComp = modeCompMap{iMode}(iCompMode);
                        dataFile=sprintf('%s/U[%d]/convFFT.mat',dataDir,iCompMode);
                        dataFiles{iNefem,iH,iP,iComp} = dataFile;
                        if(exist(dataFile,'file'))
                    
                            conv{iNefem,iP,iH,iComp}=importdata(dataFile);

                            finalErrorTmp = conv{iNefem,iP,iH,iComp}.finalError;
                            nFreqs = size(finalErrorTmp,1);

                            finalError(iH,iP,iNefem,1:nFreqs,iComp) = finalErrorTmp./analyticalFreqs;

                            foundFiles(iNefem,iH,iP,iComp) = true;
                        else
                            error('missing expected component file %s',dataFile);
                        end
                    end
                end
            end
        end
    end
end

%% read CPU times
nOfTimeSteps = nan(nH,nP,2,nFreqMax,nComponentsMax);
minutesPerStep = nan(nH,nP,2,nFreqMax,nComponentsMax);
periodRequired = nan(nH,nP,2,nFreqMax,nComponentsMax);

% calculate dt stability
dtStability = nan(nH,nP);
for iH=1:nH
    for iP=1:nP
        dtStability(iH,iP) = (h(iH)/(2*iP+ 1));
    end
end

for iComp=1:nComponentsMax
    for iNefem=1:2
        nefemStr=nefemStrs{iNefem};
        for iH=1:nH
            for iP=1:nP
                if(~isempty(conv{iNefem,iP,iH,iComp}))
                    cpuFile=fullfile('circle_cpu',nefemStr,sprintf('H%d_p%d_TM.cpuTime',iH,iP));
                    fid = fopen(cpuFile,'r');
                    cpuTime = fscanf(fid,'%e',[3,15]);
                    fclose(fid);

                    finalErrorTmp = conv{iNefem,iP,iH,iComp}.finalError;
                    nFreqs = size(finalErrorTmp,1);
                    for iFreq=1:nFreqMax
                        errDiff=abs(finalErrorTmp(iFreq)-conv{iNefem,iP,iH,iComp}.error(iFreq,:));

    %                         idx = find(errDiff==0,1,'first');
                        idx = find(errDiff<1e-3,1,'first');

                        if(~isempty(idx))
                            minutesPerStep(iH,iP,iNefem,iFreq,iComp) = min(cpuTime(2,:))/100;
                            periodRequired(iH,iP,iNefem,iFreq,iComp) = conv{iNefem,iP,iH,iComp}.T(idx);
                            nOfTimeSteps(iH,iP,iNefem,iFreq,iComp) = periodRequired(iH,iP,iNefem,iFreq,iComp)/dtStability(iH,iP);
                            %nOfTimeSteps(iH,iP,iNefem,iFreq,iComp) = conv{iNefem,iP,iH,iComp}.nOfTimeSteps(idx);
                        else
                            periodRequired(iH,iP,iNefem,iFreq,iComp) = inf;
                        end
                    end
                end
            end
        end
    end
end

warning('nOfTimeSteps is being calculated from stability condition....should be from actual timesteps');

timeTotMinutes = minutesPerStep.*nOfTimeSteps;
% in units of the fastest CPU time?
minTime = min(reshape(timeTotMinutes,numel(timeTotMinutes),1));
timeNomalised = timeTotMinutes/minTime;

%% calc ndof
nComps = 3;
refElem = refElemHybrid2D(nP, 1, 0);
ndof_h = refElem(iType,1).nOfNodes*nElem*nComps;
ndof_p=zeros(nP,1);
for iP=1:nP
    ndof_p(iP) = refElem(iType,iP).nOfNodes*nElem(1)*nComps;
end

%% plot (compare high and low order)
for iComp=plotComp
    for iFreq=plotFreq
        fprintf('F%d\n',iFreq);
        figure
        % h-refinement nefem
        plot(sqrt(ndof_h),log10(finalError(:,1,plotCPUAndNDOF,iFreq,iComp)),line.nefemHRef.sty,'color',line.nefemHRef.color,'Linewidth',2,'Markersize',8,'displayName',sprintf('%s $h$-refinement',nefemStrs{plotCPUAndNDOF}))
        hold on
        % p-refinement nefem
        plot(sqrt(ndof_p),log10(finalError(1,:,plotCPUAndNDOF,iFreq,iComp)),line.nefemPRef.sty,'color',line.nefemPRef.color,'Linewidth',2,'Markersize',8,'displayName',sprintf('%s $p$-refinement',nefemStrs{plotCPUAndNDOF}))

        xlabel('$$\sqrt{\texttt{n}_{\texttt{dof}}}$$','Interpreter','latex')
        ylabel('$$\textrm{log}_{10}(\textrm{Frequency Error})$$','Interpreter','latex')
        legend('show','Location','NorthEast')
        grid on
        axis([0 axX axY 0])
        xlim([0,150]);

        if(saveFigures)
            fSaveName = sprintf('%s/ndof/F%d_U%d',saveFigures,iFreq,plotComp);
        else
            fSaveName = false;
        end
        latexExportFigure('resizeImage',doResizeImage,'fontSize',setFontSize,'save',fSaveName,'gradient',false);
    end
end

%% Compute slopes
slopes = zeros(nH-1, nP, 2, nFreqMax, nComponentsMax);
for iComp=plotComp
    for iNefem=1:2
        for iP=1:nP
            for iFreq=1:nFreqMax
                denom = log10(h(1,2:nH)) - log10(h(1,1:nH-1));
                num = log10(finalError(2:nH,iP,iNefem,iFreq,iComp)) - log10(finalError(1:nH-1,iP,iNefem,iFreq,iComp));
                slopes(:,iP,iNefem,iFreq,iComp) = num'./denom;
            end
        end
    end
end

% compare FEM and NEFEM (h-refinement)
for iComp=plotComp
    for iFreq=plotFreq
        fprintf('F%d\n',iFreq);
        figure
        % h-refinement iso
        plot(log10(h),log10(finalError(:,1,ISO,iFreq,iComp)),lineSty{1,1},'Linewidth',2,'Markersize',8)
        hold on
        % h-refinement nefem
        plot(log10(h(1:4)),log10(finalError(1:4,1,NEFEM,iFreq,iComp)),lineSty{2,1},'Linewidth',2,'Markersize',8)
        % h-refinement iso p2
        plot(log10(h),log10(finalError(:,2,ISO,iFreq,iComp)),lineSty{1,2},'Linewidth',2,'Markersize',8)
        % h-refinement nefem p2
        plot(log10(h(1:3)),log10(finalError(1:3,2,NEFEM,iFreq,iComp)),lineSty{2,2},'Linewidth',2,'Markersize',8)


        fprintf('FEM iFreq=%d\n', iFreq)
        disp(slopes(:,:,1,iFreq))
        fprintf('NEFEM iFreq=%d\n', iFreq)
        disp(slopes(:,:,2,iFreq))

        xlabel('$$\textrm{log}_{10}(h)$$','Interpreter','latex');
        ylabel('$$\textrm{log}_{10}(\textrm{Frequency Error})$$','Interpreter','latex');
        legend('FEM ','NEFEM ','FEM $$p=2$$','NEFEM $$p=2$$','Location','NorthWest')
        grid on
        axis([-2 0 axY 0])

        if(saveFigures)
            fSaveName = sprintf('%s/href/F%d_U%d',saveFigures,iFreq,plotComp);
        else
            fSaveName = false;
        end
        latexExportFigure('resizeImage',doResizeImage,'fontSize',setFontSize,'save',fSaveName,'gradient',true);
    end
end

%% compare FEM and NEFEM (p-refinement)
for iComp=plotComp
    for iFreq=plotFreq
        fprintf('F%d U%d\n',iFreq);
        figure
        % p-refinement iso
        plot(sqrt(ndof_p),log10(finalError(1,:,1,iFreq,iComp)),line.NefemVsFemPRef.FEM.sty,'color',line.NefemVsFemPRef.FEM.color,'Linewidth',2,'Markersize',8,'displayName',nefemStrs{ISO})
        hold on
        % p-refinement nefem
        plot(sqrt(ndof_p),log10(finalError(1,:,2,iFreq,iComp)),line.NefemVsFemPRef.NEFEM.sty,'color',line.NefemVsFemPRef.NEFEM.color,'Linewidth',2,'Markersize',8,'displayName',nefemStrs{NEFEM})

        xlabel('$$\sqrt{n_{\textrm{dof}}}$$','Interpreter','latex');
        ylabel('$$\textrm{log}_{10}(\textrm{Frequency Error})$$','Interpreter','latex');
        legend('show','Location','NorthEast')
        grid on
        axis([5 20 axY 0])

        if(saveFigures)
            fSaveName = sprintf('%s/pref/F%d_U%d',saveFigures,iFreq,plotComp);
        else
            fSaveName = false;
        end
        latexExportFigure('resizeImage',doResizeImage,'fontSize',setFontSize,'save',fSaveName,'gradient',false);
    end
end
timeNomalised = log10(timeNomalised);

%% compare CPU times
warning('CPU times are done without considering each component');
for iComp=plotComp
    for iFreq=plotFreq
        fprintf('F%d\n',iFreq);
        figure
        % h-refinement
        plot(timeNomalised(:,1,plotCPUAndNDOF,iFreq),log10(finalError(:,1,plotCPUAndNDOF,iFreq,iComp)),line.nefemHRef.sty,'Linewidth',2,'Markersize',8,'color',line.nefemHRef.color,'displayName',sprintf('%s $h$-refinement',nefemStrs{plotCPUAndNDOF}))
        hold on
        % p-refinement
        plot(timeNomalised(1,:,plotCPUAndNDOF,iFreq),log10(finalError(1,:,plotCPUAndNDOF,iFreq,iComp)),line.nefemPRef.sty,'Linewidth',2,'Markersize',8,'color',line.nefemPRef.color,'displayName',sprintf('%s $p$-refinement',nefemStrs{plotCPUAndNDOF}))

        xlabel('$$\textrm{log}_{10}(\textrm{Normalised Wall Time})$$','Interpreter','latex');
        ylabel('$$\textrm{log}_{10}(\textrm{Frequency Error})$$','Interpreter','latex');
        legend('show','Location','NorthEast')
        grid on

        if(saveFigures)
            fSaveName = sprintf('%s/cpu/F%d_U%d',saveFigures,iFreq,plotComp);
        else
            fSaveName = false;
        end
        latexExportFigure('resizeImage',doResizeImage,'fontSize',setFontSize,'save',fSaveName,'gradient',false);
    end
end


warning('plotCPUAndNDOF should be NEFEM');
