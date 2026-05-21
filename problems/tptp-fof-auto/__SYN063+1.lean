theorem SYN063_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_b_0 : _U) -> (f_c_0 : _U) -> (p_big_p_1 : _U -> Prop) -> (X : _U) -> Iff (And (p_big_p_1 f_a_0) (p_big_p_1 X -> p_big_p_1 f_b_0) -> p_big_p_1 f_c_0) ((X1 : _U) -> And (Or (Or (Not (p_big_p_1 f_a_0)) (p_big_p_1 X1)) (p_big_p_1 f_c_0)) (Or (Or (Not (p_big_p_1 f_a_0)) (Not (p_big_p_1 f_b_0))) (p_big_p_1 f_c_0))) :=
  by grind

