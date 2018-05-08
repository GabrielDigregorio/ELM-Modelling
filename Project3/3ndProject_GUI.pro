// Parameters
//************************************************************************

// ALL IN S.I. (MKS)

// General
    q         = 1.6021766208e-19;       // [C] absolute value of the chanrge electrons
    epsilon_0 = 8.85418782e-12;         // [cm-3 kg-1 s4 A2] vacuum permitivity
    T         = 300;                    // [K]
    k_b       = 1.3806e-23;
    m0        = 9.109e-31 ;             // [kg] mass electron

// comsol [cm]
Na_comsol = 1e15; //[1/cm^3] Acceptor concentration
Nd_comsol = 1e15; //[1/cm^3] Donor concentration
epsilonr_param_comsol = 11.8; // Relative permittivity
Eg0_param_comsol = 1.12; //[V] Band gap
chi0_param_comsol = 4.05; //[V] Electron affinity
Ni_comsol = 1.25e10; //[1/cm^3] Intrinsic carrier concentration
Nc_param_comsol = Ni_comsol*Exp[Eg0_param_comsol*q/(2*k_b*T)]; // Conduction band density of states
Nv_param_comsol = Ni_comsol*Exp[Eg0_param_comsol*q/(2*k_b*T)]; // Valence band density of states
taun_param_comsol = 1e-6; //[s] Electron lifetime
taup_param_comsol = taun_param_comsol; // Hole lifetime
bias_comsol = -4; //[V] Device bias

Ntot = Na_comsol + Nd_comsol; // Total number of ionized impurities
A1n = 1430; //[cm^2/(V*s)] Kramer mobility model, A1 parameter, Electrons
B1n = -2.2; //[1] Kramer mobility model, B1 parameter, Electrons
MUln = A1n*(T/300)^B1n; // Kramer mobility model, MU1 parameter, Electrons
Ain = 4.61e17; //[1/(V*s*cm)] Kramer mobility model, Ai parameter, Electrons
Bin = 1.52e15; //[1/(K^2*cm^3)] Kramer mobility model, Bi parameter, Electrons
MUin = (Ain*(T/1)^(1.5)/Ntot)/(Log[1+Bin*T^2/Ntot]-Bin*T^2/(Ntot+Bin*T^2)); // Kramer mobility model, MUi parameter, Electrons
Xn = Sqrt[6*MUln/MUin]; //Kramer mobility model, X parameter, Electrons
x_n = 0.7*1e-6;//Xn *1e-4;
mu_n = MUln*(1.025/(1+(Xn/1.68)^1.43)-0.025); // Kramer mobility model, Electron mobility
A1p = 495; //[cm^2/(V*s)] Kramer mobility model, A1 parameter, Holes
B1p = -2.2; //[1] Kramer mobility model, B1 parameter, Holes
MUlp = A1p*(T/300)^B1p; // Kramer mobility model, MU1 parameter, Holes
Aip = 1e17; //[1/(V*s*cm)] Kramer mobility model, Ai parameter, Holes
Bip = 6.25e14; //[1/(K^2*cm^3)] Kramer mobility model, Bi parameter, Holes
MUip = (Aip*(T/1)^(1.5)/Ntot)/(Log[1+Bip*T^2/Ntot]-Bip*T^2/(Ntot+Bip*T^2)); // Kramer mobility model, MUi parameter, Holes
Xp = Sqrt[6*MUlp/MUip]; // Kramer mobility model, X parameter, Holes
x_p =0.7*1e-6;//Xp*1e-4;
mu_p = MUlp*(1.025/(1+(Xp/1.68)^1.43)-0.025); // Kramer mobility model, Hole mobility




// NiO
    thickness_NiO = 2.5e-4/100;             // [cm]
    epsilon_r_NiO = 11;                 // [-]
    m_star_e_NiO = 0.2*m0;              // [kg]
    m_star_h_NiO = 0.9*m0;              // [kg]
    N_a_NiO = 1e18*1e6;                 // [-/m^3]
    N_d_NiO = 0;                        // []
    p_NiO = 1e16*1e6;                   // [-/m^3]
    //n_NiO = NaN;                      // []
    //mu_e_NiO = NaN;                   // []
    mu_h_NiO = 10*1e-4;                 // [m^2/s]
    L_e_NiO = 161e-6;                   // [m]
    L_h_NiO = 161e-6;                   // [m]
    //D_e_NiO = V_t * mu_e_NiO ;        // []
    D_h_NiO = k_b*T/q * mu_h_NiO ;          // []



// ZnO Type
    thickness_ZnO = 2.5e-4/100;             // [cm]
    epsilon_r_ZnO = 8;                  // [-]
    m_star_e_ZnO =  0.23*m0;            // [kg]
    m_star_h_ZnO =  0.8*m0;             // [kg]
    N_a_ZnO = 0;                        // []
    N_d_ZnO = 1e18*1e6;                 // [-/m^3]
    //p_ZnO = NaN;                      // []
    n_ZnO = 4e18*1e6;                   // [-/m^3]
    mu_e_ZnO = 15*1e-4;                 // [m^2/s]
    //mu_h_ZnO = NaN;                   // []
    L_e_ZnO = 600e-6;                   // [m]
    L_h_ZnO = 600e-6;                   // [m]
    D_e_ZnO = k_b*T/q * mu_e_ZnO;           // []
    //D_h_ZnO = V_t * mu_h_ZnO;         // []


// ZnO/NiO PN heterojunction
    V_a = 0;                            // [V] Applied Bias voltage across the junction
                          // [V]
    b = 1.13e-11 ;                      // q *(mu_e_ZnO + mu_h_ZnO)/(epsilon_0*epsilon_r_ZnO);
    //N_ts = ;                          // density of trap
    nu_s = 5e3;                         // [m/s] velocity recombination




// Approximation
G = 0; // Generation
