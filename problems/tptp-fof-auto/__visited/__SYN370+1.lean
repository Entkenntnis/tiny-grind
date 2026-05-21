theorem SYN370_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_h_1 : _U -> _U) -> (f_f_1 : _U -> _U) -> (p_big_p_3 : _U -> _U -> _U -> Prop) -> @Exists _U (fun (V : _U) => (Y : _U) -> @Exists _U (fun (Z : _U) => Or (p_big_p_3 f_a_0 Y (f_h_1 Y)) (p_big_p_3 V Y (f_f_1 Y)) -> p_big_p_3 V Y Z)) :=
  by grind

