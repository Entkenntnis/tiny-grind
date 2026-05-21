theorem LCL648_plus_1_dot_001 : (_U : Type) -> (p_r1_2 : _U -> _U -> Prop) -> (p_p201_1 : _U -> Prop) -> (p_p101_1 : _U -> Prop) -> Not (@Exists _U (fun (X : _U) => Not (Not ((Y : _U) -> Or (Or (Not (p_r1_2 X Y)) (Not (And (p_p201_1 Y) (p_p101_1 Y)))) ((Y : _U) -> Or (Not (p_r1_2 X Y)) (Not (And (p_p201_1 Y) (p_p101_1 Y)))))))) :=
  by grind

