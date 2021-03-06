within TRANSFORM.HeatExchangers;
model LMTD_HX_Area "Log mean temperature difference heat exchanger"
  replaceable package Medium_1 =
      Modelica.Media.IdealGases.SingleGases.He
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);
  replaceable package Medium_2 = Modelica.Media.Air.DryAirNasa constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

  SI.Power Q_flow(start=1);
  input SI.CoefficientOfHeatTransfer alpha_1 = 800 annotation(Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alpha_2 = 4000 annotation(Dialog(group="Inputs"));
  SI.ThermalConductance UA;
  SI.TemperatureDifference dT_LM;
  parameter SI.Area surfaceArea;

Medium_1.ThermodynamicState state_a_1;
Medium_1.ThermodynamicState state_b_1;

Medium_2.ThermodynamicState state_a_2;
Medium_2.ThermodynamicState state_b_2;

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a1(redeclare package Medium =
        Medium_1) annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b1(redeclare package Medium =
        Medium_1) annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a2(redeclare package Medium =
        Medium_2) annotation (Placement(transformation(extent={{-110,30},{-90,50}}),
        iconTransformation(extent={{-110,30},{-90,50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b2(redeclare package Medium =
        Medium_2) annotation (Placement(transformation(extent={{90,30},{110,50}}),
        iconTransformation(extent={{90,30},{110,50}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume1(redeclare package Medium =
        Medium_1, use_HeatPort=true)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance1(
      redeclare package Medium = Medium_1, R=1)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary1(
      use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-10})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume2(redeclare package Medium =
        Medium_2, use_HeatPort=true)
    annotation (Placement(transformation(extent={{-50,50},{-30,30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary2(
      use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,70})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance2(
      redeclare package Medium = Medium_2, R=1)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a1(redeclare package
      Medium = Medium_1)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b1(redeclare package
      Medium = Medium_1)
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a2(redeclare package
      Medium = Medium_2)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b2(redeclare package
      Medium = Medium_2)
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Blocks.Sources.RealExpression boundary2_input(y=Q_flow)
    annotation (Placement(transformation(extent={{0,70},{-20,90}})));
  Modelica.Blocks.Sources.RealExpression boundary1_input(y=-Q_flow)
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
equation
  Q_flow = UA*dT_LM;
  dT_LM = TRANSFORM.HeatExchangers.Utilities.Functions.logMean(sensor_T_a1.T -
    sensor_T_b1.T, sensor_T_b2.T - sensor_T_a2.T);
  UA = 1/(1/(alpha_1*surfaceArea) + 1/(alpha_2*surfaceArea));

  // Properties
  state_a_1 = Medium_1.setState_phX(
    port_a1.p,
    inStream(port_a1.h_outflow),
    inStream(port_a1.Xi_outflow));
  state_b_1 = Medium_1.setState_phX(
    port_b1.p,
    inStream(port_b1.h_outflow),
    inStream(port_b1.Xi_outflow));

  state_a_2 = Medium_2.setState_phX(
    port_a2.p,
    inStream(port_a2.h_outflow),
    inStream(port_a2.Xi_outflow));
  state_b_2 = Medium_2.setState_phX(
    port_b2.p,
    inStream(port_b2.h_outflow),
    inStream(port_b2.Xi_outflow));

  connect(volume1.port_b, resistance1.port_a)
    annotation (Line(points={{-34,-40},{3,-40}}, color={0,127,255}));
  connect(volume1.heatPort, boundary1.port)
    annotation (Line(points={{-40,-34},{-40,-20}}, color={191,0,0}));
  connect(volume2.port_b, resistance2.port_a)
    annotation (Line(points={{-34,40},{3,40}}, color={0,127,255}));
  connect(boundary2.port, volume2.heatPort)
    annotation (Line(points={{-40,60},{-40,46}}, color={191,0,0}));
  connect(port_a1, sensor_T_a1.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
  connect(sensor_T_a1.port_b, volume1.port_a)
    annotation (Line(points={{-60,-40},{-46,-40}}, color={0,127,255}));
  connect(resistance1.port_b, sensor_T_b1.port_a)
    annotation (Line(points={{17,-40},{60,-40}}, color={0,127,255}));
  connect(sensor_T_b1.port_b, port_b1)
    annotation (Line(points={{80,-40},{100,-40}}, color={0,127,255}));
  connect(port_a2, sensor_T_a2.port_a)
    annotation (Line(points={{-100,40},{-80,40}}, color={0,127,255}));
  connect(sensor_T_a2.port_b, volume2.port_a)
    annotation (Line(points={{-60,40},{-46,40}}, color={0,127,255}));
  connect(resistance2.port_b, sensor_T_b2.port_a)
    annotation (Line(points={{17,40},{60,40}}, color={0,127,255}));
  connect(sensor_T_b2.port_b, port_b2)
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(boundary2_input.y, boundary2.Q_flow_ext)
    annotation (Line(points={{-21,80},{-40,80},{-40,74}}, color={0,0,127}));
  connect(boundary1_input.y, boundary1.Q_flow_ext)
    annotation (Line(points={{-21,0},{-40,0},{-40,-6}}, color={0,0,127}));
  annotation (defaultComponentName="lmtd_HX",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,40},{-60,40},{-30,0},{0,40},{30,0},{60,40},{88,40}},
            color={28,108,200}),
        Line(points={{-88,-40},{-30,-40},{0,0},{30,-40},{88,-40}}, color={238,46,
              47}),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Assumption:</p>
<p>Side 1 is hot side (i.e,. if Q_flow &lt; 0 then heat is going from Side 1 to Side 2)</p>
</html>"));
end LMTD_HX_Area;
