within TRANSFORM.Nuclear.FuelModels.Examples;
model Regions_1_FD2DCyl_Test
  import TRANSFORM;
    extends TRANSFORM.Icons.Example;
  TRANSFORM.Nuclear.FuelModels.Regions_1_FD2DCyl fuelModel(
    nR_1=5,
    nZ=10,
    redeclare package Material_1 = TRANSFORM.Media.Solids.UO2,
    energyDynamics=system.energyDynamics,
    length=1,
    r_1_outer=0.005,
    Ts_start_1=[fill(
        fuelModel.T_start_1,
        fuelModel.nR_1 - 1,
        fuelModel.nZ); {fixedTemperature.T}],
    T_start_1=773.15)
    annotation (Placement(transformation(extent={{-12,-32},{52,32}})));
  Modelica.Blocks.Sources.Constant const(k=10e3)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  inner TRANSFORM.Fluid.System    system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TRANSFORM.Nuclear.PowerProfiles.GenericPowerProfile powerProfile(nNodes=
        fuelModel.nZ)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.FixedTemperature_FD
    fixedTemperature(nNodes=fuelModel.nZ, T=300*ones(fuelModel.nZ))
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
equation
  connect(powerProfile.Q_totalshaped, fuelModel.Power_in)
    annotation (Line(points={{-39,0},{-15.2,0}},color={0,0,127}));
  connect(const.y, powerProfile.Q_total)
    annotation (Line(points={{-79,0},{-62,0},{-62,0}}, color={0,0,127}));
  connect(fixedTemperature.port, fuelModel.heatPorts_b)
    annotation (Line(points={{80,0},{52.64,0},{52.64,0.32}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end Regions_1_FD2DCyl_Test;
