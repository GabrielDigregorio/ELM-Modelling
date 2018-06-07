
Include "transfo_common_3phases.pro";
Solver.AutoShowLastStep = 0; // don't automatically show the last time step

// Infinity 
SetFactory("OpenCASCADE");
Circle(1) = {0,0,0,Rinf,0,2*Pi};
infinity_loop = newll ; Curve Loop(infinity_loop) = {1};

// CORE 
// central right square points
P_1 = newp ; Point(P_1) = {width_core/2+4*Rint_x, Rint_y,0,dim};
P_2 = newp ; Point(P_2) = {width_core/2, Rint_y,0,dim};
P_3 = newp ; Point(P_3) = {width_core/2, -Rint_y,0,dim};
P_4 = newp ; Point(P_4) = {width_core/2+4*Rint_x, -Rint_y,0,dim};

//Exterior shape points
P_5 = newp ; Point(P_5) = {2*width_core+6*Rint_x, Rint_y+width_core/2,0,dim};
P_6 = newp ; Point(P_6) = {-2*width_core-6*Rint_x, Rint_y+width_core/2,0,dim};
P_7 = newp ; Point(P_7) = {-2*width_core-6*Rint_x, -Rint_y-width_core/2,0,dim};
P_8 = newp ; Point(P_8) = {2*width_core+6*Rint_x, -Rint_y-width_core/2,0,dim};

// central left square point
P_9 = newp ; Point(P_9) = {-width_core/2, Rint_y,0,dim};
P_10 = newp ; Point(P_10) = {-width_core/2-4*Rint_x, Rint_y,0,dim};
P_11 = newp ; Point(P_11) = {-width_core/2-4*Rint_x, -Rint_y,0,dim};
P_12 = newp ; Point(P_12) = {-width_core/2, -Rint_y,0,dim};

// exterior left square point
P_13 = newp ; Point(P_13) = {-3*width_core/2-4*Rint_x, Rint_y,0,dim};
P_14 = newp ; Point(P_14) = {-3*width_core/2-6*Rint_x, Rint_y,0,dim};
P_15 = newp ; Point(P_15) = {-3*width_core/2-6*Rint_x, -Rint_y,0,dim};
P_16 = newp ; Point(P_16) = {-3*width_core/2-4*Rint_x, -Rint_y,0,dim};

//exterior right square point 
P_17 = newp ; Point(P_17) = {3*width_core/2+4*Rint_x, Rint_y,0,dim};
P_18 = newp ; Point(P_18) = {3*width_core/2+6*Rint_x, Rint_y,0,dim};
P_19 = newp ; Point(P_19) = {3*width_core/2+6*Rint_x, -Rint_y,0,dim};
P_20 = newp ; Point(P_20) = {3*width_core/2+4*Rint_x, -Rint_y,0,dim};

// Inner lines

//central right square lines
L_1 = newl ; Line(L_1) = {P_1,P_2};
L_2 = newl ; Line(L_2) = {P_2,P_3};
L_3 = newl ; Line(L_3) = {P_3,P_4};
L_4 = newl ; Line(L_4) = {P_4,P_1};

//Exterior lines
L_5 = newl ; Line(L_5) = {P_5,P_6};
L_6 = newl ; Line(L_6) = {P_6,P_7};
L_7 = newl ; Line(L_7) = {P_7,P_8};
L_8 = newl ; Line(L_8) = {P_8,P_5};

// central left square lines
L_9 = newl ; Line(L_9) = {P_9,P_10};
L_10 = newl ; Line(L_10) = {P_10,P_11};
L_11 = newl ; Line(L_11) = {P_11,P_12};
L_12 = newl ; Line(L_12) = {P_12,P_9};

//exterior left square lines 
L_13 = newl ; Line(L_13) = {P_13, P_14};
L_14 = newl ; Line(L_14) = {P_14, P_15};
L_15 = newl ; Line(L_15) = {P_15, P_16};
L_16 = newl ; Line(L_16) = {P_16, P_13};

