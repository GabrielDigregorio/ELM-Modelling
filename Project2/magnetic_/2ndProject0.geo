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
dens_MeshPoint_Ground = 10;  // Density of the mesh : Ground domain
dens_MeshPoint_cable = 15;  // Density of the mesh : cable domain
dens_MeshPoint_Shield = 20;  // Density of the mesh : cable domain


//*************************************************************************************
// Geometry
Point(1) = {0, 0, 0, 1.0}; // center of the system
Point(2) = {0, L, 0, 1.0}; // upper point
Point(3) = {-Sqrt((L)^2-(l)^2), -l, 0, 1.0}; Point(5) = {Sqrt((L)^2-(l)^2), -l, 0, 1.0};// ground point skyline
Point(6) = {-0, -4, 0, 1.0}; // Center at ground level
Point(7) = {Shield1_Length/2, -4, 0, 1.0}; Point(8) = {-Shield1_Length/2, -4, 0, 1.0}; // bottom point plate
Point(9) = {-Shield1_Length/2, -l+Shield1_Thickness, 0, 1.0}; // left first plate height
Point(10) = {-Shield2_Length/2, -l+2*Shield2_Thickness, 0, 1.0}; // left second plate height
Point(11) = {Shield1_Length/2, -l+Shield1_Thickness, 0, 1.0}; // right first plate height
Point(12) = {Shield2_Length/2, -l+2*Shield2_Thickness, 0, 1.0}; // right second plate height

Point(13)={-Shield2_Length/2+Shield2_Thickness, -l+2*Shield2_Thickness, 0, 1.0};
Point(14)={Shield2_Length/2-Shield2_Thickness, -l+2*Shield2_Thickness, 0, 1.0};
Point(15)={-Shield1_Length/2+Shield2_Thickness, -4, 0, 1.0};
Point(16)={Shield1_Length/2-Shield2_Thickness, -4, 0, 1.0};
Point(17) = {-Shield1_Length/2+Shield2_Thickness, -l+Shield1_Thickness, 0, 1.0};
Point(18) = {Shield1_Length/2-Shield2_Thickness, -l+Shield1_Thickness, 0, 1.0};


leftG=1;// left ground
rightG=2;// right ground
//lowerLP=3;
//lowerRP=5;
lowerPl=3;
leftLP=4;
rightLP=6;
Line(leftG) = {3, 15}; //Line(lowerLP) = {8, 6}; Line(lowerRP) = {6,7};
Line(lowerPl)={15,16};
Line(rightG) = {16, 5}; //Line(leftLP) = {8, 9}; Line(rightLP) = {7, 11};
leftUP=7;
rightUP=9;
middleP=8;
upperPl=10;
//Line(leftUP) = {9, 10}; Line(rightUP) = {11, 12}; // Ground
Line(middleP) = {9, 11}; Line(upperPl) = {13, 14}; // bottom line shield


outercircle=11;
Circle(outercircle) = {-0, -0, 0, L+0.1*L, 0, 2*Pi}; // Infinit sky domain
leftinnercircle=12;
rightinnercircle=13;
Circle(leftinnercircle) = {3, 1, 2}; Circle(rightinnercircle) = {2, 1, 5}; // Sky Domain
lowercircle=14;
Circle(lowercircle) = {5, 1, 3}; // Bottom domain

Circle(newreg) = {9, 17, 13};
Circle(newreg) = {15, 17, 9};
Circle(newreg) = {14, 18, 11};
Circle(newreg) = {11, 18, 16};

