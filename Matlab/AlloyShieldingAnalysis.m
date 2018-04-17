% Postprocess the data
close all
clear all

% Mu-Metal :
%               Expensive, high permeability
%               sigma = 1.61e+06 [1/(ohm.m)]   
%               mu_r = 50000 
%               Price/m^3 = 3e+06 $ 

% AK Steel 400 :
%               is one of the most economical chromium ferritic stainless steels
%               sigma = 1.66e+06 [1/(ohm.m)] 
%               mu_r = 1800 
%               Price/m^3 = 

% Medium grade Carbon Steel :
%               Expensive, high permeability
%               sigma = 6.02e+06 [1/(ohm.m)]
%               mu_r = 100  
%               Price/m^3 = 7785.63$



%% Influence of l_shield
l=[2 4 6 8 10];
for i=1:5
DATA.muMetal(:,:,i) = load(strcat('../magnetic/results/b_line_muMetal_l',num2str(l(i)),'.txt'))
DATA.FerriticSteinlessSteel(:,:,i) = load(strcat('../magnetic/results/b_line_FerriticSteinlessSteel_l',num2str(l(i)),'.txt'))
DATA.CarbonSteel(:,:,i) = load(strcat('../magnetic/results/b_line_CarbonSteel_l',num2str(l(i)),'.txt'))
end

MeasurementPoint = 50; % x=0, y=-4.05, z=0
 
figure(1)
hold on
plot(l,...
             reshape(max(sqrt( DATA.muMetal(:,9,:).^2 +...
             DATA.muMetal(:,10,:).^2 +...
             DATA.muMetal(:,11,:).^2)),[1,5]), 'linewidth',2)
plot(l,...
             reshape(max(sqrt( DATA.FerriticSteinlessSteel(:,9,:).^2 +...
             DATA.FerriticSteinlessSteel(:,10,:).^2 + ...
             DATA.FerriticSteinlessSteel(:,11,:).^2)),[1,5]), 'linewidth',2)
plot(l,...
             reshape(max(sqrt( DATA.CarbonSteel(:,9,:).^2 +...
             DATA.CarbonSteel(:,10,:).^2 +...
             DATA.CarbonSteel(:,11,:).^2)),[1,5]), 'linewidth',2)
         
plot(l,...
             reshape(sqrt( DATA.muMetal(MeasurementPoint,9,:).^2 +...
             DATA.muMetal(MeasurementPoint,10,:).^2 +...
             DATA.muMetal(MeasurementPoint,11,:).^2),[1,5]))
plot(l,...
             reshape(sqrt( DATA.FerriticSteinlessSteel(MeasurementPoint,9,:).^2 +...
             DATA.FerriticSteinlessSteel(MeasurementPoint,10,:).^2 + ...
             DATA.FerriticSteinlessSteel(MeasurementPoint,11,:).^2),[1,5]))
plot(l,...
             reshape(sqrt( DATA.CarbonSteel(MeasurementPoint,9,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,10,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,11,:).^2),[1,5]))
         
xlabel('$l_{shield}$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('mu-metal (max)', 'Ferritic Stainless Steel (max)', 'Carbon Steel (max)', 'mu-metal (centered)', 'Ferritic Stainless Steel (centered)', 'Carbon Steel (centered)')
grid on
hold off

%% Comparison

b_line = load('../magnetic/results/b_line_NoShield.txt');

% CHANGE THE INDICES
figure(6)
hold on
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
plot(reshape(DATA.muMetal(:,3,1),[1,101]), sqrt( DATA.muMetal(:,9,1).^2 +...
              DATA.muMetal(:,10,1).^2 +...
              DATA.muMetal(:,11,1).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,2),[1,101]), sqrt( DATA.muMetal(:,9,2).^2 +...
              DATA.muMetal(:,10,2).^2 +...
              DATA.muMetal(:,11,2).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,3),[1,101]), sqrt( DATA.muMetal(:,9,3).^2 +...
              DATA.muMetal(:,10,3).^2 +...
              DATA.muMetal(:,11,3).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,4),[1,101]), sqrt( DATA.muMetal(:,9,4).^2 +...
              DATA.muMetal(:,10,4).^2 +...
              DATA.muMetal(:,11,4).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,5),[1,101]), sqrt( DATA.muMetal(:,9,5).^2 +...
              DATA.muMetal(:,10,5).^2 +...
              DATA.muMetal(:,11,5).^2), 'linewidth',2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('No shield', 'mu-metal l=2m', 'mu-metal l=4m', 'mu-metal l=6m', 'mu-metal l=8m', 'mu-metal l=10m')
legend
grid on

