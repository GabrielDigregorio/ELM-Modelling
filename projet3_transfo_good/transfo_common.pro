DefineConstant[
  type_Conds = {2, Choices{1 = "Massive", 2 = "Coil"}, Highlight "Blue",
    Name "Parameters/01Conductor type"}
  type_Source = {2, Choices{1 = "Current", 2 = "Voltage"}, Highlight "Blue",
    Name "Parameters/02Source type"}
  type_Analysis = {1, Choices{1 = "Frequency-domain", 2 = "Time-domain"}, Highlight "Blue",
    Name "Parameters/03Analysis type"}
  Freq = {50, Min 0, Max 1e3, Step 1,
    Name "Parameters/Frequency"}
  sigma_c={59.6*10^6, Min 1e-10, Max 1e15, Step 1,
    Name "Parameters/conductivity coils"}
  mur_Core={30000, Min 1, Max 10000000, Step 1,
    Name "Parameters/realtive permeability core"}
  Power = {3, Choices{1 = "50VA", 2 = "500VA", 3 = "5000VA"}, Highlight "Blue",
    Name "Parameters/01Working Power"}
];



DefineConstant[

  height_Coil_1={0.115, Min 0.01, Max 10000, Step 1,
    Name "Geometry/coil1/heigth coils"}
  width_Core_Leg={0.04, Min 0.01, Max 10000, Step 1,
    Name "Geometry/core/Thickness horiz core"}
  height_Core_Leg={0.04, Min 0.01, Max 10000, Step 1,
    Name "Geometry/core/Thickness verti core"}
  width_Core={0.2, Min 0.01, Max 10000, Step 1,
    Name "Geometry/core/width core"}
  height_Core={0.2, Min 0.01, Max 10000, Step 1,
    Name "Geometry/core/heigth core"}
  height_Coil_2={0.115, Min 0.01, Max 10000, Step 1,
    Name "Geometry/coil2/heigth coils"}

  gap_Core_Coil_1={0.001, Min 0.01, Max 10000, Step 1,
    Name "Geometry/coil1/gap coils ferro"}
  gap_Core_Coil_2={0.001, Min 0.01, Max 10000, Step 1,
    Name "Geometry/coil2/gap coils ferro"}
  gap_Core_Box_X ={1, Min 0.01, Max 10000, Step 1,
    Name "Box/width from ferro"}
  gap_Core_Box_Y={2, Min 0.01, Max 10000, Step 1,
    Name "Box/heigh from ferro"}
  s={1, Min 1, Max 10000, Step 1,
    Name "Parameters/size mesh"}
];




// Dimensions
thickness_Core = width_Core_Leg ;//1.;
B_max=1.5;
  Printf("width_Core_Leg  %g", width_Core_Leg);
N1=(1/(2*Pi*Freq*width_Core_Leg*width_Core_Leg*B_max))*120;
  Printf("n_1  %g", N1);
N2=N1/10;


If(Power == 1)
	S_N = 50;
  S_wire1=0.4167/1e6;
  S_wire2=4.167/1e6;
ElseIf(Power == 2)
	S_N = 500;
  S_wire1=4.167/1e6;
  S_wire2=41.67/1e6;
Else
	S_N = 5000;
  S_wire1=41.67/1e6;
  S_wire2=416.7/1e6;
EndIf

Air_tot_1=S_wire1*N1;
Air_tot_2=S_wire2*N2;


width_Coil_1 =Air_tot_1/height_Coil_1;
width_Coil_2 =Air_tot_2/height_Coil_2;


// Characteristic lenghts (for mesh sizes)
c_Core = width_Core_Leg/15. *s;

c_Coil_1 = height_Coil_1/2/20 *s;
c_Coil_2 = height_Coil_2/2/20 *s;

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
