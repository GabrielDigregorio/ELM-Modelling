Include "Heterojunction_GUI.pro";

Group {
  lowvoltage  = Region[103] ;
  highvoltage  = Region[104] ;

  contact_n  = Region[106] ;
  contact_p  = Region[107] ;
  //middel_LINE= Region[105] ;

  Pregion_dpl    = Region[201] ;
  Nregion_dpl    = Region[202] ;

  P_region_no_dpl =Region[203] ;
  N_region_no_dpl =Region[204] ;


  P_region=Region[{Pregion_dpl,P_region_no_dpl}];
  N_region=Region[{Nregion_dpl,N_region_no_dpl}];

  PNjunction=Region[{Pregion_dpl,Nregion_dpl,P_region_no_dpl ,N_region_no_dpl }];
  Ext =Region[{P_region_no_dpl,N_region_no_dpl}];
  Deplection=Region[{Pregion_dpl,Nregion_dpl}];
}

Function {

  // Relative permitivity for each region
  epsr[P_region] = epsilon_r_NiO;
  epsr[N_region] = epsilon_r_ZnO;
  eps = epsilon_0 ;

  // Full-depletion approximation used (for decoupled system)
  Na[Nregion_dpl] = N_d_ZnO;
  Na[Pregion_dpl] = 0;
  Na[N_region_no_dpl] = 0;
  Na[P_region_no_dpl] = 0;
  Nd[Nregion_dpl] = 0;
  Nd[Pregion_dpl] = N_a_NiO;
  Nd[N_region_no_dpl] = 0;
  Nd[P_region_no_dpl] = 0;

  // Use a given profile
    /*mes_donnees_na() = ListFromFile["Na.txt"] ;
    Na[] = InterpolationBilinear[$1,$2]{mes_donnees_na()} ;
    mes_donnees_nd() = ListFromFile["Nd.txt"] ;
    Nd[] = InterpolationBilinear[$1,$2]{mes_donnees_nd()} ;*/

  // Full-depletion approximation NOT used (no analytical approximation on Na Nd)
    /*Na[P_region] = N_d_ZnO;//e21;
    Na[N_region] = 0;//e21;
    Nd[P_region] = 0;//1e21;
    Nd[N_region] = N_a_NiO;//e21;*/

}

Constraint {
  // Boundary condition phi
  { Name Voltage ;
    Case {
      { Region highvoltage ; Type Assign; Value 0. ; }
      { Region lowvoltage ;Type Assign; Value phi_i - V_a; }
      //{ Region lowvoltage ;Type Assign; Value 0; }
    }
  }
  // Boundary condition for p
  { Name concentration_p ;
    Case {
      { Region lowvoltage ; Type Assign; Value  po; }
      { Region highvoltage ; Type Assign; Value  n_po; }
    }
  }
  // Boundary condition for n
  { Name concentration_n ;
    Case {
      { Region highvoltage ; Type Assign; Value  no; }
      { Region lowvoltage ; Type Assign; Value  p_no; }
    }
  }
}


Jacobian {
  { Name JVol ;
    Case {
      { Region All ; Jacobian Vol ; }
    }
  }
  { Name JSur ;
    Case {
      { Region All ; Jacobian Sur ; }
    }
  }
}

Integration {
  { Name I1 ;
    Case {
      { Type Gauss ;
        Case {
          { GeoElement Point       ; NumberOfPoints  1 ; }
          { GeoElement Line        ; NumberOfPoints  5 ; }
          { GeoElement Triangle    ; NumberOfPoints  7 ; }
          { GeoElement Quadrangle  ; NumberOfPoints  4 ; }
          { GeoElement Tetrahedron ; NumberOfPoints  15 ; }
          { GeoElement Hexahedron  ; NumberOfPoints  14 ; }
          { GeoElement Prism       ; NumberOfPoints  21 ; }
        }
      }
    }
  }
}

FunctionSpace {
  // phi coefficeint
  { Name volt_phi; Type Form0;
    BasisFunction {
      { Name volt; NameOfCoef phi_coeff; Function BF_Node; Support PNjunction;
        Entity NodesOf[All]; }
    }
    Constraint {
      { NameOfCoef phi_coeff; EntityType NodesOf ; NameOfConstraint Voltage; }
    }
  }

  // p  hole
  { Name p_hole; Type Form0;
    BasisFunction {
      { Name p_h; NameOfCoef p_coeff; Function BF_Node; Support PNjunction;
        Entity NodesOf[All]; }
    }
    Constraint {
      { NameOfCoef p_coeff; EntityType NodesOf ; NameOfConstraint concentration_p; }
    }
  }

  // n  électron
  { Name n_elec; Type Form0;
    BasisFunction {
      { Name n_e; NameOfCoef n_coeff; Function BF_Node; Support PNjunction;
        Entity NodesOf[All]; }
    }
    Constraint {
      { NameOfCoef n_coeff; EntityType NodesOf ; NameOfConstraint concentration_n; }
    }

  }
}