//exterior right square lines 
L_17 = newl ; Line(L_17) = {P_17, P_18};
L_18 = newl ; Line(L_18) = {P_18, P_19};
L_19 = newl ; Line(L_19) = {P_19, P_20};
L_20 = newl ; Line(L_20) = {P_20, P_17};

//Curve Loop and surface

Inner_loopcr = newll; Curve Loop(Inner_loopcr) = {L_1,L_2,L_3,L_4};
Inner_loopcl = newll; Curve Loop(Inner_loopcl) = {L_9,L_10,L_11,L_12};
Inner_looper = newll; Curve Loop(Inner_looper) = {L_17,L_18,L_19, L_20};
Inner_loopel = newll; Curve Loop(Inner_loopel) = {L_13,L_14,L_15,L_16};
Outside_loop = newll; Curve Loop(Outside_loop) = {L_5,L_6,L_7,L_8};
surf_coil = news ; Plane Surface(surf_coil) = {Outside_loop,Inner_loopcr,Inner_loopcl,Inner_looper,Inner_loopel};
Physical Surface("Core", Core) = {surf_coil};


// COILS

//Coil_central_phase

//central one left 
P_c1l_1 = newp ; Point(P_c1l_1) = {-width_core/2-air_gap_coil,height_coil,0,dim_coil};
P_c1l_2 = newp ; Point(P_c1l_2) = {-width_core/2-air_gap_coil-width_coil,height_coil,0,dim_coil};
P_c1l_3 = newp ; Point(P_c1l_3) = {-width_core/2-air_gap_coil-width_coil,-height_coil,0,dim_coil};
P_c1l_4 = newp ; Point(P_c1l_4) = {-width_core/2-air_gap_coil,-height_coil,0,dim_coil};

L_c1l_1 = newl ; Line(L_c1l_1) = {P_c1l_1, P_c1l_2};
L_c1l_2 = newl ; Line(L_c1l_2) = {P_c1l_2, P_c1l_3};
L_c1l_3 = newl ; Line(L_c1l_3) = {P_c1l_3, P_c1l_4};
L_c1l_4 = newl ; Line(L_c1l_4) = {P_c1l_4, P_c1l_1};

c1l_loop = newll ; Curve Loop(c1l_loop) = {L_c1l_1,L_c1l_2,L_c1l_3,L_c1l_4};
surf_c1l = news; Plane Surface(surf_c1l) = {c1l_loop};
Physical Surface("Coil_central_1left", Coil_central_1left) ={surf_c1l};

// central one right
P_c1r_1 = newp ; Point(P_c1r_1) = {width_core/2+air_gap_coil,height_coil,0,dim_coil};
P_c1r_2 = newp ; Point(P_c1r_2) = {width_core/2+air_gap_coil+width_coil,height_coil,0,dim_coil};
P_c1r_3 = newp ; Point(P_c1r_3) = {width_core/2+air_gap_coil+width_coil,-height_coil,0,dim_coil};
P_c1r_4 = newp ; Point(P_c1r_4) = {width_core/2+air_gap_coil,-height_coil,0,dim_coil};

L_c1r_1 = newl ; Line(L_c1r_1) = {P_c1r_1, P_c1r_2};
L_c1r_2 = newl ; Line(L_c1r_2) = {P_c1r_2, P_c1r_3};
L_c1r_3 = newl ; Line(L_c1r_3) = {P_c1r_3, P_c1r_4};
L_c1r_4 = newl ; Line(L_c1r_4) = {P_c1r_4, P_c1r_1};

c1r_loop = newll ; Curve Loop(c1r_loop) = {L_c1r_1,L_c1r_2,L_c1r_3,L_c1r_4};
surf_c1r = news; Plane Surface(surf_c1r) = {c1r_loop};
Physical Surface("Coil_central_1right", Coil_central_1right) ={surf_c1r};

