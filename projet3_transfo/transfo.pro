

Include "transfo_GUI.pro";


Group {
// Physical regions :
  Air = Region[{1003, 1001}];
  Sur_Air_Ext = Region[1002]; // exterior boundary
  Core = Region[1004]; // magnetic core of the transformer, assumed non-conducting
  P_Left = Region[1005]; P_Right = Region[1006];
  P = Region[{P_Left, P_Right}]; // Primary coil
  S_Left = Region[1007]; S_Right = Region[1008];
  S = Region[{S_Left, S_Right}]; // Secondry coil
  Coils = Region[{P, S}];

<<<<<<< HEAD
  // Used in the "Lib_Magnetodynamics2D_av_Cir.pro"
  Vol_Mag = Region[{Air, Core, Coils}];
=======
  // Abstract regions that will be used in the "Lib_Magnetodynamics2D_av_Cir.pro"
  // template file included below;
  Vol_Mag = Region[{Air, Core, Coils}]; // full magnetic domain
>>>>>>> 0a46616a3796c241b2c64da0c03d35e506ada642
  If(Flag_nonlinear_core)
    Vol_NL_Mag=Region[{Air, Core, Coils}];// je sais pas faire autrement
  EndIf

  If (type_Conds == 1)
    Vol_C_Mag = Region[{Coils}]; // massive conductors
  ElseIf (type_Conds == 2)
    Vol_S_Mag = Region[{Coils}]; // stranded conductors (coils)
  EndIf
}



If(Flag_nonlinear_core)


Function {

  sigma[Coils] = sigma_Coils;

  // For a correct definition of the voltage
  CoefGeo = thickness_Core;

  // To be defined separately for each coil portion
  Sc[P_Left] = SurfaceArea[];
  SignBranch[P_Left] = 1; // To fix the convention of positive current (1:
                            // along Oz, -1: along -Oz)

  Sc[P_Right] = SurfaceArea[];
  SignBranch[P_Right] = -1;

  Sc[S_Left] = SurfaceArea[];
  SignBranch[S_Left] = 1;

  Sc[S_Right] = SurfaceArea[];
  SignBranch[S_Right] = -1;

  // Number of turns (same for PLUS and MINUS portions) (half values because
  // half coils are defined)
  Ns[P] = N_Primary;
  Ns[S] = N_Secondary;

  // Global definitions (nothing to change):

  // Current density in each coil portion for a unit current (will be multiplied
  // by the actual total current in the coil)
  js0[Coils] = Ns[]/Sc[] * Vector[0,0,SignBranch[]];
  CoefGeos[Coils] = SignBranch[] * CoefGeo;

  // The reluctivity will be used
    mes_donneesair() = ListFromFile["mu_B_air.txt"] ;
    mu[Air]= InterpolationLinear[$1]{mes_donneesair()} ;
    //mu[Air] = 1 * mu0;

    mes_donneescore() = ListFromFile["mu_B_core.txt"] ;
    mu[Core]= InterpolationLinear[$1]{mes_donneescore()} ;


    mes_donneescoils() = ListFromFile["mu_B_coils.txt"] ;
    mu[Coils]= InterpolationLinear[$1]{mes_donneescoils()} ;


    mes_donneesair() = ListFromFile["nu_B_air.txt"] ;
    nu[Air]= InterpolationLinear[$1]{mes_donneesair()} ;


    mes_donneescore() = ListFromFile["nu_B_core.txt"] ;
    nu[Core]= InterpolationLinear[$1]{mes_donneescore()} ;


    mes_donneescoils() = ListFromFile["dhdb_B_coils.txt"] ;
    nu[Coils]= InterpolationLinear[$1]{mes_donneescoils()} ;

    mes_donneesair() = ListFromFile["dhdb_B_air.txt"] ;
    dhdb[Air]= InterpolationLinear[$1]{mes_donneesair()} ;


    mes_donneescore() = ListFromFile["dhdb_B_core.txt"] ;
    dhdb[Core]= InterpolationLinear[$1]{mes_donneescore()} ;


    mes_donneescoils() = ListFromFile["dhdb_B_coils.txt"] ;
    dhdb[Coils]= InterpolationLinear[$1]{mes_donneescoils()} ;



  //dhdb[]=10000;
}

Else
  Function {
  sigma[Coils] = sigma_Coils;

// For a correct definition of the voltage
  CoefGeo = thickness_Core;

// To be defined separately for each coil portion
  Sc[P_Left] = SurfaceArea[];
  SignBranch[P_Left] = 1; // To fix the convention of positive current (1:
                          // along Oz, -1: along -Oz)

  Sc[P_Right] = SurfaceArea[];
  SignBranch[P_Right] = -1;

  Sc[S_Left] = SurfaceArea[];
  SignBranch[S_Left] = 1;

  Sc[S_Right] = SurfaceArea[];
  SignBranch[S_Right] = -1;

<<<<<<< HEAD
  // Number of turns (same for PLUS and MINUS portions) (half values because
  // half coils are defined)
  Ns[P] = 1;
  Ns[S] = 10;
=======
// Number of turns (same for PLUS and MINUS portions) (half values because
// half coils are defined)
  Ns[P] = N_Primary;
  Ns[S] = N_Secondary;
>>>>>>> 0a46616a3796c241b2c64da0c03d35e506ada642

// Global definitions (nothing to change):

// Current density in each coil portion for a unit current (will be multiplied
// by the actual total current in the coil)
  js0[Coils] = Ns[]/Sc[] * Vector[0,0,SignBranch[]];
  CoefGeos[Coils] = SignBranch[] * CoefGeo;

  mu[Air] = 1 * mu0;
  mu[Core] = mur_Core * mu0;
  mu[Coils] = 1 * mu0;
  nu[] = 1/mu[];
}
EndIf





