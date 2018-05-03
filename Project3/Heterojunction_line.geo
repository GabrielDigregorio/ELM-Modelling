L=2;
Point(1)={-L/2,0,0};
Point(2)={0,0,0};
Point(3)={L/2,0,0};
Line(1)={1,2};
Line(2)={2,3};
// Physical boundaries
// Physical Line("Gamma", 100) = {n_type_boundaries_left,p_type_boundaries_left, n_type_boundaries_right, p_type_boundaries_right};
// Physical Line("GammaN", 101) = {n_type_boundaries_left, n_type_boundaries_right};
// Physical Line("GammaP", 102) = {p_type_boundaries_left, p_type_boundaries_right};
Physical Point("V_n", 103) = 1;
Physical Point("V_p", 104) = 3;
Physical Point("middle", 105) = 2;


// Physical surface domain
//Physical Surface("L", 200) = {n_type_materials_left, p_type_materials_left,p_type_materials_right,n_type_materials_right};// stock_disk_surf[0] : stock_disk_surf[3*n-1], lowerPsurf};
Physical Line("OmegaN", 201) = 1;
Physical Line("OmegaP", 202) = 2;
