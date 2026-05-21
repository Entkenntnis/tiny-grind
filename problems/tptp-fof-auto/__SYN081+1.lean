theorem SYN081_plus_1 : (_U : Type) -> (f_f_1 : _U -> _U) -> (p_big_f_1 : _U -> Prop) -> (pel59_1 : (X : _U) -> Iff (p_big_f_1 X) (Not (p_big_f_1 (f_f_1 X)))) -> @Exists _U (fun (X : _U) => And (p_big_f_1 X) (Not (p_big_f_1 (f_f_1 X)))) :=
  by grind

