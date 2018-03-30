


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
dens_MeshPoint_Ground = 10;  // Density of the mesh : Ground domain
dens_MeshPoint_cable = 750;  // Density of the mesh : cable domain
dens_MeshPoint_Shield = 20;  // Density of the mesh : cable domain


//*************************************************************************************
// Geometry
Point(1) = {0, 0, 0, 1.0}; // center
Point(2) = {0, L, 0, 1.0}; // upper point
Point(3) = {-Sqrt((L)^2-(l)^2), -l, 0, 1.0}; // ground point
Point(4) = {Sqrt((L)^2-(l)^2), -l, 0, 1.0}; // ground point
Circle(5) = {3, 1, 2}; // Domain
Circle(6) = {4, 1, 2}; // Domain
Line(7) = {3, 4}; // Domain

Line Loop(8) = {5, -6, -7};


// create a bundle of n cable (circle of line) separated by a distance F around a given point
// create a bundle of n cable (circle of line) separated by a distance F around a given point
Macro Bundlecable
        
    If(switche==1)
        For p In {0:(n-1):1}
            phi = p*(2*Pi/n);
            curr_point=newreg;
            Circle(curr_point) = {x+D*Cos(phi-rotation), y+D*Sin(phi-rotation), 0, r, 0, 2*Pi};
            Line Loop(curr_point) = {curr_point};
            Transfinite Line{curr_point} = dens_MeshPoint_cable*(Pi*r) + 1;

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

                    stock_circle[k*n+2*(t-1)]=curr_point1;
                    stock_circle[k*n+2*(t-1)+1]=curr_point2;

            EndFor
        Else
                curr_point=newreg;
                Circle(curr_point) = {x, y, 0, r, 0, 2*Pi};
                Line Loop(curr_point) = {curr_point};
                Transfinite Line{curr_point} = dens_MeshPoint_cable*(Pi*r) + 1;
                stock_circle[k*n]=curr_point;

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

                        stock_circle[k*n+2*(t-1)+1]=curr_point1;
                        stock_circle[k*n+2*t]=curr_point2;
                EndFor
        EndIf
    EndIf
Return

rotations[0]=rotation1; rotations[1]=rotation2; rotations[2]=rotation3;

    k=0; x=0; y=0;
    rotation =rotations[k];
    Call Bundlecable;
    For k1 In {1:(nb-1)/2:1}
        k=2*k1-1;
        x=k1*Spacing;
        y=0;
        rotation=rotations[k];
        Call Bundlecable;
        k=2*(k1);
        x=-k1*Spacing;
        y=0;
        rotation=rotations[k];
        Call Bundlecable;
    EndFor

    
Plane Surface(1)={8,stock_circle[]};

Physical Surface("Omega", 100) = 1;
Physical Line("GammaInf", 101) = {5, -6};
Physical Line("GammaGround", 102) = 7;
Physical Line("GammaWires1", 103) = {stock_circle[0]:stock_circle[n-1]};
Physical Line("GammaWires2", 104) = {stock_circle[n]:stock_circle[2*n-1]};
Physical Line("GammaWires3", 105) = {stock_circle[2*n]:stock_circle[3*n-1]};
