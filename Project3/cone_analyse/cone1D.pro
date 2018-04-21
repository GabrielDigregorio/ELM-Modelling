

Group {
  fixtemp1  = Region[4001] ;
  fixtemp = Region[4002] ;
  surface1    = Region[4000] ;
  Vol_The = Region[{surface1 }] ;
  Tot_The = Region[{Vol_The}];
  Vol_Con = Region[{surface1 }] ;
  Tot_Con = Region[{Vol_The}];
}
Include "mat.pro";

Function {
 DefineConstant[
timemax = {3e-8, Min 1e-10, Max 1e-8, Step 1e-10,
  Name "Parameters/1Simulation time"}
  dtime = {1e-10, Min 1e-12, Max 1e-10, Step 1e-12,
    Name "Parameters/1Time step"}

  ];
  //k[surface1  ] =k_mat ;
  //k[ bottom] =  kbottom ;

  Da[surface1]=Da;
  Ce_v=Ce;
  Ch_v=Ch;
  C=Ce+Ch;
  E_gap=Egap;
  mes_donnees_n() = ListFromFile["concno.txt"] ;
  no[] = InterpolationLinear[$1]{mes_donnees_n()} ;

    mes_donneesrhocp() = ListFromFile["rhocp_T.txt"] ;
    rhoc [surface1 ]= InterpolationLinear[$1]{mes_donneesrhocp()} ;
    mes_donneesk() = ListFromFile["k_T.txt"] ;
    k [surface1 ]= InterpolationLinear[$1]{mes_donneesk()} ;





  //TimeFct[] = ($Time < pulse) ? 1 : 0 ;

  //Flux[] = flux * TimeFct[] ;
  //qVol[] = 0;

  t0 = 0;
  t1 = timemax;
  dt = dtime;

  SaveFct[] = 0; //!($TimeStep % 20) ;



  mes_donnees() = ListFromFile["test1D.txt"] ;
  T_init[] = InterpolationLinear[$1]{mes_donnees()} ;
  mes_donneesR() = ListFromFile["R0.txt"] ;
  R[]= InterpolationLinear[$1]{mes_donneesR()} ;
  qVol[]=0;
}

Constraint {
  { Name Temperature ;
    Case {

      //  If(Flag_AnalysisType == 0)
      //{ Region fixtemp1 ; Type Assign; Value 20. ; }
      { Region fixtemp ; Type Assign; Value 15. ; }
      //SEndIf

        { Region Vol_The ; Type Init; Value T_init[X[]] ; }


    }
  }
  { Name concentration ;
    Case {

      //  If(Flag_AnalysisType == 0)
      //{ Region fixtemp1 ; Type Assign; Value 20. ; }
    //  { Region fixtemp ; Type Assign; Value 20. ; }
      //SEndIf
      //If(Flag_AnalysisType != 0)
        { Region Vol_Con ; Type Init; Value no[X[]] ; }

      //EndIf
    }
}
}






DefineConstant[ Flag_AnalysisType = 0 ];

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
	  { GeoElement Line        ; NumberOfPoints  3 ; }
	  { GeoElement Triangle    ; NumberOfPoints  4 ; }
	  { GeoElement Quadrangle  ; NumberOfPoints  4 ; }
	  { GeoElement Tetrahedron ; NumberOfPoints  4 ; }
	  { GeoElement Hexahedron  ; NumberOfPoints  6 ; }
	  { GeoElement Prism       ; NumberOfPoints  6 ; }
	}
      }
    }
  }
}

FunctionSpace {
  // Temperture
  { Name Hgrad_T; Type Form0;
    BasisFunction {
      { Name sn; NameOfCoef Tn; Function BF_Node; Support Tot_The;
        Entity NodesOf[All]; }
    }
    Constraint {
      { NameOfCoef Tn; EntityType NodesOf ; NameOfConstraint Temperature; }
    }

  }

// concetration
{ Name Hgrad_n; Type Form0;
  BasisFunction {
    { Name sc; NameOfCoef Cn; Function BF_Node; Support Tot_Con;
      Entity NodesOf[All]; }

  }
  Constraint {
    { NameOfCoef Cn; EntityType NodesOf ; NameOfConstraint concentration; }
  }


}
}