// central two left 
P_c2l_1 = newp ; Point(P_c2l_1) = {-width_core/2-2*air_gap_coil-width_coil,height_coil,0,dim_coil};
P_c2l_2 = newp ; Point(P_c2l_2) = {-width_core/2-2*air_gap_coil-2*width_coil,height_coil,0,dim_coil};
P_c2l_3 = newp ; Point(P_c2l_3) = {-width_core/2-2*air_gap_coil-2*width_coil,-height_coil,0,dim_coil};
P_c2l_4 = newp ; Point(P_c2l_4) = {-width_core/2-2*air_gap_coil-width_coil,-height_coil,0,dim_coil};

L_c2l_1 = newl ; Line(L_c2l_1) = {P_c2l_1, P_c2l_2};
L_c2l_2 = newl ; Line(L_c2l_2) = {P_c2l_2, P_c2l_3};
L_c2l_3 = newl ; Line(L_c2l_3) = {P_c2l_3, P_c2l_4};
L_c2l_4 = newl ; Line(L_c2l_4) = {P_c2l_4, P_c2l_1};

c2l_loop = newll ; Curve Loop(c2l_loop) = {L_c2l_1,L_c2l_2,L_c2l_3,L_c2l_4};
surf_c2l = news; Plane Surface(surf_c2l) = {c2l_loop};
Physical Surface("Coil_central_2left", Coil_central_2left) ={surf_c2l};

// central two right
P_c2r_1 = newp ; Point(P_c2r_1) = {width_core/2+2*air_gap_coil+width_coil,height_coil,0,dim_coil};
P_c2r_2 = newp ; Point(P_c2r_2) = {width_core/2+2*air_gap_coil+2*width_coil,height_coil,0,dim_coil};
P_c2r_3 = newp ; Point(P_c2r_3) = {width_core/2+2*air_gap_coil+2*width_coil,-height_coil,0,dim_coil};
P_c2r_4 = newp ; Point(P_c2r_4) = {width_core/2+2*air_gap_coil+width_coil,-height_coil,0,dim_coil};

L_c2r_1 = newl ; Line(L_c2r_1) = {P_c2r_1, P_c2r_2};
L_c2r_2 = newl ; Line(L_c2r_2) = {P_c2r_2, P_c2r_3};
L_c2r_3 = newl ; Line(L_c2r_3) = {P_c2r_3, P_c2r_4};
L_c2r_4 = newl ; Line(L_c2r_4) = {P_c2r_4, P_c2r_1};

c2r_loop = newll ; Curve Loop(c2r_loop) = {L_c2r_1,L_c2r_2,L_c2r_3,L_c2r_4};
surf_c2r = news; Plane Surface(surf_c2r) = {c2r_loop};
Physical Surface("Coil_central_2right", Coil_central_2right) ={surf_c2r};

//Coil left phase 

//left one left 
P_l1l_1 = newp ; Point(P_l1l_1) = {-3*width_core/2-4*Rint_x-air_gap_coil,height_coil,0,dim_coil};
P_l1l_2 = newp ; Point(P_l1l_2) = {-3*width_core/2-4*Rint_x-2*air_gap_coil-width_coil,height_coil,0,dim_coil};
P_l1l_3 = newp ; Point(P_l1l_3) = {-3*width_core/2-4*Rint_x-2*air_gap_coil-width_coil,-height_coil,0,dim_coil};
P_l1l_4 = newp ; Point(P_l1l_4) = {-3*width_core/2-4*Rint_x-air_gap_coil,-height_coil,0,dim_coil};

L_l1l_1 = newl ; Line(L_l1l_1) = {P_l1l_1, P_l1l_2};
L_l1l_2 = newl ; Line(L_l1l_2) = {P_l1l_2, P_l1l_3};
L_l1l_3 = newl ; Line(L_l1l_3) = {P_l1l_3, P_l1l_4};
L_l1l_4 = newl ; Line(L_l1l_4) = {P_l1l_4, P_l1l_1};

