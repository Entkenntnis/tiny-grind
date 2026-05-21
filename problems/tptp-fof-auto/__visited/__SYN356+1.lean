theorem SYN356_plus_1 : (_U : Type) -> (f_a_0 : _U) -> (f_b_0 : _U) -> (p_big_r_2 : _U -> _U -> Prop) -> (p_big_q_2 : _U -> _U -> Prop) -> And (p_big_r_2 f_a_0 f_b_0) ((X : _U) -> (Y : _U) -> And (p_big_r_2 X Y -> And (p_big_r_2 Y X) (p_big_q_2 X Y)) ((U : _U) -> (V : _U) -> p_big_q_2 U V -> p_big_q_2 U U)) -> And (p_big_q_2 f_a_0 f_a_0) (p_big_q_2 f_b_0 f_b_0) :=
  by grind

