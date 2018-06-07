/* -------------------------------------------------------------------
   Tutorial 7b : magnetodyamic model of a single-phase transformer

   Features:
   - Use of a generic template formulation library
   - Frequency- and time-domain dynamic solutions
   - Circuit coupling used as a black-box (see Tutorial 8 for details)

   To compute the solution in a terminal:
       getdp transfo -solve Magnetodynamics2D_av -pos Map_a

   To compute the solution interactively from the Gmsh GUI:
       File > Open > transfo.pro
       Run (button at the bottom of the left panel)
   ------------------------------------------------------------------- */

Include "transfo_common_1phase_coil.pro";

DefineConstant[
  type_Conds = {2, Choices{1 = "Massive", 2 = "Coil"}, Highlight "Blue",
    Name "Parameters/01Conductor type"}
  type_Source = {2, Choices{1 = "Current", 2 = "Voltage"}, Highlight "Blue",
    Name "Parameters/02Source type"}
  type_Analysis = {1, Choices{1 = "Frequency-domain", 2 = "Time-domain"}, Highlight "Blue",
    Name "Parameters/03Analysis type"}
  Freq = {50, Min 0, Max 1e3, Step 1,
    Name "Parameters/Frequency"}
  R_out_value = {24/416.67, Min 0, Max 10^6, Step 100,
    Name "Parameters/R_out"}
];

Group {
  // Physical regions:
  Air = Region[{Air_window, Air_ext}];
  Sur_Air_Ext = Region[Sur_inf]; // exterior boundary
  Core = Region[Core]; // magnetic core of the transformer, assumed non-conducting
  Coil_1_P = Region[Coil_left_left]; // 1st coil, positive side
  Coil_1_M = Region[Coil_left_right]; // 1st coil, negative side
  Coil_1 = Region[{Coil_1_P, Coil_1_M}];
  Coil_2_P = Region[Coil_right_left]; // 2nd coil, positive side
  Coil_2_M = Region[Coil_right_right]; // 2nd coil, negative side
  Coil_2 = Region[{Coil_2_P, Coil_2_M}];
  Coils = Region[{Coil_1, Coil_2}];

  // Abstract regions that will be used in the "Lib_Magnetodynamics2D_av_Cir.pro"
  // template file included below;
  Vol_Mag = Region[{Air,Core,Coils}]; // full magnetic domain
  If (type_Conds == 1)
    Vol_C_Mag = Region[{Coils}]; // massive conductors
  ElseIf (type_Conds == 2)
    Vol_S_Mag = Region[{Coils}]; // stranded conductors (coils)
  EndIf
}

Function {
  mu0 = 4e-7*Pi;

  mu[Air] = 1 * mu0;

  mur_Core = 2000;
  mu[Core] = mur_Core * mu0;

  mu[Coils] = 1 * mu0;
  sigma[Coils] = 59.6*10^6;

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

  // Number of turns (same for PLUS and MINUS portions) 
  Ns[Coil_1] = 120;
  Ns[Coil_2] = 12;

  // Global definitions (nothing to change):

  // Current density in each coil portion for a unit current (will be multiplied
  // by the actual total current in the coil)
  js0[Coils] = Ns[]/Sc[] * Vector[0,0,SignBranch[]];
  CoefGeos[Coils] = SignBranch[] * CoefGeo;

  // The reluctivity will be used
  nu[] = 1/mu[];
}

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
    val_E_in = 240;
    phase_E_in = 0*deg; // Phase in radian (from phase in degree)
    // High value for an open-circuit test; Low value for a short-circuit test;
    // any value in-between for any charge
    Resistance[R_out] = R_out_value;
  }

  Constraint {

    { Name Current_Cir ;
      Case {
	  //{ Region E_in; Value 0.41667; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_E_in}; }
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
       { Region Coil_1; Value 0.41667; TimeFunction F_Sin_wt_p[]{2*Pi*Freq, 0};  }
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
      //Print[ j, OnElementsOf Region[{Vol_C_Mag, Vol_S_Mag}], Format Gmsh, File "j.pos" ];
      //Print[ norm_of_b, OnElementsOf Vol_Mag, Format Gmsh, File "b.pos" ];
	  //Print[ norm_of_b, OnElementsOf Vol_Mag, Format Gmsh, File "b.pos" ];
	  Print[ JouleLosses[Vol_S_Mag], OnGlobal, Format Table, File > "joule_losses.txt"];
	  //Print[ norm_of_b, OnLine {{cix,ciy,ciz}{cfx,cfy,cfz}}{ld},Format Table, File "Cut1_b_norm.txt" ];
	  //Print[ norm_of_b, OnLine {{cix,ciy,ciz}{cfx,cfy,cfz}}{ld},Format Gmsh, File "Cut1_b_norm.pos" ];

      //Print[ az, OnElementsOf Vol_Mag, Format Gmsh, File "az.pos" ];

      If (type_Source == 1) // current
        // In text file UI.txt: voltage and current for each coil portion (note
        // that the voltage is not equally distributed in PLUS and MINUS
        // portions, which is the reason why we must apply the total voltage
        // through a circuit -> type_Source == 2)
        Echo[ "Coil_1_P", Format Table, File > "UI.txt" ];
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
        //Echo[ "E_in", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion E_in, Format Table, File > "UI.txt" ];
        Print[ I, OnRegion E_in, Format Table, File > "UI.txt"];

        // In text file UI.txt: voltage and current of the secondary coil (from R_out)
        //Echo[ "R_out", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R_out, Format Table, File > "UI.txt" ];
        Print[ I, OnRegion R_out, Format Table, File > "UI.txt"];
      EndIf
    }
  }
}