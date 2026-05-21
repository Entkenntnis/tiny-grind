theorem KRS136_plus_1 : (_U : Type) -> (p_cowlThing_1 : _U -> Prop) -> (p_cowlNothing_1 : _U -> Prop) -> (p_xsd_string_1 : _U -> Prop) -> (p_xsd_integer_1 : _U -> Prop) -> (axiom_0 : (X : _U) -> And (p_cowlThing_1 X) (Not (p_cowlNothing_1 X))) -> (axiom_1 : (X : _U) -> Iff (p_xsd_string_1 X) (Not (p_xsd_integer_1 X))) -> (X : _U) -> And (And (p_cowlThing_1 X) (Not (p_cowlNothing_1 X))) ((X : _U) -> Iff (p_xsd_string_1 X) (Not (p_xsd_integer_1 X))) :=
  by grind

