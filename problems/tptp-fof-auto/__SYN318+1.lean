theorem SYN318_plus_1 : (_U : Type) -> (p_big_f_1 : _U -> Prop) -> (p_big_g_1 : _U -> Prop) -> (p_p_0 : Prop) -> @Exists _U (fun (Y : _U) => (X : _U) -> (p_big_f_1 X -> p_big_f_1 Y -> p_big_g_1 X) -> p_p_0 -> (X : _U) -> p_big_f_1 X -> p_big_g_1 Y) :=
  by grind

