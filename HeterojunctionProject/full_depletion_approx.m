clear all;
close all;

Main

Factor_Correct = 1e3;

% Approximation
epsilon_s = mean([epsilon_r_ZnO epsilon_r_NiO]) * epsilon_0;
w_n = thickness_ZnO; % [m]thickness_ZnO; % quasi neutral region
w_p = thickness_NiO; % [m]thickness_NiO; % quasi neutral region
N_d_NiO = 0; N_a = N_a_NiO;
N_a_ZnO = 0; N_d = N_d_ZnO; 
n_n0 = n_ZnO;
p_p0 = p_NiO;
L_p = L_h_NiO;
L_n = L_e_ZnO;
D_p = D_h_NiO;
D_n = D_e_ZnO;
V_t =  25.85e-3;
R_series =100;



% Variables
V_a = -2.5:0.01:1;
x = (-w_p : 0.01e-6 : w_n);

% Solve for the full depletion PN junction approximation
x_d = real(sqrt( (2*epsilon_s/q) * (1/N_a + 1/N_d) * (phi_i - V_a) ));
x_n = real(sqrt( (2*epsilon_s/q) * (N_a/N_d) *  (1/(N_a+N_d)) * (phi_i - V_a) ));
x_p = -real(sqrt( (2*epsilon_s/q) * (N_d/N_a) *  (1/(N_a+N_d)) * (phi_i - V_a) ));

w_n_prim = w_n - x_n; % quasi neutral region
w_p_prim = w_p - x_p; % quasi neutral region

% Solve electric field and potential across the junction
for i=1:length(V_a)
    
    % Approximation
    p_n0 = 2.5e3; %p_p0/exp(V_a(i)/V_t);
    n_p0 = 1e4; %n_n0/exp(V_a(i)/V_t);
    
for X = x
    V_n = phi_i-V_a(i);
    V_p = 0;
    if(X<x_p(i))
        E(find(x==X),i) = 0;
        V(find(x==X),i) = 0;
    elseif(X>x_p(i) && X<=0)
        E(find(x==X),i) = q*N_a/epsilon_s * (X-x_p(i));
        V(find(x==X),i) = q*N_a/(2*epsilon_s) * (X-x_p(i))^2 + V_p;
    elseif(X<x_n(i) && X>0)
        E(find(x==X),i) = -q*N_d/epsilon_s * (X-x_n(i));
        V(find(x==X),i) = -q*N_d/(2*epsilon_s) * (X-x_n(i))^2 + V_n;
    elseif(X>x_n(i))
        E(find(x==X),i) = 0;
        V(find(x==X),i) = phi_i-V_a(i);
    end   
end
end

% Solve curent density across the junction
for i=1:length(V_a)
    %J_bb(i) = q*n_i^2 * b * x_d(i) * (exp(V_a(i)/V_t) - 1)* Factor_Correct;
    %U_SHR_Max = n_i/(2*xi) * (exp(V_a(i)/(2*V_t)) - 1); % approx
    %x_prime = trapz(x , (1/xi) * (n_i^2*(exp(V_a(i)/V_t) - 1))/(n+p+2*n_i*cosh((E_t-E_i)/(k*T))))/U_SHR_Max;
    %x_prime = x_d(i); %upper estimation
    %xi = 1/(nu_s);
    %J_SHR(i) = q*n_i*x_prime/(2*xi)*(exp(V_a(i)/(2*V_t)) - 1)* Factor_Correct;
    
for X = x
    if(X<x_p(i))
        J_p(find(x==X),i) = 0;
        J_n(find(x==X),i) = q*D_n*n_p0/L_n * (exp(V_a(i)/V_t) - 1) * (sinh((X-x_p(i))/L_p) + coth(w_p_prim(i)/L_n)*cosh((X-x_p(i))/L_n))* Factor_Correct;
        %J_r(find(x==X),i) = 0;
    elseif(X>=x_p(i) && X<0)
        J_p(find(x==X),i) = 0;
        J_n(find(x==X),i) = 0;
        %J_r(find(x==X),i) = 0;
    elseif(X<x_n(i) && X>=0)
        J_p(find(x==X),i) = 0;
        J_n(find(x==X),i) = 0;
        %J_r(find(x==X),i) = 0;
    elseif(X>=x_n(i))
        J_p(find(x==X),i) = -q*D_p*p_n0/L_p * (exp(V_a(i)/V_t) - 1) * (sinh((X-x_n(i))/L_n) - coth(w_n_prim(i)/L_p)*cosh((X-x_n(i))/L_p))* Factor_Correct;
        J_n(find(x==X),i) = 0;
        %J_r(find(x==X),i) = 0;
    end
end
    J(i) = max(J_n(:,i)) + max(J_p(:,i));% J_bb(i);% + J_SHR(i);
    J_simpl(i) = q*[D_n*n_p0/L_n + D_p*p_n0/w_n_prim(i)]* (exp(V_a(i)/V_t) - 1) * Factor_Correct;
    
end



% Plot
figure(1)
title('Electric field')
mesh(x,V_a,transp(E))
xlabel('thickness x [m]')
ylabel('bias [V]')
zlabel('E [V/m]')
grid on

figure(2)
title('Electric potential')
mesh(x,V_a,transp(V))
xlabel('thickness x [m]')
ylabel('Bias [V]')
zlabel('V [V]')
grid on

figure(3)
title('Total curent density')
hold on
plot(V_a,J, 'linewidth', 2)
%plot(V_a,J_bb, 'linewidth', 2)
%plot(V_a,J_SHR, 'linewidth', 2)
hold off
xlabel('Bias [V]')
ylabel('J [A/m^2]')
%legend('J_{tot}','J_{bb}','J_{SHR}')
grid on

figure(4)
hold on
title('Electron and hole curent density')
plot(V_a,max(J_n), 'linewidth', 2)
plot(V_a,max(J_p), 'linewidth', 2)
xlabel('Bias [V]')
ylabel('J [A/m^2]')
legend('J_n','J_p')
grid on
hold off

