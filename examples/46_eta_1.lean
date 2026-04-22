def eta_fun : (A : Type) -> (B : Type) -> (f : A -> B) -> @Eq (A -> B) (fun (x : A) => f x) f := 
  fun (A : Type) (B : Type) (f : A -> B) => @Eq.refl (A -> B) f