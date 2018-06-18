function [Efficiency] = AnalyseHeight()
close all
clear all

Value_Height = [20 22 24 26 28 30 32 34 36 38 40]

% Listing all files :
if (~nargin)
    listingB = dir('line*');%dir('**/*.csv')
    listingA = dir('b*');
    listingC = dir('UI*');
    FileName1 = string({listingA(:).name}) 
    FileName2 = string({listingB(:).name}) ;
    FileName3 = string({listingC(:).name}) ;
        
end

for i=1:length(FileName1)
clear DATA1
DATA1 = dlmread(FileName1(i));

DATA2 = dlmread(FileName2(i));


figure(3*(i)-2)
hist(DATA1(:,15),500);
pourcentage_histogram = length(find(DATA1(:,15)<=1.8))/length(DATA1(:,15))
xlabel('$|b|$ [T]', 'interpreter', 'LaTex')
ylabel('Count [arb.un.]', 'interpreter', 'LaTex')
grid on

figure(3*(i)-1)
plot(DATA2(:,3)-min(DATA2(:,3)),DATA2(:,9));
xlabel('$x$ [m]', 'interpreter', 'LaTex')
ylabel('$|b|$ [T]', 'interpreter', 'LaTex')
axis([0 0.04 0 2])
grid on

% max magnetic flux density at legs
Max_Magn(i) = max(DATA2(:,9));

% UI analysis
disp(['****************************'])
disp(['Power Analysis:'])
UI = importdata(FileName3(i));
Vp = norm([str2num(UI.textdata{3,2}) str2num(UI.textdata{3,3})]);
Ip = norm([str2num(UI.textdata{5,2}) str2num(UI.textdata{5,3})]);
Vs = norm([str2num(UI.textdata{8,2}) str2num(UI.textdata{8,3})]);
Is = norm([str2num(UI.textdata{10,2}) str2num(UI.textdata{10,3})]);


Power_in = Vp.*Ip;
%Power_in = (str2num(UI.textdata{3,2})+i*str2num(UI.textdata{3,3})) .* ...
%              conj(str2num(UI.textdata{5,2})+i*str2num(UI.textdata{5,3}))
%Power_in = str2num(UI.textdata{3,2}).*str2num(UI.textdata{5,2})
Power_out = Vs.*Is;
%Power_out = (str2num(UI.textdata{8,2})+i*str2num(UI.textdata{8,3})) .* ...
%              conj(str2num(UI.textdata{10,2})+i*str2num(UI.textdata{10,3}))
%Power_out = str2num(UI.textdata{8,2}).*str2num(UI.textdata{10,2})

Efficiency(i) = Power_out/Power_in;

if (i==1)
    S_p = (str2num(UI.textdata{3,2})+ i*str2num(UI.textdata{3,3})) * ...
    conj(str2num(UI.textdata{5,2})+ i*str2num(UI.textdata{5,3}))
    S_i = (str2num(UI.textdata{8,2})+ i*str2num(UI.textdata{8,3})) * ...
    conj(str2num(UI.textdata{10,2})+ i*str2num(UI.textdata{10,3}))

    P = real(S_p)
    Q = imag(S_p)
    
% open circuit
disp(['****************************'])
disp(['open circuit:'])
Rp_Rs = P/Is^2
Xp_Xs = Q/Is^2

% short circuit
disp(['short circuit:'])
Rc = Vp^2/P
Xm = Vp^2/Q
end

end


figure(3*(i)+1)
plot(Value_Height,Efficiency, 'linewidth', 2);
xlabel('$H$ [m]', 'interpreter', 'LaTex')
ylabel('$\eta$ [-]', 'interpreter', 'LaTex')
yyaxis right
plot(Value_Height,Max_Magn, 'linewidth', 2);
ylabel('$|b|$ [T]', 'interpreter', 'LaTex')
grid on


end
