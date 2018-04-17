Include "2ndProject_data.pro";
//we can directly include the .pro file
SetFactory("OpenCASCADE");

SkinDepth = 0.01; // Skin Depth for coper at 50Hz
A_Copper = 0.0035; // Total Area of the cables pi*(60*10^(-3))^2-pi*((60-10)*10^(-3))^2
r = 0.1;//( (A_Copper/n) + (Pi*SkinDepth^2) ) / (2*Pi*SkinDepth);   // Radius Cables

dens_MeshPoint_ExtDom = 0.5;  // Density of the mesh : External domain
dens_MeshPoint_Ground = 50;  // Density of the mesh : Ground domain
dens_MeshPoint_cable = 15;   // Density of the mesh : cable domain




Point(1)={-l/2, -L/2, 0, 1.0};
Point(2)={l/2, -L/2, 0, 1.0};
Point(3)={l/2, L/2, 0, 1.0};
Point(4)={-l/2, L/2, 0, 1.0};
//e=2;//
Point(5)={-l/2-e, -L/2-e, 0, 1.0};
Point(6)={l/2+e, -L/2-e, 0, 1.0};
Point(7)={l/2+e, L/2+e, 0, 1.0};
Point(8)={-l/2-e, L/2+e, 0, 1.0};
Line(1) = {5, 6}; // Domain
Line(2) = {6, 7};
Line(3) = {7, 8};
Line(4) = {8, 5};
outerlineloop=1;
Line Loop(outerlineloop)={1,2,3,4};

If(box==0)
firstline=newreg;
Line(firstline) = {1, 2}; // Domain
Line(newreg) = {2, 3};
Line(newreg) = {3, 4};
Line(newreg) = {4, 1};
last_line=newreg-1;
innerlineloop=newreg;
firstlineloop=innerlineloop;
Line Loop(innerlineloop) = {firstline:last_line};
EndIf

If(box==1)
//e1=0.5;
Hpoint=newp;
Point(Hpoint)={(1-PourcentH)*l/2, -L/2, 0, 1.0};
Point(newp)={(1-PourcentH)*l/2-e1, -L/2, 0, 1.0};
Vpoint=newp;
Point(Vpoint)={l/2, -(1-PourcentV)*L/2, 0, 1.0};
Point(newp)={l/2, -(1-PourcentV)*L/2+e1, 0, 1.0};
middlPoint=newp;
Point(middlPoint)={(1-PourcentH)*l/2, -(1-PourcentV)*L/2, 0, 1.0};
Point(newp)={(1-PourcentH)*l/2-e1, -(1-PourcentV)*L/2+e1, 0, 1.0};


firstline=newreg;
Line(firstline) = {1, Hpoint+1}; // Domain
Line(newreg) = { Hpoint+1, Hpoint};
Line(newreg) = { Hpoint, 2};
//Line(newreg) = {2,Vpoint+1};
Line(newreg) = {2,Vpoint};
break2=newreg;
Line(break2) = {Vpoint,Vpoint+1};
Line(newreg) = {Vpoint+1,3};
Line(newreg) = {3, 4};
Line(newreg) = {4, 1};
break1=newreg;
Line(break1) = {Hpoint+1, middlPoint+1};
Line(newreg) = {middlPoint+1, Vpoint+1};
break3=newreg;
Line(break3) = {Hpoint, middlPoint};
Line(newreg) = {middlPoint, Vpoint};


firstlineloop=newreg;
Line Loop(firstlineloop) = {firstline,break1,break1+1,break2+1,break2+2,break2+3};
secondlineloop=newreg;
Line Loop(secondlineloop) = {firstline+2,firstline+3,-(break3+1),-break3};
Plane Surface(newreg)={secondlineloop};
thirdlineloop=newreg;
Line Loop(thirdlineloop) = {firstline+1,break3,break3+1,break2,-(break1+1),-break1};
Plane Surface(newreg)={thirdlineloop};

