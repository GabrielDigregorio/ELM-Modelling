// Parameters
//************************************************************************

// General
    q         = 1.6021766208e-19;       // [C] absolute value of the chanrge electrons
    epsilon_0 = 8.85418782e-12;         // [m-3 kg-1 s4 A2] vacuum permitivity
    T         = 300;                    // [K]
    k_b       = 1.3806e-23; 
    h         = 6.62607004e-34;         // [m2 kg / s] Planck
    m0        = 9.109e-31 ;             // [kg] mass electron
    V_t       =  k_b*T/q;

// NiO
    thickness_NiO = 10000e-9;             // [m]
    epsilon_r_NiO = 11;                 // [-]
    m_star_e_NiO = 0.2*m0;              // [kg]
    m_star_h_NiO = 0.9*m0;              // [kg]
    N_a_NiO = 1e18;                     // []
    N_d_NiO = 0;                        // []
    p_NiO = 1e18;                       // []
    //n_NiO = NaN;                        // []
    //mu_e_NiO = NaN;                     // []
    mu_h_NiO = 10;                      // []
    L_e_NiO = 161e-6*1e2;               // []
    L_h_NiO = 161e-6*1e2;               // []
    //D_e_NiO = V_t * mu_e_NiO ;          // []
    D_h_NiO = V_t * mu_h_NiO ;          // []



// ZnO Type 
    thickness_ZnO = 10000e-9;             // [m]
    epsilon_r_ZnO = 8;                  // [-]
    m_star_e_ZnO =  0.23*m0;            // [kg]
    m_star_h_ZnO =  0.8*m0;             // [kg]
    N_a_ZnO = 0;                        // []
    N_d_ZnO = 4e19;                     // []
    //p_ZnO = NaN;                        // []
    n_ZnO = 4e19;                       // []
    mu_e_ZnO = 15;                      // []
    //mu_h_ZnO = NaN;                     // []
    L_e_ZnO = 600e-9*1e2;               // []
    L_h_ZnO = 600e-9*1e2;               // []
    D_e_ZnO = V_t * mu_e_ZnO;           // []
    //D_h_ZnO = V_t * mu_h_ZnO;           // []


// ZnO/NiO PN heterojunction
    phi_i = 2.18;                       // [V]
    b = 1.13e-11 ;                      // q *(mu_e_ZnO + mu_h_ZnO)/(epsilon_0*epsilon_r_ZnO);
    //N_ts = ;                          // density of trap
    nu_s = 5e3;                         // [m/s] velocity recombination




// Approximation
G = 0; // Generation