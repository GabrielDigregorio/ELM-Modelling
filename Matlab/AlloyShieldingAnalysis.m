% Postprocess the data
close all
clear all

%% Influence of l_shield
for i=1:5
DATA.muMetal(:,:,i) = load(strcat('../magnetic/b_line_muMetal_l',num2str(i),'.txt'))
DATA.FerriticSteinlessSteel(:,:,i) = load(strcat('../magnetic/b_line_FerriticSteinlessSteel_l',num2str(i),'.txt'))
DATA.CarbonSteel(:,:,i) = load(strcat('../magnetic/b_line_CarbonSteel_l',num2str(i),'.txt'))
end

MeasurementPoint = 50; % x=0, y=-4.05, z=0

figure(1)
hold on
plot(DATA.muMetal(MeasurementPoint,3,:),...
             sqrt( DATA.muMetal(MeasurementPoint,9,:).^2 +...
             DATA.muMetal(MeasurementPoint,10,:).^2 +...
             DATA.muMetal(MeasurementPoint,11,:).^2))
plot(DATA.FerriticSteinlessSteel(MeasurementPoint,3,:),...
             sqrt( DATA.FerriticSteinlessSteel(MeasurementPoint,9,:).^2 +...
             DATA.FerriticSteinlessSteel(MeasurementPoint,10,:).^2 + ...
             DATA.FerriticSteinlessSteel(MeasurementPoint,11,:).^2))
plot(DATA.CarbonSteel(MeasurementPoint,3,:),...
             sqrt( DATA.CarbonSteel(MeasurementPoint,9,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,10,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,11,:).^2))
xlabel('$l_{shield}$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
grid on
hold off



%% Influence of t_shield
for i=1:5
DATA.muMetal(:,:,i) = load(strcat('../magnetic/b_line_muMetal_t',num2str(i),'.txt'))
DATA.FerriticSteinlessSteel(:,:,i) = load(strcat('../magnetic/b_line_FerriticSteinlessSteel_t',num2str(i),'.txt'))
DATA.CarbonSteel(:,:,i) = load(strcat('../magnetic/b_line_CarbonSteel_t',num2str(i),'.txt'))
end

MeasurementPoint = 50; % x=0, y=-4.05, z=0

figure(2)
hold on
plot(DATA.muMetal(MeasurementPoint,3,:),...
             sqrt( DATA.muMetal(MeasurementPoint,9,:).^2 +...
             DATA.muMetal(MeasurementPoint,10,:).^2 +...
             DATA.muMetal(MeasurementPoint,11,:).^2))
plot(DATA.FerriticSteinlessSteel(MeasurementPoint,3,:),...
             sqrt( DATA.FerriticSteinlessSteel(MeasurementPoint,9,:).^2 +...
             DATA.FerriticSteinlessSteel(MeasurementPoint,10,:).^2 + ...
             DATA.FerriticSteinlessSteel(MeasurementPoint,11,:).^2))
plot(DATA.CarbonSteel(MeasurementPoint,3,:),...
             sqrt( DATA.CarbonSteel(MeasurementPoint,9,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,10,:).^2 +...
             DATA.CarbonSteel(MeasurementPoint,11,:).^2))
xlabel('$t_{shield}$ [m]','interpreter', 'latex')
ylabel('$\| \!R \{ \textbf{B}\} \|$[T]', 'interpreter', 'latex')
grid on
hold off