Formulation {
  { Name coupled ; Type FemEquation;
    Quantity {
      { Name n;  Type Local; NameOfSpace n_elec; }
      { Name p;  Type Local; NameOfSpace p_hole; }
      { Name phi;  Type Local; NameOfSpace volt_phi; }
    }
    Equation {
      // equation phi
      Galerkin { [ -epsr[]* Dof{d phi} , {d phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [-Dof{p}, {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [+Dof{n} , {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  } // This equation is very sensitive to small changes in Na and Nd
      Galerkin { [+(Na[X[],Y[]]-Nd[X[],Y[]]) , {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }

      // equation n-static
      Galerkin { [ -A*Dof{n}*{d phi} , {d n} ]; // This equation make instabilities !
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -B*Dof{d n} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  +1/taun*Dof{n} , {n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  -1/taun*n_po , {n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }

      // equation p-static
      Galerkin { [ C*Dof{p}*{d phi} , {d p} ]; // This equation make instabilities !
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -D* Dof{d p} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  +1/taup*Dof{p} , {p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  -1/taup*p_no , {p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
    }
  }

  { Name phi ; Type FemEquation;
    Quantity {
      { Name phi;  Type Local; NameOfSpace volt_phi; }
    }
    Equation {
      Galerkin { [ -epsr[]* Dof{d phi} , {d phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [+Ac*(Na[X[],Y[]]-Nd[X[],Y[]]) , {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
    }
  }

  { Name pn ; Type FemEquation;
    Quantity {
      { Name n;  Type Local; NameOfSpace n_elec; }
      { Name p;  Type Local; NameOfSpace p_hole; }
      { Name phi;  Type Local; NameOfSpace volt_phi; }
    }
    Equation {
      Galerkin { [ -A*Dof{n}*{d phi} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -B* Dof{d n} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  +1/taun*Dof{n} , {n} ];
        In N_region; Integration I1; Jacobian JVol;  }
      Galerkin { [  -1/taun*n_po , {n} ];
        In N_region; Integration I1; Jacobian JVol;  }


      Galerkin { [ C*Dof{p}*{d phi} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -D* Dof{d p} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  +1/taup*Dof{p} , {p} ];
        In P_region; Integration I1; Jacobian JVol;  }
      Galerkin { [  -1/taup*p_no , {p} ];
        In P_region; Integration I1; Jacobian JVol;  }
    }
  }
}

Resolution {
  { Name analysis;
    System {

      // DECOUPLED SYSTEM
        { Name phi; NameOfFormulation phi; }
        { Name pn; NameOfFormulation pn; }

      // COUPLED SYSTEM
        //{ Name coupled; NameOfFormulation coupled; }
    }
    Operation {

      // DECOUPLED SYSTEM
        Generate[phi]; Solve[phi];
        Generate[pn]; Solve[pn];
        SaveSolution[phi];
        SaveSolution[pn];
      
      // COUPLED SYSTEM
        /*IterativeLoop[20,1e-4,1]{
          GenerateJac[coupled]; SolveJac[coupled];
        }
        SaveSolution[coupled];*/

    }
  }
}

PostProcessing {
  { Name PN_post; NameOfFormulation pn;
    Quantity {
      { Name n; Value{ Local{ [ {n} ] ; In PNjunction; Jacobian JVol; } } }
      { Name p; Value{ Local{ [ {p} ] ; In PNjunction; Jacobian JVol; } } }
      { Name phi; Value{ Local{ [{phi} ] ; In PNjunction; Jacobian JVol; } } }
      { Name E; Value{ Local{ [{d phi} ] ; In PNjunction; Jacobian JVol; } } }
      { Name Na; Value{ Local{ [Na[X[],Y[]] ] ; In PNjunction; Jacobian JVol; } } }
      { Name Nd; Value{ Local{ [Nd[X[],Y[]] ] ; In PNjunction; Jacobian JVol; } }}
    }
  }
}

PostOperation {
  { Name map ; NameOfPostProcessing PN_post ;
    Operation {
      Print[ n, OnElementsOf PNjunction , File "map.pos"];
      Print[ p, OnElementsOf PNjunction , File "map.pos"];
      Print[ phi, OnElementsOf PNjunction , File "map.pos"];
      Print[ E, OnElementsOf PNjunction , File "map.pos"];
      Print[Na, OnElementsOf PNjunction , File "map.pos"];
      Print[Nd, OnElementsOf PNjunction , File "map.pos"];


      // This Does not work, but should work ...
      //Print[ n, OnLine { {0,-thickness_ZnO,0} {0,thickness_NiO,0} } {50}, Dimension 2, Format Table, File "n_line.txt"];
      //Print[ p, OnLine { {0,-thickness_ZnO,0} {0,thickness_NiO,0} } {50}, Dimension 2, Format Table, File "p_line.txt"];
      //Print[ phi, OnLine { {0,-thickness_ZnO,0} {0,thickness_NiO,0} } {50}, Dimension 2, Format Table, File "phi_line.txt"];
    }
  }

}

DefineConstant[
  // preset all getdp options and make them invisible
  R_ = {"analysis", Name "GetDP/1ResolutionChoices", Visible 0},
  C_ = {"-solve -pos -v2 -bin", Name "GetDP/9ComputeCommand", Visible 0},
  P_ = {"map", Name "GetDP/2PostOperationChoices", Visible 0}
];
