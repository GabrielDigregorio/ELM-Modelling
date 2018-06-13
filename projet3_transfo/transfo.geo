// Geometry of a Transformer
    // S for Secondary
    // P for Primary

Include "transfo_GUI.pro";

Solver.AutoShowLastStep = 0; // do not sreeen the time step

// POINTS
    // Ferromagnetic Core Geometry
    point_Core_Ext_Left_Bottom=newp; 
    Point(newp) = {-width_Core/2., 0, 0, mesh_Core};
    point_Core_Int_Left_Bottom=newp; 
    Point(newp) = {-width_Core/2.+width_Core_Leg, 0, 0, mesh_Core};
    point_Core_Ext_Top_Left=newp; 
    Point(newp) = {-width_Core/2., height_Core/2., 0, mesh_Core};
    point_Core_Int_Top_Left=newp; 
    Point(newp) = {-width_Core/2.+width_Core_Leg, height_Core/2.-width_Core_Leg, 0, mesh_Core};
    point_Core_Int_Right_Bottom=newp; 
    Point(newp) = {width_Core/2.-width_Core_Leg, 0, 0, mesh_Core};
    point_Core_Ext_Right_Bottom=newp; 
    Point(newp) = {width_Core/2., 0, 0, mesh_Core};
    point_Core_Int_Right_Top=newp; 
    Point(newp) = {width_Core/2.-width_Core_Leg, height_Core/2.-width_Core_Leg, 0, mesh_Core};
    point_Core_Ext_Right_Top=newp; 
    Point(newp) = {width_Core/2., height_Core/2., 0, mesh_Core};

    // Primary P_RIGHT
    x_[]=Point{point_Core_Int_Left_Bottom};
    point_P_Int_BottoCoil_Left=newp; 
    Point(newp) = {x_[0]+gap_Core_P, 0, 0, mesh_P};
    point_P_point_Ext_Left=newp; 
    Point(newp) = {x_[0]+gap_Core_P+width_P, 0, 0, mesh_P};
    point_P_point_Int_right=newp; 
    Point(newp) = {x_[0]+gap_Core_P, height_P/2, 0, mesh_P};
    point_P_point_Ext_right=newp; 
    Point(newp) = {x_[0]+gap_Core_P+width_P, height_P/2, 0, mesh_P};

    //Primary P_LEFT
    x_[]=Point{point_Core_Ext_Left_Bottom};
    point_P_Coil_Int_Left=newp; 
    Point(newp) = {x_[0]-gap_Core_P, 0, 0, mesh_P};
    point_P_Coil_Ext_Left=newp; 
    Point(newp) = {x_[0]-(gap_Core_P+width_P), 0, 0, mesh_P};
    point_P_Coil_Int_right=newp; 
    Point(newp) = {x_[0]-gap_Core_P, height_P/2, 0, mesh_P};
    point_P_Coil_Ext_right=newp; 
    Point(newp) = {x_[0]-(gap_Core_P+width_P), height_P/2, 0, mesh_P};

    //Secondary S_RIGHT
    x_[]=Point{point_Core_Ext_Right_Bottom};
    point_S_point_Int_Left=newp; 
    Point(newp) = {x_[0]+gap_Core_S, 0, 0, mesh_S};
    point_S_point_Ext_Left=newp; 
    Point(newp) = {x_[0]+gap_Core_S+width_S, 0, 0, mesh_S};
    point_S_point_Int_right=newp; 
    Point(newp) = {x_[0]+gap_Core_S, height_S/2, 0, mesh_S};
    point_S_point_Ext_right=newp; 
    Point(newp) = {x_[0]+gap_Core_S+width_S, height_S/2, 0, mesh_S};

    //Secondary S_LEFT
    x_[]=Point{point_Core_Int_Right_Bottom};
    point_S_Coil_Int_Left=newp; 
    Point(newp) = {x_[0]-gap_Core_S, 0, 0, mesh_S};
    point_S_Coil_Ext_Left=newp; 
    Point(newp) = {x_[0]-(gap_Core_S+width_S), 0, 0, mesh_S};
    point_S_Coil_Int_right=newp; 
    Point(newp) = {x_[0]-gap_Core_S, height_S/2, 0, mesh_S};
    point_S_Coil_Ext_right=newp; 
    Point(newp) = {x_[0]-(gap_Core_S+width_S), height_S/2, 0, mesh_S};

    // AIR_EXT
    x_[]=Point{point_Core_Ext_Right_Top};
    point_Air_Ext_1_R_0=newp; 
    Point(newp) = {x_[0]+gap_Core1, 0, 0, mesh_Box};
    point_Air_Ext_1_R_1=newp; 
    Point(newp) = {x_[0]+gap_Core1, x_[1]+gap_Core2, 0, mesh_Box};
    x_[]=Point{point_Core_Ext_Top_Left};
    point_Air_Ext_1_L_0=newp; 
    Point(newp) = {x_[0]-gap_Core1, 0, 0, mesh_Box};
    point_Air_Ext_1_L_1=newp; 
    Point(newp) = {x_[0]-gap_Core1, x_[1]+gap_Core2, 0, mesh_Box};