figure(7)
hold on
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,1),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,1).^2 +...
              DATA.FerriticSteinlessSteel(:,10,1).^2 +...
              DATA.FerriticSteinlessSteel(:,11,1).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,2),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,2).^2 +...
              DATA.FerriticSteinlessSteel(:,10,2).^2 +...
              DATA.FerriticSteinlessSteel(:,11,2).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,3),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,3).^2 +...
              DATA.FerriticSteinlessSteel(:,10,3).^2 +...
              DATA.FerriticSteinlessSteel(:,11,3).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,4),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,4).^2 +...
              DATA.FerriticSteinlessSteel(:,10,4).^2 +...
              DATA.FerriticSteinlessSteel(:,11,4).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,5),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,5).^2 +...
              DATA.FerriticSteinlessSteel(:,10,5).^2 +...
              DATA.FerriticSteinlessSteel(:,11,5).^2), 'linewidth',2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('No shield','AK Steel 400 l=2m', 'AK Steel 400 l=4m', 'AK Steel 400 l=6m', 'AK Steel 400 l=8m', 'AK Steel 400 l=10m')
legend
grid on


figure(8)
hold on
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
plot(reshape(DATA.CarbonSteel(:,3,1),[1,101]), sqrt( DATA.CarbonSteel(:,9,1).^2 +...
              DATA.CarbonSteel(:,10,1).^2 +...
              DATA.CarbonSteel(:,11,1).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,2),[1,101]), sqrt( DATA.CarbonSteel(:,9,2).^2 +...
              DATA.CarbonSteel(:,10,2).^2 +...
              DATA.CarbonSteel(:,11,2).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,3),[1,101]), sqrt( DATA.CarbonSteel(:,9,3).^2 +...
              DATA.CarbonSteel(:,10,3).^2 +...
              DATA.CarbonSteel(:,11,3).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,4),[1,101]), sqrt( DATA.CarbonSteel(:,9,4).^2 +...
              DATA.CarbonSteel(:,10,4).^2 +...
              DATA.CarbonSteel(:,11,4).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,5),[1,101]), sqrt( DATA.CarbonSteel(:,9,5).^2 +...
              DATA.CarbonSteel(:,10,5).^2 +...
              DATA.CarbonSteel(:,11,5).^2), 'linewidth',2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('No shield','Carbon Steel l=2m', 'Carbon Steel l=4m', 'Carbon Steel l=6m', 'Carbon Steel l=8m', 'Carbon Steel l=10m')
legend
grid on




%% Influence of t_shield
t=[1 2 3 4 5];
for i=1:5
DATA.muMetal(:,:,i) = load(strcat('../magnetic/results/b_line_muMetal_t',num2str(t(i)),'.txt'))
DATA.FerriticSteinlessSteel(:,:,i) = load(strcat('../magnetic/results/b_line_FerriticSteinlessSteel_t',num2str(t(i)),'.txt'))
DATA.CarbonSteel(:,:,i) = load(strcat('../magnetic/results/b_line_CarbonSteel_t',num2str(t(i)),'.txt'))
end

MeasurementPoint = 50; % x=0, y=-4.05, z=0

figure(2)
hold on
plot(t,...
             reshape(max(sqrt( DATA.muMetal(:,9,:).^2 +...
             DATA.muMetal(:,10,:).^2 +...
             DATA.muMetal(:,11,:).^2)),[1,5]), 'linewidth',2)
plot(t,...
             reshape(max(sqrt( DATA.FerriticSteinlessSteel(:,9,:).^2 +...
             DATA.FerriticSteinlessSteel(:,10,:).^2 + ...
             DATA.FerriticSteinlessSteel(:,11,:).^2)),[1,5]), 'linewidth',2)
plot(t,...
             reshape(max(sqrt( DATA.CarbonSteel(:,9,:).^2 +...
             DATA.CarbonSteel(:,10,:).^2 +...
             DATA.CarbonSteel(:,11,:).^2)),[1,5]), 'linewidth',2)
         
plot(t,...
             reshape(sqrt( DATA.muMetal(MeasurementPoint,9,:).^2 +...
             DATA.muMetal(MeasurementPoint,10,:).^2 +...
             DATA.muMetal(MeasurementPoint,11,:).^2),[1,5]))
plot(t,...
             reshape(sqrt( DATA.FerriticSteinlessSteel(MeasurementPoint,9,:).^2 +...
             DATA.FerriticSteinlessSteel(MeasurementPoint,10,:).^2 + ...
             DATA.FerriticSteinlessSteel(MeasurementPoint,11,:).^2),[1,5]))
plot(t,...
             reshape(sqrt( DATA.CarbonSteel(MeasurementPoint,9,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,10,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,11,:).^2),[1,5]))
         
