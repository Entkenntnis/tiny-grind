def basic_subst : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y: A) -> @Eq A x y -> P x -> P y := 
    by grind