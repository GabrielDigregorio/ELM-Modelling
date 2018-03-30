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

    //DefineConstant[  physicalmodel = {0,Choices{0,1},
//        Name "Input/1model/switch for elec(0) or mag(1)."}
//        ];

DefineConstant[
      nb = {3, Highlight "Green",// number of bundle of cables
        /*Choices{
          1="nb=1",
          2="nb=2",
          3="nb=3",
          4="nb=4",
          5="nb=5",
          6="nb=6"},*/
        Name "Input/1Geometry/0number of bundle" }
    ];


Mu_r_Shield1 = DefineNumber [100, Highlight "Pink",//
        Name Sprintf["Input/1Physics/0Relative Permeability of the shield1"]];
SigmaShield1 = DefineNumber [2e6, Highlight "Pink",//
        Name Sprintf["Input/1Physics/0Condictivity of the shield1"]];

DefineConstant[
    Current = {10000, Name "Input/1Physics/5Current"}
  ];


Shield1_Thickness = DefineNumber[0.02,
        Name Sprintf[ "Input/1Geometry/{Shield1 Thickness "]];

Shield1_Length = DefineNumber[4,
        Name Sprintf[ "Input/1Geometry/{Shield1 Length "]];


D=DefineNumber[0.5,
       Min 0.01, Max 4, Step 1/100,
      Name Sprintf["Input/1Geometry/{D "]];

M=DefineNumber[2,
        Min 0.01, Max 4, Step 1/100,
       Name Sprintf["Input/1Geometry/{spacing "]];


       rotation1=DefineNumber[Pi/6,Choices{
           0="0",
         Pi/6="Pi/6",
         Pi/4="Pi/4",
         Pi/3="Pi/3",
         Pi/2="Pi/2",
         2*Pi/3="2*Pi/3",
         3*Pi/4="3*Pi/4",
         5*Pi/6="5*Pi/6",
         Pi="Pi"},Name Sprintf["Input/1Geometry/0bundles %g/Rotation", 1]];
       rotation2=DefineNumber[2*Pi/3,Choices{
         0="0",
         Pi/6="Pi/6",
         Pi/4="Pi/4",
         Pi/3="Pi/3",
         Pi/2="Pi/2",
         2*Pi/3="2*Pi/3",
         3*Pi/4="3*Pi/4",
         5*Pi/6="5*Pi/6",
         Pi="Pi"  },Name Sprintf["Input/1Geometry/0bundles %g/Rotation", 2]];
       rotation3=DefineNumber[Pi/3,Choices{
         0="0",
         Pi/6="Pi/6",
         Pi/4="Pi/4",
         Pi/3="Pi/3",
         Pi/2="Pi/2",
         2*Pi/3="2*Pi/3",
         3*Pi/4="3*Pi/4",
         5*Pi/6="5*Pi/6",
         Pi="Pi"
       },Name Sprintf["Input/1Geometry/0bundles %g/Rotation", 3]];