lowerD=newreg;
Line Loop(lowerD) = {1, 3,2,14}; // lower shell domain
upperD=newreg;
Line Loop(newreg) = {12,13, -2, -18, -17,-10,-15,-16, -1}; // upper shell domain
lowerP=newreg;
Line Loop(lowerP) = { 16, 8, 18, 3}; //lower shield plate
upperP=newreg;
Line Loop(upperP) = {-8, 15, 10, 17}; //upper shield plate
outershell=newreg;
Line Loop(outershell) = {11};  // Infinit Sky Domain
innershell=newreg;
Line Loop(innershell)={12,13,-14};
// create a bundle of n cable (circle or line) separated by a distance F around a given point
// consider we give the center , the number of cable, the spacing ,the type of configuration and the rotation of the bundle of cable
Macro Bundlecable// create a bundle of n cable (circle of line) separated by a distance F around a given point
        // consider we give the center , the number of cable, the spacing ,the type of configuration and the rotation of the bundle of cable
    If(switche==1)
        For p In {0:(n-1):1}
            phi = p*(2*Pi/n);
            curr_point=newreg;
            Circle(curr_point) = {x+D*Cos(phi-rotation), y+D*Sin(phi-rotation), 0, r, 0, 2*Pi};
            Line Loop(curr_point) = {curr_point};
            Transfinite Line{curr_point} = dens_MeshPoint_cable*(Pi*r) + 1;
            curr_surf=newreg;
            Plane Surface(curr_surf)={curr_point};
            stock_disk_surf[k*n+p]=curr_surf;
            stock_circle[k*n+p]=curr_point;
        EndFor
    Else
        If(n%2==0)
            For t In {1:n/2}
                    CenterR=((t-1)+1/2)*D;
                    curr_point1=newreg;
                    Circle(curr_point1) = {x+CenterR*Cos(rotation), y+CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                    Line Loop(curr_point1) = {curr_point1};
                    Transfinite Line{curr_point1} = dens_MeshPoint_cable*(Pi*r) + 1;
                    curr_point2=newreg;
                    Circle(curr_point2) = {x-CenterR*Cos(rotation), y-CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                    Line Loop(curr_point2) = {curr_point2};
                    Transfinite Line{curr_point2} = dens_MeshPoint_cable*(Pi*r) + 1;

                    curr_surf1=newreg;
                    Plane Surface(curr_surf1)={curr_point1};
                    stock_disk_surf[k*n+2*(t-1)]=curr_surf1;
                    curr_surf2=newreg;
                    Plane Surface(curr_surf2)={curr_point2};
                    stock_disk_surf[k*n+2*(t-1)+1]=curr_surf2;

                    stock_circle[k*n+2*(t-1)]=curr_point1;
                    stock_circle[k*n+2*(t-1)+1]=curr_point2;

            EndFor
        Else
                curr_point=newreg;
                Circle(curr_point) = {x, y, 0, r, 0, 2*Pi};
                Line Loop(curr_point) = {curr_point};
                Transfinite Line{curr_point} = dens_MeshPoint_cable*(Pi*r) + 1;
                //Printf("point '%g' ",k*n);
                stock_circle[k*n]=curr_point;
                curr_surf=newreg;
                Plane Surface(curr_surf)={curr_point};

                stock_disk_surf[k*n]=curr_surf;
                For t In {1:(n-1)/2}
                        CenterR=t*D;

                        curr_point1=newreg;
                        Circle(curr_point1) = {x+CenterR*Cos(rotation), y+CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                        Line Loop(curr_point1) = {curr_point1};
                        Transfinite Line{curr_point1} = dens_MeshPoint_cable*(Pi*r) + 1;
                        curr_point2=newreg;
                        Circle(curr_point2) = {x-CenterR*Cos(rotation), y-CenterR*Sin(rotation), 0, r, 0, 2*Pi};
                        Line Loop(curr_point2) = {curr_point2};
                        Transfinite Line{curr_point2} = dens_MeshPoint_cable*(Pi*r) + 1;

                        curr_surf1=newreg;
                        Plane Surface(curr_surf1)={curr_point1};
                        stock_disk_surf[k*n+2*(t-1)+1]=curr_surf1;
                        curr_surf2=newreg;
                        Plane Surface(curr_surf2)={curr_point2};
                        stock_disk_surf[k*n+2*t]=curr_surf2;

                        stock_circle[k*n+2*(t-1)+1]=curr_point1;
                        stock_circle[k*n+2*t]=curr_point2;
                EndFor
        EndIf
    EndIf
Return


/*theta = k*(2*Pi/nb);
x=Spacing*Cos(theta);
y=Spacing*Sin(theta);*/
If(nb%2==0)
    For k1 In {0:(nb/2)-1:1}
        k=2*k1;
        x=((k1)+1/2)*Spacing;
        y=0;
        rotation = 0; //rotation=rotations[k];
        Call Bundlecable;
        k=2*k1+1;
        x=-((k1)+1/2)*Spacing;
        y=0;
        rotation = 0; //rotation=rotations[k];
        Call Bundlecable;

    EndFor
Else
    k=0;
    x=0;
    y=0;
    rotation = 0;
    Call Bundlecable;
    For k1 In {1:(nb-1)/2:1}
        k=2*k1-1;
        x=k1*Spacing;
        y=0;
        rotation = 0; //rotation=rotations[k];
        Call Bundlecable;
        k=2*(k1);
        x=-k1*Spacing;
        y=0;
        rotation = 0; //rotation=rotations[k];
        Call Bundlecable;

    EndFor


EndIf

// Surface creation
upperDsurf=newreg;
Plane Surface(upperDsurf) = {upperD,stock_circle[]}; // Surface upper  of the air domain
lowerDsurf=newreg;
Plane Surface(lowerDsurf) = {lowerD}; // Surface upper  of the air domain
lowerPsurf=newreg;
Plane Surface(lowerPsurf) = {lowerP}; // Surface lower Shield plate
upperPsurf=newreg;
Plane Surface(upperPsurf) = {upperP}; // Surface upper Shield plate
outershellsurf=newreg;
Plane Surface(outershellsurf) = {outershell,innershell}; // Surface of the infinit domain

// Mesh
Transfinite Line{leftinnercircle,rightinnercircle} = dens_MeshPoint_ExtDom*(Pi*L) + 1 Using Progression 1.01;
Transfinite Line{outercircle} = dens_MeshPoint_ExtDom*(Pi*L) + 1 Using Progression 1.01;
Transfinite Line{lowercircle} = dens_MeshPoint_ExtDom*(Pi*L) + 1;
Transfinite Line{leftG,-rightG} = dens_MeshPoint_Ground*(2*(L-Sqrt((L)^2-(l)^2)))*20 + 1.1;
Transfinite Line{lowerPl} = dens_MeshPoint_Shield*l + 1;
Transfinite Line{16, 18} = dens_MeshPoint_Shield*l/2 + 1;
Transfinite Line{15, 17} = dens_MeshPoint_Shield*l/2 + 1;
Transfinite Line{middleP} = dens_MeshPoint_Shield*l + 1;
Transfinite Line{upperPl} = dens_MeshPoint_Shield*l + 1;

Transfinite Surface{lowerPsurf};
Transfinite Surface{upperPsurf};
Recombine Surface{lowerPsurf};
Recombine Surface{upperPsurf};
// Physical boundaries
Physical Line("Gamma", 100) = {12, 13};
Physical Line("GammaInf", 101) = 11;
Physical Line("GammaGround", 102) = {1, 2};// on doit ajouter le dessous de la plaque ?
//Physical Line("GammaWires1", 103) = {100+((1-1)+1)+(1-1)*n : 100+((n-1)+1)+(1-1)*n};
//Physical Line("GammaWires2", 104) = {100+((1-1)+1)+(2-1)*n : 100+((n-1)+1)+(2-1)*n};
//Physical Line("GammaWires3", 105) = {100+((1-1)+1)+(3-1)*n : 100+((n-1)+1)+(3-1)*n};
//Physical Line("GammaShield", 106) = {14, 19, 18, 23, 22};

// Physical surface domain
/*Physical Surface("Omega", 200) = 1;
Physical Surface("OmegaInf", 201) = 3;
Physical Surface("SigmaWires1", 203) = {100+((1-1)+1)+(1-1)*n : 100+((n-1)+1)+(1-1)*n};
Physical Surface("SigmaWires2", 204) = {100+((1-1)+1)+(2-1)*n : 100+((n-1)+1)+(2-1)*n};
Physical Surface("SigmaWires3", 205) = {100+((1-1)+1)+(3-1)*n : 100+((n-1)+1)+(3-1)*n};
Physical Surface("SigmaShield", 206) = 2;*/