l1l_loop = newll ; Curve Loop(l1l_loop) = {L_l1l_1,L_l1l_2,L_l1l_3,L_l1l_4};
surf_l1l = news; Plane Surface(surf_l1l) = {l1l_loop};
Physical Surface("Coil_left_1left", Coil_left_1left) ={surf_l1l};

// left one right
P_l1r_1 = newp ; Point(P_l1r_1) = {-width_core/2-4*Rint_x+air_gap_coil+width_coil,height_coil,0,dim_coil};
P_l1r_2 = newp ; Point(P_l1r_2) = {-width_core/2-4*Rint_x+air_gap_coil,height_coil,0,dim_coil};
P_l1r_3 = newp ; Point(P_l1r_3) = {-width_core/2-4*Rint_x+air_gap_coil,-height_coil,0,dim_coil};
P_l1r_4 = newp ; Point(P_l1r_4) = {-width_core/2-4*Rint_x+air_gap_coil+width_coil,-height_coil,0,dim_coil};

L_l1r_1 = newl ; Line(L_l1r_1) = {P_l1r_1, P_l1r_2};
L_l1r_2 = newl ; Line(L_l1r_2) = {P_l1r_2, P_l1r_3};
L_l1r_3 = newl ; Line(L_l1r_3) = {P_l1r_3, P_l1r_4};
L_l1r_4 = newl ; Line(L_l1r_4) = {P_l1r_4, P_l1r_1};

l1r_loop = newll ; Curve Loop(l1r_loop) = {L_l1r_1,L_l1r_2,L_l1r_3,L_l1r_4};
surf_l1r = news; Plane Surface(surf_l1r) = {l1r_loop};
Physical Surface("Coil_left_1right", Coil_left_1right) ={surf_l1r};

// left two left 
P_l2l_1 = newp ; Point(P_l2l_1) = {-3*width_core/2-6*Rint_x+air_gap_coil+width_coil,height_coil,0,dim_coil};
P_l2l_2 = newp ; Point(P_l2l_2) = {-3*width_core/2-6*Rint_x+air_gap_coil,height_coil,0,dim_coil};
P_l2l_3 = newp ; Point(P_l2l_3) = {-3*width_core/2-6*Rint_x+air_gap_coil,-height_coil,0,dim_coil};
P_l2l_4 = newp ; Point(P_l2l_4) = {-3*width_core/2-6*Rint_x+air_gap_coil+width_coil,-height_coil,0,dim_coil};

L_l2l_1 = newl ; Line(L_l2l_1) = {P_l2l_1, P_l2l_2};
L_l2l_2 = newl ; Line(L_l2l_2) = {P_l2l_2, P_l2l_3};
L_l2l_3 = newl ; Line(L_l2l_3) = {P_l2l_3, P_l2l_4};
L_l2l_4 = newl ; Line(L_l2l_4) = {P_l2l_4, P_l2l_1};

l2l_loop = newll ; Curve Loop(l2l_loop) = {L_l2l_1,L_l2l_2,L_l2l_3,L_l2l_4};
surf_l2l = news; Plane Surface(surf_l2l) = {l2l_loop};
Physical Surface("Coil_left_2left", Coil_left_2left) ={surf_l2l};

// left two right
P_l2r_1 = newp ; Point(P_l2r_1) = {-width_core/2-4*Rint_x+2*air_gap_coil+2*width_coil,height_coil,0,dim_coil};
P_l2r_2 = newp ; Point(P_l2r_2) = {-width_core/2-4*Rint_x+2*air_gap_coil+width_coil,height_coil,0,dim_coil};
P_l2r_3 = newp ; Point(P_l2r_3) = {-width_core/2-4*Rint_x+2*air_gap_coil+width_coil,-height_coil,0,dim_coil};
P_l2r_4 = newp ; Point(P_l2r_4) = {-width_core/2-4*Rint_x+2*air_gap_coil+2*width_coil,-height_coil,0,dim_coil};

