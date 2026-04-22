def example_1 : (P : Prop) -> (p1 : P) -> (p2 : P) -> (T : P -> Type) -> (val : T p1) -> T p2 :=
  fun (P : Prop) (p1 : P) (p2 : P) (T : P -> Type) (val : T p1) => val