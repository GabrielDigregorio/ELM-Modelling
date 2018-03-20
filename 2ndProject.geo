// TITLE
Include "2ndProject_GUI.pro";
SetFactory("OpenCASCADE");
 
// Parameters
l = 4;    // height of the ground
SkinDepth = 0.01; // Skin Depth for coper at 50Hz
A_Copper = 0.0035; // Total Area of the cables
d = ( (A_Copper/n) + (Pi*SkinDepth^2) ) / (2*Pi*SkinDepth);   // Radius Cables
r = d;  // Radius Cables

//Mesh and Domain Variables
L = 8;                       // Radius Domain
dens_MeshPoint_ExtDom = 1;   // Density of the mesh : External domain
dens_MeshPoint_Ground = 50;  // Density of the mesh : Ground domain
dens_MeshPoint_cable = 150;  // Density of the mesh : cable domain
dens_MeshPoint_Shield = 20;  // Density of the mesh : cable domain


//*************************************************************************************
// Geometry
Point(1) = {0, 0, 0, 1.0}; // center of the system
Point(2) = {0, L, 0, 1.0}; // upper point
Point(3) = {-Sqrt((L)^2-(l)^2), -l, 0, 1.0}; Point(4) = {Sqrt((L)^2-(l)^2), -l, 0, 1.0};// ground point skyline
Point(9) = {-0, -4, 0, 1.0};// Center at ground level
Point(10) = {Shield1_Length/2, -4, 0, 1.0}; Point(11) = {-Shield1_Length/2, -4, 0, 1.0}; // bottom point plate
Point(12) = {-Shield1_Length/2, -l+Shield1_Thickness, 0, 1.0};// left first plate height
Point(13) = {-Shield2_Length/2, -l+2*Shield2_Thickness, 0, 1.0};// left second plate height
Point(14) = {Shield1_Length/2, -l+Shield1_Thickness, 0, 1.0};// right second plate height
Point(15) = {Shield2_Length/2, -l+2*Shield2_Thickness, 0, 1.0}; // right first plate height

Line(14) = {11, 12}; Line(15) = {12, 13}; Line(16) = {13, 15};
Line(17) = {15, 14}; Line(18) = {14, 10}; Line(19) = {12, 14};

Circle(50) = {-0, -0, 0, L+0.1*L, 0, 2*Pi}; // Infinit sky domain
Circle(5) = {3, 1, 2}; Circle(6) = {4, 1, 2}; // Sky Domain
Circle(13) = {3, 1, 4}; // Bottom domain
Line(20) = {3, 11}; Line(21) = {10, 4}; // Ground
Line(22) = {11, 9}; Line(23) = {10, 9}; // bottom line shield

Line Loop(8) = {5, -6, -13}; // Sky shell domain
Line Loop(9) = {14, 19, 18, 23, 22}; // First shield plate
//Line Loop(10) = {}; // Second shield plate
Line Loop(11) = {50}; // Infinit Sky Domain


