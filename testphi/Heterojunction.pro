Include "Heterojunction_GUI.pro";

Group {
  lowvoltage  = Region[101] ;
  highvoltage  = Region[102] ;

  contact_n  = Region[101] ;
  contact_p  = Region[102] ;



  // n et p region sont inversé par rapport au point .geo, ce n'est pas clair!!!
  Pregion    = Region[104] ;
  Nregion    = Region[103] ;
  Nregion_dpl=Region[108];
  Pregion_dpl=Region[107];
  N_region_no_dpl=Region[106];
  P_region_no_dpl=Region[105];

  P_region=Region[{  Nregion_dpl,N_region_no_dpl}];
  N_region=Region[{  Pregion_dpl,P_region_no_dpl}];


  PNjunction=Region[{P_region,N_region}];


}

Function {
  epsr[P_region] = epsilon_r_NiO;
  epsr[N_region] = epsilon_r_ZnO;
  eps = epsilon_0 ;

  Na[Nregion_dpl] = N_d_ZnO;
  Na[Pregion_dpl] = 0;
  Na[N_region_no_dpl] = 0;
  Na[P_region_no_dpl] = 0;
  Nd[Nregion_dpl] = 0;
  Nd[Pregion_dpl] = N_a_NiO;
  Nd[N_region_no_dpl] = 0;
  Nd[P_region_no_dpl] = 0;

  Factor = 0;
  /*mes_donnees_na() = ListFromFile["Na.txt"] ;
  Na[] = InterpolationBilinear[$1,$2]{mes_donnees_na()} ;
  mes_donnees_nd() = ListFromFile["Nd.txt"] ;
  Nd[] = InterpolationBilinear[$1,$2]{mes_donnees_nd()} ;*/

  Naa[P_region] = 1e21;
  Naa[N_region] = 0;
  Ndd[P_region] = 0 ;
  Ndd[N_region] = 1e21;

}

