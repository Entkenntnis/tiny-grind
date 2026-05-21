theorem SYN376_plus_1 : (_U : Type) -> (p_big_p_1 : _U -> Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> Iff (p_big_p_1 Y) (p_big_p_1 X) -> (X : _U) -> Or (p_big_p_1 X) ((X : _U) -> Not (p_big_p_1 X))) :=
  by grind

