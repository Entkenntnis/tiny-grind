theorem SYN935_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_c_0 : Prop) -> @Exists _U (fun (X : _U) => Iff (p_p_1 X -> p_c_0) ((X : _U) -> p_p_1 X -> p_c_0)) :=
  by grind

