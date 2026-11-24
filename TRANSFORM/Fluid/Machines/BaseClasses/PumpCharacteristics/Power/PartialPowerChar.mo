within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Power;
partial model PartialPowerChar
  "Base class for pump power characteristics"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (Dialog(tab="Internal Interface"));

  input SI.VolumeFlowRate V_flow annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input Medium.ThermodynamicState state "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input Modelica.Units.NonSI.AngularVelocity_rpm N "Pump speed"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length diameter "Impeller Diameter"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  parameter SI.VolumeFlowRate V_flow_start annotation (Dialog(tab="Internal Interface", group="Initialization"));

  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal
    "Pump speed" annotation (Dialog(tab="Internal Interface", group=
         "Nominal Operating Parameters"));
  parameter SI.Length diameter_nominal "Impeller Diameter" annotation (Dialog(
        tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.VolumeFlowRate V_flow_nominal "Nominal volumetric flow rate"
    annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
   parameter SI.Density d_nominal "Nominal density"
     annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));

  parameter SI.Power W_nominal "Power consumption" annotation (Dialog(
        tab="Internal Interface", group="Nominal Operating Parameters"));

  SI.Power W "Power consumption";
  parameter TRANSFORM.Fluid.Types.ImpellerScaling impellerScaling=
    TRANSFORM.Fluid.Types.ImpellerScaling.Similar
    "Affinity law for a diameter other than diameter_nominal" annotation (Evaluate=true,
      Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
protected
  final parameter Real n_D=if impellerScaling == TRANSFORM.Fluid.Types.ImpellerScaling.Similar
       then 3 else 1
    "Exponent of diameter/diameter_nominal in the flow affinity law (power: n_D + 2)";
public
  SItf.NonDim affinityLaw_flow = (N/N_nominal)*(diameter/diameter_nominal)^n_D "Affinity law for scaling";
  SItf.NonDim affinityLaw_power = Medium.density(state)/d_nominal*(N/N_nominal)^3*(diameter/diameter_nominal)^(n_D + 2) "Affinity law for scaling";

  annotation (defaultComponentName="flowCurve",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          textColor={0,0,0},
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPowerChar;