xlabel('$t_{shield}$ [mm]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('mu-metal (max)', 'Ferritic Stainless Steel (max)', 'Carbon Steel (max)', 'mu-metal (centered)', 'Ferritic Stainless Steel (centered)', 'Carbon Steel (centered)')
grid on
hold off


%% Comparison

b_line = load('../magnetic/results/b_line_NoShield.txt');

% CHANGE THE INDICES
figure(3)
hold on
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
plot(reshape(DATA.muMetal(:,3,1),[1,101]), sqrt( DATA.muMetal(:,9,1).^2 +...
              DATA.muMetal(:,10,1).^2 +...
              DATA.muMetal(:,11,1).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,1),[1,101]), sqrt( DATA.muMetal(:,9,2).^2 +...
              DATA.muMetal(:,10,2).^2 +...
              DATA.muMetal(:,11,2).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,1),[1,101]), sqrt( DATA.muMetal(:,9,3).^2 +...
              DATA.muMetal(:,10,3).^2 +...
              DATA.muMetal(:,11,3).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,1),[1,101]), sqrt( DATA.muMetal(:,9,4).^2 +...
              DATA.muMetal(:,10,4).^2 +...
              DATA.muMetal(:,11,4).^2), 'linewidth',2)
plot(reshape(DATA.muMetal(:,3,1),[1,101]), sqrt( DATA.muMetal(:,9,5).^2 +...
              DATA.muMetal(:,10,5).^2 +...
              DATA.muMetal(:,11,5).^2), 'linewidth',2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('No shield','mu-metal t=1mm', 'mu-metal t=2mm', 'mu-metal t=3mm', 'mu-metal t=4mm', 'mu-metal t=5mm')
legend
grid on

figure(4)
hold on
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,1),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,1).^2 +...
              DATA.FerriticSteinlessSteel(:,10,1).^2 +...
              DATA.FerriticSteinlessSteel(:,11,1).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,1),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,2).^2 +...
              DATA.FerriticSteinlessSteel(:,10,2).^2 +...
              DATA.FerriticSteinlessSteel(:,11,2).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,1),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,3).^2 +...
              DATA.FerriticSteinlessSteel(:,10,3).^2 +...
              DATA.FerriticSteinlessSteel(:,11,3).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,1),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,4).^2 +...
              DATA.FerriticSteinlessSteel(:,10,4).^2 +...
              DATA.FerriticSteinlessSteel(:,11,4).^2), 'linewidth',2)
plot(reshape(DATA.FerriticSteinlessSteel(:,3,1),[1,101]), sqrt( DATA.FerriticSteinlessSteel(:,9,5).^2 +...
              DATA.FerriticSteinlessSteel(:,10,5).^2 +...
              DATA.FerriticSteinlessSteel(:,11,5).^2), 'linewidth',2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('No shield','AK Steel 400 t=1mm', 'AK Steel 400 t=2mm', 'AK Steel 400 t=3mm', 'AK Steel 400 t=4mm', 'AK Steel 400 t=5mm')
legend
grid on


figure(5)
hold on
plot(b_line(:,3),sqrt(b_line(:,9).^2 + b_line(:,10).^2 + b_line(:,11).^2), 'linewidth', 2)
plot(reshape(DATA.CarbonSteel(:,3,1),[1,101]), sqrt( DATA.CarbonSteel(:,9,1).^2 +...
              DATA.CarbonSteel(:,10,1).^2 +...
              DATA.CarbonSteel(:,11,1).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,1),[1,101]), sqrt( DATA.CarbonSteel(:,9,2).^2 +...
              DATA.CarbonSteel(:,10,2).^2 +...
              DATA.CarbonSteel(:,11,2).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,1),[1,101]), sqrt( DATA.CarbonSteel(:,9,3).^2 +...
              DATA.CarbonSteel(:,10,3).^2 +...
              DATA.CarbonSteel(:,11,3).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,1),[1,101]), sqrt( DATA.CarbonSteel(:,9,4).^2 +...
              DATA.CarbonSteel(:,10,4).^2 +...
              DATA.CarbonSteel(:,11,4).^2), 'linewidth',2)
plot(reshape(DATA.CarbonSteel(:,3,1),[1,101]), sqrt( DATA.CarbonSteel(:,9,5).^2 +...
              DATA.CarbonSteel(:,10,5).^2 +...
              DATA.CarbonSteel(:,11,5).^2), 'linewidth',2)
xlabel('$x$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
legend('No shield','Carbon Steel t=1mm', 'Carbon Steel t=2mm', 'Carbon Steel t=3mm', 'Carbon Steel t=4mm', 'Carbon Steel t=5mm')
legend
grid on