Include "3ndProject_GUI.pro";

Group {
  lowvoltage  = Region[102] ;
  highvoltage  = Region[103] ;

  //leftplate_n  = Region[102] ;
  rightplate_n  = Region[103] ;
 leftplate_p  = Region[102] ;
//  rightplate_p  = Region[103] ;

  Pregion    = Region[100] ;
  Nregion    = Region[101] ;
  PNjunction=Region[{Pregion,Nregion}];

}
//Include "mat.pro";

Function {

  // All in µm
  //epsr[Pregion] = epsilon_r_NiO;
  //epsr[Nregion] = epsilon_r_ZnO;
  //eps = epsilon_0 * 1e-18;
  //Na[Pregion] = N_a_NiO * 1e-18;
  //Na[Nregion] = 0;
  //Nd[Nregion] = N_d_ZnO * 1e-18;
  //Nd[Pregion] = 0;
  //nun = mu_e_ZnO * 1e12;
  //nup =  mu_h_NiO * 1e12;
  //Dn = D_e_ZnO * 1e12;
  //Dp = D_h_NiO * 1e12;
  //no = N_d_ZnO * 1e-18;
  //po = N_a_NiO * 1e-18;
  //taun = ((L_e_ZnO*1e-6)^2)/D_e_ZnO;
  //taup = ((L_h_NiO*1e-6)^2)/D_h_NiO;
  //G=0;
q         = 1; 
epsilon_0 = 1;
T         = 1;               
k_b       = 1; 
h         = 1;        
m0        = 1;          

  epsr[Pregion] = 1;
  epsr[Nregion] = 1;
  eps = 1;
  Na[Pregion] = 0;
  Na[Nregion] = 0;
  Nd[Nregion] = 0;
  Nd[Pregion] = 0;
  nun = 1;
  nup =  1;
  Dn = 1;
  Dp = 1;
  no = 0;
  po = 0;
  taun = 1;
  taup = 1;
  G=0;

  /*Ce_v=Ce;
  Ch_v=Ch;
  C=Ce+Ch;
  E_gap=Egap;
  mes_donnees_n() = ListFromFile["concno.txt"] ;
  no[] = InterpolationLinear[$1]{mes_donnees_n()} ;
  mes_donneesrhocp() = ListFromFile["rhocp_T.txt"] ;
  rhoc [surface1 ]= InterpolationLinear[$1]{mes_donneesrhocp()} ;
  mes_donneesk() = ListFromFile["k_T.txt"] ;
  k [surface1 ]= InterpolationLinear[$1]{mes_donneesk()} ;

  SaveFct[] = 0; //!($TimeStep % 20) ;

  mes_donnees() = ListFromFile["test1D.txt"] ;
  T_init[] = InterpolationLinear[$1]{mes_donnees()} ;
  mes_donneesR() = ListFromFile["R0.txt"] ;
  R[]= InterpolationLinear[$1]{mes_donneesR()} ;
  qVol[]=0;*/
}

