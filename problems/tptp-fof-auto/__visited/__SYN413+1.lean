theorem SYN413_plus_1 : (_U : Type) -> (p_f_2 : _U -> _U -> Prop) -> (Z : _U) -> @Exists _U (fun (Y : _U) => (X : _U) -> Iff (p_f_2 X Y) (And (p_f_2 X Z) (Not (p_f_2 X X))) -> Not (@Exists _U (fun (V : _U) => (U : _U) -> p_f_2 U V))) :=
  by grind

