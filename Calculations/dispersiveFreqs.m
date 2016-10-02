clear all;

eps_inf = 1;
w_p = 0.7933333;
y = 0.076;

A = 1;
B = 2;

epsD = @(w) eps_inf - (w_p.^2)./(w.^2 - 1i.*w.*y);
charD = @(w,ky) w.^2.*epsD(w) - ky.^2;

%%
nMode=10;
minCoordD = nan(nMode,nMode);
minValD = nan(nMode,nMode);

analyt=AnalyticalRectangularModalCavity(1:100);

for m=0:nMode
    for n=0:nMode
        k_mn = sqrt(((m*pi)/A)^2 + ((n*pi)/B)^2);
        c = sqrt(eps_inf);
        f_guess = (1/(2*pi*c))*k_mn;

        ky = sqrt(((m.*pi)./A).^2 + ((n.*pi)./B).^2);
        
        fun=@(x) abs(charD(x(1)+1i.*x(2),ky));
        valTmp = fsolve(fun,[f_guess,0.2],optimset('TolX',0.000000000001,'TolFun',0.000000000001));
        minCoordD(m+1,n+1) = valTmp(1) + 1i*valTmp(2);
        minValD(m+1,n+1) = fun(valTmp);
    end
end
%figure
%plot(X,Y,zeros(size(X)),epsD,'edgeColor','none');

%%

plotVertLines(analyt,'lineSty','b-');
hold all
f = unique(sort(real(minCoordD./(2*pi))));
plotVertLines(f,'lineSty','r--');