L_l2r_1 = newl ; Line(L_l2r_1) = {P_l2r_1, P_l2r_2};
L_l2r_2 = newl ; Line(L_l2r_2) = {P_l2r_2, P_l2r_3};
L_l2r_3 = newl ; Line(L_l2r_3) = {P_l2r_3, P_l2r_4};
L_l2r_4 = newl ; Line(L_l2r_4) = {P_l2r_4, P_l2r_1};

l2r_loop = newll ; Curve Loop(l2r_loop) = {L_l2r_1,L_l2r_2,L_l2r_3,L_l2r_4};
surf_l2r = news; Plane Surface(surf_l2r) = {l2r_loop};
Physical Surface("Coil_left_2right", Coil_left_2right) ={surf_l2r};

//Coil right phase 

//right one left 
P_r1l_1 = newp ; Point(P_r1l_1) = {width_core/2+4*Rint_x-air_gap_coil,height_coil,0,dim_coil};
P_r1l_2 = newp ; Point(P_r1l_2) = {width_core/2+4*Rint_x-air_gap_coil-width_coil,height_coil,0,dim_coil};
P_r1l_3 = newp ; Point(P_r1l_3) = {width_core/2+4*Rint_x-air_gap_coil-width_coil,-height_coil,0,dim_coil};
P_r1l_4 = newp ; Point(P_r1l_4) = {width_core/2+4*Rint_x-air_gap_coil,-height_coil,0,dim_coil};

L_r1l_1 = newl ; Line(L_r1l_1) = {P_r1l_1, P_r1l_2};
L_r1l_2 = newl ; Line(L_r1l_2) = {P_r1l_2, P_r1l_3};
L_r1l_3 = newl ; Line(L_r1l_3) = {P_r1l_3, P_r1l_4};
L_r1l_4 = newl ; Line(L_r1l_4) = {P_r1l_4, P_r1l_1};

r1l_loop = newll ; Curve Loop(r1l_loop) = {L_r1l_1,L_r1l_2,L_r1l_3,L_r1l_4};
surf_r1l = news; Plane Surface(surf_r1l) = {r1l_loop};
Physical Surface("Coil_right_1left", Coil_right_1left) ={surf_r1l};

// right one right
P_r1r_1 = newp ; Point(P_r1r_1) = {3*width_core/2+4*Rint_x+air_gap_coil+width_coil,height_coil,0,dim_coil};
P_r1r_2 = newp ; Point(P_r1r_2) = {3*width_core/2+4*Rint_x+air_gap_coil,height_coil,0,dim_coil};
P_r1r_3 = newp ; Point(P_r1r_3) = {3*width_core/2+4*Rint_x+air_gap_coil,-height_coil,0,dim_coil};
P_r1r_4 = newp ; Point(P_r1r_4) = {3*width_core/2+4*Rint_x+air_gap_coil+width_coil,-height_coil,0,dim_coil};

L_r1r_1 = newl ; Line(L_r1r_1) = {P_r1r_1, P_r1r_2};
L_r1r_2 = newl ; Line(L_r1r_2) = {P_r1r_2, P_r1r_3};
L_r1r_3 = newl ; Line(L_r1r_3) = {P_r1r_3, P_r1r_4};
L_r1r_4 = newl ; Line(L_r1r_4) = {P_r1r_4, P_r1r_1};

r1r_loop = newll ; Curve Loop(r1r_loop) = {L_r1r_1,L_r1r_2,L_r1r_3,L_r1r_4};
surf_r1r = news; Plane Surface(surf_r1r) = {r1r_loop};
Physical Surface("Coil_right_1right", Coil_right_1right) ={surf_r1r};

