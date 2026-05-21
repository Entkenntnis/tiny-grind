theorem SYN315_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_p_0 : Prop) -> @Exists _U (fun (X : _U) => (Y : _U) -> Iff (p_big_f_1 X) p_p_0 -> Iff (p_big_f_1 Y) p_p_0) :=
  by grind

