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
        Name "Input/1Geometry/0number of bundle" }
    ];

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
