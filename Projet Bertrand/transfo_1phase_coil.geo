
Include "transfo_common_1phase_coil.pro";
Solver.AutoShowLastStep = 0; // don't automatically show the last time step

// Infinity 
SetFactory("OpenCASCADE");
Circle(1) = {0,0,0,Rinf,0,2*Pi};
infinity_loop = newll ; Curve Loop(infinity_loop) = {1};

// CORE 
// Point
P_1 = newp ; Point(P_1) = {Rint_x, Rint_y,0,dim};
P_2 = newp ; Point(P_2) = {-Rint_x, Rint_y,0,dim};
P_3 = newp ; Point(P_3) = {-Rint_x, -Rint_y,0,dim};
P_4 = newp ; Point(P_4) = {Rint_x, -Rint_y,0,dim};
P_5 = newp ; Point(P_5) = {Rint_x+width_core, Rint_y+width_core,0,dim};
P_6 = newp ; Point(P_6) = {-Rint_x-width_core, Rint_y+width_core,0,dim};
P_7 = newp ; Point(P_7) = {-Rint_x-width_core, -Rint_y-width_core,0,dim};
P_8 = newp ; Point(P_8) = {Rint_x+width_core, -Rint_y-width_core,0,dim};

// Inner lines
L_1 = newl ; Line(L_1) = {P_1,P_2};
L_2 = newl ; Line(L_2) = {P_2,P_3};
L_3 = newl ; Line(L_3) = {P_3,P_4};
L_4 = newl ; Line(L_4) = {P_4,P_1};

//Exterior lines
L_5 = newl ; Line(L_5) = {P_5,P_6};
L_6 = newl ; Line(L_6) = {P_6,P_7};
L_7 = newl ; Line(L_7) = {P_7,P_8};
L_8 = newl ; Line(L_8) = {P_8,P_5};

//Curve Loop and surface

Inner_loop = newll; Curve Loop(Inner_loop) = {L_1,L_2,L_3,L_4};
Outside_loop = newll; Curve Loop(Outside_loop) = {L_5,L_6,L_7,L_8};
surf_coil = news ; Plane Surface(surf_coil) = {Outside_loop,Inner_loop};
Physical Surface("Core", Core) = {surf_coil};

// COILS

//Coil_left_left
P_cll_1 = newp ; Point(P_cll_1) = {-Rint_x-width_core-air_gap_coil,height_coil,0,dim_coil};
P_cll_2 = newp ; Point(P_cll_2) = {-Rint_x-width_core-air_gap_coil,-height_coil,0,dim_coil};
P_cll_3 = newp ; Point(P_cll_3) = {-Rint_x-width_core-air_gap_coil-width_coil,-height_coil,0,dim_coil};
P_cll_4 = newp ; Point(P_cll_4) = {-Rint_x-width_core-air_gap_coil-width_coil,height_coil,0,dim_coil};

L_cll_1 = newl ; Line(L_cll_1) = {P_cll_1, P_cll_2};
L_cll_2 = newl ; Line(L_cll_2) = {P_cll_2, P_cll_3};
L_cll_3 = newl ; Line(L_cll_3) = {P_cll_3, P_cll_4};
L_cll_4 = newl ; Line(L_cll_4) = {P_cll_4, P_cll_1};

cll_loop = newll ; Curve Loop(cll_loop) = {L_cll_1,L_cll_2,L_cll_3,L_cll_4};
s_cll = news; Plane Surface(s_cll) = {cll_loop};
Physical Surface("Coil_left_left", Coil_left_left) ={s_cll};

// Coil_left_right
P_clr_1 = newp ; Point(P_clr_1) = {-Rint_x+air_gap_coil,height_coil,0,dim_coil};
P_clr_2 = newp ; Point(P_clr_2) = {-Rint_x+air_gap_coil,-height_coil,0,dim_coil};
P_clr_3 = newp ; Point(P_clr_3) = {-Rint_x+air_gap_coil+width_coil,-height_coil,0,dim_coil};
P_clr_4 = newp ; Point(P_clr_4) = {-Rint_x+air_gap_coil+width_coil,height_coil,0,dim_coil};