// LINES  
    // Ferromagnetic Core Geometry
    line_Core_Int[]={};
    line_Core_Int[]+=newl;
    Line(newl) = {point_Core_Int_Left_Bottom, point_Core_Int_Top_Left};
    line_Core_Int[]+=newl;
    Line(newl) = {point_Core_Int_Top_Left, point_Core_Int_Right_Top};
    line_Core_Int[]+=newl;
    Line(newl) = {point_Core_Int_Right_Top, point_Core_Int_Right_Bottom};
    line_Core_Ext[]={};
    line_Core_Ext[]+=newl;
    Line(newl) = {point_Core_Ext_Right_Bottom, point_Core_Ext_Right_Top};
    line_Core_Ext[]+=newl;
    Line(newl) = {point_Core_Ext_Right_Top, point_Core_Ext_Top_Left};
    line_Core_Ext[]+=newl;
    Line(newl) = {point_Core_Ext_Top_Left, point_Core_Ext_Left_Bottom};
    line_Core_Left_Bottom[]={};
    line_Core_Left_Bottom[]+=newl; 
    Line(newl) = {point_Core_Ext_Left_Bottom, point_Core_Int_Left_Bottom};
    line_Core_Right_Bottom[]={};
    line_Core_Right_Bottom[]+=newl; 
    Line(newl) = {point_Core_Int_Right_Bottom, point_Core_Ext_Right_Bottom};

    // Primary P_RIGHT
    line_P_p[]={};
    line_P_point[]+=newl; 
    Line(newl) = {point_P_point_Ext_Left, point_P_point_Ext_right};
    line_P_point[]+=newl; 
    Line(newl) = {point_P_point_Ext_right, point_P_point_Int_right};
    line_P_point[]+=newl; 
    Line(newl) = {point_P_point_Int_right, point_P_Int_BottoCoil_Left};
    line_P_point_Bottom[]={};
    line_P_point_Bottom[]+=newl; 
    Line(newl) = {point_P_Int_BottoCoil_Left, point_P_point_Ext_Left};

    //Primary P_LEFT
    line_P_Coil[]={};
    line_P_Coil[]+=newl; 
    Line(newl) = {point_P_Coil_Ext_Left, point_P_Coil_Ext_right};
    line_P_Coil[]+=newl; 
    Line(newl) = {point_P_Coil_Ext_right, point_P_Coil_Int_right};
    line_P_Coil[]+=newl; 
    Line(newl) = {point_P_Coil_Int_right, point_P_Coil_Int_Left};
    line_P_Coil_Bottom[]={};
    line_P_Coil_Bottom[]+=newl; 
    Line(newl) = {point_P_Coil_Int_Left, point_P_Coil_Ext_Left};

    //Secondary S_RIGHT
    line_S_point[]={};
    line_S_point[]+=newl; 
    Line(newl) = {point_S_point_Ext_Left, point_S_point_Ext_right};
    line_S_point[]+=newl; 
    Line(newl) = {point_S_point_Ext_right, point_S_point_Int_right};
    line_S_point[]+=newl; 
    Line(newl) = {point_S_point_Int_right, point_S_point_Int_Left};
    line_S_point_Bottom[]={};
    line_S_point_Bottom[]+=newl; 
    Line(newl) = {point_S_point_Int_Left, point_S_point_Ext_Left};

    //Secondary S_LEFT
    line_S_Coil[]={};
    line_S_Coil[]+=newl; 
    Line(newl) = {point_S_Coil_Ext_Left, point_S_Coil_Ext_right};
    line_S_Coil[]+=newl; 
    Line(newl) = {point_S_Coil_Ext_right, point_S_Coil_Int_right};
    line_S_Coil[]+=newl; 
    Line(newl) = {point_S_Coil_Int_right, point_S_Coil_Int_Left};
    line_S_Coil_Bottom[]={};
    line_S_Coil_Bottom[]+=newl; 
    Line(newl) = {point_S_Coil_Int_Left, point_S_Coil_Ext_Left};

    // AIR_InnerCore
    line_Air_InnerCore_Bottom[]={};
    line_Air_InnerCore_Bottom[]+=newl; 
    Line(newl) = {point_Core_Int_Left_Bottom, point_P_Int_BottoCoil_Left};
    line_Air_InnerCore_Bottom[]+=newl; 
    Line(newl) = {point_P_point_Ext_Left, point_S_Coil_Ext_Left};
    line_Air_InnerCore_Bottom[]+=newl; 
    Line(newl) = {point_S_Coil_Int_Left, point_Core_Int_Right_Bottom};

    // AIR_EXT
    line_Air_Ext[]={};
    line_Air_Ext[]+=newl; 
    Line(newl) = {point_Air_Ext_1_R_0, point_Air_Ext_1_R_1};
    line_Air_Ext[]+=newl; 
    Line(newl) = {point_Air_Ext_1_R_1, point_Air_Ext_1_L_1};
    line_Air_Ext[]+=newl; 
    Line(newl) = {point_Air_Ext_1_L_1, point_Air_Ext_1_L_0};
    line_Air_Ext_Bottom[]={};
    line_Air_Ext_Bottom[]+=newl; 
    Line(newl) = {point_Core_Ext_Right_Bottom, point_S_point_Int_Left};
    line_Air_Ext_Bottom[]+=newl; 
    Line(newl) = {point_S_point_Ext_Left, point_Air_Ext_1_R_0};
    line_Air_Ext_Bottom[]+=newl; 
    Line(newl) = {point_Air_Ext_1_L_0, point_P_Coil_Ext_Left};
    line_Air_Ext_Bottom[]+=newl; 
    Line(newl) = {point_P_Coil_Int_Left, point_Core_Ext_Left_Bottom};



