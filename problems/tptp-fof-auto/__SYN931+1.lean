theorem SYN931_plus_1 : (_U : Type) -> (p_p_1 : _U -> Prop) -> (p_c_0 : Prop) -> @Exists _U (fun (X : _U) => Iff (And (p_p_1 X) p_c_0) (@Exists _U (fun (X : _U) => And (p_p_1 X) p_c_0))) :=
  by grind

