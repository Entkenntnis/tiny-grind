theorem SYN363_plus_1 : (_U : Type) -> (f_b_0 : _U) -> (f_a_0 : _U) -> (p_big_r_2 : _U -> _U -> Prop) -> ((X : _U) -> And (p_big_r_2 X f_b_0) ((Y : _U) -> @Exists _U (fun (Z : _U) => p_big_r_2 Y Z -> p_big_r_2 f_a_0 Y))) -> @Exists _U (fun (U : _U) => (V : _U) -> p_big_r_2 U V) :=
  by grind

