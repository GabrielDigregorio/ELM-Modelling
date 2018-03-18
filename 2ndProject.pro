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
      D = { 0.5,// distance between the center of one cables and its barycenter
        Min 0.01, Max 4, Step 1/100,
        Name Sprintf 
        ["Input/1Geometry/{D= "]}
    ];

DefineConstant[
      Spacing = { 2,// distance between the center of one cables and its barycenter
      Min 0.01, Max 4, Step 1/100,
      Name Sprintf["Input/1Geometry/{spacing= "]}
    ];
// parameter of the box
//l=10;
//L=10;



/*For i In {1:nb}
rotation[i-1]=0;
  DefineConstant[
    rotations = {0,
      Min 0, Max Pi, Step 1e-2,
      Name Sprintf["Input/1Geometry/{bundles %g/Rotations", i]}
  ];
  //rotations[i-1]=rotationss;
EndFor*/

DefineConstant[
  rotations = {0,
    Min 0, Max Pi, Step 1e-2,
    Name Sprintf["Input/1Geometry/{rotation"]}
];


DefineConstant[
  l = {10,
    Min 0, Max 100, Step 0.1,
    Name Sprintf["Input/1Box/{heigth"]}
];
DefineConstant[
  L = {10,
    Min 0, Max 100, Step 0.1,
    Name Sprintf["Input/1Box/{width"]}
];


Group {
  // Physical regions:
  Air    = Region[ 101 ];   Core   = Region[ 102 ];
  Ind    = Region[ 103 ];   AirInf = Region[ 111 ];

  Surface_ht0 = Region[ 1100 ];
  Surface_bn0 = Region[ 1101 ];
  Surface_Inf = Region[ 1102 ];

  Vol_Mag     = Region[ {Air, AirInf, Core, Ind} ];
  Vol_S_Mag   = Region[ Ind ];
  Vol_Inf_Mag = Region[ AirInf ];
  Sur_Dir_Mag = Region[ {Surface_bn0, Surface_Inf} ];
  Sur_Neu_Mag = Region[ {} ]; // empty
}

Function {
  mu0 = 4.e-7 * Pi;

  murCore = DefineNumber[100, Name "Model parameters/Mur core",
			 Help "Magnetic relative permeability of Core"];

  nu [ Region[{Air, Ind, AirInf}] ]  = 1. / mu0;
  nu [ Core ]  = 1. / (murCore * mu0);


  Current = DefineNumber[0.01, Name "Model parameters/Current",
			 Help "Current injected in coil [A]"];

  NbTurns = 1000 ; // number of turns in the coil
  js_fct[ Ind ] = -NbTurns*Current/SurfaceArea[];
  /* The minus sign is to have the current in -e_z direction,
     so that the magnetic induction field is in +e_y direction */
}


Constraint {
  { Name Dirichlet_a_Mag;
    Case {
      { Region Sur_Dir_Mag ; Value 0.; }
    }
  }
  { Name SourceCurrentDensityZ;
    Case {
      { Region Vol_S_Mag ; Value js_fct[]; }
    }
  }
}

Group {
  Dom_Hcurl_a_Mag_2D = Region[ {Vol_Mag, Sur_Neu_Mag} ];
}

FunctionSpace {
  { Name Hcurl_a_Mag_2D; Type Form1P; // Magnetic vector potential a
    BasisFunction {
      { Name se; NameOfCoef ae; Function BF_PerpendicularEdge;
        Support Dom_Hcurl_a_Mag_2D ; Entity NodesOf[ All ]; }
    }
    Constraint {
      { NameOfCoef ae; EntityType NodesOf;
        NameOfConstraint Dirichlet_a_Mag; }
    }
  }

  { Name Hregion_j_Mag_2D; Type Vector; // Electric current density js
    BasisFunction {
      { Name sr; NameOfCoef jsr; Function BF_RegionZ;
        Support Vol_S_Mag; Entity Vol_S_Mag; }
    }
    Constraint {
      { NameOfCoef jsr; EntityType Region;
        NameOfConstraint SourceCurrentDensityZ; }
    }
  }

}

Include "electromagnet_common.pro";
Val_Rint = rInt; Val_Rext = rExt;

Jacobian {
  { Name Vol ;
    Case { { Region Vol_Inf_Mag ;
             Jacobian VolSphShell {Val_Rint, Val_Rext} ; }
           { Region All ; Jacobian Vol ; }
    }
  }
}

Integration {
  { Name Int ;
    Case { { Type Gauss ;
             Case { { GeoElement Triangle    ; NumberOfPoints  4 ; }
                    { GeoElement Quadrangle  ; NumberOfPoints  4 ; }
	}
      }
    }
  }
}

Formulation {
  { Name Magnetostatics_a_2D; Type FemEquation;
    Quantity {
      { Name a ; Type Local; NameOfSpace Hcurl_a_Mag_2D; }
      { Name js; Type Local; NameOfSpace Hregion_j_Mag_2D; }
    }
    Equation {
      // all terms on the left-hand side (hence the "-" sign in front of
      // Dof{js}):
      Integral { [ nu[] * Dof{d a} , {d a} ];
        In Vol_Mag; Jacobian Vol; Integration Int; }
      Integral { [ -Dof{js} , {a} ];
        In Vol_S_Mag; Jacobian Vol; Integration Int; }
    }
  }
}

Resolution {
  { Name MagSta_a;
    System {
      { Name Sys_Mag; NameOfFormulation Magnetostatics_a_2D; }
    }
    Operation {
      Generate[Sys_Mag]; Solve[Sys_Mag]; SaveSolution[Sys_Mag];
    }
  }
}

PostProcessing {
  { Name MagSta_a_2D; NameOfFormulation Magnetostatics_a_2D;
    Quantity {
      { Name a;
        Value {
          Term { [ {a} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name az;
        Value {
          Term { [ CompZ[{a}] ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name b;
        Value {
          Term { [ {d a} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name h;
        Value {
          Term { [ nu[] * {d a} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name js;
        Value {
          Term { [ {js} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
    }
  }
}


PostOperation {

  { Name Map_a; NameOfPostProcessing MagSta_a_2D;
    Operation {
      Echo[ Str["l=PostProcessing.NbViews-1;",
		"View[l].IntervalsType = 1;",
		"View[l].NbIso = 40;"],
	    File "tmp.geo", LastTimeStepOnly] ;
      Print[ a, OnElementsOf Dom_Hcurl_a_Mag_2D, File "a.pos" ];
      Print[ js, OnElementsOf Dom_Hcurl_a_Mag_2D, File "js.pos" ];
      Print[ az, OnElementsOf Dom_Hcurl_a_Mag_2D, File "az.pos" ];
      Print[ b, OnElementsOf Dom_Hcurl_a_Mag_2D, File "b.pos" ];
    }
  }
}
