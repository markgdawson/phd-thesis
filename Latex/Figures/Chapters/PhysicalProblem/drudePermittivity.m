
close all
omega_p = 1;
gamma=1;
epsilon_inf=1;

omega = 0:0.1:50;

re = epsilon_inf - omega_p^2 ./ ( omega.^2 + gamma^2 );
imag = gamma*omega_p ./ (omega.*(omega.^2 + gamma^2));

figure
xmax=5
txtSize=20;
subplot(121)
set(gca,'fontsize',txtSize)
plot(omega./omega_p, re./epsilon_inf,'LineWidth',1.5)
set(gca,'XTick',[1]);
set(gca,'YTick',[1]);
grid on
% set(gca,'LineWidth', 1);
% set(gca,'GridLineStyle', '-');
ylabel('Re\{ \epsilon_r \} / \epsilon_{\infty}')
xlabel('\omega / \omega_p')
xlim([0,xmax])
ylim([0,1.1])
subplot(122)
set(gca,'fontsize',txtSize)
plot(omega./omega_p, imag./epsilon_inf,'LineWidth',1.5)
ylabel('Im\{ \epsilon_r \} / \epsilon_{\infty}')
xlabel('\omega / \omega_p')
grid on
set(gca,'XTick',[1]);
set(gca,'YTick',[1]);
xlim([0,xmax])