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

Include "transfo_common_3phases.pro";

DefineConstant[
  type_Conds = {2, Choices{1 = "Massive", 2 = "Coil"}, Highlight "Blue",
    Name "Parameters/01Conductor type"}
  type_Source = {2, Choices{1 = "Current", 2 = "Voltage"}, Highlight "Blue",
    Name "Parameters/02Source type"}
  type_Analysis = {1, Choices{1 = "Frequency-domain", 2 = "Time-domain"}, Highlight "Blue",
    Name "Parameters/03Analysis type"}
  Freq = {50, Min 0, Max 1e3, Step 1,
    Name "Parameters/Frequency"}
];

Group {
  // Physical regions:
  Air = Region[{Air_windowel,Air_windower,Air_windowcl, Air_windowcr,Air_ext}];
  Sur_Air_Ext = Region[Sur_inf]; // exterior boundary
  Core = Region[Core]; // magnetic core of the transformer, assumed non-conducting
  
  //Central phase 
  Coil_c1_P = Region[Coil_central_1left]; // 1st coil, positive side
  Coil_c1_M = Region[Coil_central_1right]; // 1st coil, negative side
  Coil_c1 = Region[{Coil_c1_P, Coil_c1_M}];
  Coil_c2_P = Region[Coil_central_2left]; // 2nd coil, positive side
  Coil_c2_M = Region[Coil_central_2right]; // 2nd coil, negative side
  Coil_c2 = Region[{Coil_c2_P, Coil_c2_M}];
  Coils_c = Region[{Coil_c1, Coil_c2}];
  
  //left phase 
  Coil_l1_P = Region[Coil_left_1left]; // 1st coil, positive side
  Coil_l1_M = Region[Coil_left_1right]; // 1st coil, negative side
  Coil_l1 = Region[{Coil_l1_P, Coil_l1_M}];
  Coil_l2_P = Region[Coil_left_2left]; // 2nd coil, positive side
  Coil_l2_M = Region[Coil_left_2right]; // 2nd coil, negative side
  Coil_l2 = Region[{Coil_l2_P, Coil_l2_M}];
  Coils_l = Region[{Coil_l1, Coil_l2}];
  
  //right phase 
  Coil_r1_P = Region[Coil_right_1left]; // 1st coil, positive side
  Coil_r1_M = Region[Coil_right_1right]; // 1st coil, negative side
  Coil_r1 = Region[{Coil_r1_P, Coil_r1_M}];
  Coil_r2_P = Region[Coil_right_2left]; // 2nd coil, positive side
  Coil_r2_M = Region[Coil_right_2right]; // 2nd coil, negative side
  Coil_r2 = Region[{Coil_r2_P, Coil_r2_M}];
  Coils_r = Region[{Coil_r1, Coil_r2}];
  
  // All coils
  Coils = Region[{Coils_c,Coils_l,Coils_r}];
  
  // Abstract regions that will be used in the "Lib_Magnetodynamics2D_av_Cir.pro"
  // template file included below;
  Vol_Mag = Region[{Air, Core, Coils}]; // full magnetic domain
  If (type_Conds == 1)
    Vol_C_Mag = Region[{Coils}]; // massive conductors
  ElseIf (type_Conds == 2)
    Vol_S_Mag = Region[{Coils}]; // stranded conductors (coils)
  EndIf
}

