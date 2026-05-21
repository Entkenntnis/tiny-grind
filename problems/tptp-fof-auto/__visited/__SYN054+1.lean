theorem SYN054_plus_1 : (_U : Type) -> (p_big_s_1 : _U -> Prop) -> (p_big_q_1 : _U -> Prop) -> (p_big_p_1 : _U -> Prop) -> (p_big_r_1 : _U -> Prop) -> (pel24_1 : Not (@Exists _U (fun (X : _U) => And (p_big_s_1 X) (p_big_q_1 X)))) -> (pel24_2 : (X : _U) -> p_big_p_1 X -> Or (p_big_q_1 X) (p_big_r_1 X)) -> (pel24_3 : Not (@Exists _U (fun (X : _U) => p_big_p_1 X -> @Exists _U (fun (Y : _U) => p_big_q_1 Y)))) -> (pel24_4 : (X : _U) -> Or (p_big_q_1 X) (p_big_r_1 X) -> p_big_s_1 X) -> @Exists _U (fun (X : _U) => And (p_big_p_1 X) (p_big_r_1 X)) :=
  by grind

