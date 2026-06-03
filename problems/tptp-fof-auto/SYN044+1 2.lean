theorem SYN044_plus_1 : (_U : Type) -> (p_q_0 : Prop) -> (p_r_0 : Prop) -> (p_p_0 : Prop) -> (pel10_1 : p_q_0 -> p_r_0) -> (pel10_2 : p_r_0 -> And p_p_0 p_q_0) -> (pel10_3 : p_p_0 -> Or p_q_0 p_r_0) -> Iff p_p_0 p_q_0 :=
  by grind

