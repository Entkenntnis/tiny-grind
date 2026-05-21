theorem SYN371_plus_1 : (_U : Type) -> (p_big_r_2 : _U -> _U -> Prop) -> @Exists _U (fun (X : _U) => p_big_r_2 X X -> (Y : _U) -> p_big_r_2 Y Y) -> @Exists _U (fun (U : _U) => (V : _U) -> p_big_r_2 U U -> p_big_r_2 V V) :=
  by grind

