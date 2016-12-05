close all;
clear all
clc

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

%% config
plotCPUAndNDOF=NEFEM;
plotFreq = 1;
plotComp = 1;

nH = 5;
nP = 4;
nElem = [4, 16, 64, 256, 1024];
h = 0.5.^[1:5];
nFreqMax = 10;
nOfComponents = 6;
iType = 1;
axX = 140; 
axY = -7;
pPlot = 1:4;
lineSty = {'k-o', 'r-s'; 'k--o', 'r--s'};

conv = cell(nP,nH);
convUnion = cell(nP,nH);

for iNefem=1:2
    for iH=1:nH
        for iP=1:nP
            dataFile = sprintf('circle_data/%s/H%d_p%d_TM_conv.union.mat',nefemStrs{iNefem},iH,iP);
            if(exist(dataFile,'file'))
                convUnion{iP,iH,iNefem}=importdata(dataFile);
            end
            
            dataFile = sprintf('circle_data/%s/H%d_p%d_TM_conv.mat',nefemStrs{iNefem},iH,iP);
            if(exist(dataFile,'file'))
                conv{iP,iH,iNefem}=importdata(dataFile);
            end
        end
    end
end

%%
close all;
iFreq = 1;

for iNefem=1:2
    for iH=1:nH
        for iP=1:nP
            if(~isempty(conv{iP,iH,iNefem}) && ~isempty(convUnion{iP,iH,iNefem}))
                figure
                hold on
                
                nComp = size(conv{iP,iH,iNefem}.freq,2);
                for iComp=1:nComp
                    plot(conv{iP,iH,iNefem}.T,log10(conv{iP,iH,iNefem}.freq{iFreq,iComp}.error))
                end
            
                iComp = 1;
                plot(convUnion{iP,iH,iNefem}.T,log10(convUnion{iP,iH,iNefem}.freq{iFreq,iComp}.error),'r') 
                title(sprintf('p%d H%d %d',iP,iH,iNefem));
            end
        end
    end
end