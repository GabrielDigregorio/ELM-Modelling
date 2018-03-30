%% 
clear all
close all

M=[0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.1];
norm_e=[6.89e6 6.01e6 5.47e6 5.01e6 4.71e6 4.46e6 4.24e6 4.13e6 3.96e6 3.79e6 3.72e6 3.59e6 3.53e6 3.48e6 3.41e6 3.35e6 3.28e6 3.23e6 3.14e6 3.06e6 2.99e6 2.93e6 2.88e6 2.83e6 2.77e6 2.73e6 2.71e6 2.69e6];
figure
plot(M,norm_e, 'linewidth', 2);
xlabel('$M$ [m]','interpreter', 'latex')
ylabel('$\|\textbf{E}\|$[V/m]', 'interpreter', 'latex')
grid on
