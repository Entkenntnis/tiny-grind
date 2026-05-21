theorem SYN381_plus_1 : (_U : Type) -> (p_big_q_2 : _U -> _U -> Prop) -> (p_big_p_1 : _U -> Prop) -> ((X : _U) -> And (@Exists _U (fun (Y : _U) => p_big_q_2 X Y -> p_big_p_1 X)) ((V : _U) -> @Exists _U (fun (U : _U) => And (p_big_q_2 U V) ((W : _U) -> (Z : _U) -> p_big_q_2 W Z -> Or (p_big_q_2 Z W) (p_big_q_2 Z Z))))) -> (Z : _U) -> p_big_p_1 Z :=
  by grind

