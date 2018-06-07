
DefineConstant[   
   // height_window = {0.035, Min 0.05, Max 2, Step 0.01, 
     // Name "Parameters/height_Window"}
	 
   // width_window = {0.02, Min 0.05, Max 2, Step 0.01, 
	 // Name "Parameters/width_Window"}
	
   // width_Core_Leg = {0.055, Min 0.02, Max 0.1, Step 0.001, 
     // Name "Parameters/width_Core_Leg"}
	 
   // width_Core = {0.13, Min 0.01, Max 1, Step 0.01, 
     // Name "Parameters/width_Core"}
	 
   // height_Core = {0.155, Min 0.01, Max 1, Step 0.01, 
     // Name "Parameters/height_Core"}
	 
   // d_1 = {2.3034*10^(-3), Min 0.3e-3, Step 0.001e-3, 
     // Name "Parameters/d_1"}
	 
   // d_2 = {7.2839*10^(-3), Min 0.3e-3, Step 0.001e-3, 
     // Name "Parameters/d_2"}

   value_SN = {1, Choices{1 = "50 VA", 2 = "500 VA", 3 = "5000 VA"},
     Name "Parameters/Nominal_power"}
	 
   Freq = {50, Min 1, Max 1000, Step 1, 
     Name "Parameters/frequency"}
	 
   // height_Coil_1 = {0.046068, Min d_1, Max 0.2/*height_window-0.001*/, Step 5*d_1, 
     // Name "Parameters/height_coil_1"}
	 
   // height_Coil_2 = {0.05009873, Min d_2, Max 0.2/*height_window-0.001*/, Step d_2, 
     // Name "Parameters/height_coil_2"}  

   // n_1 = {600, Min 10, Max 1000, Step 10, 
     // Name "Parameters/n_1"}
	 
];

// Dimensions

If(value_SN == 1)
	S_N = 50;
	height_Core = 0.135; 
	height_window = 0.035;
	width_Core = 0.13; 
	width_window = 0.02;
	height_Coil_1 = 0.032778; 
	height_Coil_2 = 0.034551; 
	d_1 = 0.7284*10^(-3); 
	d_2 = 2.3034*10^(-3); 
	n_1 = 600; 
ElseIf(value_SN == 2)
	S_N = 500;
	height_Core = 0.1755; 
	height_window = 0.055;
	width_Core = 0.18; 
	width_window = 0.06;
	height_Coil_1 = 0.046068; 
	height_Coil_2 = 0.05009873; 
	d_1 = 2.3034*10^(-3); 
	d_2 = 7.2839*10^(-3); 
	n_1 = 250; 
Else
	S_N = 5000;
	height_Core = 0.27; 
	height_window = 0.12;
	width_Core = 0.23; 
	width_window = 0.08;
	height_Coil_1 = 0.109258; 
	height_Coil_2 = 0.115169; 
	d_1 = 7.2839*10^(-3); 
	d_2 = 23.0339*10^(-3); 
	n_1 = 80; 
EndIf 

width_Core_Leg = (width_Core-width_window)/2;
// width_window = width_Core - width_Core_Leg/2; 
// height_window = (height_Core - width_Core_Leg*2);
thickness_Core = width_Core_Leg;
 
gap_Core_Coil_1 = 0.00005;
gap_Core_Coil_2 = 0.00005;

gap_Core_Box_X = 1.;
gap_Core_Box_Y = 1.;

V_N1 = 240; // Nominal voltage in the primary [V]
V_N2 = 24;  // Nominal voltage in the secondary [V]

sigma_Cu = 59.6*10^6; // Conductivity of the copper 
B_max = 1.5;
r_1 = d_1/2; 
r_2 = d_2/2; 

Area_C = thickness_Core*width_Core_Leg; 

n_2 = n_1/10; 

Area_Coil_1 = (d_1^2)*n_1; 
Area_Coil_2 = (d_2^2)*n_2;

width_Coil_1 = Area_Coil_1/height_Coil_1; 
width_Coil_2 = Area_Coil_2/height_Coil_2;

// Characteristic lenghts (for mesh sizes)

s = 1;

c_Core = width_Core_Leg/10. *s;

c_Coil_1 = height_Coil_1/2/5 *s;
c_Coil_2 = height_Coil_2/2/5 *s;

c_Box = gap_Core_Box_X/6. *s;

// Physical regions

AIR_EXT = 1001;
SUR_AIR_EXT = 1002;
AIR_WINDOW = 1011;

CORE = 1050;

COIL_1_PLUS = 1101;
COIL_1_MINUS = 1102;

COIL_2_PLUS = 1201;
COIL_2_MINUS = 1202;
