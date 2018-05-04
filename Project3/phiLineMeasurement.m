close all
DATA = dlmread('phi.txt');


    q         = 1.6021766208e-19;       % [C] absolute value of the chanrge electrons
    epsilon_0 = 8.85418782e-12;        % [m-3 kg-1 s4 A2] vacuum permitivity
    T         = 300;                    % [K]
    k_b       = 1.3806e-23; 
    h         = 6.62607004e-34;         % [m2 kg / s] Planck
    m0        = 9.109e-31 ;             % [kg] mass electron
    
    
    N_a_NiO = 4e18*1e6;                 %  [-/m^3]
    N_d_NiO = 0;                        %  []
    p_NiO = 1e16*1e6;                   %  [-/m^3]
    
    N_a_ZnO = 0;                        %  []
    N_d_ZnO = 4e18*1e6;                 %  [-/m^3]
    n_ZnO = 4e18*1e6;                   %  [-/m^3]
   
phi_i = ((k_b*T)/q) * log((N_d_ZnO*N_a_NiO)/(n_ZnO*p_NiO))
figure(1)
plot(DATA(:,3),DATA(:,end-1), '*')

figure(2)
plot(DATA(:,3),diff([DATA(1,end-1) ;DATA(:,end-1)]), '*')


DATA = dlmread('E.txt');
figure(3)
plot(DATA(:,3),DATA(:,end-1), '*')