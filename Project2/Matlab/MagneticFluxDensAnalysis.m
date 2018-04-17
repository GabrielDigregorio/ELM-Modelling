% Postprocess the data
close all
clear all
b_line = load('../magnetic/results/b_line_NoShield.txt');

% CHANGE THE INDICES
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
grid on
