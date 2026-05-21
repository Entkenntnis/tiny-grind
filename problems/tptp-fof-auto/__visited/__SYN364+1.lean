theorem SYN364_plus_1 : (_U : Type) -> (f_f_2 : _U -> _U -> _U) -> (f_g_1 : _U -> _U) -> (p_big_p_2 : _U -> _U -> Prop) -> (p_big_m_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> ((X : _U) -> And (@Exists _U (fun (Y : _U) => p_big_p_2 X Y -> (Z : _U) -> p_big_p_2 Z Z)) ((U : _U) -> @Exists _U (fun (V : _U) => And (Or (p_big_p_2 U V) (And (p_big_m_1 U) (p_big_q_1 (f_f_2 U V)))) ((W : _U) -> p_big_q_1 W -> Not (p_big_m_1 (f_g_1 W)))))) -> (U : _U) -> @Exists _U (fun (V : _U) => And (p_big_p_2 (f_g_1 U) V) (p_big_p_2 U U)) :=
  by grind

