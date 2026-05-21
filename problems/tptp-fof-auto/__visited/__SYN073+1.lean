theorem SYN073_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (p_big_f_2 : _U -> _U -> Prop) -> (X : _U) -> Or (p_big_f_2 f_a_0 X) ((Y : _U) -> p_big_f_2 X Y) -> @Exists _U (fun (X1 : _U) => (Y1 : _U) -> p_big_f_2 X1 Y1) :=
  by grind

