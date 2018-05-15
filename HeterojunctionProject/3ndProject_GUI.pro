// Parameters
//************************************************************************

// ALL IN S.I. (MKS)

// General
    q         = 1.6021766208e-19;       // [C] absolute value of the chanrge electrons
    epsilon_0 = 8.85418782e-12;         // [m-3 kg-1 s4 A2] vacuum permitivity
    T         = 300;                    // [K]
    k_b       = 1.3806e-23;
    m0        = 9.109e-31 ;             // [kg] mass electron


// Depletion approx
    x_n = 0.65e-6;
    x_p = 0.65e-6;



// NiO
    thickness_NiO = 2.5e-6;             // [m]
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
    thickness_ZnO = 2.5e-6;             // [m]
    epsilon_r_ZnO = 8;                  // [-]
    m_star_e_ZnO =  0.23*m0;            // [kg]
    m_star_h_ZnO =  0.8*m0;             // [kg]
    N_a_ZnO = 0;                        // []
    N_d_ZnO = 1e18*1e6;                 // [-/m^3]
    //p_ZnO = NaN;                      // []
    n_ZnO = 4e18*1e6;                   // [-/m^3]
    mu_e_ZnO = 10*1e-4;                 // [m^2/s]
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
