// GUI : define conastants, physical and geometrical parameters

DefineConstant[
  modelPath = "", // default path of the model
  resPath = StrCat[modelPath, "Results/"], // path for post-operation files
  Flag_Axi = 0, // axisymmetric model?
  Flag_FrequencyDomain = 1, // frequency-domain or time-domain simulation
  Flag_CircuitCoupling = 0, // consider coupling with external electric circuit
  Flag_NewtonRaphson = 0, // Newton-Raphson or Picard method for nonlinear iterations
  //Flag_nonlinear_core=0,
  CoefPower = 0.5, // coefficient for power calculations
  Freq = 50, // frequency (for harmonic simulations)
  TimeInit = 0, // intial time (for time-domain simulations)
  TimeFinal = 1/50, // final time (for time-domain simulations)
  DeltaTime = 1/500, // time step (for time-domain simulations)
  FE_Order = 1, // finite element order
  Val_Rint = 0, // interior radius of annulus shell transformation region (Vol_Inf_Mag)
  Val_Rext = 0 // exterior radius of annulus shell  transformation region (Vol_Inf_Mag)
  Val_Cx = 0, // x-coordinate of center of Vol_Inf_Mag
  Val_Cy = 0, // y-coordinate of center of Vol_Inf_Mag
  Val_Cz = 0, // z-coordinate of center of Vol_Inf_Mag
  NL_tol_abs = 1e-6, // absolute tolerance on residual for noninear iterations
  NL_tol_rel = 1e-6, // relative tolerance on residual for noninear iterations
  NL_iter_max = 20 // maximum number of noninear iterations
];

DefineConstant[
  type_Conds = {2, Choices{1 = "Massive", 2 = "Coil"}, Highlight "Blue",
    Name "Parameters/01Conductor type"}
  type_Source = {2, Choices{1 = "Current", 2 = "Voltage"}, Highlight "Blue",
    Name "Parameters/02Source type"}
  type_Analysis = {1, Choices{1 = "Frequency-domain", 2 = "Time-domain"}, Highlight "Blue",
    Name "Parameters/03Analysis type"}
  Freq = {50, Min 0, Max 1e3, Step 1,
    Name "Parameters/Frequency"}
    mur_corr={100, Min 1, Max 1e3, Step 1,
      Name "Parameters/mu_r_core"}
  Flag_nonlinear_core=    {0, Choices{0 = "Linear", 1= "nonlinear"}, Highlight "Blue",
  Name "Parameters/01Non linear"}
  sigma_c={1e7, Min 1, Max 1e9, Step 1,
    Name "Parameters/conductivity coil"}
    N1={1, Min 1, Max 200, Step 1,
      Name "Parameters/number of turn coil1"}
      load={1e6, Min 1e-5, Max 1e11, Step 1,
        Name "Parameters/number of turn coil1"}
];


// Geometrical Dimensions
thickness_Core = 1; // perpendicular to the plane
width_Core = 1;
height_Core = 1;
width_Window = 0.8;// control thickness of the core
width_Core_Leg = (width_Core-width_Window)/2.;

width_P = 0.10; 
width_S = 0.10;
height_P = 0.25; 
height_S = 0.25;
gap_Core_P = 0.05; 
gap_Core_S = 0.05;
gap_Core1 = 1; 
gap_Core2 = 1;

// Mesh Characteristic length
Factor_Mesh = 1;

mesh_Core = width_Core_Leg/10. *Factor_Mesh;
mesh_P = height_P/2/5 *Factor_Mesh;
mesh_S = height_S/2/5 *Factor_Mesh;
mesh_Box = gap_Core1/6. *Factor_Mesh;