If(type_Analysis == 1)
  Flag_FrequencyDomain = 1;
Else
  Flag_FrequencyDomain = 0;
EndIf

If (type_Source == 1) // current

  Flag_CircuitCoupling = 0;

ElseIf (type_Source == 2) // voltage

  // PLUS and MINUS coil portions to be connected in series, with applied
  // voltage on the resulting branch
  Flag_CircuitCoupling = 1;

  // Here is the definition of the circuits on primary and secondary sides:
  Group {
    // Empty Groups to be filled
    Resistance_Cir  = Region[{}];
    Inductance_Cir  = Region[{}] ;
    Capacitance_Cir = Region[{}] ;
    SourceV_Cir = Region[{}]; // Voltage sources
    SourceI_Cir = Region[{}]; // Current sources

    // Primary side
    E_in = Region[10001]; // arbitrary region number (not linked to the mesh)
    SourceV_Cir += Region[{E_in}];

    // Secondary side
    R_out = Region[10101]; // arbitrary region number (not linked to the mesh)
    Resistance_Cir += Region[{R_out}];
  }

  Function {
    deg = Pi/180;
    // Input RMS voltage (half of the voltage because of symmetry; half coils
    // are defined)
    val_E_in = 1.;
    phase_E_in = 90 *deg; // Phase in radian (from phase in degree)
    // High value for an open-circuit test; Low value for a short-circuit test;
    // any value in-between for any charge
    Resistance[R_out] = 1e6;
  }

  Constraint {

    { Name Current_Cir ;
      Case {
      }
    }

    { Name Voltage_Cir ;
      Case {
        { Region E_in; Value val_E_in; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_E_in}; }
      }
    }

    { Name ElectricalCircuit ; Type Network ;
      Case Circuit_1 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // E_in (an additional resistor should be defined to represent the
        // P end-winding (not considered in the 2D model))
        { Region E_in; Branch {1,2}; }

        { Region P_Left; Branch {2,3} ; }
        { Region P_Right; Branch {3,1} ; }
      }
      Case Circuit_2 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // R_out (an additional resistor should be defined to represent the
        // S end-winding (not considered in the 2D model))
        { Region R_out; Branch {1,2}; }

        { Region S_Left; Branch {2,3} ; }
        { Region S_Right; Branch {3,1} ; }
      }
    }

  }

EndIf

Constraint {
  { Name MagneticVectorPotential_2D;
    Case {
      { Region Sur_Air_Ext; Value 0; }
    }
  }
  { Name Current_2D;
    Case {
     If (type_Source == 1)
      // Current in each coil (same for PLUS and MINUS portions)
       { Region P; Value 1; TimeFunction F_Sin_wt_p[]{2*Pi*Freq, 0};  }
      { Region S; Value 0; }
     EndIf
    }
  }
  { Name Voltage_2D;
    Case {
    }
  }
}

Include "Lib_Magnetodynamics2D_av_Cir.pro";

PostOperation {
  { Name Map_a; NameOfPostProcessing Magnetodynamics2D_av;
    Operation {
      Print[ j, OnElementsOf Region[{Vol_C_Mag, Vol_S_Mag}], Format Gmsh, File "j.pos" ];
      Print[ b, OnElementsOf Vol_Mag, Format Gmsh, File "b.pos" ];
      Print[ az, OnElementsOf Vol_Mag, Format Gmsh, File "az.pos" ];

      If (type_Source == 1) // current
        // In text file UI.txt: voltage and current for each coil portion (note
        // that the voltage is not equally distributed in PLUS and MINUS
        // portions, which is the reason why we must apply the total voltage
        // through a circuit -> type_Source == 2)
        Echo[ "P_Left", Format Table, File "UI.txt" ];
        Print[ U, OnRegion P_Left, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion P_Left, Format FrequencyTable, File > "UI.txt"];
        Echo[ "P_Right", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion P_Right, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion P_Right, Format FrequencyTable, File > "UI.txt"];

        Echo[ "S_Left", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion S_Left, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion S_Left, Format FrequencyTable, File > "UI.txt"];
        Echo[ "S_Right", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion S_Right, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion S_Right, Format FrequencyTable, File > "UI.txt"];

      ElseIf (type_Source == 2)
        // In text file UI.txt: voltage and current of the primary coil (from E_in)
        // (real and imaginary parts!)
        Echo[ "E_in", Format Table, File "UI.txt" ];
        Print[ U, OnRegion E_in, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E_in, Format FrequencyTable, File > "UI.txt"];

        // In text file UI.txt: voltage and current of the secondary coil (from R_out)
        Echo[ "R_out", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R_out, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R_out, Format FrequencyTable, File > "UI.txt"];
      EndIf
    }
  }
}