innerlineloop=newreg;
Line Loop(innerlineloop) = {firstline,firstline+1,firstline+2,firstline+3,break2,break2+1,break2+2,break2+3};

EndIf


//Plane Surface(1) = {8};

// a macro work as a fucntion in a way
Macro Bundlecable// create a bundle of n cable (circle of line) separated by a distance F around a given point
        // consider we give the center , the number of cable, the spacing ,the type of configuration and the rotation of the bundle of cable
    If(switche==1)
        For p In {0:(n-1):1}
            phi = p*(2*Pi/n);
            curr_point=newreg;
            Circle(curr_point) = {x+D*Cos(phi-rotation), y+D*Sin(phi-rotation), 0, r, 0, 2*Pi};
            Line Loop(curr_point) = {curr_point};
            Transfinite Line{curr_point} = dens_MeshPoint_cable*(Pi*r) + 1;
            //indi_stock[p]=curr_point;
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
                //Printf("point '%g''%g' ",k*n+2*(t-1)+1,k*n+2*t);
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
                        //Printf("point '%g''%g' ",k*n+2*(t-1)+1,k*n+2*t);
                EndFor
        EndIf
    EndIf
Return


For k In {0:(nb-1):1}
    theta = k*(2*Pi/nb);
    x=Spacing*Cos(theta);
    y=Spacing*Sin(theta);
    rotation=rotations[k];
    // need to give all the parameter
    Call Bundlecable;

EndFor



Plane Surface(1)={firstlineloop,stock_circle[]};//,stock_circle[1],stock_circle[2]};
Plane Surface(newreg)={outerlineloop,innerlineloop};

// voir t10.geo dans tutorial pour faire des trucs sympa
/*lc = 0.01;
Field[1] = Threshold;
Field[1].IField = 1;
Field[1].LcMin = lc / 30;
Field[1].LcMax = lc;
Field[1].DistMin = 0.15;
Field[1].DistMax = 0.5;


Field[2] = Box;
Field[2].VIn = lc / 15;
Field[2].VOut = lc;
Field[2].XMin = 0;
Field[2].XMax = 3;
Field[2].YMin = 0;
Field[2].YMax = 3;*/


//Printf("point '%g''%g''%g' ",stock_circle[]);

// fun guy
If(guy==1)
    head=newp;
    Point(head)={(1-PourcentH/2)*l/2, -(1-PourcentV/2)*L/2, 0, 1.0};// head
    butt=newp;
    Point(butt)={(1-PourcentH/2)*l/2, -(1-PourcentV/6)*L/2, 0, 1.0};// butt
    Line(newreg)={head,butt};
    neck=newp;
    Point(neck)={(1-PourcentH/2)*l/2, -(1-PourcentV/2.5)*L/2, 0, 1.0};// neck
    foot=newp;
    Point(foot)={(1-PourcentH/2.5)*l/2, -(1-PourcentV/8)*L/2, 0, 1.0};// right foot
    Point(newp)={(1-PourcentH/1.7)*l/2, -(1-PourcentV/8)*L/2, 0, 1.0};// left foot
    Line(newreg)={butt,foot};
    Line(newreg)={butt,foot+1};
    hand=newp;
    Point(hand)={(1-PourcentH/1.7)*l/2, -(1-PourcentV/2.5)*L/2, 0, 1.0};// left hand
    Point(newp)={(1-PourcentH/2.5)*l/2, -(1-PourcentV/2.5)*L/2, 0, 1.0};// right hand
    Line(newreg)={neck,hand};
    Line(newreg)={neck,hand+1};
    radius=(-(1-PourcentV/2)*L/2+(1-PourcentV/2.5)*L/2)/2;
    Circle(newreg) = {(1-PourcentH/2)*l/2, -(1-PourcentV/2)*L/2, 0, radius, 0, 2*Pi};
EndIf
