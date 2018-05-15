
// TITLE
Include "3ndProject_GUI.pro";
SetFactory("OpenCASCADE");

// Scaling
 thickness_NiO =  thickness_NiO ; // [µm]
 thickness_ZnO =  thickness_ZnO ; // [µm]

//Mesh and Domain Variables
L = 5e-6;                   // [cm] length of the heterojunction
dens_MeshPoint_NiO_Contact = 10e6;   // Density of the mesh : External domain
dens_MeshPoint_ZnO_Contact = 10e6;  // Density of the mesh : Ground domain
dens_MeshPoint_Interface = 10e6;  // Density of the mesh : cable domain
dens_MeshPoint_Lateral = 100e6;  // Density of the mesh : cable domain



//*************************************************************************************
// Geometry
Point(1) = {0, 0, 0}; // center interface
Point(2) = {-L, 0, 0}; // center interface
Point(3) = {L, 0, 0}; // center interface
Point(4) = {0, thickness_NiO, 0}; // upper point
Point(5) = {0, -thickness_ZnO, 0}; // bottom point
Point(6) = {-L,  thickness_NiO, 0}; // left upper point
Point(7) = {-L, -thickness_ZnO, 0}; // left bottom point
Point(8) = {L, thickness_NiO, 0}; // right upper point
Point(9) = {L, -thickness_ZnO, 0}; // right bottom point

Point(10) = {0, x_n, 0}; // upper point
Point(11) = {0, -x_p, 0}; // bottom point
Point(12) = {-L, x_n, 0}; // left upper point
Point(13) = {-L, -x_p, 0}; // left bottom point
Point(14) = {L, x_n, 0}; // right upper point
Point(15) = {L, -x_p, 0}; // right bottom point

Line(1) = {1,2};
Line(2) = {1,3};
Line(3) = {2,13};
Line(4) = {13,7};
Line(5) = {7,5};
Line(6) = {5,9};
Line(7) = {9,15};
Line(8) = {15,3};
Line(9) = {2,12};
Line(10) = {12,6};
Line(11) = {6,4};
Line(12) = {4,8};
Line(13) = {8,14};
Line(14) = {14,3};
Line(15) = {1,11};
Line(16) = {11,5};
Line(17) = {4,10};
Line(18) = {10,4};


Line(19) = {13,11};
Line(20) = {11,15};
Line(21) = {12,10};
Line(22) = {10,14};
Line(23) = {10,1};

// Contour
n_type_depl_left = newreg;
Line Loop(n_type_depl_left) = {1,3,19,-15};
n_type_depl_right = newreg;
Line Loop(n_type_depl_right) = {-2,15,20,8};

n_type_nodepl_left = newreg;
Line Loop(n_type_nodepl_left) = {-19,4,5,-16};
n_type_nodepl_right = newreg;
Line Loop(n_type_nodepl_right) = {-20,16,6,7};

p_type_depl_left = newreg;
Line Loop(p_type_depl_left) = {1,9,21,23};
p_type_depl_right = newreg;
Line Loop(p_type_depl_right) = {-2,-23,22,14};

p_type_nodepl_left = newreg;
Line Loop(p_type_nodepl_left) = {21,10,11,17};
p_type_nodepl_right = newreg;
Line Loop(p_type_nodepl_right) = {-22,-17,12,13};

// Surface creation
n_type_materialsDepl_left = newreg;
Plane Surface(n_type_materialsDepl_left) = {n_type_depl_left}; // Surface upper  of the n-type
n_type_materialsDepl_right = newreg;
Plane Surface(n_type_materialsDepl_right) = {n_type_depl_right}; // Surface upper  of the p-type

p_type_materialsDepl_left = newreg;
Plane Surface(p_type_materialsDepl_left) = {p_type_depl_left}; // Surface upper  of the n-type
p_type_materialsDepl_right = newreg;
Plane Surface(p_type_materialsDepl_right) = {p_type_depl_right}; // Surface upper  of the p-type

