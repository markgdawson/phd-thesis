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
set(gca,'XTickLabel','1');
set(gca,'YTickLabel','1');
grid on
% set(gca,'LineWidth', 1);
% set(gca,'GridLineStyle', '-');
ylabel('$\textrm{Im}\{ \varepsilon_r \} / \varepsilon_{\infty}$')
xlabel('$\omega / \omega_{p}$')
xlim([0,xmax])
ylim([0,1.1])
latexExportFigure('file','drudePermittivityReal');
figure;
set(gca,'fontsize',txtSize)
plot(omega./omega_p, imag./epsilon_inf,'k','LineWidth',1.5)
ylabel('$\textrm{Re}\{ \varepsilon_r \} / \varepsilon_{\infty}$')
xlabel('$\omega / \omega_{p}$')
grid on
set(gca,'XTick',1);
set(gca,'YTick',1);
set(gca,'XTickLabel','1');
set(gca,'YTickLabel','1');
xlim([0,xmax])
latexExportFigure('file','drudePermittivityImag');