// Lineloop
lline_Core=newll; 
Line Loop(newll) = {line_Core_Int[], line_Core_Right_Bottom[], line_Core_Ext[], line_Core_Left_Bottom[]};
lline_P_point=newll; 
Line Loop(newll) = {line_P_point[], line_P_point_Bottom[]};
lline_P_Coil=newll; 
Line Loop(newll) = {line_P_Coil[], line_P_Coil_Bottom[]};
lline_S_point=newll; 
Line Loop(newll) = {line_S_point[], line_S_point_Bottom[]};
lline_S_Coil=newll; 
Line Loop(newll) = {line_S_Coil[], line_S_Coil_Bottom[]};
lline_Air_InnerCore=newll; 
Line Loop(newll) = {-line_Core_Int[], -line_P_point[], line_S_Coil[], line_Air_InnerCore_Bottom[]};
lline_Air_Ext=newll; 
Line Loop(newll) = {-line_Core_Ext[], -line_S_point[], line_P_Coil[], line_Air_Ext[], line_Air_Ext_Bottom[]};

// Surface
surface_Core=news; 
Plane Surface(news) = {lline_Core};
surface_P_point=news; 
Plane Surface(news) = {lline_P_point};
surface_P_Coil=news; 
Plane Surface(news) = {lline_P_Coil};
surface_S_point=news; 
Plane Surface(news) = {lline_S_point};
surface_S_Coil=news; 
Plane Surface(news) = {lline_S_Coil};
surface_Air_InnerCore=news; 
Plane Surface(news) = {lline_Air_InnerCore};
surface_Air_Ext=news; 
Plane Surface(news) = {lline_Air_Ext};


// Physical regions
Physical Surface("Air_Ext", 1001) = {surface_Air_Ext};
Physical Line("Domain_Boundaries", 1002) = {line_Air_Ext[]};
Physical Surface("Air_InnerCore", 1003) = {surface_Air_InnerCore};
Physical Surface("Core", 1004) = {surface_Core};
Physical Surface("P_Right", 1005) = {surface_P_point};
Physical Surface("P_Left", 1006) = {surface_P_Coil};
Physical Surface("S_Right", 1007) = {surface_S_point};
Physical Surface("S_Left", 1008) = {surface_S_Coil};

