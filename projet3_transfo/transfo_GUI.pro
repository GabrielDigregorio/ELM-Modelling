// Constant
mu0=4*Pi*1e-7;
RatioVoltage = 10; //240-24 V


DefineConstant[
  type_Conds = {2, Choices{1 = "Massive", 2 = "Coil"}, Highlight "Blue",
    Name "Parameters/01Conductor type"}
  type_Source = {2, Choices{1 = "Current", 2 = "Voltage"}, Highlight "Blue",
    Name "Parameters/02Source type"}
  type_Analysis = {1, Choices{1 = "Frequency-domain", 2 = "Time-domain"}, Highlight "Blue",
    Name "Parameters/03Analysis type"}
  Freq = {50, Min 0, Max 1e3, Step 1,
    Name "Parameters/Frequency"}
  Power = {3, Choices{1 = "50VA", 2 = "500VA", 3 = "5000VA"}, Highlight "Blue",
    Name "Parameters/01Working Power"}
  mur_Core = {100, Min 0, Max 1e4, Step 10,
    Name "Parameters/mu_r Core"}
  sigma_Coils = {59.6*10^6, Min 0, Max 1e9, Step 1000, 
    Name "Parameters/sigma Coils"} // copper
  Flag_nonlinear_core = {0, Choices{0 = "linear", 1 = "nonlinear"}, Highlight "Blue",
    Name "Parameters/01Resolution"}
];


If(Power == 1)
	S_N = 50;
	height_Core = 0.135; 
	height_Window = 0.035;
	width_Core = 0.13; 
	width_Window = 0.02;
	height_P = 0.032778; 
	height_S = 0.034551; 
	d_1 = 0.7284*10^(-3); 
	d_2 = 2.3034*10^(-3); 
	N_Primary = 600; 
ElseIf(Power == 2)
	S_N = 500;
	height_Core = 0.1755; 
	height_Window = 0.055;
	width_Core = 0.18; 
	width_Window = 0.06;
	height_P = 0.046068; 
	height_S = 0.05009873; 
	d_1 = 2.3034*10^(-3); 
	d_2 = 7.2839*10^(-3); 
	N_Primary = 250; 
Else
	S_N = 5000;
	height_Core = 0.27; 
	height_Window = 0.12;
	width_Core = 0.23; 
	width_Window = 0.08;
	height_P = 0.109258; 
	height_S = 0.115169; 
	d_1 = 7.2839*10^(-3); 
	d_2 = 23.0339*10^(-3); 
	N_Primary = 80; 
EndIf 

thickness_Core = 1.;

N_Secondary = N_Primary/RatioVoltage;

width_Core_Leg = (width_Core-width_Window)/2.;
Area_P = (d_1^2)*N_Primary; 
Area_S = (d_2^2)*N_Secondary;

width_P = Area_P/height_P; 
width_S = Area_S/height_S;

gap_Core_P = 0.00005;
gap_Core_S = 0.00005;
gap_Core1 = 1.;
gap_Core2 = 1.;


// Characteristic lenghts (for mesh sizes)
Factor_Mesh = 1;
mesh_Core = width_Core_Leg/10. *Factor_Mesh;
mesh_P = height_P/2/5 *Factor_Mesh;
mesh_S = height_S/2/5 *Factor_Mesh;
mesh_Box = gap_Core1/6. *Factor_Mesh;

