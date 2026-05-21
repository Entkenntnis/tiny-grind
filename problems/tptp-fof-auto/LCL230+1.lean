theorem LCL230_plus_1 : (_U : Type) -> (p_p_0 : Prop) -> (p_q_0 : Prop) -> (p_r_0 : Prop) -> (Or p_p_0 p_q_0 -> Or p_p_0 p_r_0) -> Or p_p_0 (p_q_0 -> p_r_0) :=
  by grind

