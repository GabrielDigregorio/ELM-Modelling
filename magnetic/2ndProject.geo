// TITLE
Include "2ndProject_GUI.pro";
SetFactory("OpenCASCADE");

// Parameters
l = 4;    // height of the ground
SkinDepth = 0.01; // Skin Depth for coper at 50Hz
A_Copper = 0.0035; // Total Area of the cables
d = ( (A_Copper/n) + (Pi*SkinDepth^2) ) / (2*Pi*SkinDepth);   // Radius Cables
r = d;  // Radius Cables
Spacing=M;
//Mesh and Domain Variables
L = 20;                       // Radius Domain
dens_MeshPoint_ExtDom = 1;   // Density of the mesh : External domain
<<<<<<< HEAD
dens_MeshPoint_Ground = 10;  // Density of the mesh : Ground domain
dens_MeshPoint_cable = 750;  // Density of the mesh : cable domain
dens_MeshPoint_Shield = 20;  // Density of the mesh : cable domain

=======
dens_MeshPoint_Ground = 25;  // Density of the mesh : Ground domain
dens_MeshPoint_cable = 300;  // Density of the mesh : cable domain
dens_MeshPoint_Shield = 100;  // Density of the mesh : cable domain
dens_MeshPoint_Shield_height = 1000;
>>>>>>> c47e1a7d3edbab9d0570e85fb567b296bc31d8d9

//*************************************************************************************
// Geometry
Point(1) = {0, 0, 0, 1.0}; // center of the system
Point(2) = {0, L, 0, 1.0}; // upper point
Point(3) = {-Sqrt((L)^2-(l)^2), -l, 0, 1.0}; Point(5) = {Sqrt((L)^2-(l)^2), -l, 0, 1.0};// ground point skyline
Point(6) = {-0, -4, 0, 1.0}; // Center at ground level
Point(7) = {Shield1_Length/2, -4, 0, 1.0}; Point(8) = {-Shield1_Length/2, -4, 0, 1.0}; // bottom point plate
Point(9) = {-Shield1_Length/2, -l+Shield1_Thickness, 0, 1.0}; // left first plate height
//Point(10) = {-Shield2_Length/2, -l+2*Shield2_Thickness, 0, 1.0}; // left second plate height
Point(11) = {Shield1_Length/2, -l+Shield1_Thickness, 0, 1.0}; // right first plate height
//Point(12) = {Shield2_Length/2, -l+2*Shield2_Thickness, 0, 1.0}; // right second plate height


leftG=1;// left ground line
rightG=2;// right ground line
lowerPl=3; // lower plate line
leftLP=4; // left lower plate line
rightLP=6; // right lower plate line
Line(leftG) = {3, 8};
Line(lowerPl)={8,7};
Line(rightG) = {7, 5}; Line(leftLP) = {8, 9}; Line(rightLP) = {7, 11};

middleP=8; // middel plate line

Line(middleP) = {9, 11};// Line(upperPl) = {10, 12};


outercircle=11;// Infinit sky domain
Circle(outercircle) = {-0, -0, 0, L+0.1*L, 0, 2*Pi};
leftinnercircle=12; // left arc circle of the inner domain
rightinnercircle=13;// right arc circle of the inner domain
Circle(leftinnercircle) = {3, 1, 2}; Circle(rightinnercircle) = {2, 1, 5};
lowercircle=14; // Bottom arc cirlce of the inner domain
Circle(lowercircle) = {5, 1, 3};

lowerD=newreg; // lower domain line loop
Line Loop(lowerD) = {1, 3,2,14}; // lower shell domain
upperD=newreg; // upper domain line loop
Line Loop(upperD) = {12,13, -2, 6, -8,-4, -1}; // upper shell domain 1,4,6,8,13,12
lowerP=newreg; // lower plate line loop
Line Loop(lowerP) = { 4, 8, -6, 3}; //lower shield plate

