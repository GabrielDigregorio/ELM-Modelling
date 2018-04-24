Point(1)={0,0,0,0.1};
Point(2)={1,0,0,0.1};
Point(3)={2,0,0,0.1};
Point(4)={0,1,0,0.1};
Point(5)={1,1,0,0.1};
Point(6)={2,1,0,0.1};

Line(1) = {1, 2};
Transfinite Line{1} = 10;
Line(2) = {2, 3};
Transfinite Line{2} = 10;
Line(3) = {4, 5};
Transfinite Line{3} = 10;
Line(4) = {5, 6};
Transfinite Line{4} = 10;
Line(5) = {1, 4};
Transfinite Line{5} = 2;
Line(6) = {2, 5};
Transfinite Line{6} = 2;
Line(7) = {3, 6};
Transfinite Line{7} = 2;




Curve Loop(1) = {5, 3, -6, -1};
Plane Surface(1) = {1};
Transfinite Surface{1};
Recombine Surface{1};
Curve Loop(2) = {6, 4, -7, -2};
Plane Surface(2) = {2};
Transfinite Surface{2};
Recombine Surface{2};

Physical Surface("P_region", 100) = 1;
Physical Surface("N_region", 101) = 2;

Physical Line("V_minus", 102) = 5;
Physical Line("V_plus", 103) = 7;
Physical Line("middle", 104) = 6;

/*Physical Line("GammaGround", 102) = 7;
Physical Line("GammaWires1", 103) = {stock_circle[0]:stock_circle[n-1]};
Physical Line("GammaWires2", 104) = {stock_circle[n]:stock_circle[2*n-1]};
Physical Line("GammaWires3", 105) = {stock_circle[2*n]:stock_circle[3*n-1]};*/
