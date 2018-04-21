L=5e-06;
Point(1)={0,0,0, 0.0001};
Point(2)={L,0,0, 0.0001};
 Line(3)={1,2};
Transfinite Line{3} = 150;
 Physical Line(4000) = {3};//domain
 Physical Point(4001) = {1};
 Physical Point(4002) = {2};