Function {
  mu0 = 4e-7*Pi;

  mu[Air] = 1 * mu0;

  mur_Core = 100;
  mu[Core] = mur_Core * mu0;

  mu[Coils] = 1 * mu0;
  sigma[Coils] = 1e7;

  // For a correct definition of the voltage
  CoefGeo = thickness_Core;

  // To be defined separately for each coil portion
  
  //central coil
  Sc[Coil_c1_P] = SurfaceArea[];
  SignBranch[Coil_c1_P] = 1; // To fix the convention of positive current (1:
                            // along Oz, -1: along -Oz)

  Sc[Coil_c1_M] = SurfaceArea[];
  SignBranch[Coil_c1_M] = -1;

  Sc[Coil_c2_P] = SurfaceArea[];
  SignBranch[Coil_c2_P] = 1;

  Sc[Coil_c2_M] = SurfaceArea[];
  SignBranch[Coil_c2_M] = -1;

  //left coil
  Sc[Coil_l1_P] = SurfaceArea[];
  SignBranch[Coil_l1_P] = 1; // To fix the convention of positive current (1:
                            // along Oz, -1: along -Oz)

  Sc[Coil_l1_M] = SurfaceArea[];
  SignBranch[Coil_l1_M] = -1;

  Sc[Coil_l2_P] = SurfaceArea[];
  SignBranch[Coil_l2_P] = 1;

  Sc[Coil_l2_M] = SurfaceArea[];
  SignBranch[Coil_l2_M] = -1;
  
  //right coil
  Sc[Coil_r1_P] = SurfaceArea[];
  SignBranch[Coil_r1_P] = 1; // To fix the convention of positive current (1:
                            // along Oz, -1: along -Oz)

  Sc[Coil_r1_M] = SurfaceArea[];
  SignBranch[Coil_r1_M] = -1;

  Sc[Coil_r2_P] = SurfaceArea[];
  SignBranch[Coil_r2_P] = 1;

  Sc[Coil_r2_M] = SurfaceArea[];
  SignBranch[Coil_r2_M] = -1; 
  
  // Number of turns (same for PLUS and MINUS portions) (half values because
  // half coils are defined)
  Ns[Coil_c1] = 600;
  Ns[Coil_c2] = 60;
  Ns[Coil_l1] = 600;
  Ns[Coil_l2] = 60;
  Ns[Coil_r1] = 600;
  Ns[Coil_r2] = 60;

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
    E1_in = Region[10001]; // arbitrary region number (not linked to the mesh)
	E2_in = Region[10002];
	E3_in = Region[10003];
    SourceV_Cir += Region[{E1_in}];
	SourceV_Cir += Region[{E2_in}];
	SourceV_Cir += Region[{E3_in}];
	
    // Secondary side
    R1_out = Region[10101]; // arbitrary region number (not linked to the mesh)
	R2_out = Region[10102];
	R3_out = Region[10103];
    Resistance_Cir += Region[{R1_out}];
	Resistance_Cir += Region[{R2_out}];
	Resistance_Cir += Region[{R3_out}];
  }

  Function {
    deg = Pi/180;
    // Input RMS voltage (half of the voltage because of symmetry; half coils
    // are defined)
    val_E1_in = 0;
	val_E2_in = 240;
	val_E3_in = 240;
    phase_E1_in = 0 *deg; 
	phase_E2_in = 240 *deg;
	phase_E3_in = 120 *deg;
    Resistance[R1_out] = 24/4.1667;
	Resistance[R2_out] = 24/4.1667;
	Resistance[R3_out] = 24/4.1667;
  }

  Constraint {

    { Name Current_Cir ;
      Case {
      }
    }

    { Name Voltage_Cir ;
      Case {
        { Region E1_in; Value val_E1_in; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_E1_in}; }
		{ Region E2_in; Value val_E2_in; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_E2_in}; }
		{ Region E3_in; Value val_E3_in; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_E3_in}; }
      }
    }

    { Name ElectricalCircuit ; Type Network ;
      Case Circuit_1 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // E_in (an additional resistor should be defined to represent the
        // Coil_1 end-winding (not considered in the 2D model))
		
		{ Region E1_in; Branch {1,2}; }

        { Region Coil_c1_P; Branch {2,4} ; }
        { Region Coil_c1_M; Branch {4,1} ; }
      
	  }
      Case Circuit_2 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // R_out (an additional resistor should be defined to represent the
        // Coil_2 end-winding (not considered in the 2D model))
        { Region R1_out; Branch {1,2}; }

        { Region Coil_c2_P; Branch {2,4} ; }
        { Region Coil_c2_M; Branch {4,1} ; }
      }
	  Case Circuit_3 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // E_in (an additional resistor should be defined to represent the
        // Coil_1 end-winding (not considered in the 2D model))
        { Region E2_in; Branch {2,3}; }

        { Region Coil_l1_P; Branch {3,5} ; }
        { Region Coil_l1_M; Branch {5,2} ; }
      }
      Case Circuit_4 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // R_out (an additional resistor should be defined to represent the
        // Coil_2 end-winding (not considered in the 2D model))
        { Region R2_out; Branch {2,3}; }

        { Region Coil_l2_P; Branch {3,5} ; }
        { Region Coil_l2_M; Branch {5,2} ; }
      }
	  Case Circuit_5 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // E_in (an additional resistor should be defined to represent the
        // Coil_1 end-winding (not considered in the 2D model))
        { Region E3_in; Branch {3,1}; }

        { Region Coil_r1_P; Branch {1,6} ; }
        { Region Coil_r1_M; Branch {6,3} ; }
      }
      Case Circuit_6 {
        // PLUS and MINUS coil portions to be connected in series, together with
        // R_out (an additional resistor should be defined to represent the
        // Coil_2 end-winding (not considered in the 2D model))
        { Region R3_out; Branch {3,1}; }

        { Region Coil_r2_P; Branch {1,6} ; }
        { Region Coil_r2_M; Branch {6,3} ; }
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
      Print[ norm_of_b, OnElementsOf Vol_Mag, Format Gmsh, File "b.pos" ];
      //Print[ az, OnElementsOf Vol_Mag, Format Gmsh, File "az.pos" ];

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
        //Echo[ "E1_in", Format Table, File "UI.txt" ];
        Print[ U, OnRegion E1_in, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E1_in, Format FrequencyTable, File > "UI.txt"];

        //Echo[ "R1_out", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R1_out, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R1_out, Format FrequencyTable, File > "UI.txt"];
		
		//Echo[ "E2_in", Format Table, File "UI.txt" ];
        Print[ U, OnRegion E2_in, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E2_in, Format FrequencyTable, File > "UI.txt"];

        //Echo[ "R2_out", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R2_out, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R2_out, Format FrequencyTable, File > "UI.txt"];
		
		//Echo[ "E3_in", Format Table, File "UI.txt" ];
        Print[ U, OnRegion E3_in, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E3_in, Format FrequencyTable, File > "UI.txt"];

        //Echo[ "R3_out", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R3_out, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R3_out, Format FrequencyTable, File > "UI.txt"];
		
      EndIf
    }
  }
}