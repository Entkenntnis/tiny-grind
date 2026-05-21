theorem LCL678_plus_1_dot_001 : (_U : Type) -> (p_r1_2 : _U -> _U -> Prop) -> (p_p1_1 : _U -> Prop) -> (reflexivity : (X : _U) -> p_r1_2 X X) -> (transitivity : (X : _U) -> (Y : _U) -> (Z : _U) -> And (p_r1_2 X Y) (p_r1_2 Y Z) -> p_r1_2 X Z) -> Not (@Exists _U (fun (X : _U) => Not (Or False (Not ((Y : _U) -> Or (Or (Not (p_r1_2 X Y)) False) (Not ((X : _U) -> Or (Not (p_r1_2 Y X)) ((Y : _U) -> Or (Or (Not (p_r1_2 X Y)) (p_p1_1 Y)) (Not ((Y : _U) -> Or (Not (p_r1_2 X Y)) (p_p1_1 Y))))))))))) :=
  by grind

