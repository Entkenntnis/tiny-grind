-- problems/phase00/example1.lean
theorem phase00_example1 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  by grind

theorem phase00_example1_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  by sorry


-- problems/phase00/example2.lean
theorem phase00_example2 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by grind

theorem phase00_example2_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by sorry


-- problems/phase00/example3.lean
theorem phase00_example3 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by grind

theorem phase00_example3_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by sorry


-- problems/phase00/example4.lean
theorem phase00_example4 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  by grind

theorem phase00_example4_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  by sorry


-- problems/phase00/example5_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example5_f_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x :=
  by sorry


