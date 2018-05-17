% Parameters
%************************************************************************
adim = 1; %adim or not adim
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
    L = 5e-6;                   % [m] length of the heterojunction
    nun = mu_e_ZnO ;
    nup =  mu_h_NiO ;
    Dn = D_e_ZnO ;
    Dp = D_h_NiO ;
    taun = 1e-6; %[s] Electrons lifetime
    taup = 1e-6; %[s] Holes lifetime

% Limit conditions
    no = 1e21 ;
    po = 1e21 ;
    p_no = 1e15;
    n_po = 1e15;

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


% Adim 

    Lc = sqrt(((epsilon_0*k_b*T))/(q^2*no/2))
    phi_prime = (k_b*T)/q
    n_prime = 1e21
    Tauc = 1.000000e-06;
    A = Tauc * nun * phi_prime / (Lc)^2;
    B = Tauc * Dn * phi_prime / (Lc)^2;
    C = Tauc * nup * phi_prime / (Lc)^2;
    D = Tauc * Dp * phi_prime / (Lc)^2;
    
   if (adim == 1)
        thickness_NiO = thickness_NiO/Lc;   
        N_a_NiO = N_a_NiO/n_prime;                 
        N_d_NiO = N_d_NiO/n_prime;              
        p_NiO = p_NiO/n_prime;             
        mu_h_NiO = mu_h_NiO*phi_prime/Lc^2;             
        L_e_NiO =  L_e_NiO/Lc ;             
        L_h_NiO = L_h_NiO/Lc ;            
        D_h_NiO = D_h_NiO/Lc^2 ;
        thickness_ZnO = thickness_ZnO/Lc ; 
        N_a_ZnO = N_a_ZnO/n_prime;                      
        N_d_ZnO = N_d_ZnO/n_prime;                 
        n_ZnO = n_ZnO/n_prime;                  
        mu_e_ZnO = mu_e_ZnO*phi_prime/Lc^2;                 
        L_e_ZnO = L_e_ZnO/Lc;                   
        L_h_ZnO = L_h_ZnO/Lc;                
        D_e_ZnO = D_e_ZnO/Lc^2; 
        V_a = V_a*phi_prime;
        L = 5e-6/Lc;                 
            nun = mu_e_ZnO ;
            nup =  mu_h_NiO ;
            Dn = D_e_ZnO ;
            Dp = D_h_NiO ;
        taun = 1e-6; 
        taup = 1e-6;
        no = 1e21/n_prime;
        po = 1e21/n_prime;
        p_no = 1e15/n_prime;
        n_po = 1e15/n_prime;
        n_i = 1.25e16/n_prime;
        phi_i = phi_i / phi_prime;
        x_n = x_n/Lc;
        x_p = x_p/Lc;
   end
    

    
%% Generation profile
%NaNd_GenerationProfile_2D(1,1e15,1e15,2.5e-4,2.5e-4)


%% Write the GUI.pro
fid = fopen('Heterojunction_GUI.pro','w');

fprintf(fid,'// Parameters\n');
fprintf(fid,'// ************************************************************************\n\n');
fprintf(fid,'//  ALL IN S.I. (MKS)\n');

