-- problems/phase00/example01.lean
theorem phase00_example01 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  by grind

theorem phase00_example01_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  None


-- problems/phase00/example02.lean
theorem phase00_example02 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  by grind

theorem phase00_example02_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  None


-- problems/phase00/example03.lean
theorem phase00_example03 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  by grind

theorem phase00_example03_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  None


-- problems/phase00/example04.lean
theorem phase00_example04 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  by grind

theorem phase00_example04_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  None


-- problems/phase00/example05_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example05_f : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x :=
  None


-- problems/phase00/example06.lean
theorem phase00_example06 : (A : Type) -> (a : A) -> @Eq A a a :=
  by grind

theorem phase00_example06_proof : (A : Type) -> (a : A) -> @Eq A a a :=
  None


-- problems/phase00/example07.lean
theorem phase00_example07 : (A : Type) -> (a : A) -> (b : A) -> @Eq A a b -> @Eq A b a :=
  by grind

theorem phase00_example07_proof : (A : Type) -> (a : A) -> (b : A) -> @Eq A a b -> @Eq A b a :=
  None


-- problems/phase00/example08.lean
theorem phase00_example08 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f b) (g a) -> @Eq A (f a) (g b) :=
  by grind

theorem phase00_example08_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f b) (g a) -> @Eq A (f a) (g b) :=
  None


-- problems/phase00/example09.lean
theorem phase00_example09 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a)) (f (g b)) :=
  by grind

theorem phase00_example09_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a)) (f (g b)) :=
  None


-- problems/phase00/example10.lean
theorem phase00_example10 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A a c -> @Eq A b d -> @Eq A c d :=
  by grind

theorem phase00_example10_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A a c -> @Eq A b d -> @Eq A c d :=
  None


-- problems/phase00/example11.lean
theorem phase00_example11 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A -> A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A d e -> @Eq A (f a) (f e) :=
  by grind

theorem phase00_example11_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A -> A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A d e -> @Eq A (f a) (f e) :=
  None


-- problems/phase00/example12.lean
theorem phase00_example12 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A b (g c) -> @Eq A (g c) (h a) -> @Eq A (f a) (h a) :=
  by grind

theorem phase00_example12_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A b (g c) -> @Eq A (g c) (h a) -> @Eq A (f a) (h a) :=
  None


-- problems/phase00/example13.lean
theorem phase00_example13 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A (g b) c -> @Eq A (h c) a -> @Eq A (f (h (g (f a)))) (f a) :=
  by grind

theorem phase00_example13_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A (g b) c -> @Eq A (h c) a -> @Eq A (f (h (g (f a)))) (f a) :=
  None


-- problems/phase00/example14.lean
theorem phase00_example14 : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> @Eq A b c -> P a -> P c :=
  by grind

theorem phase00_example14_proof : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> @Eq A b c -> P a -> P c :=
  None


-- problems/phase00/example15.lean
theorem phase00_example15 : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a (f b) -> P (f b) -> P a :=
  by grind

theorem phase00_example15_proof : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a (f b) -> P (f b) -> P a :=
  None


-- problems/phase00/example16.lean
theorem phase00_example16 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A a c -> @Eq A a d -> @Eq A e d -> @Eq A b e :=
  by grind

theorem phase00_example16_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A a c -> @Eq A a d -> @Eq A e d -> @Eq A b e :=
  None


-- problems/phase00/example17.lean
theorem phase00_example17 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a b -> @Eq A (f (g (h a))) (f (g (h b))) :=
  by grind

theorem phase00_example17_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a b -> @Eq A (f (g (h a))) (f (g (h b))) :=
  None


-- problems/phase00/example18.lean
theorem phase00_example18 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g b)) (f (g a)) :=
  by grind

theorem phase00_example18_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g b)) (f (g a)) :=
  None


-- problems/phase00/example19.lean
theorem phase00_example19 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A b c -> @Eq A d e -> @Eq A e c -> @Eq A a d :=
  by grind

theorem phase00_example19_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A b c -> @Eq A d e -> @Eq A e c -> @Eq A a d :=
  None


-- problems/phase00/example20.lean
theorem phase00_example20 : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> P (f b) -> P (f a) :=
  by grind

theorem phase00_example20_proof : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> P (f b) -> P (f a) :=
  None


-- problems/phase00/example21_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example21_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a b -> @Eq A (f (g a)) (f (h b)) :=
  None


-- problems/phase00/example22_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example22_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A b c -> @Eq A d e -> @Eq A a d :=
  None


-- problems/phase00/example23_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example23_f : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a (f b) -> P (f b) -> P b :=
  None


-- problems/phase00/example24_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example24_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f a) (f c) :=
  None


-- problems/phase00/example25_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example25_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A (f a) (g b) -> @Eq A (f c) (g d) -> @Eq A a c :=
  None


-- problems/phase00/example26.lean
theorem phase00_example26 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f b c) :=
  by grind

theorem phase00_example26_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f b c) :=
  None


-- problems/phase00/example27.lean
theorem phase00_example27 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f c a) (f c b) :=
  by grind

theorem phase00_example27_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f c a) (f c b) :=
  None


-- problems/phase00/example28.lean
theorem phase00_example28 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (f b d) :=
  by grind

theorem phase00_example28_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (f b d) :=
  None


-- problems/phase00/example29.lean
theorem phase00_example29 : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> P a c -> P b c :=
  by grind

theorem phase00_example29_proof : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> P a c -> P b c :=
  None


-- problems/phase00/example30.lean
theorem phase00_example30 : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A c d -> P a c -> P b d :=
  by grind

theorem phase00_example30_proof : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A c d -> P a c -> P b d :=
  None


-- problems/phase00/example31.lean
theorem phase00_example31 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a) c) (f (g b) c) :=
  by grind

theorem phase00_example31_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a) c) (f (g b) c) :=
  None


-- problems/phase00/example32.lean
theorem phase00_example32 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> (g : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (g b d) -> @Eq A (f a c) (g a d) :=
  by grind

theorem phase00_example32_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> (g : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (g b d) -> @Eq A (f a c) (g a d) :=
  None


-- problems/phase00/example33_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example33_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f c b) :=
  None


-- problems/phase00/example34_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example34_f : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> P a c -> P b d :=
  None


-- problems/phase00/example35_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example35_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f b d) :=
  None


-- problems/phase00/example36_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example36_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A (f a b) c -> @Eq A a c :=
  None


-- problems/phase00/example37_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example37_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> (g : A -> A -> A) -> (h : A -> A) -> (k : A -> A) -> @Eq A a b -> @Eq A (f (g a c) (h d)) (f (g b c) (k d)) :=
  None


-- problems/phase00/example38_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example38_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f a) (g b) :=
  None


-- problems/phase00/example39_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example39_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A c d -> @Eq A a c :=
  None


-- problems/phase00/example40_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example40_f : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> P a -> P b :=
  None


-- problems/phase00/example41_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example41_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A (f a) b -> @Eq A a (f b) :=
  None


-- problems/phase00/example42_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example42_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> @Eq A a b -> @Eq A b (f c) -> @Eq A a c :=
  None


