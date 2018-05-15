% Parameters
%************************************************************************

% ALL IN S.I. (MKS)

% General
    q         = 1.6021766208e-19;       % [C] absolute value of the chanrge electrons
    epsilon_0 = 8.85418782e-12;         % [m-3 kg-1 s4 A2] vacuum permitivity
    T         = 300;                    % [K]
    k_b       = 1.3806e-23;
    m0        = 9.109e-31 ;             % [kg] mass electron


% NiO
    thickness_NiO = 2.5e-6;             % [m]
    epsilon_r_NiO = 1;                 % [-]
    m_star_e_NiO = 0.2*m0;              % [kg]
    m_star_h_NiO = 0.9*m0;              % [kg]
    N_a_NiO = 1e21;                 % [-/m^3]
    N_d_NiO = 0;                        % []
    p_NiO = 1e21;                   % [-/m^3]
    %n_NiO = NaN;                      % []
    %mu_e_NiO = NaN;                   % []
    mu_h_NiO = 10*1e-4;                 % [m^2/s]
    L_e_NiO = 500e-6;                   % [m]
    L_h_NiO = 500e-6;                   % [m]
    %D_e_NiO = V_t * mu_e_NiO ;        % []
    D_h_NiO = k_b*T/q * mu_h_NiO ;          % []



% ZnO Type
    thickness_ZnO = 2.5e-6;             % [m]
    epsilon_r_ZnO = 1;                  % [-]
    m_star_e_ZnO =  0.23*m0;            % [kg]
    m_star_h_ZnO =  0.8*m0;             % [kg]
    N_a_ZnO = 0;                        % []
    N_d_ZnO = 1e21;                 % [-/m^3]
    %p_ZnO = NaN;                      % []
    n_ZnO = 1e21;                   % [-/m^3]
    mu_e_ZnO = 10*1e-4;                 % [m^2/s]
    %mu_h_ZnO = NaN;                   % []
    L_e_ZnO = 500e-6;                   % [m]
    L_h_ZnO = 500e-6;                   % [m]
    D_e_ZnO = k_b*T/q * mu_e_ZnO;           % []
    %D_h_ZnO = V_t * mu_h_ZnO;         % []


% Bias Applied
    V_a = 0                            % [V] Applied Bias voltage across the junction

% For numerical model
    nun = mu_e_ZnO ;
    nup =  mu_h_NiO ;
    Dn = D_e_ZnO ;
    Dp = D_h_NiO ;
    taun = 1e-6; %[s] Electrons lifetime
    taup = 1e-6; %[s] Holes lifetime

% Limit conditions
    no = 1e21 ;
    po = 1e21 ;
    p_no = 1e11;
    n_po = 1e11;

% build in potential
    n_i = 1.25e16; %[1/cm^3] Intrinsic carrier concentration;
%     n_in = 
%     n_ip = 
%     N_vn =
%     N_cp =
%     N_cn =
%     N_vp =
%     DeltaE_c = E_c_NiO - E_c_ZnO;
%     DeltaE_v = E_v_NiO - E_v_ZnO;

    phi_i = ((k_b*T)/q) * log((N_d_ZnO*N_a_NiO)/(n_i^2))
    %phi_i = ((1/q) * (DeltaE_c - DeltaE_v)/2)      +     ((k_b*T)/q) * Log[(N_d*N_a)/(n_in*n_ip)]   +  ((k_b*T)/(2*q)) * Log[(N_vn*N_cp)/(N_cn*N_vp)];


% Depletion approx

    x_n = sqrt(((2*epsilon_r_NiO*epsilon_0)/q) * (N_a_NiO/N_d_ZnO) * (1/(N_d_ZnO+((epsilon_r_NiO/epsilon_r_ZnO)*N_a_NiO))) * (phi_i - V_a))
    x_p = sqrt(((2*epsilon_r_ZnO*epsilon_0)/q) * (N_d_ZnO/N_a_NiO) * (1/(N_a_NiO+((epsilon_r_NiO/epsilon_r_ZnO)*N_d_ZnO))) * (phi_i - V_a))
    %Printf[ "string", x_n ];

% Approximation
    G = 0; % Generation
