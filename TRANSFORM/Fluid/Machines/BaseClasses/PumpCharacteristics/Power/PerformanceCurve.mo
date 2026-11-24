within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Power;
model PerformanceCurve   "Cubic spline of a characteristic curve of power vs. volume flow rate"
  extends PartialPowerChar;

  parameter SI.VolumeFlowRate V_flow_curve[:]={0,V_flow_nominal,1.5*
      V_flow_nominal} "Volume flow rate operating points (single pump)";
  parameter SI.Power W_curve[size(V_flow_curve, 1)]={0,W_nominal,2*W_nominal}
    "Pump head operating points";
  final parameter Real d_curve[size(V_flow_curve, 1)]=
      TRANSFORM.Math.splineDerivatives(
      x=V_flow_curve,
      y=W_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=W_curve, strict=false))
    "Spline tangents at the support points (precomputed once for analytic derivative)";

equation
  // The curve function is called with a relative speed of 1: affinityLaw_flow already scales
  // for speed, and the function would divide by it again.
  W =affinityLaw_power*Math.PerformanceCurve(
    V_flow/affinityLaw_flow,
    V_flow_curve,
    W_curve,
    d_curve,
    1);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PerformanceCurve;
