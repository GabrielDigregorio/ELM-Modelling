Include "3ndProject_GUI.pro";

Group {
  lowvoltage  = Region[104] ;
  highvoltage  = Region[103] ;

  leftplate_n  = Region[103] ;
  rightplate_p  = Region[104] ;
  Pregion    = Region[202] ;
  Nregion    = Region[201] ;
  PNjunction=Region[{Pregion,Nregion}];

}

Function {

  // All in µm
  epsr[Pregion] = epsilon_r_NiO; // epsr[Pextregion] = 1;
  epsr[Nregion] = epsilon_r_NiO; // epsr[Nextregion] = 1;
  eps = epsilon_0 ; //* 1e-18;
  mes_donnees_na() = ListFromFile["Na.txt"] ;
  Na[] = InterpolationLinear[$1]{mes_donnees_na()} ;
  mes_donnees_nd() = ListFromFile["Nd.txt"] ;
  Nd[] = InterpolationLinear[$1]{mes_donnees_nd()} ;
  nun = mu_e_ZnO ;//* 1e12;
  nup =  mu_h_NiO ;//* 1e12;
  Dn = D_e_ZnO ;//* 1e12;
  Dp = D_h_NiO ;//* 1e12;
  no =N_d_ZnO ;//* 1e-18;// 2.71828^(q*V_a/(k_b*T));
  po =N_a_NiO ;//* 1e-18;
  taun = ((L_e_ZnO)^2)/D_e_ZnO;
  taup = ((L_h_NiO)^2)/D_h_NiO;
  G=0;

  phi_i = ((k_b*T)/q) * Log[(N_d_ZnO*N_a_NiO)/(n_ZnO*p_NiO)];

  NL_tol_abs = 1e-6;
  NL_tol_rel = 1e-6;
  NL_iter_max = 40;
  relax = 1e-3;
  Factor=1;
}

Constraint {
  // Boundary condition phi
  { Name Voltage ;
    Case {
      { Region lowvoltage ; Type Assign; Value 0. ; }
      //{ Region highvoltage ;Type Assign; Value V_a; }
    }
  }
  // Boundary condition for p
    { Name concentration_p ;
      Case {
        //{ Region rightplate_p ; Type Assign; Value  po; }
        //{ Region leftplate_n ; Type Assign; Value  0; }
      }
    }
  // Boundary condition for n
    { Name concentration_n ;
        Case {
        //  { Region leftplate_n ; Type Assign; Value  no; }
          //{ Region rightplate_p ; Type Assign; Value  0; }
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

        Galerkin { [+q*Factor*Dof{p} , {phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [-q*Factor*Dof{n} , {phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }

        Galerkin { [+q*(Na[X[]]-Nd[X[]])  , {phi} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }

        // equation n-static
        Galerkin { [ -nun*Factor*Dof{n}*$relax*{d phi} , {d n} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [ +Dn* Factor*Dof{d n} , {d n} ];
                              In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [  +1/taun*Factor*Dof{n} , {n} ];
                  In Pregion; Integration I1; Jacobian JVol;  }// only on P region
        Galerkin { [  -1/taun*no , {n} ];
                  In Pregion; Integration I1; Jacobian JVol;  }// only on P region
        Galerkin { [  +1/taup*Factor*Dof{p} , {n} ];
                    In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  -1/taup*Factor*po , {n} ];
                    In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  -G , {n} ];
                    In PNjunction; Integration I1; Jacobian JVol;  }


        // equation p-static
        Galerkin { [ nup*Factor*Dof{p}*$relax*{d phi} , {d p} ];
                   In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [ -Dp* Factor*Dof{d p} , {d p} ];
                              In PNjunction; Integration I1; Jacobian JVol;  }
        Galerkin { [  +1/taup*Factor*Dof{p} , {p} ];
                  In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  -1/taup*po , {p} ];
                  In Nregion; Integration I1; Jacobian JVol;  }// only on N region
        Galerkin { [  +1/taun*Factor*Dof{n} , {p} ];
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
        Evaluate[$relax = 1e-3];
        While[$relax <= 1]{

          Print[{$relax}, Format "************** RELAX = %03g ************** "];

          Generate[PN]; GetResidual[PN, $res0];
          Evaluate[ $res = $res0, $iter = 0 ];
          Print[{$iter, $res, $res / $res0},
            Format "Residual %03g: abs %14.12e rel %14.12e"];
          While[$res > NL_tol_abs && $res / $res0 > NL_tol_rel &&
            $res / $res0 <= 1 && $iter < NL_iter_max]{
            Solve[PN]; Generate[PN]; GetResidual[PN, $res];
            Evaluate[ $iter = $iter + 1 ];
            Print[{$iter, $res, $res / $res0},
              Format "Residual %03g: abs %14.12e rel %14.12e"];
          }

          Evaluate[ $relax = $relax * 1.5 ];
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
        }
    }

  }


  PostOperation {

    { Name map ; NameOfPostProcessing PN_post ;
      Operation {
        Print[ phi, OnElementsOf PNjunction , File "map_phi.pos"];
        Print[ n, OnElementsOf PNjunction , File "map_n.pos"];
        Print[ p, OnElementsOf PNjunction , File "map_p.pos"];

        Print[ phi, OnElementsOf PNjunction ,Format Table, File "phi.txt"];
        Print[ n, OnElementsOf PNjunction ,Format Table, File "n.txt"];
        Print[ p, OnElementsOf PNjunction ,Format Table, File "p.txt"];
        Print[ phi, OnLine { {-1e-7,0,0} {1e-7,0,0} } {200}, Format Table, File "phi_line.txt"];
        }
    }


  }

  DefineConstant[
    // preset all getdp options and make them invisible
    R_ = {"analysis", Name "GetDP/1ResolutionChoices", Visible 0},
    C_ = {"-solve -pos -v2 -bin", Name "GetDP/9ComputeCommand", Visible 0},
    P_ = {"map", Name "GetDP/2PostOperationChoices", Visible 0}
  ];
