% Postprocess the data
close all
clear all
Maille1 = load('../magnetic/results/Maille1.txt');
Maille2 = load('../magnetic/results/Maille2.txt');
Maille3 = load('../magnetic/results/Maille3.txt');

% CHANGE THE INDICES
figure(1)
hold on
plot(Maille1(:,3),sqrt(Maille1(:,9).^2 + Maille1(:,10).^2 + Maille1(:,11).^2), 'linewidth', 2)
plot(Maille2(:,3),sqrt(Maille2(:,9).^2 + Maille2(:,10).^2 + Maille2(:,11).^2), 'linewidth', 2)
plot(Maille3(:,3),sqrt(Maille3(:,9).^2 + Maille3(:,10).^2 + Maille3(:,11).^2), 'linewidth', 2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('Mesh density: along the shield = 100, across the shield = 1000', 'Mesh density: along the shield = 150, across the shield = 1000', 'Mesh density: along the shield = 150, across the shield = 2000')
grid on