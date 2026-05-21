theorem SYN084_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_f_1 : _U -> _U) -> (p_big_p_1 : _U -> Prop) -> (X : _U) -> Iff (And (p_big_p_1 f_a_0) (p_big_p_1 X -> p_big_p_1 (f_f_1 X)) -> p_big_p_1 (f_f_1 (f_f_1 X))) ((X1 : _U) -> And (Or (Or (Not (p_big_p_1 f_a_0)) (p_big_p_1 X1)) (p_big_p_1 (f_f_1 (f_f_1 X1)))) (Or (Or (Not (p_big_p_1 f_a_0)) (Not (p_big_p_1 (f_f_1 X1)))) (p_big_p_1 (f_f_1 (f_f_1 X1))))) :=
  by grind