Constraint {
  // Boundary condition phi
  { Name Voltage ;
    Case {
      { Region lowvoltage ; Type Assign; Value 0. ; }
      { Region highvoltage ; Type Assign; Value V_a ; }
    }
  }
  // Boundary condition for p
    { Name concentration_p ;
      Case {
          { Region rightplate_p ; Type Assign; Value  no; }
      }
    }
  // Boundary condition for n
    { Name concentration_n ;
        Case {
            { Region leftplate_n ; Type Assign; Value  po; }
        }
  }
  // the two other missing condition are neuman condition implicitly consider in the formulation
  }



  Jacobian {
    { Name JVol ;
      Case {
        { Region All ; Jacobian Vol ; }
      }
    }
    //{ Name JSur ;
    //  Case {
    //    { Region All ; Jacobian Sur ; }
    //  }
    //}
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

  // !!!!! à corriger tout les signes et vérifier la formulation !!!!!
  Formulation {

    { Name PN_prob ; Type FemEquation;
      Quantity {
        { Name n;  Type Local; NameOfSpace n_elec; }
        { Name p;  Type Local; NameOfSpace p_hole; }
        { Name phi;  Type Local; NameOfSpace volt_phi; }
      }
      Equation {
        // equation phi
        Galerkin { [ -epsr[]*eps* Dof{d phi} , {d phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }

        Galerkin { [+q*Dof{p} , {phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [-q*Dof{n} , {phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [+q*(Na[]-Nd[]) , {phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }

        // equation n-static
        Galerkin { [ -nun*Dof{n}*{d phi} , {d n} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [ +Dn* Dof{d n} , {d n} ];
                              In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [  +1/taun*Dof{n} , {n} ];
                  In Pregion; Integration I1; Jacobian JVol;  }// only on P region
        Galerkin { [  -1/taun*no , {n} ];
                  In Pregion; Integration I1; Jacobian JVol;  }// only on P region
        Galerkin { [  +1/taup*Dof{p} , {n} ];
                    In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  -1/taup*po , {n} ];
                    In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  -G , {n} ];
                    In PNjunction; Integration I1; Jacobian JVol;  }

        // equation p-static
        Galerkin { [ nup*Dof{p}*{d phi} , {d p} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [ -Dp* Dof{d n} , {d p} ];
                              In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [  +1/taup*Dof{p} , {p} ];
                  In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  -1/taup*po , {p} ];
                  In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  +1/taun*Dof{n} , {p} ];
                  In Pregion; Integration I1; Jacobian JVol;  }// only on P region
        Galerkin { [  -1/taun*no , {p} ];
                  In Pregion; Integration I1; Jacobian JVol;  }// only on P region
        Galerkin { [  -G , {p} ];
                    In PNjunction; Integration I1; Jacobian JVol;  }

      }
    }

  }

  Resolution {
    { Name analysis;
      System {
        { Name PN; NameOfFormulation PN_prob; }
      }
      Operation {

      IterativeLoop[15,1e-6,0.5]{
            GenerateJac[PN]; SolveJac[PN];
          }
            SaveSolution[PN];
          }

      }
    }



  PostProcessing {
    { Name PN_post; NameOfFormulation PN_prob;
      Quantity {
        { Name n; Value{ Local{ [ {n} ] ; In PNjunction; Jacobian JVol; } } }
        { Name p; Value{ Local{ [ {p} ] ; In PNjunction; Jacobian JVol; } } }
        { Name phi; Value{ Local{ [{phi} ] ; In PNjunction; Jacobian JVol; } } }
        // to compute E -field
        //{ Name E_fiel; Value{ Local{ [ R[X[]] ] ; In Vol_The; Jacobian JVol; } } }
      }
    }

  }


  PostOperation {

    { Name map ; NameOfPostProcessing PN_post ;
      Operation {
        Print[ n, OnElementsOf PNjunction , File "map.pos"];
        Print[ p, OnElementsOf PNjunction , File "map.pos"];
        Print[ phi, OnElementsOf PNjunction , File "map.pos"];
        //  Print[ q, OnElementsOf Vol_The , File "map.pos"];
          Print[ n, OnElementsOf PNjunction ,Format Table, File "n.txt"];
          Print[ phi, OnElementsOf PNjunction ,Format Table, File "phi.txt"];
          Print[ p, OnElementsOf PNjunction ,Format Table, File "p.txt"];
        //  Print[ R, OnElementsOf Vol_The ,Format Table, File "R.txt"];
        //  Print[ T, OnPoint {1e-9,0, 0} , File "Tcont.txt" , Format TimeTable];
        //  Print[ T, OnElementsOf Vol_The ,Format TimeTable, File "temperovertime.txt"];
        //  Print[ co_no, OnElementsOf Vol_The ,Format TimeTable, File "concentr.txt"];
      }
    }



  }

  DefineConstant[
    // preset all getdp options and make them invisible
    R_ = {"analysis", Name "GetDP/1ResolutionChoices", Visible 0},
    C_ = {"-solve -pos -v2 -bin", Name "GetDP/9ComputeCommand", Visible 0},
    P_ = {"map", Name "GetDP/2PostOperationChoices", Visible 0}
  ];
