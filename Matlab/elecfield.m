%% 
clear all
close all

M=[0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.1 5 6 7];
norm_e=[6.89e6 6.01e6 5.47e6 5.01e6 4.71e6 4.46e6 4.24e6 4.13e6 3.96e6 3.79e6 3.72e6 3.59e6 3.53e6 3.48e6 3.41e6 3.35e6 3.28e6 3.23e6 3.14e6 3.06e6 2.99e6 2.93e6 2.88e6 2.83e6 2.77e6 2.73e6 2.71e6 2.69e6 2.58e6 2.48e6 2.43e6];
figure
plot(M,norm_e, 'linewidth', 2);
xlabel('$M$ [m]','interpreter', 'latex')
ylabel('$\|\textbf{E}\|$[V/m]', 'interpreter', 'latex')
grid on


%1A/mm^2->10^6 A/m^2
I=[1000 1200 1400 1600 1800 2000 2200];
J=[4.95e5 5.94e5 6.93e5 7.93e5 8.92e5 9.95e5 1.09e6];
figure
plot(I,J, 'linewidth', 2);
xlabel('$I$ [A]','interpreter', 'latex')
ylabel('$J$[A/m$^2$]', 'interpreter', 'latex')
grid on
p = polyfit(I,J,1);

J_wanted=8.5e5;

I_calulated=(J_wanted-p(2))/p(1);

