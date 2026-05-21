theorem LCL666_plus_1_dot_001 : (_U : Type) -> (p_r1_2 : _U -> _U -> Prop) -> (p_p201_1 : _U -> Prop) -> (p_p101_1 : _U -> Prop) -> (reflexivity : (X : _U) -> p_r1_2 X X) -> Not (@Exists _U (fun (X : _U) => Not (Not ((Y : _U) -> Or (Or (Not (p_r1_2 X Y)) (Not (And (p_p201_1 Y) (p_p101_1 Y)))) (Not (And (p_p201_1 X) (p_p101_1 X))))))) :=
  by grind

