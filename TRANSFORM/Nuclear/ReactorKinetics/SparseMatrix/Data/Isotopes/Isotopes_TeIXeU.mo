within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes;
record Isotopes_TeIXeU
  "Te-135, I-135, Xe-135 and U-235 with thermal (2200 m/s) one-group cross-sections"
  // One spectrum throughout: the kinetics model takes the flux from the power and the U-235
  // fission cross-section and applies every other cross-section to that flux. U-235 at 0.0253 eV:
  // fission 587.3 b, capture 99.5 b (absorption 686.8 b), nu 2.43; Xe-135 absorption 2.6e6 b.
  // Production of Te-135 and Xe-135 is yield per fission times the fission cross-section.
  extends PartialIsotopes(
    extraPropertiesNames={"te135","i135","xe135","u235"},
    SIZZZAAA= fill(0, nC),
    C_nominal=fill(1e26, nC),
    molarMass={0.1276,0.135918,0.13490723,0.23504393},
    actinideIndex = {4},
    lambdas={log(2)/19,log(2)/23760,log(2)/32760,0},
    sigmasA=1e-28*{0,0,2.6e6,686.8},
    w_c=fill(0,nC),
    sigmasF=1e-28*{587.3},
    w_f=1.6022e-13*{200},
    nus={2.43},
    w_near_decay=1.6022e-16*{6000,1300,910,0},
    w_far_decay=1.6022e-16*{603.5,1260.4,249.8,0},
    l_lambdas_col={1,2},
    l_lambdas_count={0,1,1,0},
    l_lambdas={1.0*log(2)/19,1.0*log(2)/23760},
    f_sigmasA_col={4,4},
    f_sigmasA_count={1,0,1,0},
    f_sigmasA={0.061*587.3e-28,0.003*587.3e-28},
    transitionMT=fill(0,size(f_sigmasA_col,1)));

end Isotopes_TeIXeU;
