omega_p = 1;
gamma=1;
epsilon_inf=1;

omega = 0:0.1:50;

re = epsilon_inf - omega_p^2 ./ ( omega.^2 + gamma^2 );
imag = gamma*omega_p ./ (omega.*(omega.^2 + gamma^2));

xmax=5;
txtSize=20;
figure;
set(gca,'fontsize',txtSize)
plot(omega./omega_p, re./epsilon_inf,'k','LineWidth',1.5)
set(gca,'XTick',[1]);
set(gca,'YTick',[1]);
set(gca,'XTickLabel','$\omega_{p}$');
set(gca,'YTickLabel','$\varepsilon_{\infty}$');
grid on
% set(gca,'LineWidth', 1);
% set(gca,'GridLineStyle', '-');
ylabel('$Re\{ \varepsilon_r \}$')
xlabel('$\omega$')
xlim([0,xmax])
ylim([0,1.1])
latexExportFigure('file','drudePermittivityReal');
figure;
set(gca,'fontsize',txtSize)
plot(omega./omega_p, imag./epsilon_inf,'k','LineWidth',1.5)
ylabel('$Im\{ \varepsilon_r \}$')
xlabel('$\omega$')
grid on
set(gca,'XTick',[1]);
set(gca,'YTick',[1]);
set(gca,'XTickLabel','$\omega_{p}$');
set(gca,'YTickLabel','$\varepsilon_{\infty}$');
xlim([0,xmax])
latexExportFigure('file','drudePermittivityImag');