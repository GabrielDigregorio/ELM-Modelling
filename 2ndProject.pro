Include "2ndProject_GUI.pro";

Group {
  // Physical regions
  Bundle1 = Region[203];
  Bundle2 = Region[204];
  Bundle3 = Region[205];
  Air     = Region[200];
  Shield1  = Region[206];
  Surface_Inf = Region[101];

  // Abstract regions used in the "Lib_MagStaDyn_av_2D_Cir.pro" template file
  // that is included below:
  Vol_CC_Mag = Region[{Air, Shield1}]; // Non-conducting regions
  Vol_C_Mag = Region[{Bundle1, Bundle2, Bundle3, Shield1}]; // Massive conducting regions
}

Function {
  mu0 = 4.e-7 * Pi;
  nu[ Region[{Air,Bundle1,Bundle2,Bundle3}] ]  = 1. / mu0;
  nu[ Shield ]  = 1. / (Mu_r_Shield1 * mu0);

  sigma[ Region[{Bundle1,Bundle2,Bundle3}] ] = 5e7;
  sigma[ Shield ] = SigmaShield1;

  CoefGeos[] = 1;
  Freq = 50;
}

Constraint {
  { Name MagneticVectorPotential_2D;
    Case {
      { Region Surface_Inf; Value 0; }
    }
  }
  { Name Current_2D;
    Case {
      { Region Bundle1; Value 1; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, 0}; }
      { Region Bundle2; Value 1; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, 2*Pi/3}; }
      { Region Bundle3; Value 1; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, 4*Pi/3}; }
      { Region Shield1; Value 0;  }
    }
  }
  { Name Voltage_2D;
    Case {
    }
  }
}

Include "Lib_MagStaDyn_av_2D_Cir.pro";

PostOperation {
  { Name Map_a; NameOfPostProcessing MagDyn_a_2D;
    Operation {
      Print[ az, OnElementsOf Vol_Mag, File "a.pos" ];
      Print[ j_Shield1, OnElementsOf Shield1, File "j_Shield1.pos" ];
      Print[ j_Bundle1, OnElementsOf Bundle1, File "j_Bundle1.pos" ];
      Print[ j_Bundle2, OnElementsOf Bundle2, File "j_Bundle1.pos" ];
      Print[ j_Bundle3, OnElementsOf Bundle3, File "j_Bundle1.pos" ];
      Print[ b, OnElementsOf Vol_Mag, File "b.pos" ];
    }
  }
}
