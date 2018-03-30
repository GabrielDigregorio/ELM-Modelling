% Postprocess the data
close all
clear all
load('../magnetic/b_line.txt')

% CHANGE THE INDICES
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2))
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
grid on
