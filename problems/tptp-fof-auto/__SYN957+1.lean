theorem SYN957_plus_1 : (_U : Type) -> (p_a_2 : _U -> _U -> Prop) -> Not (@Exists _U (fun (Y : _U) => (X : _U) -> Iff (p_a_2 X Y) (Not (p_a_2 X X)))) :=
  by grind

