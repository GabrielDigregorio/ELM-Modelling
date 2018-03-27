DefineConstant[
  n = {3, Highlight "Blue",// Numbers of Cables
    Choices{
      1="n=1",
      2="n=2",
      3="n=3",
      4="n=4",
      5="n=5",
      6="n=6"},
    Name "Input/1Geometry/0number cables in one bundle" }
];
DefineConstant[  switche = {1,Choices{0,1},
    Name "Input/1Geometry/switch for circle to line config."}
    ];


DefineConstant[
      nb = {3, Highlight "Green",// number of bundle of cables
        Choices{
          1="nb=1",
          2="nb=2",
          3="nb=3",
          4="nb=4",
          5="nb=5",
          6="nb=6"},
        Name "Input/1Geometry/0number of bundle" }
    ];


Mu_r_Shield1 = DefineNumber [100, Highlight "Pink",// 
        Name Sprintf["Input/1Physics/0Relative Permeability of the shield1"]];
SigmaShield1 = DefineNumber [2e6, Highlight "Pink",// 
        Name Sprintf["Input/1Physics/0Condictivity of the shield1"]];
Mu_r_Shield2 = DefineNumber [100, Highlight "Pink",// 
        Name Sprintf["Input/1Physics/0Relative Permeability of the shield2"]];
SigmaShield2 = DefineNumber [2e6, Highlight "Pink",// 
        Name Sprintf["Input/1Physics/0Condictivity of the shield2"]];


Shield1_Thickness = DefineNumber[0.02, 
        Name Sprintf[ "Input/1Geometry/{Shield1 Thickness "]];

Shield1_Length = DefineNumber[4, 
        Name Sprintf[ "Input/1Geometry/{Shield1 Length "]];

Shield2_Thickness = DefineNumber[0.02, 
        Name Sprintf[ "Input/1Geometry/{Shield2 Thickness "]];

Shield2_Length = DefineNumber[4, 
        Name Sprintf[ "Input/1Geometry/{Shield2 Length "]];

D=DefineNumber[0.5,
       Min 0.01, Max 4, Step 1/100,
      Name Sprintf["Input/1Geometry/{D "]];

Spacing=DefineNumber[2,
        Min 0.01, Max 4, Step 1/100,
       Name Sprintf["Input/1Geometry/{spacing "]];


/*For i In {1:nb}
  rotations[i-1]= DefineNumber[ 0, Min 0, Max 2*Pi,Name Sprintf["Input/1Geometry/{bundles %g/Rotations", i]];
EndFor*/
