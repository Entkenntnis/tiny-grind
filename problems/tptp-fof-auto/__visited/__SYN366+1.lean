theorem SYN366_plus_1 : (_U : Type) -> (p_big_r_2 : _U -> _U -> Prop) -> ((U : _U) -> (V : _U) -> And (Iff (p_big_r_2 U U) (p_big_r_2 U V)) ((W : _U) -> (Z : _U) -> Iff (p_big_r_2 W W) (p_big_r_2 Z W))) -> @Exists _U (fun (X : _U) => p_big_r_2 X X -> (Y : _U) -> p_big_r_2 Y Y) :=
  by grind

