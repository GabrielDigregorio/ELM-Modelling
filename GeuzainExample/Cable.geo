SetFactory("OpenCASCADE");
Disk(1) = {0, 4, 0, 0.02, 0.02};
Disk(2) = {0.1, 4, 0, 0.02, 0.02};
Disk(3) = {-0, 3.9, 0, 0.02, 0.02};
Disk(4) = {0.1, 3.9, 0, 0.02, 0.02};
Disk(5) = {0.5, 4, 0, 0.02, 0.02};
Disk(6) = {0.6, 4, 0, 0.02, 0.02};
Disk(7) = {0.5, 3.9, 0, 0.02, 0.02};
Disk(8) = {0.6, 3.9, 0, 0.02, 0.02};
Disk(9) = {1, 4, 0, 0.02, 0.02};
Disk(10) = {1.1, 4, 0, 0.02, 0.02};
Disk(11) = {1, 3.9, 0, 0.02, 0.02};
Disk(12) = {1.1, 3.9, 0, 0.02, 0.02};
Disk(13) = {0.5, 4, 0, 8, 8}; // air
Rectangle(14) = {-1.3, 2.5, 0, 4, 0.02, 0};
BooleanFragments{ Surface{13}; Delete; }{ Surface{1:12, 14}; Delete; }
p() = PointsOf{ Surface{1:12}; };
Characteristic Length{p()} = 0.02/5;
p2() = PointsOf{ Surface{14}; };
Characteristic Length{p2()} = 0.1;
Transfinite Curve{15,17} = 6;
Transfinite Surface{14};
Recombine Surface{14};

Physical Surface("Bundle 1", 1) = {1:4};
Physical Surface("Bundle 2", 2) = {5:8};
Physical Surface("Bundle 3", 3) = {9:12};
Physical Surface("Air", 15) = {15};
Physical Surface("Shield", 20) = {14};
Physical Curve("Infinity", 100) = {1};