Constraint {
  // Boundary condition phi
  { Name Voltage ;
    Case {
      { Region highvoltage ; Type Assign; Value 0. ; }
      { Region lowvoltage ;Type Assign; Value phi_i - V_a; }
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
  /*{ Name E_field ;
    Case {
      //{ Region highvoltage ; Type Assign; Value  no; }
      { Region lowvoltage ; Type Assign; Value  p_no; }
    }
  }*/

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
      Galerkin { [ -epsr[]*eps* Dof{d phi} , {d phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [+q*{p} , {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [-q*{n} , {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [+q*(Naa[]-Ndd[]) , {phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }

      // equation n-static
      // attention !! cette Ã©quation fait tout diverger mÃªme avec zÃ©ro comme facteur !!
      /*Galerkin { [ -nun*Dof{n}*{d phi} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -Dn* Dof{d n} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }*/
      /*Galerkin { [  +1/taun*Dof{n} , {n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }// only on P region
      Galerkin { [  -1/taun*n_po , {n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }// only on P region*/

      // equation p-static
      /*Galerkin { [ nup*Dof{p}*{d phi} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -Dp* Dof{d p} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }*/
      /*Galerkin { [  +1/taup*Dof{p} , {p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }// only on N region
      Galerkin { [  -1/taup*p_no , {p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }// only on N region*/
    }
  }

  { Name phi ; Type FemEquation;
    Quantity {
      { Name phi;  Type Local; NameOfSpace volt_phi; }
    }
    Equation {
      Galerkin { [ -epsr[]*eps* Dof{d phi} , {d phi} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [+q*(Na[]-Nd[]) , {phi} ];
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
      Galerkin { [ -nun*Dof{n}*{d phi} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ +Dn* Dof{d n} , {d n} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [  -1/taun*Dof{n} , {n} ];
        In N_region; Integration I1; Jacobian JVol;  }
      Galerkin { [  +1/taun*n_po , {n} ];
        In N_region; Integration I1; Jacobian JVol;  }

      Galerkin { [ nup*Dof{p}*{d phi} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -Dp* Dof{d p} , {d p} ];
        In PNjunction; Integration I1; Jacobian JVol;  }
      Galerkin { [ -1/taup*Dof{p} , {p} ];
        In P_region; Integration I1; Jacobian JVol;  }
      Galerkin { [  +1/taup*p_no , {p} ];
        In P_region; Integration I1; Jacobian JVol;  }
    }

  }

}

Resolution {
  { Name analysis;
    System {
      { Name phi; NameOfFormulation phi; }
      { Name pn; NameOfFormulation pn; }
      { Name coupled; NameOfFormulation coupled; }
    }
    Operation {

      Generate[phi]; Solve[phi];
      SaveSolution[phi];
      IterativeLoop[50,1e-4,0.5]{
      GenerateJac[pn]; SolveJac[pn];
      }



      IterativeLoop[20,1e-4,0.5]{
        GenerateJac[coupled]; SolveJac[coupled];
      }
      IterativeLoop[50,1e-4,0.5]{
      GenerateJac[pn]; SolveJac[pn];
      }
      IterativeLoop[20,1e-4,0.5]{
        GenerateJac[coupled]; SolveJac[coupled];
      }
      SaveSolution[coupled];

    }
  }
}

PostProcessing {
  { Name PN_post; NameOfFormulation pn;
    Quantity {
      //{ Name n; Value{ Local{ [ {n} ] ; In PNjunction; Jacobian JVol; } } }
      //{ Name p; Value{ Local{ [ {p} ] ; In PNjunction; Jacobian JVol; } } }
      { Name phi; Value{ Local{ [{phi} ] ; In PNjunction; Jacobian JVol; } } }
    /*  { Name Na; Value{ Local{ [Na[] ] ; In PNjunction; Jacobian JVol; } } }
      { Name Nd; Value{ Local{ [Nd[] ] ; In PNjunction; Jacobian JVol; } }}
      { Name Naa; Value{ Local{ [Naa[] ] ; In PNjunction; Jacobian JVol; } } }
      { Name Ndd; Value{ Local{ [Ndd[ ] ] ; In PNjunction; Jacobian JVol; } }}*/
      //{ Name phi; Value { Term { [ {phi} ]; In PNjunction; Jacobian JVol; } }
    }
  }
}

PostOperation {
  { Name map ; NameOfPostProcessing PN_post ;
    Operation {
      //Print[ n, OnElementsOf PNjunction , File "map.pos"];
      //Print[ p, OnElementsOf PNjunction , File "map.pos"];
      Print[ phi, OnElementsOf PNjunction , File "map.pos"];
    /*  Print[Na, OnElementsOf PNjunction , File "map.pos"];
      Print[Nd, OnElementsOf PNjunction , File "map.pos"];
      Print[Naa, OnElementsOf PNjunction , File "map.pos"];
      Print[Ndd, OnElementsOf PNjunction , File "map.pos"];*/
      //Print[ n, OnLine { {0,-2.5e-6,0} {0,2.5e-6,0} } {50}, Dimension 2, Format Table, File "n_line.txt"];
      //Print[ p, OnLine { {0,-2.5e-6,0} {0,2.5e-6,0} } {50}, Dimension 2, Format Table, File "p_line.txt"];
      //Print[ phi, OnLine { {0,-2.5e-6,0} {0,2.5e-6,0} } {50}, Dimension 2, Format Table, File "phi_line.txt"];


    //  Print[ n, OnElementsOf PNjunction ,Format Table, File "n.txt"];
      Print[ phi, OnElementsOf PNjunction ,Format Table, File "phi.txt"];
    //  Print[ p, OnElementsOf PNjunction ,Format Table, File "p.txt"];
    }
  }

}

DefineConstant[
  // preset all getdp options and make them invisible
  R_ = {"analysis", Name "GetDP/1ResolutionChoices", Visible 0},
  C_ = {"-solve -pos -v2 -bin", Name "GetDP/9ComputeCommand", Visible 0},
  P_ = {"map", Name "GetDP/2PostOperationChoices", Visible 0}
];
