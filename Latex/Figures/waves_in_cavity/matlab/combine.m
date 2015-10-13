hFig = figure;

%# create temporary subplots as template
for i=1:4, h(i) = subplot(2,2,i); end       %# create subplots
pos = get(h, 'Position');                   %# record their positions
delete(h)                                   %# delete them

%# load the .fig files inside the new figure
fileNames = {'run_figure1.fig' 'run_figure2.fig','run_figure3.fig' 'run_figure4.fig'};              %# saved *.fig file names
for i=1:4
    %# load fig
    hFigFile = hgload( fileNames{i} );

    %# move/copy axis from old fig to new fig
    hAx = get(hFigFile, 'Child');           %# hAx = gca;
    set(hAx, 'Parent',hFig)
    %#hAx = copyobj(hAx,hFig);

    %# resize it to match subplot position
    set(hAx, 'Position',pos{i});

    %# delete old fig
    %delete(hFigFile)
end