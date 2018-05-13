close all
DATA_phi = dlmread('phi_line.txt');
DATA_Na = dlmread('Na.txt');
DATA_Nd = dlmread('Nd.txt');


figure(1)
hold on
plot(DATA_phi(:,4),DATA_phi(:,6), '*')
%plot(DATA_Na(:,1),-DATA_Na(:,2)*1e-15, 'Color', 'magenta')
%plot(DATA_Nd(:,1),DATA_Nd(:,2)*1e-15, 'Color', 'blue')
hold off

figure(2)
plot(DATA_phi(:,3),diff([DATA_phi(1,end-1) ;DATA_phi(:,end-1)]), '*')


DATA_phi = dlmread('E.txt');
figure(3)
plot(DATA_phi(:,3),DATA_phi(:,end-1), '*')

