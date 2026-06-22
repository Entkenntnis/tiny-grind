
-- problems/basic/example1.lean
theorem basic_subst : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  by grind

theorem basic_subst_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  fun (A: Type) (P : A -> Prop) (x y: A) (h1: _) (h2 : _)  =>
    Classical.byContradiction (fun (p : ¬ P y) =>
    false_of_true_eq_false
      (Eq.trans (Eq.trans (Eq.symm (eq_true h2)) (congrArg P h1)) (eq_false p)))


-- problems/basic/example2.lean
theorem chaining : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by grind

theorem chaining_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by sorry


-- problems/basic/example3.lean
theorem congruence_on_functions : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by grind

theorem congruence_on_functions_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by sorry
