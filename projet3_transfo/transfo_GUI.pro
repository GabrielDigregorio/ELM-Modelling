// Constant
mu0=4*Pi*1e-7;


DefineConstant[
  type_Conds = {2, Choices{1 = "Massive", 2 = "Coil"}, Highlight "Blue",
    Name "Parameters/01Conductor type"}
  type_Source = {2, Choices{1 = "Current", 2 = "Voltage"}, Highlight "Blue",
    Name "Parameters/02Source type"}
  type_Analysis = {1, Choices{1 = "Frequency-domain", 2 = "Time-domain"}, Highlight "Blue",
    Name "Parameters/03Analysis type"}
  Freq = {50, Min 0, Max 1e3, Step 1,
    Name "Parameters/Frequency"}
  Power = {1, Choices{1 = "50VA", 2 = "500VA", 3 = "5000VA"}, Highlight "Blue",
    Name "Parameters/01Working Power"}
  mur_Core = {100, Min 0, Max 1e4, Step 10,
    Name "Parameters/mu_r Core"}
  sigma_Coils = {1e7, Min 0, Max 1e9, Step 1000,
    Name "Parameters/sigma Coils"}
  Flag_nonlinear_core = {0, Choices{0 = "linear", 1 = "nonlinear"}, Highlight "Blue",
    Name "Parameters/01Resolution"}
];


N_Primary = 100;
N_Secondary = 10;

// Dimensions
width_Core = 1.;
height_Core = 1.;

// Thickness along Oz (to be considered for a correct definition of voltage)
thickness_Core = 1.;

width_Window = 0.5;
height_Window = 0.5;

width_Core_Leg = (width_Core-width_Window)/2.;

width_P = 0.10; 
width_S = 0.10;
height_P = 0.25; 
height_S = 0.25;
gap_Core_P = 0.05; 
gap_Core_S = 0.05;
gap_Core1 = 1; 
gap_Core2 = 1;

// Characteristic lenghts (for mesh sizes)
Factor_Mesh = 1;
mesh_Core = width_Core_Leg/10. *Factor_Mesh;
mesh_P = height_P/2/5 *Factor_Mesh;
mesh_S = height_S/2/5 *Factor_Mesh;
mesh_Box = gap_Core1/6. *Factor_Mesh;

