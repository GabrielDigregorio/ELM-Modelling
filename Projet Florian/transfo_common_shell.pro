DefineConstant[   
 
   // width = {0.05, Min 0.01, Max 1, Step 0.01, 
     // Name "Parameters/width"}
	 
   // height = {0.088, Min 0.01, Max 2, Step 0.01, 
     // Name "Parameters/height"}
	 
   // d_1 = {2.3034*10^(-3), Min 0.3e-3, Step 0.001e-3, 
     // Name "Parameters/d_1"}
	 
   // d_2 = {7.2839*10^(-3), Min 0.3e-3, Step 0.001e-3, 
     // Name "Parameters/d_2"}

   value_SN = {1, Choices{1 = "50 VA", 2 = "500 VA", 3 = "5000 VA"},
     Name "Parameters/Nominal_power"}
	 
   // wire_height_1 = {0.0414, Min d_1, Max 0.2, Step d_1, 
     // Name "Parameters/wire_height_1"}
	 
   // wire_height_2 = {0.0728, Min d_2, Max 0.2, Step d_2, 
     // Name "Parameters/wire_height_2"}  

   // n_1 = {250, Min 10, Max 1000, Step 10, 
     // Name "Parameters/n_1"}
	 
   // space = {0.065, Min 0.1, Max 2, Step 0.001, 
     // Name "Parameters/space"}
	 
   // air_gap_value = {0.0001, Min 1e-6, Max 0.1, Step 1e-6, 
     // Name "Parameters/length_air_gap"}
	 
];

If(value_SN == 1)
	S_N = 50;
	width = 0.05; 
	height = 0.088;
	wire_height_1 = 0.0182; 
	wire_height_2 = 0.0184;
	d_1 = 0.7284*10^(-3); 
	d_2 = 2.3034*10^(-3); 
	space = 0.0365; 
	n_1 = 600; 
ElseIf(value_SN == 2)
	S_N = 500;
	width = 0.05; 
	height = 0.128;
	wire_height_1 = 0.0368544; 
	wire_height_2 = 0.0364195;
	d_1 = 2.3034*10^(-3); 
	d_2 = 7.2839*10^(-3); 
	n_1 = 250; 
	space = 0.074; 
Else
	S_N = 5000;
	width = 0.08; 
	height = 0.23;
	wire_height_1 = 0.0728; 
	wire_height_2 = 0.0691;
	d_1 = 7.2839*10^(-3); 
	d_2 = 23.0339*10^(-3); 
	n_1 = 80; 
	space = 0.123; 
EndIf

// Constant used here:
room = 2.5; //-- Distance between the centre and the "infinity" 

wire_dist=0.0005;	//-- Distance between the rectangle representing the wire and the core
dist_wire = 0.0005; //-- Distance between the two coils

// Dimensions

thickness_Core = width;

gap_Core_Box_X = 1.;
gap_Core_Box_Y = 1.;

V_N1 = 240; // Nominal voltage in the primary [V]
V_N2 = 24;  // Nominal voltage in the secondary [V]

sigma_Cu = 59.6*10^6; // Conductivity of the copper 
B_max = 1.5;
r_1 = d_1/2; 
r_2 = d_2/2; 

Area_C = thickness_Core*width; 

n_2 = n_1/10; 

Area_Coil_1 = (d_1^2)*n_1; 
Area_Coil_2 = (d_2^2)*n_2;

wire_width_1 = Area_Coil_1/wire_height_1; 
wire_width_2 = Area_Coil_2/wire_height_2;

// Characteristic lenghts (for mesh sizes)

s = 1;

c_Core = width/10. *s;

c_Coil_1 = wire_height_1/2/5 *s;
c_Coil_2 = wire_height_2/2/5 *s;

c_Box = gap_Core_Box_X/6. *s;

// Physical regions
/*
AIR_EXT = 1001;
SUR_AIR_EXT = 1002;
AIR_WINDOWL = 1011;
AIR_WINDOWR = 1012;

CORE = 1050;

Coil1_N = 1100;
Coil1_P = 1101;

Coil2_N = 1110;
Coil2_P = 1111;*/

AIR_WINDOWL = 1011;
AIR_WINDOWR = 1012;
AIR_EXT = 1001;
SUR_AIR_EXT = 1002;
AIR_WINDOW = 1011;

CORE = 1050;

COIL_1_PLUS = 1101;
COIL_1_MINUS = 1102;

COIL_2_PLUS = 1201;
COIL_2_MINUS = 1202;
