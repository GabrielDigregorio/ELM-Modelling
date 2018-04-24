% Generat profile Na Nd

% How to launch :
%                    NaNd_GenerationProfile(1,1e18,1e19,110e-9,60e-9)


% profile = 1 ==> constant concentration
% profile = 2 ==>
% profile = 3 ==>
% profile = 4 ==>

function [] = NaNd_GenerationProfile(profile, N_a_experiment, N_d_experiment, t_NiO, t_ZnO)

fileID_Na = fopen( 'Na.txt', 'wt' );
fileID_Nd = fopen( 'Nd.txt', 'wt' );

if (profile == 1)
    fprintf(fileID_Na , '%i %i\n', -t_NiO, N_a_experiment);
    fprintf(fileID_Na , '%i %i\n', 0-10*eps, N_a_experiment);
    fprintf(fileID_Na , '%i %i\n', 0+10*eps, 0);
    fprintf(fileID_Na , '%i %i\n', t_ZnO, 0);
    fprintf(fileID_Nd , '%i %i\n', -t_NiO, 0);
    fprintf(fileID_Nd , '%i %i\n', 0-10*eps, 0);
    fprintf(fileID_Nd , '%i %i\n', 0+10*eps, N_d_experiment);
    fprintf(fileID_Nd , '%i %i\n', t_ZnO, N_d_experiment);
elseif (profile == 2)
elseif (profile == 3)
elseif (profile == 4)
elseif (profile == 5)
end

end