within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow;
model Quadratic
  "Quadratic head curve, signed in speed and flow; a stopped pump is a flow resistance"
  extends PartialFlowChar;

  parameter SI.Height head_shutoff=2*head_nominal
    "Head at zero flow and nominal speed (single pump)";
  parameter SI.VolumeFlowRate V_flow_small=0.01*V_flow_nominal
    "Flow below which the flow-resistance term turns linear (regularization)"
    annotation (Dialog(tab="Advanced"));

  Real s(start=V_flow_start/unit_V_flow)
    "Curvilinear abscissa for the flow curve with checkValve = true";

protected
  constant SI.Height unit_head=1;
  constant SI.VolumeFlowRate unit_V_flow=1;
  // The resistance uses regSquare, as Modelica.Fluid's flow resistances do, so that its
  // derivative is not zero at zero flow (a stopped pump in a stagnant loop). k_res divides
  // by the same regSquare, so the curve passes exactly through the nominal point.
  final parameter Real k_res(unit="s2/m5")=(head_shutoff - head_nominal)/
    Modelica.Fluid.Utilities.regSquare(V_flow_nominal, V_flow_small)
    "Flow-resistance coefficient";
  Real r_N=N/N_nominal "Relative speed";
  Real r_D=diameter/diameter_nominal "Relative impeller diameter";
  // SI.Length, not SI.Height: the term is negative when the pump turns backwards. abs() is
  // already free of events; noEvent() around it stopped OpenModelica from differentiating it.
  SI.Length head_speed=head_shutoff*r_N*abs(r_N)*r_D^2 "Speed term of the head";

equation
  assert(head_shutoff > head_nominal,
    "Quadratic pump curve: head_shutoff must be greater than head_nominal");
  // head = r_D^2*r_N^2*f(V_flow/(r_N*r_D^3)) with f(q) = head_shutoff - k_res*q^2, written so
  // that nothing divides by the speed: at N = 0 the head is -k_res*V_flow*|V_flow|/r_D^4.
  if checkValve then
    V_flow = homotopy(if s > 0 then s*unit_V_flow else 0, s*unit_V_flow);
    head = if s > 0 then head_speed - k_res*Modelica.Fluid.Utilities.regSquare(V_flow,
      V_flow_small)/r_D^4 else head_speed - s*unit_head;
  else
    s = 0;
    head = head_speed - k_res*Modelica.Fluid.Utilities.regSquare(V_flow, V_flow_small)/r_D^4;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quadratic pump characteristic, scaled by the affinity laws:</p>
<p><code>head = head_shutoff*r_N*|r_N|*r_D^2 - k_res*V_flow*|V_flow|/r_D^4</code></p>
<p>with <code>r_N = N/N_nominal</code>, <code>r_D = diameter/diameter_nominal</code> and
<code>k_res</code> set so that the curve passes through (<code>V_flow_nominal</code>,
<code>head_nominal</code>) at nominal speed. <code>head_shutoff</code> is the head at zero flow and
nominal speed; its default, twice the nominal head, matches the default curve of
<code>PerformanceCurve</code>.</p>
<p>Nothing divides by the speed, so the curve holds down to and at zero speed. A stopped pump is a
flow resistance that passes flow in either direction (unless <code>checkValve = true</code>), for
example natural circulation. At zero or positive speed, reverse flow meets a resistance that opposes
it. Below <code>V_flow_small</code> the resistance term turns linear
(<code>Modelica.Fluid.Utilities.regSquare</code>) so that its derivative is not zero at zero flow.</p>
<p>With the other characteristics in this package the head of a stopped pump goes to zero, so it
offers no resistance and the flow through it is limited only by the rest of the circuit. Use this
one when a pump may stop.</p>
</html>"));
end Quadratic;