fprintf(fid,'// General\n\n');
fprintf(fid,'%s%i%s\n','q=',q,';');
fprintf(fid,'%s%i%s\n','epsilon_0=',epsilon_0,';');
fprintf(fid,'%s%i%s\n','T=',T,';');
fprintf(fid,'%s%i%s\n','k_b=',k_b,';');
fprintf(fid,'%s%i%s\n','m0=',m0,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// NiO\n\n');
fprintf(fid,'%s%i%s\n','thickness_NiO=',thickness_NiO,';');
fprintf(fid,'%s%i%s\n','epsilon_r_NiO=',epsilon_r_NiO ,';');
fprintf(fid,'%s%i%s\n','m_star_e_NiO=',m_star_e_NiO,';');
fprintf(fid,'%s%i%s\n','m_star_h_NiO=',m_star_h_NiO,';');
fprintf(fid,'%s%i%s\n','N_a_NiO=',N_a_NiO,';');
fprintf(fid,'%s%i%s\n','N_d_NiO=',N_d_NiO,';');
fprintf(fid,'%s%i%s\n','p_NiO=',p_NiO,';');
fprintf(fid,'%s%i%s\n','mu_h_NiO=',mu_h_NiO,';');
fprintf(fid,'%s%i%s\n','L_e_NiO=',L_e_NiO,';');
fprintf(fid,'%s%i%s\n','L_h_NiO=',L_h_NiO,';');
fprintf(fid,'%s%i%s\n','D_h_NiO=',D_h_NiO,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// ZnO\n\n');
fprintf(fid,'%s%i%s\n','thickness_ZnO=',thickness_ZnO,';');
fprintf(fid,'%s%i%s\n','epsilon_r_ZnO=',epsilon_r_ZnO ,';');
fprintf(fid,'%s%i%s\n','m_star_e_ZnO=',m_star_e_ZnO,';');
fprintf(fid,'%s%i%s\n','m_star_h_ZnO=',m_star_h_ZnO,';');
fprintf(fid,'%s%i%s\n','N_a_ZnO=',N_a_ZnO,';');
fprintf(fid,'%s%i%s\n','N_d_ZnO=',N_d_ZnO,';');
fprintf(fid,'%s%i%s\n','n_ZnO=',n_ZnO,';');
fprintf(fid,'%s%i%s\n','mu_e_ZnO=',mu_e_ZnO,';');
fprintf(fid,'%s%i%s\n','L_e_ZnO=',L_e_ZnO,';');
fprintf(fid,'%s%i%s\n','L_h_ZnO=',L_h_ZnO,';');
fprintf(fid,'%s%i%s\n','D_e_ZnO=',D_e_ZnO,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// Bias Applied\n\n');
fprintf(fid,'%s%i%s\n','V_a=',V_a,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// For numerical model\n\n');
fprintf(fid,'%s%i%s\n','L=',L,';');
fprintf(fid,'%s%i%s\n','nun=',nun,';');
fprintf(fid,'%s%i%s\n','nup=',nup,';');
fprintf(fid,'%s%i%s\n','Dn=',Dn,';');
fprintf(fid,'%s%i%s\n','Dp=',Dp,';');
fprintf(fid,'%s%i%s\n','taun=',taun,';');
fprintf(fid,'%s%i%s\n','taup=',taup,';');
fprintf(fid,'\n\n\n');


fprintf(fid,'// Limit conditions\n\n');
fprintf(fid,'%s%i%s\n','no=',no,';');
fprintf(fid,'%s%i%s\n','po=',po,';');
fprintf(fid,'%s%i%s\n','p_no=',p_no,';');
fprintf(fid,'%s%i%s\n','n_po=',n_po,';');
fprintf(fid,'\n\n\n');


fprintf(fid,'// build in potential\n\n');
fprintf(fid,'%s%i%s\n','n_i=',n_i,';');
fprintf(fid,'%s%i%s\n','phi_i=',phi_i,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// Depletion approx\n\n');
fprintf(fid,'%s%i%s\n','x_n=',x_n,';');
fprintf(fid,'%s%i%s\n','x_p=',x_p,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// Depletion approx\n\n');
fprintf(fid,'%s%i%s\n','G=',G,';');
fprintf(fid,'\n\n\n');

fprintf(fid,'// Adimentionnalisation\n\n');
fprintf(fid,'%s%i%s\n','A=',A,';');
fprintf(fid,'%s%i%s\n','B=',B,';');
fprintf(fid,'%s%i%s\n','C=',C,';');
fprintf(fid,'%s%i%s\n','D=',D,';');
fprintf(fid,'\n\n\n');

fclose(fid);