n_type_materialsNoDepl_left = newreg;
Plane Surface(n_type_materialsNoDepl_left) = {n_type_nodepl_left}; // Surface upper  of the n-type
n_type_materialsNoDepl_right = newreg;
Plane Surface(n_type_materialsNoDepl_right) = {n_type_nodepl_right}; // Surface upper  of the p-type

p_type_materialsNoDepl_left = newreg;
Plane Surface(p_type_materialsNoDepl_left) = {p_type_nodepl_left}; // Surface upper  of the n-type
p_type_materialsNoDepl_right = newreg;
Plane Surface(p_type_materialsNoDepl_right) = {p_type_nodepl_right}; // Surface upper

// Mesh
Transfinite Line{1,2,5,6,11,12,19,20,21,22} = dens_MeshPoint_Interface * L;
Transfinite Line{4,16,7} = 4*dens_MeshPoint_Lateral * (thickness_ZnO - x_n);
Transfinite Line{3,15,8} = 4*dens_MeshPoint_Lateral * x_n;
Transfinite Line{10,17,13} = 4*dens_MeshPoint_Lateral * (thickness_NiO - x_p);
Transfinite Line{9,23,14} = 4*dens_MeshPoint_Lateral * x_p;


Transfinite Surface{n_type_materialsNoDepl_left};
Recombine Surface{n_type_materialsNoDepl_left};
Transfinite Surface{n_type_materialsNoDepl_right};
Recombine Surface{n_type_materialsNoDepl_right};
Transfinite Surface{p_type_materialsNoDepl_left};
Recombine Surface{p_type_materialsNoDepl_left};
Transfinite Surface{p_type_materialsNoDepl_right};
Recombine Surface{p_type_materialsNoDepl_right};

Transfinite Surface{n_type_materialsDepl_left};
Recombine Surface{n_type_materialsDepl_left};
Transfinite Surface{n_type_materialsDepl_right};
Recombine Surface{n_type_materialsDepl_right};
Transfinite Surface{p_type_materialsDepl_left};
Recombine Surface{p_type_materialsDepl_left};
Transfinite Surface{p_type_materialsDepl_right};
Recombine Surface{p_type_materialsDepl_right};


// Physical boundaries
//Physical Line("Gamma", 100) = {n_type_boundaries_left,p_type_boundaries_left, n_type_boundaries_right, p_type_boundaries_right};
//Physical Line("GammaN", 101) = {n_type_boundaries_left, n_type_boundaries_right};
//Physical Line("GammaP", 102) = {p_type_boundaries_left, p_type_boundaries_right};
Physical Line("V_n", 103) = {5,6};
Physical Line("V_p", 104) = {11,12};
Physical Line("middle", 105) = {-1,2};
Physical Line("X_n", 106) = {19,20};
Physical Line("X_p", 107) = {21,22};

// Physical surface domain
Physical Surface("Omega", 200) = {n_type_materialsDepl_left, p_type_materialsDepl_left,p_type_materialsDepl_right,n_type_materialsDepl_right,n_type_materialsNoDepl_left, p_type_materialsNoDepl_left,p_type_materialsNoDepl_right,n_type_materialsNoDepl_right};// stock_disk_surf[0] : stock_disk_surf[3*n-1], lowerPsurf};
Physical Surface("Depl_N", 201) = {n_type_materialsDepl_left, n_type_materialsDepl_right};
Physical Surface("Depl_P", 202) = {p_type_materialsDepl_left, p_type_materialsDepl_right};
//Physical Line("NoDepl_N", 203) = {n_type_materialsNoDepl_left, n_type_materialsNoDepl_right};
//Physical Line("NoDepl_P", 204) = {p_type_materialsNoDepl_left, p_type_materialsNoDepl_right};
Physical Surface("NoDepl_N", 203) = {n_type_materialsNoDepl_left, n_type_materialsNoDepl_right};
Physical Surface("NoDepl_P", 204) = {p_type_materialsNoDepl_left, p_type_materialsNoDepl_right};