Function{
  DefineFunction[Flux,qVol,h,hr,TConv];
}

Formulation {

  { Name The_T_n ; Type FemEquation;
    Quantity {
      { Name T;  Type Local; NameOfSpace Hgrad_T; }
      { Name n;  Type Local; NameOfSpace Hgrad_n; }
    }
    Equation {
      // equation thermique
      Galerkin { [ R[X[]]*R[X[]]*k[{T}] * Dof{d T} , {d T} ];
                 In Vol_The; Integration I1; Jacobian JVol;  }

      Galerkin { DtDof [R[X[]]*R[X[]]*rhoc[{T}] * Dof{T} , {T} ];
                 In Vol_The; Integration I1; Jacobian JVol;  }


    // concentration
    Galerkin { [R[X[]]*R[X[]]*Da[] * Dof{d n} , {d n} ];
               In Vol_Con; Integration I1; Jacobian JVol;  }

    Galerkin { DtDof [R[X[]]*R[X[]]* Dof{n} , {n} ];
               In Vol_Con; Integration I1; Jacobian JVol;  }

   Galerkin { [-R[X[]]*R[X[]]*(Ch+Ce)*{n}*{n}*Dof{n}  , {n} ];
              In Vol_Con; Integration I1; Jacobian JVol;  }

              // coupling term
    Galerkin { [ -R[X[]]*R[X[]]*(Ch+Ce)*Egap*1e6*{n}*{n}*Dof{n} , {T} ];
                         In Vol_The; Integration I1; Jacobian JVol;  }
    }
  }

}

Resolution {
  { Name analysis;
    System {
      { Name T; NameOfFormulation The_T_n; }
    }
    Operation {


        InitSolution[T] ; SaveSolution[T] ;
        TimeLoopTheta [t0, t1, dt, 1.0] {

          IterativeLoop[15,1e-4,0.5]{
          GenerateJac[T]; SolveJac[T];
        }
        Test[SaveFct[]] {
          SaveSolution[T];
        }
          /*Generate[T] ; Solve[T];
          Test[SaveFct[]] {
            SaveSolution[T];
          }*/

        }

      /*If(Flag_AnalysisType == 2) // transient linear fast
        InitSolution[T] ;  SaveSolution[T] ;
        GenerateSeparate[T] ;
        TimeLoopTheta [t0, t1, dt, 1.0] {
	  Update[T, TimeFct[]] ;
          SolveAgain[T] ;
	  Test[SaveFct[]] {
            SaveSolution[T];
          }
	}
      EndIf*/
    }
  }
}


PostProcessing {
  { Name The; NameOfFormulation The_T_n;
    Quantity {
      { Name T; Value{ Local{ [ {T} ] ; In Vol_The; Jacobian JVol; } } }
     { Name co_no; Value{ Local{ [ {n} ] ; In Vol_The; Jacobian JVol; } } }
      { Name R; Value{ Local{ [ R[X[]] ] ; In Vol_The; Jacobian JVol; } } }
    }
  }

}










PostOperation {

  { Name map ; NameOfPostProcessing The ;
    Operation {
      Print[ T, OnElementsOf Vol_The , File "map.pos"];
      //  Print[ q, OnElementsOf Vol_The , File "map.pos"];
        Print[ T, OnElementsOf Vol_The ,Format Table, File "temper.txt"];
        Print[ R, OnElementsOf Vol_The ,Format Table, File "R.txt"];
        Print[ T, OnPoint {1e-9,0, 0} , File "Tcont.txt" , Format TimeTable];
        Print[ T, OnElementsOf Vol_The ,Format TimeTable, File "temperovertime.txt"];

        Print[ co_no, OnElementsOf Vol_The ,Format TimeTable, File "concentr.txt"];
    }
  }



}

DefineConstant[
  // preset all getdp options and make them invisible
  R_ = {"analysis", Name "GetDP/1ResolutionChoices", Visible 0},
  C_ = {"-solve -pos -v2 -bin", Name "GetDP/9ComputeCommand", Visible 0},
  P_ = {"map", Name "GetDP/2PostOperationChoices", Visible 0}
];
