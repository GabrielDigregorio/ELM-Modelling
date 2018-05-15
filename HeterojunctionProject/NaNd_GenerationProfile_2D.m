% Generat profile Na Nd

% How to launch :
%                    NaNd_GenerationProfile(1,1e15,1e15,2.5e-4,2.5e-4) In cm !!!


% profile = 1 ==> constant concentration
% profile = 2 ==>
% profile = 3 ==>
% profile = 4 ==>

function [] = NaNd_GenerationProfile_2D(profile, N_a_experiment, N_d_experiment, t_NiO, t_ZnO)
% General
q         = 1.6021766208e-19;       % [C] absolute value of the chanrge electrons
epsilon_0 = 8.85418782e-12;         % [cm-3 kg-1 s4 A2] vacuum permitivity
T         = 300;                    % [K]
k_b       = 1.3806e-23;
m0        = 9.109e-31 ;             % [kg] mass electron

% comsol [cm]
Na_comsol = 1e15; %[1/cm^3] Acceptor concentration
Nd_comsol = 1e15; %[1/cm^3] Donor concentration
epsilonr_param_comsol = 11.8; % Relative permittivity
Eg0_param_comsol = 1.12; %[V] Band gap
chi0_param_comsol = 4.05; %[V] Electron affinity
Ni_comsol = 1.25e10; %[1/cm^3] Intrinsic carrier concentration
Nc_param_comsol = Ni_comsol*exp(Eg0_param_comsol*q/(2*k_b*T)); % Conduction band density of states
Nv_param_comsol = Ni_comsol*exp(Eg0_param_comsol*q/(2*k_b*T)); % Valence band density of states
taun_param_comsol = 1e-6; %[s] Electron lifetime
taup_param_comsol = taun_param_comsol; % Hole lifetime
bias_comsol = -4; %[V] Device bias

x_p = 0.65e-6
x_n = 0.65e-6


fileID_Na = fopen( 'Na.txt', 'wt' );
fileID_Nd = fopen( 'Nd.txt', 'wt' );
PourcentCoeff = 0.08;

if (profile == 1)
    %     fprintf(fileID_Na , '%i %i\n', -t_NiO, 0);
    %     fprintf(fileID_Na , '%i %i\n', -x_p, 0);
    %     fprintf(fileID_Na , '%i %i\n', -x_p+(PourcentCoeff/2)*x_p, N_a_experiment/2);
    %     fprintf(fileID_Na , '%i %i\n', -x_p+PourcentCoeff*x_p, N_a_experiment);
    %     fprintf(fileID_Na , '%i %i\n', 0-10*eps, N_a_experiment);
    %     fprintf(fileID_Na , '%i %i\n', 0+10*eps, 0);
    %     fprintf(fileID_Na , '%i %i\n', t_ZnO, 0);
    %     fprintf(fileID_Nd , '%i %i\n', -t_NiO, 0);
    %     fprintf(fileID_Nd , '%i %i\n', 0-10*eps, 0);
    %     fprintf(fileID_Nd , '%i %i\n', 0+10*eps, N_d_experiment);
    %     fprintf(fileID_Nd , '%i %i\n', x_n-PourcentCoeff*x_n, N_d_experiment);
    %     fprintf(fileID_Nd , '%i %i\n', x_n-(PourcentCoeff/2)*x_n, N_d_experiment/2);
    %     fprintf(fileID_Nd , '%i %i\n', x_n, 0);
    %     fprintf(fileID_Nd , '%i %i\n', t_ZnO, 0);
    nbx=2;
    nby=6;
    fprintf(fileID_Na , '%s\n',nbx);
    fprintf(fileID_Na , '%s\n',nby);
    fprintf(fileID_Na , '%s %s\n',0,1);
    fprintf(fileID_Na , '%s %s %s %s %s %s\n',0,1,2,3,4,5);
    
    i=1;%nbx*nby
    while(i<=nbx*nby)
        
        i=i+1;
    end
    
    
    
elseif (profile == 2)
elseif (profile == 3)
elseif (profile == 4)
elseif (profile == 5)
end
fclose(fileID_Na);
fclose(fileID_Nd);


% DATA_Na = dlmread('Nd.txt');
% DATA_Nd = dlmread('Na.txt');

% figure(1)
% hold on
% plot(DATA_Na(:,1), DATA_Na(:,2))
% plot(DATA_Nd(:,1), DATA_Nd(:,2))
% grid on
% box on
% hold off
end

