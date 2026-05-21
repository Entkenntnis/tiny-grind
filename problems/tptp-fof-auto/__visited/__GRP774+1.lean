theorem GRP774_plus_1 : (_U : Type) -> (f_product_2 : _U -> _U -> _U) -> (p_d_2 : _U -> _U -> Prop) -> (sos01 : (C : _U) -> (B : _U) -> (A : _U) -> @Eq _U (f_product_2 (f_product_2 A B) C) (f_product_2 A (f_product_2 B C))) -> (sos02 : (A : _U) -> @Eq _U (f_product_2 A A) A) -> (sos03 : (X0 : _U) -> (X1 : _U) -> Iff (p_d_2 X0 X1) (And (@Eq _U (f_product_2 X0 (f_product_2 X1 X0)) X0) (@Eq _U (f_product_2 X1 (f_product_2 X0 X1)) X1))) -> (X2 : _U) -> (X3 : _U) -> (X4 : _U) -> (X5 : _U) -> And (p_d_2 X2 X3) (p_d_2 X4 X5) -> p_d_2 (f_product_2 X2 X4) (f_product_2 X3 X5) :=
  by grind

