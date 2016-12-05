close all;
clear all;

types={'FEM','NEFEM'};

% TE
mode='TE';
%freqs = 2;
freqs = 6;

% TM
mode='TM';
freqs = 1:9;

nP = 9;

% ndof
iType = 1;
nElem = [4, 16, 64, 256, 1024];
nOfComponents = 3;

refElem = refElemHybrid2D(nP, 1, 0);
ndof_h = refElem(iType,1).nOfNodes*nElem*nOfComponents;
ndof_p=zeros(nP,1);
for iP=1:nP
    ndof_p(iP) = refElem(iType,iP).nOfNodes*nElem(1)*nOfComponents;
end

freqColor=hsv(max(freqs));

% ndof
typeLine = {'.-','.--'};

for iType=1:2
    figure(iType);
    type=types{iType};
    
    finalError = nan(nP,max(freqs));
    dts = nan(nP,1);
    conv = cell(nP,1);
    
    for iP=1:nP
        dtFile=sprintf('%s/%s/meshCircularCavity_H1_p%d_%s/uPoint.dt',type,mode,iP,mode);
        if(exist(dtFile,'file'))
            dts(iP) = importdata(dtFile);
        end
            
        convFile=sprintf('%s/%s/meshCircularCavity_H1_p%d_%s/convFFT.mat',type,mode,iP,mode);
        if(exist(convFile,'file'))
            conv{iP}=load(convFile);
            finalError(iP,freqs) = conv{iP}.finalError(freqs);

            subplot(3,3,iP);
            for iFreq=freqs
                plot([1,10],log10(finalError(iP,iFreq)*[1,1]),'k:')
                hold on
            end

            conv{iP}.plot('newfig',false);
            legend hide
            hold all

            ylim([-9,-2]);
            title(sprintf('p%d',iP));
        end
    end

    figure(3);
    for iFreq=freqs
        plot(sqrt(ndof_p),log10(finalError(:,iFreq)),typeLine{iType},'markerSize',20,'displayName',sprintf('F%d',iFreq),'color',freqColor(iFreq,:))
        hold all;
    end
    title(sprintf('%s',mode));
    xlabel('sqrt(ndof)');
    ylabel('log10(err)');
    legend show
    
    figure(4);
    plot(sqrt(ndof_p),dts,typeLine{iType},'markerSize',20,'displayName',sprintf('F%d',iFreq),'color',freqColor(iFreq,:))
    hold all;
    xlabel('dt');
    ylabel('log10(err)');
end