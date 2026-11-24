within TRANSFORM.Fluid.Types;
type ImpellerScaling = enumeration(
    Similar
      "Geometrically similar pump: flow ~ D^3, head ~ D^2, power ~ D^5",
    Trimmed
      "Same pump with its impeller trimmed: flow ~ D, head ~ D^2, power ~ D^3")
  "Affinity law used when a pump's impeller diameter differs from its nominal diameter";
