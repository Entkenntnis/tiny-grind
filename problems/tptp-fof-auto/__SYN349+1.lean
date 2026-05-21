theorem SYN349_plus_1 : (_U : Type) -> (p_big_f_2 : _U -> _U -> Prop) -> @Exists _U (fun (X1 : _U) => (X2 : _U) -> @Exists _U (fun (X3 : _U) => (X4 : _U) -> Iff (p_big_f_2 X1 X4) (p_big_f_2 X2 X4) -> Iff (Iff (Iff (p_big_f_2 X1 X4) (p_big_f_2 X4 X3)) (p_big_f_2 X3 X4)) (p_big_f_2 X4 X2))) :=
  by grind

