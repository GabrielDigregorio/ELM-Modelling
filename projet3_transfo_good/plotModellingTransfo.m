close all
clear all


DATA1 = dlmread('norm_of_b.txt');

DATA2 = dlmread('norm_of_b_line.txt');


figure(1)
hist(DATA1(:,15),500);
pourcentage_histogram = length(find(DATA1(:,15)<=1.8))/length(DATA1(:,15))
xlabel('$|b|$ [T]', 'interpreter', 'LaTex')
ylabel('Count [arb.un.]', 'interpreter', 'LaTex')
grid on

figure(2)
plot(DATA2(:,3)-min(DATA2(:,3)),DATA2(:,9));
xlabel('$x$ [m]', 'interpreter', 'LaTex')
ylabel('$|b|$ [T]', 'interpreter', 'LaTex')
axis([0 0.04 0 2])
grid on



% UI analysis
disp(['****************************'])
disp(['Power Analysis:'])
UI = importdata('UI.txt');
Vp = norm([str2num(UI.textdata{3,2}) str2num(UI.textdata{3,3})]);
Ip = norm([str2num(UI.textdata{5,2}) str2num(UI.textdata{5,3})]);
Vs = norm([str2num(UI.textdata{8,2}) str2num(UI.textdata{8,3})]);
Is = norm([str2num(UI.textdata{10,2}) str2num(UI.textdata{10,3})]);
P = str2num(UI.textdata{3,2}) * str2num(UI.textdata{5,2});
Q = str2num(UI.textdata{3,3}) * str2num(UI.textdata{5,3});

Power_in = Vp.*Ip
power_out = Vs.*Is

Efficiency = power_out/Power_in

% open circuit
disp(['****************************'])
disp(['open circuit:'])
Rp_Rs = P/Is^2
Xp_Xs = Q/Is^2

% short circuit
disp(['short circuit:'])
Rc = Vp^2/P
Xm = Vp^2/Q


