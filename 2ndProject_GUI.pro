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


Shield_Thickness = DefineNumber[0.02, 
        Name Sprintf[ "Input/1Geometry/{Shield Thickness "]];



Shield_Length = DefineNumber[2, 
        Name Sprintf[ "Input/1Geometry/{Shield Length "]];



D=DefineNumber[0.5,
       Min 0.01, Max 4, Step 1/100,
      Name Sprintf["Input/1Geometry/{D "]];

Spacing=DefineNumber[2,
        Min 0.01, Max 4, Step 1/100,
       Name Sprintf["Input/1Geometry/{spacing "]];


For i In {1:nb}
rotations[i-1]= DefineNumber[ 0, Min 0, Max 2*Pi,Name Sprintf["Input/1Geometry/{bundles %g/Rotations", i]];
EndFor