outershell=newreg; // Infinit sky domain line loop
Line Loop(outershell) = {11};  // Infinit Sky Domain
innershell=newreg;// inner domain line loop
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

rotations[0]=rotation1;
rotations[1]=rotation2;
rotations[2]=rotation3;
/*theta = k*(2*Pi/nb);
x=Spacing*Cos(theta);
y=Spacing*Sin(theta);*/
    k=0; x=0; y=0;
    //rotation =0;//
    rotation = rotations[k];
    Call Bundlecable;
    For k1 In {1:(nb-1)/2:1}
        k=2*k1-1;
        x=k1*Spacing;
        y=0;
        //rotation = 0; //
        rotation=rotations[k];
        Call Bundlecable;
        k=2*(k1);
        x=-k1*Spacing;
        y=0;
        //rotation = 0; //
        rotation=rotations[k];
        Call Bundlecable;

    EndFor



// Surface creation
upperDsurf=newreg;
Plane Surface(upperDsurf) = {upperD,stock_circle[]}; // Surface upper  of the air domain
lowerDsurf=newreg;
Plane Surface(lowerDsurf) = {lowerD}; // Surface upper  of the air domain
lowerPsurf=newreg;
Plane Surface(lowerPsurf) = {lowerP}; // Surface lower Shield plate
outershellsurf=newreg;
Plane Surface(outershellsurf) = {outershell,innershell}; // Surface of the infinit domain

// Mesh
Transfinite Line{leftinnercircle,rightinnercircle} = dens_MeshPoint_ExtDom*(Pi*L);
Transfinite Line{outercircle} = dens_MeshPoint_ExtDom*(Pi*L) + 1 Using Progression 1.01;
Transfinite Line{lowercircle} = dens_MeshPoint_ExtDom*(Pi*L) + 1;
Transfinite Line{-leftG, rightG} =  dens_MeshPoint_Shield*l/3 + 1 Using Progression 1.07 ;//dens_MeshPoint_Shield*l/10 + 1;
Transfinite Line{lowerPl,middleP} = dens_MeshPoint_Shield*l/3 + 1 ;
Transfinite Line{leftLP, rightLP} = dens_MeshPoint_Shield_height*Shield1_Thickness + 1 ;//dens_MeshPoint_Shield*l/10 + 1;



// regulare rectangulare mesh for the 2 plates
Transfinite Surface{lowerPsurf};
//Transfinite Surface{upperPsurf};
Recombine Surface{lowerPsurf};
//Recombine Surface{upperPsurf};

// Physical boundaries
Physical Line("Gamma", 100) = {leftinnercircle, rightinnercircle,lowercircle};
Physical Line("GammaInf", 101) = outercircle;
Physical Line("GammaGround", 102) = {leftG, rightG, lowerPl};
Physical Line("GammaWires1", 103) = {stock_circle[0] : stock_circle[n-1]};
Physical Line("GammaWires2", 104) = {stock_circle[n] : stock_circle[2*n-1]};
Physical Line("GammaWires3", 105) = {stock_circle[2*n] : stock_circle[3*n-1]};
Physical Line("GammaShield1", 106) = {-lowerPl, leftLP, middleP, -rightLP};

// Physical surface domain
//  /!\ air domain, with the upper shield being air /!\

Physical Surface("Omega", 200) = {upperDsurf,lowerDsurf};// stock_disk_surf[0] : stock_disk_surf[3*n-1], lowerPsurf};
Physical Surface("OmegaInf", 201) = outershellsurf;
Physical Surface("SigmaWires1", 203) = {stock_disk_surf[0] : stock_disk_surf[n-1]};
Physical Surface("SigmaWires2", 204) = {stock_disk_surf[n] : stock_disk_surf[2*n-1]};
Physical Surface("SigmaWires3", 205) = {stock_disk_surf[2*n]  : stock_disk_surf[3*n-1]};
Physical Surface("SigmaShield1", 206) = lowerPsurf;
