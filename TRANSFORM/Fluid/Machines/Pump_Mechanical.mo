within TRANSFORM.Fluid.Machines;
model Pump_Mechanical
  extends BaseClasses.PartialPump_nom;

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (Placement(
        transformation(extent={{-10,50},{10,70}}, rotation=0),
        iconTransformation(extent={{-10,50},{10,70}})));

  SI.Power Q_mech "Mechanical power added to system (i.e., pumping power)";
  SI.Angle phi(start=0) "Shaft rotation angle";
  SI.Torque tau "Net torque acting on the turbine";
  SI.AngularVelocity omega=N*2*Modelica.Constants.pi/60
    "Shaft angular velocity";

equation

  // Mechanical shaft power
  W = Q_mech;
  Q_mech = omega*tau;

  // Mechanical boundary conditions
  tau = shaft.tau;
  shaft.phi = phi;
  der(phi) = omega;

  annotation (
    defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>A <code>diameter</code> other than <code>diameter_nominal</code> follows <code>impellerScaling</code>: with <code>Similar</code> (default) it is a geometrically similar pump, flow ~ D<sup>3</sup>, head ~ D<sup>2</sup>, power ~ D<sup>5</sup>; with <code>Trimmed</code> it is the same pump with its impeller cut down, flow ~ D, head ~ D<sup>2</sup>, power ~ D<sup>3</sup> and the same efficiency. The trimming law is an approximation for small cuts; where the manufacturer gives a curve for the trimmed diameter, that curve is more accurate.</p>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Pump_Mechanical;
