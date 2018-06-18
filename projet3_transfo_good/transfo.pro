Include "transfo_common.pro";




Flag_nonlinear_core=0;

Group {
  // Physical regions:
  Air = Region[{AIR_WINDOW, AIR_EXT}];
  Sur_Air_Ext = Region[SUR_AIR_EXT]; // exterior boundary
  Core = Region[CORE]; // magnetic core of the transformer, assumed non-conducting
  Coil_1_P = Region[COIL_1_PLUS]; // 1st coil, positive side
  Coil_1_M = Region[COIL_1_MINUS]; // 1st coil, negative side
  Coil_1 = Region[{Coil_1_P, Coil_1_M}];
  Coil_2_P = Region[COIL_2_PLUS]; // 2nd coil, positive side
  Coil_2_M = Region[COIL_2_MINUS]; // 2nd coil, negative side
  Coil_2 = Region[{Coil_2_P, Coil_2_M}];
  Coils = Region[{Coil_1, Coil_2}];

  // Abstract regions that will be used in the "Lib_Magnetodynamics2D_av_Cir.pro"
  // template file included below;
  Vol_Mag = Region[{Air, Core, Coils}]; // full magnetic domain
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

  sigma[Coils] = sigma_c;

  // For a correct definition of the voltage
  CoefGeo = thickness_Core;

  // To be defined separately for each coil portion
  Sc[Coil_1_P] = SurfaceArea[];
  SignBranch[Coil_1_P] = 1; // To fix the convention of positive current (1:
                            // along Oz, -1: along -Oz)

  Sc[Coil_1_M] = SurfaceArea[];
  SignBranch[Coil_1_M] = -1;

  Sc[Coil_2_P] = SurfaceArea[];
  SignBranch[Coil_2_P] = 1;

  Sc[Coil_2_M] = SurfaceArea[];
  SignBranch[Coil_2_M] = -1;

  // Number of turns (same for PLUS and MINUS portions) (half values because
  // half coils are defined)
  Ns[Coil_1] = N1;
  Ns[Coil_2] = N2;

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
  sigma[Coils] = sigma_c;

// For a correct definition of the voltage
  CoefGeo = thickness_Core;

// To be defined separately for each coil portion
  Sc[Coil_1_P] = SurfaceArea[];
  SignBranch[Coil_1_P] = 1; // To fix the convention of positive current (1:
                          // along Oz, -1: along -Oz)

  Sc[Coil_1_M] = SurfaceArea[];
  SignBranch[Coil_1_M] = -1;

  Sc[Coil_2_P] = SurfaceArea[];
  SignBranch[Coil_2_P] = 1;

  Sc[Coil_2_M] = SurfaceArea[];
  SignBranch[Coil_2_M] = -1;

// Number of turns (same for PLUS and MINUS portions) (half values because
// half coils are defined)


Ns[Coil_1] = N1;
Ns[Coil_2] = N2;

// Global definitions (nothing to change):

// Current density in each coil portion for a unit current (will be multiplied
// by the actual total current in the coil)
  js0[Coils] = Ns[]/Sc[] * Vector[0,0,SignBranch[]];
  CoefGeos[Coils] = SignBranch[] * CoefGeo;

  mu0=4*Pi*1e-7;

  mu[Air] = 1 * mu0;

  //mur_Core = 100;
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
    val_E_in = 120.;
    phase_E_in = 0 *deg; // Phase in radian (from phase in degree)
    // High value for an open-circuit test; Low value for a short-circuit test;
    // any value in-between for any charge
    Resistance[R_out] = 10;
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
        // Coil_1 end-winding (not considered in the 2D model))
        { Region E_in; Branch {1,2}; }

        { Region Coil_1_P; Branch {2,3} ; }
        { Region Coil_1_M; Branch {3,1} ; }
      }
      Case Circuit_2 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // R_out (an additional resistor should be defined to represent the
        // Coil_2 end-winding (not considered in the 2D model))
        { Region R_out; Branch {1,2}; }

        { Region Coil_2_P; Branch {2,3} ; }
        { Region Coil_2_M; Branch {3,1} ; }
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
       { Region Coil_1; Value 1; TimeFunction F_Sin_wt_p[]{2*Pi*Freq, 0};  }
      { Region Coil_2; Value 0; }
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
      Print[ norm_of_b, OnElementsOf Vol_Mag, Format Gmsh, File "norm_of_b.pos" ];
      Print[ az, OnElementsOf Vol_Mag, Format Gmsh, File "az.pos" ];

      If (type_Source == 1) // current
        // In text file UI.txt: voltage and current for each coil portion (note
        // that the voltage is not equally distributed in PLUS and MINUS
        // portions, which is the reason why we must apply the total voltage
        // through a circuit -> type_Source == 2)
        Echo[ "Coil_1_P", Format Table, File "UI.txt" ];
        Print[ U, OnRegion Coil_1_P, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion Coil_1_P, Format FrequencyTable, File > "UI.txt"];
        Echo[ "Coil_1_M", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion Coil_1_M, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion Coil_1_M, Format FrequencyTable, File > "UI.txt"];

        Echo[ "Coil_2_P", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion Coil_2_P, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion Coil_2_P, Format FrequencyTable, File > "UI.txt"];
        Echo[ "Coil_2_M", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion Coil_2_M, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion Coil_2_M, Format FrequencyTable, File > "UI.txt"];

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

        
        Print[ norm_of_b, OnLine { {-width_Core/2,0,0} {-width_Core/2 + width_Core_Leg,0,0} } {200}, Format Table, File "norm_of_b_line.txt"];
        Print[ norm_of_b, OnElementsOf Core ,Format Table, File "norm_of_b.txt"];
        
      EndIf
    }
  }
}
