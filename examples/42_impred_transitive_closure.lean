def Transitive : (alpha : Type) -> (R : alpha -> alpha -> Prop) -> Prop :=
  fun (alpha : Type) (R : alpha -> alpha -> Prop) =>
    forall (a : alpha) (b : alpha) (c : alpha), R a b -> R b c -> R a c

def TransitiveClosure : (alpha : Type) -> (R : alpha -> alpha -> Prop) -> (x : alpha) -> (y : alpha) -> Prop :=
  fun (alpha : Type) (R : alpha -> alpha -> Prop) (x : alpha) (y : alpha) =>
    forall (T : alpha -> alpha -> Prop), 
      Transitive alpha T -> 
      (forall (a : alpha) (b : alpha), R a b -> T a b) -> 
      T x y