// create a bundle of n cable (circle of line) separated by a distance F around a given point
// consider we give the center , the number of cable, the spacing ,the type of configuration and the rotation of the bundle of cable
For k In {0:(nb-1):1}

    theta = k*(2*Pi/nb);
    x=Spacing*Cos(theta);
    y=Spacing*Sin(theta);
    rotation = 0; //rotation=rotations[k];


    If(switche==1)
        For p In {0:(n-1):1}
            Index_Ref = 100+(p+1)+k*nb; // reference the number asociated to the Circle
            phi = p*(2*Pi/n);
            Circle(Index_Ref) = {x+D*Cos(phi-rotation), y+D*Sin(phi-rotation), 0, r, 0, 2*Pi};
            Line Loop(Index_Ref) = {Index_Ref};
            Transfinite Line{Index_Ref} = dens_MeshPoint_cable*(Pi*r) + 1;
            Plane Surface(Index_Ref) = Index_Ref;
        EndFor
        
    Else
        If(n%2==0)
            For t In {1:n/2}
                    Index_Ref = 100+(t+1)+k*nb; // reference the number asociated to the Circle
                    CenterR=((t-1)+1/2)*D;
                    Circle(Index_Ref) = {x+CenterR*Cos(rotation), y+CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                    Line Loop(Index_Ref) = {Index_Ref};
                    Transfinite Line{Index_Ref} = dens_MeshPoint_cable*(Pi*r) + 1;
                    Circle(Index_Ref+1) = {x-CenterR*Cos(rotation), y-CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                    Line Loop(Index_Ref+1) = {Index_Ref+1};
                    Transfinite Line{Index_Ref+1} = dens_MeshPoint_cable*(Pi*r) + 1;
            EndFor
        Else

                For t In {1:(n-1)/2}
                    Index_Ref = 100+(t+1)+k*nb; // reference the number asociated to the Circle
                    CenterR=t*D;
                    Circle(Index_Ref) = {x+CenterR*Cos(rotation), y+CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                    Line Loop(Index_Ref) = {Index_Ref};
                    Transfinite Line{Index_Ref} = dens_MeshPoint_cable*(Pi*r) + 1;
                    Circle(Index_Ref+1) = {x-CenterR*Cos(rotation), y-CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                    Line Loop(Index_Ref+1) = {Index_Ref+1};
                    Transfinite Line{Index_Ref+1} = dens_MeshPoint_cable*(Pi*r) + 1;
                EndFor
                    Circle(Index_Ref+3) = {x, y, 0, r, 0, 2*Pi};
                    Line Loop(Index_Ref+3) = {Index_Ref+3};
                    Transfinite Line{Index_Ref+3} = dens_MeshPoint_cable*(Pi*r) + 1;
        EndIf
    EndIf
EndFor


// Surface creation
Plane Surface(1) = {8,9, 101 : 100+((n-1)+1)+(nb-1)*nb }; // Surface of the air
Plane Surface(2) = 9; // Surface Shield plate
Plane Surface(3) = {11,8};

// Mesh
Transfinite Line{5} = dens_MeshPoint_ExtDom*(Pi*L) + 1 Using Progression 1.01;
Transfinite Line{6} = dens_MeshPoint_ExtDom*(Pi*L) + 1 Using Progression 1.01;
Transfinite Line{13} = dens_MeshPoint_ExtDom*(Pi*L) + 1;
Transfinite Line{20,21} = dens_MeshPoint_Ground*(2*(L-Sqrt((L)^2-(l)^2))) + 1;
Transfinite Line{14, 19, 18, 23, 22} = dens_MeshPoint_Shield*l + 1;

// Physical boundaries
Physical Line("Gamma", 100) = {5, -6, 13};
Physical Line("GammaInf", 101) = 50;
Physical Line("GammaGround", 102) = {20, 21};
Physical Line("GammaWires1", 103) = {100+((1-1)+1)+(1-1)*1 : 100+((n-1)+1)+(1-1)*1};
Physical Line("GammaWires2", 104) = {100+((1-1)+1)+(2-1)*2 : 100+((n-1)+1)+(2-1)*2};
Physical Line("GammaWires3", 105) = {100+((1-1)+1)+(3-1)*3 : 100+((n-1)+1)+(3-1)*3};
Physical Line("GammaShield", 106) = {14, 19, 18, 23, 22};

// Physical surface domain
Physical Surface("Omega", 200) = 1;
Physical Surface("OmegaInf", 201) = 3;
Physical Surface("SigmaWires1", 203) = {100+((1-1)+1)+(1-1)*1 : 100+((n-1)+1)+(1-1)*1};
Physical Surface("SigmaWires2", 204) = {100+((1-1)+1)+(2-1)*2 : 100+((n-1)+1)+(2-1)*2};
Physical Surface("SigmaWires3", 205) = {100+((1-1)+1)+(3-1)*3 : 100+((n-1)+1)+(3-1)*3};
Physical Surface("SigmaShield", 206) = {9};
