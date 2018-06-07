/************************************************
* Geometry of the shell type transformer        *
* Authors: Radelet Florian, DUMONT Antoine      *
************************************************/

Include "transfo_common_shell.pro";

	// Core:
	
// External core: 
P1_core = newp; Point(P1_core) = {-width/2-space-width/2, -height/2, 0, c_Core};
P2_core = newp; Point(P2_core) = {-width/2-space-width/2, height/2, 0, c_Core};
P3_core = newp; Point(P3_core) = {width/2+space+width/2, height/2, 0, c_Core};
P4_core = newp; Point(P4_core) = {width/2+space+width/2, -height/2, 0, c_Core};

L1_core = newl; Line(L1_core) = {P1_core,P2_core};
L2_core = newl; Line(L2_core) = {P2_core,P3_core};
L3_core = newl; Line(L3_core) = {P3_core,P4_core};
L4_core = newl; Line(L4_core) = {P4_core,P1_core};

Ext_core = newll; Curve Loop(Ext_core) = {L1_core,L2_core,L3_core,L4_core};

// Internal core (left): 
P5_core = newp; Point(P5_core) = {-width/2-space, -height/2+width/2, 0, c_Core};
P6_core = newp; Point(P6_core) = {-width/2-space, height/2-width/2, 0, c_Core};
P7_core = newp; Point(P7_core) = {-width/2, height/2-width/2, 0, c_Core};
P8_core = newp; Point(P8_core) = {-width/2, -height/2+width/2, 0, c_Core};

L5_core = newl; Line(L5_core) = {P5_core,P6_core};
L6_core = newl; Line(L6_core) = {P6_core,P7_core};
L7_core = newl; Line(L7_core) = {P7_core,P8_core};
L8_core = newl; Line(L8_core) = {P8_core,P5_core};

Int_coreL = newll; Curve Loop(Int_coreL) = {L5_core,L6_core,L7_core,L8_core};

// Internal core (right):
P9_core = newp; Point(P9_core) = {width/2, -height/2+width/2, 0, c_Core};
P10_core = newp; Point(P10_core) = {width/2, height/2-width/2, 0, c_Core};
P11_core = newp; Point(P11_core) = {width/2+space, height/2-width/2, 0, c_Core};
P12_core = newp; Point(P12_core) = {width/2+space, -height/2+width/2, 0, c_Core};

L9_core = newl; Line(L9_core) = {P9_core,P10_core};
L10_core = newl; Line(L10_core) = {P10_core,P11_core};
L11_core = newl; Line(L11_core) = {P11_core,P12_core};
L12_core = newl; Line(L12_core) = {P12_core,P9_core};

Int_coreR = newll; Curve Loop(Int_coreR) = {L9_core,L10_core,L11_core,L12_core};

// Surface of the core: 
S_core = news; Surface(S_core) = {Ext_core,Int_coreL,Int_coreR};

	// Primary: 
// negative part: 
P1_neg = newp; Point(P1_neg) = {-width/2-wire_width_1-wire_dist, -wire_height_1, 0, c_Coil_1};
P2_neg = newp; Point(P2_neg) = {-width/2-wire_width_1-wire_dist, wire_height_1, 0, c_Coil_1};
P3_neg = newp; Point(P3_neg) = {-width/2-wire_dist, wire_height_1, 0, c_Coil_1};
P4_neg = newp; Point(P4_neg) = {-width/2-wire_dist, -wire_height_1, 0, c_Coil_1};

L1_neg = newl; Line(L1_neg) = {P1_neg,P2_neg};
L2_neg = newl; Line(L2_neg) = {P2_neg,P3_neg};
L3_neg = newl; Line(L3_neg) = {P3_neg,P4_neg};
L4_neg = newl; Line(L4_neg) = {P4_neg,P1_neg};

Coil1_N = newll; Curve Loop(Coil1_N) = {L1_neg,L2_neg,L3_neg,L4_neg};

S_1neg = news; Surface(S_1neg) = {Coil1_N};

// positive part: 
P1_pos = newp; Point(P1_pos) = {width/2+wire_dist, -wire_height_1, 0, c_Coil_1};
P2_pos = newp; Point(P2_pos) = {width/2+wire_dist, wire_height_1, 0, c_Coil_1};
P3_pos = newp; Point(P3_pos) = {width/2+wire_width_1+wire_dist, wire_height_1, 0, c_Coil_1};
P4_pos = newp; Point(P4_pos) = {width/2+wire_width_1+wire_dist, -wire_height_1, 0, c_Coil_1};

