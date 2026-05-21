theorem SYN727_plus_1 : (_U : Type) -> (f_bruce_0 : _U) -> (f_lyle_0 : _U) -> (p_likes_2 : _U -> _U -> Prop) -> ((X : _U) -> And (p_likes_2 X f_bruce_0) ((Y : _U) -> @Exists _U (fun (Z : _U) => p_likes_2 Y Z -> p_likes_2 f_lyle_0 Y))) -> @Exists _U (fun (U : _U) => (V : _U) -> p_likes_2 U V) :=
  by grind

