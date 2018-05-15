close all
clear all
DATA_phi = dlmread('phi_line.txt');
DATA_n = dlmread('n_line.txt');
DATA_p = dlmread('p_line.txt');

% V
figure(1)
hold on
plot(DATA_phi(:,6),DATA_phi(:,8))
legend('V')
hold off
grid on
box on

% E
figure(2)
plot(DATA_phi(:,6),diff([DATA_phi(1,8) ;DATA_phi(:,8)]))
legend('E')
grid on
box on


% n p
figure(3)
hold on
plot(DATA_n(:,6),DATA_n(:,8))
plot(DATA_p(:,6),DATA_p(:,8))
set(gca,'yscale','log');
legend('n','p')
hold off
grid on
box on