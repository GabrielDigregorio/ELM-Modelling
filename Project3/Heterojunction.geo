
// TITLE
Include "3ndProject_GUI.pro";
SetFactory("OpenCASCADE");

//Mesh and Domain Variables
L = 100e-6;                   // [m] length of the heterojunction 
dens_MeshPoint_NiO_Contact = 1e4;   // Density of the mesh : External domain
dens_MeshPoint_ZnO_Contact = 1e4;  // Density of the mesh : Ground domain
dens_MeshPoint_Interface = 1e4;  // Density of the mesh : cable domain
dens_MeshPoint_Lateral = 1e4;  // Density of the mesh : cable domain


//*************************************************************************************
// Geometry
Point(1) = {0, 0, 0, 1.0}; // center interface
Point(2) = {-L, 0, 0, 1.0}; // center interface
Point(3) = {L, 0, 0, 1.0}; // center interface
Point(4) = {0, thickness_NiO, 0, 1.0}; // upper point
Point(5) = {0, -thickness_ZnO, 0, 1.0}; // bottom point
Point(6) = {-L,  thickness_NiO, 0, 1.0}; // left upper point
Point(7) = {-L, -thickness_ZnO, 0, 1.0}; // left bottom point
Point(8) = {L, thickness_NiO, 0, 1.0}; // right upper point
Point(9) = {L, -thickness_ZnO, 0, 1.0}; // right bottom point


Line(1) = {1,2};
Line(2) = {1,3};
Line(3) = {2,7};
Line(4) = {7,5};
Line(5) = {5,9};
Line(6) = {9,3};
Line(7) = {2,6};
Line(8) = {6,4};
Line(9) = {4,8};
Line(10) = {8,3};

// Contour
n_type_boundaries = newreg;
Line Loop(n_type_boundaries) = {1,3,4,5,6,-2};
p_type_boundaries = newreg;
Line Loop(p_type_boundaries) = {1,7,8,9,10,-2};

    
// Surface creation
n_type_materials = newreg;
Plane Surface(n_type_materials) = {n_type_boundaries}; // Surface upper  of the n-type
p_type_materials = newreg;
Plane Surface(p_type_materials) = {p_type_boundaries}; // Surface upper  of the p-type

// Mesh
Transfinite Line{1,2,4,5,8,9} = dens_MeshPoint_Interface * L;
Transfinite Line{3,6} = dens_MeshPoint_Lateral * thickness_ZnO;
Transfinite Line{7,10} = dens_MeshPoint_Lateral * thickness_NiO;


// Physical boundaries
Physical Line("Gamma", 100) = {n_type_boundaries, p_type_boundaries};
Physical Line("GammaN", 101) = {n_type_boundaries};
Physical Line("GammaP", 102) = {p_type_boundaries};
Physical Line("V_n", 103) = {4,5};
Physical Line("V_p", 104) = {8,9};
Physical Line("middle", 105) = {1,2};


// Physical surface domain
Physical Surface("Omega", 200) = {n_type_materials,p_type_materials};// stock_disk_surf[0] : stock_disk_surf[3*n-1], lowerPsurf};
Physical Surface("OmegaN", 201) = {n_type_materials};
Physical Surface("OmegaP", 202) = {p_type_materials};