// right two left 
P_r2l_1 = newp ; Point(P_r2l_1) = {width_core/2+4*Rint_x-2*air_gap_coil-width_coil,height_coil,0,dim_coil};
P_r2l_2 = newp ; Point(P_r2l_2) = {width_core/2+4*Rint_x-2*air_gap_coil-2*width_coil,height_coil,0,dim_coil};
P_r2l_3 = newp ; Point(P_r2l_3) = {width_core/2+4*Rint_x-2*air_gap_coil-2*width_coil,-height_coil,0,dim_coil};
P_r2l_4 = newp ; Point(P_r2l_4) = {width_core/2+4*Rint_x-2*air_gap_coil-width_coil,-height_coil,0,dim_coil};

L_r2l_1 = newl ; Line(L_r2l_1) = {P_r2l_1, P_r2l_2};
L_r2l_2 = newl ; Line(L_r2l_2) = {P_r2l_2, P_r2l_3};
L_r2l_3 = newl ; Line(L_r2l_3) = {P_r2l_3, P_r2l_4};
L_r2l_4 = newl ; Line(L_r2l_4) = {P_r2l_4, P_r2l_1};

r2l_loop = newll ; Curve Loop(r2l_loop) = {L_r2l_1,L_r2l_2,L_r2l_3,L_r2l_4};
surf_r2l = news; Plane Surface(surf_r2l) = {r2l_loop};
Physical Surface("Coil_right_2left", Coil_right_2left) ={surf_r2l};

// right two right
P_r2r_1 = newp ; Point(P_r2r_1) = {3*width_core/2+6*Rint_x-air_gap_coil,height_coil,0,dim_coil};
P_r2r_2 = newp ; Point(P_r2r_2) = {3*width_core/2+6*Rint_x-air_gap_coil-width_coil,height_coil,0,dim_coil};
P_r2r_3 = newp ; Point(P_r2r_3) = {3*width_core/2+6*Rint_x-air_gap_coil-width_coil,-height_coil,0,dim_coil};
P_r2r_4 = newp ; Point(P_r2r_4) = {3*width_core/2+6*Rint_x-air_gap_coil,-height_coil,0,dim_coil};

L_r2r_1 = newl ; Line(L_r2r_1) = {P_r2r_1, P_r2r_2};
L_r2r_2 = newl ; Line(L_r2r_2) = {P_r2r_2, P_r2r_3};
L_r2r_3 = newl ; Line(L_r2r_3) = {P_r2r_3, P_r2r_4};
L_r2r_4 = newl ; Line(L_r2r_4) = {P_r2r_4, P_r2r_1};

r2r_loop = newll ; Curve Loop(r2r_loop) = {L_r2r_1,L_r2r_2,L_r2r_3,L_r2r_4};
surf_r2r = news; Plane Surface(surf_r2r) = {r2r_loop};
Physical Surface("Coil_right_2right", Coil_right_2right) ={surf_r2r};


// Other Physical surfaces :

A_windowel = news ; Plane Surface(A_windowel) = {Inner_loopel, l1l_loop,l2l_loop};
Physical Surface ("Air_windowel", Air_windowel) = {A_windowel};

A_windower = news ; Plane Surface(A_windower) = {Inner_looper, r1r_loop,r2r_loop};
Physical Surface ("Air_windower", Air_windower) = {A_windower};

A_windowcl = news ; Plane Surface(A_windowcl) = {Inner_loopcl,l1r_loop, l2r_loop,c1l_loop,c2l_loop};
Physical Surface ("Air_windowcl", Air_windowcl) = {A_windowcl};

A_windowcr = news ; Plane Surface(A_windowcr) = {Inner_loopcr,r1l_loop,r2l_loop, c1r_loop,c2r_loop};
Physical Surface ("Air_windowcr", Air_windowcr) = {A_windowcr};

Air = news ; Plane Surface(Air) = {infinity_loop,Outside_loop};
Physical Surface("Air_ext", Air_ext) = {Air};
Physical Curve("Sur_inf",Sur_inf)={infinity_loop};
