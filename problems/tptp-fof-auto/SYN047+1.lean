theorem SYN047_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_q_0 : Prop) -> (p_r_0 : Prop) -> (p_s_0 : Prop) -> Iff (And p_p_0 (p_q_0 -> p_r_0) -> p_s_0) (And (Or (Or (Not p_p_0) p_q_0) p_s_0) (Or (Or (Not p_p_0) (Not p_r_0)) p_s_0)) :=
  by grind