L_clr_1 = newl ; Line(L_clr_1) = {P_clr_1, P_clr_2};
L_clr_2 = newl ; Line(L_clr_2) = {P_clr_2, P_clr_3};
L_clr_3 = newl ; Line(L_clr_3) = {P_clr_3, P_clr_4};
L_clr_4 = newl ; Line(L_clr_4) = {P_clr_4, P_clr_1};

clr_loop = newll ; Curve Loop(clr_loop) = {L_clr_1,L_clr_2,L_clr_3,L_clr_4};
s_clr = news; Plane Surface(s_clr) = {clr_loop};
Physical Surface("Coil_left_right", Coil_left_right) ={s_clr};

// Coil_right_left
P_crl_1 = newp ; Point(P_crl_1) = {Rint_x-air_gap_coil,height_coil,0,dim_coil};
P_crl_2 = newp ; Point(P_crl_2) = {Rint_x-air_gap_coil,-height_coil,0,dim_coil};
P_crl_3 = newp ; Point(P_crl_3) = {Rint_x-air_gap_coil-width_coil,-height_coil,0,dim_coil};
P_crl_4 = newp ; Point(P_crl_4) = {Rint_x-air_gap_coil-width_coil,height_coil,0,dim_coil};

L_crl_1 = newl ; Line(L_crl_1) = {P_crl_1, P_crl_2};
L_crl_2 = newl ; Line(L_crl_2) = {P_crl_2, P_crl_3};
L_crl_3 = newl ; Line(L_crl_3) = {P_crl_3, P_crl_4};
L_crl_4 = newl ; Line(L_crl_4) = {P_crl_4, P_crl_1};

crl_loop = newll ; Curve Loop(crl_loop) = {L_crl_1,L_crl_2,L_crl_3,L_crl_4};
s_crl = news; Plane Surface(s_crl) = {crl_loop};
Physical Surface("Coil_right_left", Coil_right_left) ={s_crl};

// Coil_right_right
P_crr_1 = newp ; Point(P_crr_1) = {Rint_x+width_core+air_gap_coil,height_coil,0,dim_coil};
P_crr_2 = newp ; Point(P_crr_2) = {Rint_x+width_core+air_gap_coil,-height_coil,0,dim_coil};
P_crr_3 = newp ; Point(P_crr_3) = {Rint_x+width_core+air_gap_coil+width_coil,-height_coil,0,dim_coil};
P_crr_4 = newp ; Point(P_crr_4) = {Rint_x+width_core+air_gap_coil+width_coil,height_coil,0,dim_coil};

L_crr_1 = newl ; Line(L_crr_1) = {P_crr_1, P_crr_2};
L_crr_2 = newl ; Line(L_crr_2) = {P_crr_2, P_crr_3};
L_crr_3 = newl ; Line(L_crr_3) = {P_crr_3, P_crr_4};
L_crr_4 = newl ; Line(L_crr_4) = {P_crr_4, P_crr_1};

crr_loop = newll ; Curve Loop(crr_loop) = {L_crr_1,L_crr_2,L_crr_3,L_crr_4};
s_crr = news; Plane Surface(s_crr) = {crr_loop};
Physical Surface("Coil_right_right", Coil_right_right) ={s_crr};

//Other Surfaces 
A_window = news ; Plane Surface(A_window) = {Inner_loop, crl_loop,clr_loop};
Physical Surface ("Air_window", Air_window) = {A_window};

Air = news ; Plane Surface(Air) = {infinity_loop,Outside_loop,crr_loop,cll_loop};
Physical Surface("Air_ext", Air_ext) = {Air};
Physical Curve("Sur_inf",Sur_inf)={infinity_loop};








