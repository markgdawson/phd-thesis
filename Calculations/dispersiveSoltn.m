clear all;
close all;
eps_inf = 1;
w_p = 0;
y = 0.1;

m = 0;
n = 1;

A = 1;
B = 2;

plotit=false;

if(plotit)
    maxYX=100;
    range = -maxYX:0.01:maxYX;

    [X,Y] = meshgrid(range,range);
    w = X + 1i.*Y;
end

ky = sqrt(((m.*pi)/A).^2 + ((n.*pi)/B).^2);

epsD = @(w) eps_inf - (w_p.^2)./(w.^2 - 1i.*w.*y);
charD = @(w,ky) w.^2.*epsD(w) - ky.^2;
if(plotit)
    subplot(3,1,1)
    surf(X,Y,zeros(size(X)),abs(charD(w,ky)),'edgeColor','none');
    view([0,90]);
    title('Drude');
end

epsJ = @(w) eps_inf - (w_p.^2)./(- 1i.*w.*y);
charJ = @(w,ky) w.^2.*epsJ(w) - ky.^2;
if(plotit)
    subplot(3,1,2)
    surf(X,Y,zeros(size(X)),abs(charJ(w,ky)),'edgeColor','none');
    view([0,90]);
    title('Joule');

subplot(3,1,3)
surf(X,Y,zeros(size(X)),abs(abs(charJ(w,ky))-abs(charD(w,ky))),'edgeColor','none');
view([0,90]);
title('Diff');
end

%%
nMode=10;
minCoordD = nan(nMode,nMode);
minCoordJ = nan(nMode,nMode);
minValD = nan(nMode,nMode);
minValJ = nan(nMode,nMode);
for m=0:nMode
    for n=0:nMode
        ky = sqrt(((m.*pi)./A).^2 + ((n.*pi)./B).^2);
        
        fun=@(x) abs(charD(x(1)+1i.*x(2),ky));
        valTmp = fsolve(fun,[5,0.2],optimset('TolX',0.000000000001,'TolFun',0.000000000001));
        minCoordD(m+1,n+1) = valTmp(1) + 1i*valTmp(2);
        minValD(m+1,n+1) = fun(valTmp);

        fun=@(x) abs(charJ(x(1)+1i.*x(2),ky));
        valTmp = fsolve(fun,[5,0.2],optimset('TolX',0.000000000001,'TolFun',0.000000000001));
        minCoordJ(m+1,n+1) = valTmp(1) + 1i*valTmp(2);
        minValJ(m+1,n+1) = fun(valTmp);
    end
end
%figure
%plot(X,Y,zeros(size(X)),epsD,'edgeColor','none');

%%
k=AnalyticalRectangularModalCavity(1:100);
plotVertLines(k);
hold all
plotVertLines(unique(sort(real(minCoordD))));