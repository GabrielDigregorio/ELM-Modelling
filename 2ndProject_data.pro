DefineConstant[
  n = {1, Highlight "Blue",// Numbers of Cables
    Choices{
      1="n=1",
      2="n=2",
      3="n=3",
      4="n=4",
      5="n=5",
      6="n=6"},
    Name "Input/1Geometry/0number cables in one bundle" }
];
DefineConstant[  switche = {0,Choices{0,1},
    Name "Input/1Geometry/switch for circle to line config."}
    ];


DefineConstant[
      nb = {1, Highlight "Green",// number of bundle of cables
        Choices{
          1="nb=1",
          2="nb=2",
          3="nb=3",
          4="nb=4",
          5="nb=5",
          6="nb=6"},
        Name "Input/1Geometry/0number of bundle" }
    ];


DefineConstant[
      Mu_r = {1, Highlight "Pink",// 
        Choices{
          1="mu_r=1",
          2="mu_r=10",
          3="mu_r=100",
          4="mu_r=1000",
          5="mu_r=10000",
          6="mu_r=100000"},
        Name "Input/1Physics/0Relative Permeability" }
    ];


DefineConstant[  box = {0,Choices{0,1},
        Name "Input/1Geometry/box"}
        ];

DefineConstant[  ThicknessBox = { 0.2, // distance between the center of one cables and its barycenter
        Name "Input/1Geometry/{Wall Thickness "}
        ];


DefineConstant[  guy = {0,Choices{0,1},
                Name "Input/1Geometry/guy"}
                ];


PourcentH=DefineNumber[0.1,// distance between the center of one cables and its barycenter
                            Min 0.1, Max 1, Step 1/10,
                            Name Sprintf["Input/1Geometry/{PourcentH "]];

PourcentV=DefineNumber[0.1,// distance between the center of one cables and its barycenter
                  Min 0.1, Max 1, Step 1/10,
                  Name Sprintf["Input/1Geometry/{PourcentV "]];


l=DefineNumber[10,
  Min 0, Max 100, Step 0.1,
  Name Sprintf["Input/1Box/{width"]];


L=DefineNumber[10,
  Min 0, Max 100, Step 0.1,
  Name Sprintf["Input/1Box/{heigth"]];


D=DefineNumber[0.5,// distance between the center of one cables and its barycenter
       Min 0.01, Max 4, Step 1/100,
      Name Sprintf["Input/1Geometry/{D "]];

Spacing=DefineNumber[2,// distance between the center of one cables and its barycenter
        Min 0.01, Max 4, Step 1/100,
       Name Sprintf["Input/1Geometry/{spacing "]];


For i In {1:nb}
rotations[i-1]= DefineNumber[ 0, Min 0, Max 2*Pi,Name Sprintf["Input/1Geometry/{bundles %g/Rotations", i]];
EndFor
