% Generat profile Na Nd

% How to launch :
%                    NaNd_GenerationProfile(1,1e15,1e15,2.5e-4,2.5e-4) In cm !!!


% profile = 1 ==> constant concentration
% profile = 2 ==>
% profile = 3 ==>
% profile = 4 ==>

function [] = NaNd_GenerationProfile(profile, N_a_experiment, N_d_experiment, t_NiO, t_ZnO)
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

Ntot = Na_comsol + Nd_comsol; % Total number of ionized impurities
A1n = 1430; %[cm^2/(V*s)] Kramer mobility model, A1 parameter, Electrons
B1n = -2.2; %[1] Kramer mobility model, B1 parameter, Electrons
MUln = A1n*(T/300)^B1n; % Kramer mobility model, MU1 parameter, Electrons
Ain = 4.61e17; %[1/(V*s*cm)] Kramer mobility model, Ai parameter, Electrons
Bin = 1.52e15; %[1/(K^2*cm^3)] Kramer mobility model, Bi parameter, Electrons
MUin = (Ain*(T/1)^(1.5)/Ntot)/(log(1+Bin*T^2/Ntot)-Bin*T^2/(Ntot+Bin*T^2)) % Kramer mobility model, MUi parameter, Electrons
Xn = sqrt(6*MUln/MUin); %Kramer mobility model, X parameter, Electrons
<<<<<<< HEAD
x_n = 0.65e-6*1e2
=======
%x_n = Xn*1e-4
x_n = 8/100*2.5*1e-6;
>>>>>>> e9476466417f57e8f5c0481492f898372cb46550
mu_n = MUln*(1.025/(1+(Xn/1.68)^1.43)-0.025); % Kramer mobility model, Electron mobility
A1p = 495; %[cm^2/(V*s)] Kramer mobility model, A1 parameter, Holes
B1p = -2.2; %[1] Kramer mobility model, B1 parameter, Holes
MUlp = A1p*(T/300)^B1p; % Kramer mobility model, MU1 parameter, Holes
Aip = 1e17; %[1/(V*s*cm)] Kramer mobility model, Ai parameter, Holes
Bip = 6.25e14; %[1/(K^2*cm^3)] Kramer mobility model, Bi parameter, Holes
MUip = (Aip*(T/1)^(1.5)/Ntot)/(log(1+Bip*T^2/Ntot)-Bip*T^2/(Ntot+Bip*T^2)) % Kramer mobility model, MUi parameter, Holes
Xp = sqrt(6*MUlp/MUip); % Kramer mobility model, X parameter, Holes
<<<<<<< HEAD
x_p = 0.65e-6*1e2
=======
%x_p = Xp*1e-4
x_p = 8/100*2.5*1e-6;
>>>>>>> e9476466417f57e8f5c0481492f898372cb46550
mu_p = MUlp*(1.025/(1+(Xp/1.68)^1.43)-0.025); % Kramer mobility model, Hole mobility




fileID_Na = fopen( 'Na.txt', 'wt' );
fileID_Nd = fopen( 'Nd.txt', 'wt' );
PourcentCoeff = 0.01;

if (profile == 1)
    fprintf(fileID_Na , '%i %i\n', -t_NiO, 0);
    fprintf(fileID_Na , '%i %i\n', -x_p, 0);
    fprintf(fileID_Na , '%i %i\n', -x_p+(PourcentCoeff/2)*x_p, N_a_experiment/2);
    fprintf(fileID_Na , '%i %i\n', -x_p+PourcentCoeff*x_p, N_a_experiment);
    fprintf(fileID_Na , '%i %i\n', 0-10*eps, N_a_experiment);
    fprintf(fileID_Na , '%i %i\n', 0+10*eps, 0);
    fprintf(fileID_Na , '%i %i\n', t_ZnO, 0);
    fprintf(fileID_Nd , '%i %i\n', -t_NiO, 0);
    fprintf(fileID_Nd , '%i %i\n', 0-10*eps, 0);
    fprintf(fileID_Nd , '%i %i\n', 0+10*eps, N_d_experiment);
    fprintf(fileID_Nd , '%i %i\n', x_n-PourcentCoeff*x_n, N_d_experiment);
    fprintf(fileID_Nd , '%i %i\n', x_n-(PourcentCoeff/2)*x_n, N_d_experiment/2);
    fprintf(fileID_Nd , '%i %i\n', x_n, 0);
    fprintf(fileID_Nd , '%i %i\n', t_ZnO, 0);
elseif (profile == 2)
elseif (profile == 3)
elseif (profile == 4)
elseif (profile == 5)
end
fclose(fileID_Na);
fclose(fileID_Nd);
end