L1_pos = newl; Line(L1_pos) = {P1_pos,P2_pos};
L2_pos = newl; Line(L2_pos) = {P2_pos,P3_pos};
L3_pos = newl; Line(L3_pos) = {P3_pos,P4_pos};
L4_pos = newl; Line(L4_pos) = {P4_pos,P1_pos};

Coil1_P = newll; Curve Loop(Coil1_P) = {L1_pos,L2_pos,L3_pos,L4_pos};

S_1pos = news; Surface(S_1pos) = {Coil1_P};

	// Secondary: 
// negative part: 
P1_negS = newp; Point(P1_negS) = {-width/2-wire_width_1-wire_dist-dist_wire-wire_width_2, -wire_height_2, 0, c_Coil_2};
P2_negS = newp; Point(P2_negS) = {-width/2-wire_width_1-wire_dist-dist_wire-wire_width_2, wire_height_2, 0, c_Coil_2};
P3_negS = newp; Point(P3_negS) = {-width/2-wire_dist-dist_wire-wire_width_1, wire_height_2, 0, c_Coil_2};
P4_negS = newp; Point(P4_negS) = {-width/2-wire_dist-dist_wire-wire_width_1, -wire_height_2, 0, c_Coil_2};

L1_negS = newl; Line(L1_negS) = {P1_negS,P2_negS};
L2_negS = newl; Line(L2_negS) = {P2_negS,P3_negS};
L3_negS = newl; Line(L3_negS) = {P3_negS,P4_negS};
L4_negS = newl; Line(L4_negS) = {P4_negS,P1_negS};

Coil2_N = newll; Curve Loop(Coil2_N) = {L1_negS,L2_negS,L3_negS,L4_negS};

S_2neg = news; Surface(S_2neg) = {Coil2_N};

// positive part: 
P1_posS = newp; Point(P1_posS) = {width/2+wire_dist+dist_wire+wire_width_1, -wire_height_2, 0, c_Coil_2};
P2_posS = newp; Point(P2_posS) = {width/2+wire_dist+dist_wire+wire_width_1, wire_height_2, 0, c_Coil_2};
P3_posS = newp; Point(P3_posS) = {width/2+wire_width_1+wire_dist+dist_wire+wire_width_2, wire_height_2, 0, c_Coil_2};
P4_posS = newp; Point(P4_posS) = {width/2+wire_width_1+wire_dist+dist_wire+wire_width_2, -wire_height_2, 0, c_Coil_2};

L1_posS = newl; Line(L1_posS) = {P1_posS,P2_posS};
L2_posS = newl; Line(L2_posS) = {P2_posS,P3_posS};
L3_posS = newl; Line(L3_posS) = {P3_posS,P4_posS};
L4_posS = newl; Line(L4_posS) = {P4_posS,P1_posS};

Coil2_P = newll; Curve Loop(Coil2_P) = {L1_posS,L2_posS,L3_posS,L4_posS};

S_2pos = news; Surface(S_2pos) = {Coil2_P};

	// Room:

P1_room = newp; Point(P1_room) = {-room,-room,0,c_Box};
P2_room = newp; Point(P2_room) = {-room,room,0,c_Box};
P3_room = newp; Point(P3_room) = {room,room,0,c_Box};
P4_room = newp; Point(P4_room) = {room,-room,0,c_Box};

L1_room = newl; Line(L1_room) = {P1_room,P2_room};
L2_room = newl; Line(L2_room) = {P2_room,P3_room};
L3_room = newl; Line(L3_room) = {P3_room,P4_room};
L4_room = newl; Line(L4_room) = {P4_room,P1_room};

C_room = newll; Curve Loop(C_room) = {L1_room,L2_room,L3_room,L4_room};

	// External air:
S_airext = news; Surface(S_airext) = {C_room, Ext_core};

	// Right internal air:
S_airR = news; Surface(S_airR) = {Int_coreR, Coil1_P, Coil2_P};

	// Left internal air: 
S_airL = news; Surface(S_airL) = {Int_coreL, Coil1_N, Coil2_N};


// Physical surfaces:

Physical Surface("AIR_EXT", AIR_EXT) = {S_airext};
Physical Surface("AIR_WINDOWL", AIR_WINDOWL) = {S_airL};
Physical Surface("AIR_WINDOWR", AIR_WINDOWR) = {S_airR};
Physical Surface("CORE", CORE) = {S_core};

Physical Surface("COIL_1_MINUS", COIL_1_MINUS) = {S_2neg};
Physical Surface("COIL_1_PLUS", COIL_1_PLUS) = {S_2pos};

Physical Surface("COIL_2_MINUS", COIL_2_MINUS) = {S_1neg};
Physical Surface("COIL_2_PLUS", COIL_2_PLUS) = {S_1pos};

Physical Curve("SUR_AIR_EXT", SUR_AIR_EXT) = {C_room};