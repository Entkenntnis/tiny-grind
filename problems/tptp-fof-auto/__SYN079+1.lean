theorem SYN079_plus_1 : (_U : Type) -> (f_f_2 : _U -> _U -> _U) -> (f_a_0 : _U) -> (f_b_0 : _U) -> (f_c_0 : _U) -> (p_big_f_2 : _U -> _U -> Prop) -> (pel57_1 : p_big_f_2 (f_f_2 f_a_0 f_b_0) (f_f_2 f_b_0 f_c_0)) -> (pel57_2 : p_big_f_2 (f_f_2 f_b_0 f_c_0) (f_f_2 f_a_0 f_c_0)) -> (pel57_3 : (X : _U) -> (Y : _U) -> (Z : _U) -> And (p_big_f_2 X Y) (p_big_f_2 Y Z) -> p_big_f_2 X Z) -> p_big_f_2 (f_f_2 f_a_0 f_b_0) (f_f_2 f_a_0 f_c_0) :=
  by grind

