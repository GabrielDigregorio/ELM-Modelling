Include "2ndProject_GUI.pro";

Group {
  /* One starts by giving explicit meaningful names to
     the Physical regions defined in the "microstrip.msh" mesh file.
     There are 2 volume regions and 3 surface regions in this model. */



  Omega = Region[100];
  GammaWire = Region[103];
  GammaGround = Region[102];
  GammaInf = Region[101];
  

}

Function {
  epsilon = 8.8541e-12;
}

Constraint {
  { Name Dirichlet_Ele; Type Assign; // dirichlet condition
    Case {
      { Region GammaGround; Value 0.; }// v_n = 0 ground
      { Region GammaWire; Value 500e3; }// v_n = 500e3 wire
    }
  }
}


FunctionSpace {

  { Name Hgrad_v_Ele; Type Form0;
    // v = \sum_{n=1}^{numNodes} v_n * s_n(x)
    BasisFunction {
      { Name sn; NameOfCoef vn; Function BF_Node;
        Support Omega; Entity NodesOf[ All ]; }
    }
    // with some coefficient v_n fixed
    Constraint {
      { NameOfCoef vn; EntityType NodesOf;
        NameOfConstraint Dirichlet_Ele; }
    }
  }
}

Jacobian {
  { Name Vol ;
    Case {
      { Region All ; Jacobian Vol ; }
    }
  }
}

Integration {
  { Name Int ;
    Case { {Type Gauss ;
            Case { { GeoElement Triangle    ; NumberOfPoints  4 ; }
                   { GeoElement Quadrangle  ; NumberOfPoints  4 ; } }
      }
    }
  }
}

Formulation {

  { Name Electrostatics_v; Type FemEquation;
    Quantity {
      { Name v; Type Local; NameOfSpace Hgrad_v_Ele; }
    }
    Equation {
      Galerkin { [ epsilon * Dof{d v} , {d v} ]; In Omega;
	              Jacobian Vol; Integration Int; }
    }
  }
}

Resolution {
  { Name EleSta_v;
    System {
      { Name Sys_Ele; NameOfFormulation Electrostatics_v; }
    }
    Operation {
      Generate[Sys_Ele]; Solve[Sys_Ele]; SaveSolution[Sys_Ele];
    }
  }
}



PostProcessing {
  { Name EleSta_v; NameOfFormulation Electrostatics_v;
    Quantity {
      { Name v;
        Value {
          Local { [ {v} ]; In Omega; Jacobian Vol; }
        }
      }
      { Name e;
        Value {
          Local { [ -{d v} ]; In Omega; Jacobian Vol; }
        }
      }
      { Name e_norm;
        Value {
          Local { [ Norm[ -{d v} ]]; In Omega; Jacobian Vol; }
        }
      }
    }
  }
}

PostOperation {
  { Name Map; NameOfPostProcessing EleSta_v;
     Operation {
       Print [ v, OnElementsOf Omega, File "v.pos" ];
       Print [ e, OnElementsOf Omega, File "e.pos" ];
       Print [ e_norm, OnElementsOf Omega, File "e_norm.pos" ];
     }
  }
}
