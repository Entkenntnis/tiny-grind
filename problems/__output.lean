
theorem eq_false_intro {a : Prop} (h : ¬a) : a = False := propext (iff_false_intro h)

theorem and_elim_left {a b : Prop} (h : (a ∧ b) = True) : a = True := eq_true (of_eq_true h).left

theorem and_elim_right {a b : Prop} (h : (a ∧ b) = True) : b = True := eq_true (of_eq_true h).right

theorem and_eq_false_of_left_false {a b : Prop} (ha : a = False) : (a ∧ b) = False := eq_false_intro (fun h => of_eq_false ha h.left)

theorem and_eq_false_of_right_false {a b : Prop} (hb : b = False) : (a ∧ b) = False := eq_false_intro (fun h => of_eq_false hb h.right)

theorem and_eq_right_of_left_true {a b : Prop} (ha : a = True) : (a ∧ b) = b := propext (Iff.intro (fun h => h.right) (fun hb => And.intro (of_eq_true ha) hb))

theorem and_eq_left_of_right_true {a b : Prop} (hb : b = True) : (a ∧ b) = a := propext (Iff.intro (fun h => h.left) (fun ha => And.intro ha (of_eq_true hb)))

theorem or_eq_true_of_left_true {a b : Prop} (ha : a = True) : (a ∨ b) = True := eq_true (Or.inl (of_eq_true ha))

theorem or_eq_true_of_right_true {a b : Prop} (hb : b = True) : (a ∨ b) = True := eq_true (Or.inr (of_eq_true hb))

theorem or_eq_of_left_false {a b : Prop} (ha : a = False) : (a ∨ b) = b := propext (Iff.intro (fun h => Or.elim h (fun hleft => False.elim (of_eq_false ha hleft)) id) (fun hb => Or.inr hb))

theorem or_eq_of_right_false {a b : Prop} (hb : b = False) : (a ∨ b) = a := propext (Iff.intro (fun h => Or.elim h id (fun hright => False.elim (of_eq_false hb hright))) (fun ha => Or.inl ha))

theorem or_elim_left_false {a b : Prop} (h : (a ∨ b) = False) : a = False := eq_false_intro (fun ha => of_eq_false h (Or.inl ha))

theorem or_elim_right_false {a b : Prop} (h : (a ∨ b) = False) : b = False := eq_false_intro (fun hb => of_eq_false h (Or.inr hb))

theorem not_eq_false_of_arg_true {a : Prop} (ha : a = True) : (¬a) = False := eq_false_intro (fun hn => hn (of_eq_true ha))

theorem not_eq_true_of_arg_false {a : Prop} (ha : a = False) : (¬a) = True := eq_true (fun h => of_eq_false ha h)

theorem eq_false_of_not_eq_true {a : Prop} (hn : (¬a) = True) : a = False := eq_false_intro (fun ha => (of_eq_true hn) ha)

theorem eq_true_of_not_eq_false {a : Prop} (hn : (¬a) = False) : a = True := eq_true (Classical.byContradiction (fun hna => of_eq_false hn hna))

theorem modus_ponens {a b : Prop} (imp: (a → b) = True) (ha : a = True) : b = True := eq_true ((of_eq_true imp) (of_eq_true ha))

theorem or_elim {A B : Prop} (hor : (A ∨ B) = True) (hA : A -> (True = False)) (hB : B -> (True = False)) : True = False := Or.elim (of_eq_true hor) hA hB

theorem push_not_and {A B : Prop} (h: (A ∧ B) = False) : (¬ A ∨ ¬ B) = True := eq_true (
    match Classical.em A with
    | Or.inl hA =>
        Or.inr (fun hB => of_eq_false h ⟨hA, hB⟩)
    | Or.inr hnA =>
        Or.inl hnA
  )

theorem push_not_imp {A B : Prop} (h: (A → B) = False) : (A ∧ ¬ B) = True :=
eq_true ⟨
    Classical.byContradiction
      (fun hnA => of_eq_false h (fun hA => False.elim (hnA hA))),
    fun hB => of_eq_false h (fun _ => hB)
  ⟩


-- problems/phase00/example01.lean
theorem phase00_example01 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  (by grind)

theorem phase00_example01_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x -> P y :=
  fun (A : _) => fun (P : _) => fun (x : _) => fun (y : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h2)) (Eq.trans (congr rfl (of_eq_true (eq_true h1))) (eq_false_intro goal))))


-- problems/phase00/example02.lean
theorem phase00_example02 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  (by grind)

theorem phase00_example02_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (z : A) -> (w : A) -> @Eq A x y -> @Eq A y z -> @Eq A z w -> P x -> P w :=
  fun (A : _) => fun (P : _) => fun (x : _) => fun (y : _) => fun (z : _) => fun (w : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h4)) (Eq.trans (congr rfl (Eq.trans (of_eq_true (eq_true h1)) (Eq.trans (of_eq_true (eq_true h2)) (of_eq_true (eq_true h3))))) (eq_false_intro goal))))


-- problems/phase00/example03.lean
theorem phase00_example03 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  (by grind)

theorem phase00_example03_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f a)) (f (f b)) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (of_eq_true (eq_true h1)))))) (eq_false_intro goal)))


-- problems/phase00/example04.lean
theorem phase00_example04 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  (by grind)

theorem phase00_example04_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g c))) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (Eq.trans (Eq.symm (congr rfl (of_eq_true (eq_true h4)))) (Eq.symm (of_eq_true (eq_true h3)))))))) (eq_false_intro goal)))


-- problems/phase00/example05_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example05_f : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> @Eq A x y -> P x :=
  (by sorry)


-- problems/phase00/example06.lean
theorem phase00_example06 : (A : Type) -> (a : A) -> @Eq A a a :=
  (by grind)

theorem phase00_example06_proof : (A : Type) -> (a : A) -> @Eq A a a :=
  fun (A : _) => fun (a : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true rfl)) (eq_false_intro goal)))


-- problems/phase00/example07.lean
theorem phase00_example07 : (A : Type) -> (a : A) -> (b : A) -> @Eq A a b -> @Eq A b a :=
  (by grind)

theorem phase00_example07_proof : (A : Type) -> (a : A) -> (b : A) -> @Eq A a b -> @Eq A b a :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.symm (of_eq_true (eq_true h1))))) (eq_false_intro goal)))


-- problems/phase00/example08.lean
theorem phase00_example08 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f b) (g a) -> @Eq A (f a) (g b) :=
  (by grind)

theorem phase00_example08_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f b) (g a) -> @Eq A (f a) (g b) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (Eq.symm (congr rfl (Eq.symm (of_eq_true (eq_true h1))))) (Eq.trans (of_eq_true (eq_true h2)) (congr rfl (of_eq_true (eq_true h1))))))) (eq_false_intro goal)))


-- problems/phase00/example09.lean
theorem phase00_example09 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a)) (f (g b)) :=
  (by grind)

theorem phase00_example09_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a)) (f (g b)) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (of_eq_true (eq_true h1)))))) (eq_false_intro goal)))


-- problems/phase00/example10.lean
theorem phase00_example10 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A a c -> @Eq A b d -> @Eq A c d :=
  (by grind)

theorem phase00_example10_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A a c -> @Eq A b d -> @Eq A c d :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (Eq.symm (of_eq_true (eq_true h2))) (Eq.trans (of_eq_true (eq_true h1)) (of_eq_true (eq_true h3)))))) (eq_false_intro goal)))


-- problems/phase00/example11.lean
theorem phase00_example11 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A -> A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A d e -> @Eq A (f a) (f e) :=
  (by grind)

theorem phase00_example11_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A -> A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A d e -> @Eq A (f a) (f e) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (Eq.trans (of_eq_true (eq_true h1)) (Eq.trans (of_eq_true (eq_true h2)) (Eq.trans (of_eq_true (eq_true h3)) (of_eq_true (eq_true h4)))))))) (eq_false_intro goal)))


-- problems/phase00/example12.lean
theorem phase00_example12 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A b (g c) -> @Eq A (g c) (h a) -> @Eq A (f a) (h a) :=
  (by grind)

theorem phase00_example12_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A b (g c) -> @Eq A (g c) (h a) -> @Eq A (f a) (h a) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (of_eq_true (eq_true h1)) (Eq.trans (of_eq_true (eq_true h2)) (of_eq_true (eq_true h3)))))) (eq_false_intro goal)))


-- problems/phase00/example13.lean
theorem phase00_example13 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A (g b) c -> @Eq A (h c) a -> @Eq A (f (h (g (f a)))) (f a) :=
  (by grind)

theorem phase00_example13_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A (f a) b -> @Eq A (g b) c -> @Eq A (h c) a -> @Eq A (f (h (g (f a)))) (f a) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.symm (congr rfl (Eq.trans (Eq.symm (of_eq_true (eq_true h3))) (congr rfl (Eq.trans (Eq.symm (of_eq_true (eq_true h2))) (congr rfl (Eq.symm (of_eq_true (eq_true h1))))))))))) (eq_false_intro goal)))


-- problems/phase00/example14.lean
theorem phase00_example14 : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> @Eq A b c -> P a -> P c :=
  (by grind)

theorem phase00_example14_proof : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> @Eq A b c -> P a -> P c :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h3)) (Eq.trans (congr rfl (Eq.trans (of_eq_true (eq_true h1)) (of_eq_true (eq_true h2)))) (eq_false_intro goal))))


-- problems/phase00/example15.lean
theorem phase00_example15 : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a (f b) -> P (f b) -> P a :=
  (by grind)

theorem phase00_example15_proof : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a (f b) -> P (f b) -> P a :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h2)) (Eq.trans (congr rfl (Eq.symm (of_eq_true (eq_true h1)))) (eq_false_intro goal))))


-- problems/phase00/example16.lean
theorem phase00_example16 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A a c -> @Eq A a d -> @Eq A e d -> @Eq A b e :=
  (by grind)

theorem phase00_example16_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A a c -> @Eq A a d -> @Eq A e d -> @Eq A b e :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (Eq.symm (of_eq_true (eq_true h1))) (Eq.trans (of_eq_true (eq_true h3)) (Eq.symm (of_eq_true (eq_true h4))))))) (eq_false_intro goal)))


-- problems/phase00/example17.lean
theorem phase00_example17 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a b -> @Eq A (f (g (h a))) (f (g (h b))) :=
  (by grind)

theorem phase00_example17_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a b -> @Eq A (f (g (h a))) (f (g (h b))) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (congr rfl (of_eq_true (eq_true h1))))))) (eq_false_intro goal)))


-- problems/phase00/example18.lean
theorem phase00_example18 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g b)) (f (g a)) :=
  (by grind)

theorem phase00_example18_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g b)) (f (g a)) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (Eq.symm (of_eq_true (eq_true h1))))))) (eq_false_intro goal)))


-- problems/phase00/example19.lean
theorem phase00_example19 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A b c -> @Eq A d e -> @Eq A e c -> @Eq A a d :=
  (by grind)

theorem phase00_example19_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A b c -> @Eq A d e -> @Eq A e c -> @Eq A a d :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (of_eq_true (eq_true h1)) (Eq.trans (of_eq_true (eq_true h2)) (Eq.trans (Eq.symm (of_eq_true (eq_true h4))) (Eq.symm (of_eq_true (eq_true h3)))))))) (eq_false_intro goal)))


-- problems/phase00/example20.lean
theorem phase00_example20 : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> P (f b) -> P (f a) :=
  (by grind)

theorem phase00_example20_proof : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> P (f b) -> P (f a) :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h2)) (Eq.trans (congr rfl (congr rfl (Eq.symm (of_eq_true (eq_true h1))))) (eq_false_intro goal))))


-- problems/phase00/example21_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example21_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a b -> @Eq A (f (g a)) (f (h b)) :=
  (by sorry)


-- problems/phase00/example22_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example22_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> @Eq A a b -> @Eq A b c -> @Eq A d e -> @Eq A a d :=
  (by sorry)


-- problems/phase00/example23_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example23_f : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a (f b) -> P (f b) -> P b :=
  (by sorry)


-- problems/phase00/example24_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example24_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f a) (f c) :=
  (by sorry)


-- problems/phase00/example25_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example25_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A (f a) (g b) -> @Eq A (f c) (g d) -> @Eq A a c :=
  (by sorry)


-- problems/phase00/example26.lean
theorem phase00_example26 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f b c) :=
  (by grind)

theorem phase00_example26_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f b c) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (of_eq_true (eq_true h1))) rfl))) (eq_false_intro goal)))


-- problems/phase00/example27.lean
theorem phase00_example27 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f c a) (f c b) :=
  (by grind)

theorem phase00_example27_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f c a) (f c b) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (of_eq_true (eq_true h1))))) (eq_false_intro goal)))


-- problems/phase00/example28.lean
theorem phase00_example28 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (f b d) :=
  (by grind)

theorem phase00_example28_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (f b d) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))))) (eq_false_intro goal)))


-- problems/phase00/example29.lean
theorem phase00_example29 : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> P a c -> P b c :=
  (by grind)

theorem phase00_example29_proof : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> @Eq A a b -> P a c -> P b c :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h2)) (Eq.trans (congr (congr rfl (of_eq_true (eq_true h1))) rfl) (eq_false_intro goal))))


-- problems/phase00/example30.lean
theorem phase00_example30 : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A c d -> P a c -> P b d :=
  (by grind)

theorem phase00_example30_proof : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A c d -> P a c -> P b d :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h3)) (Eq.trans (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))) (eq_false_intro goal))))


-- problems/phase00/example31.lean
theorem phase00_example31 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a) c) (f (g b) c) :=
  (by grind)

theorem phase00_example31_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f (g a) c) (f (g b) c) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (congr rfl (of_eq_true (eq_true h1)))) rfl))) (eq_false_intro goal)))


-- problems/phase00/example32.lean
theorem phase00_example32 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> (g : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (g b d) -> @Eq A (f a c) (g a d) :=
  (by grind)

theorem phase00_example32_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> (g : A -> A -> A) -> @Eq A a b -> @Eq A c d -> @Eq A (f a c) (g b d) -> @Eq A (f a c) (g a d) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (of_eq_true (eq_true h3)) (congr (congr rfl (Eq.symm (of_eq_true (eq_true h1)))) rfl)))) (eq_false_intro goal)))


-- problems/phase00/example33_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example33_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f c b) :=
  (by sorry)


-- problems/phase00/example34_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example34_f : (A : Type) -> (P : A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> P a c -> P b d :=
  (by sorry)


-- problems/phase00/example35_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example35_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> @Eq A a b -> @Eq A (f a c) (f b d) :=
  (by sorry)


-- problems/phase00/example36_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example36_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A -> A) -> @Eq A (f a b) c -> @Eq A a c :=
  (by sorry)


-- problems/phase00/example37_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example37_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> A) -> (g : A -> A -> A) -> (h : A -> A) -> (k : A -> A) -> @Eq A a b -> @Eq A (f (g a c) (h d)) (f (g b c) (k d)) :=
  (by sorry)


-- problems/phase00/example38_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example38_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f a) (g b) :=
  (by sorry)


-- problems/phase00/example39_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example39_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> @Eq A a b -> @Eq A c d -> @Eq A a c :=
  (by sorry)


-- problems/phase00/example40_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example40_f : (A : Type) -> (P : A -> Prop) -> (a : A) -> (b : A) -> P a -> P b :=
  (by sorry)


-- problems/phase00/example41_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example41_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A (f a) b -> @Eq A a (f b) :=
  (by sorry)


-- problems/phase00/example42_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example42_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> @Eq A a b -> @Eq A b (f c) -> @Eq A a c :=
  (by sorry)


-- problems/phase00/example43.lean
theorem phase00_example43 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A -> A -> A -> A) -> @Eq A a d -> @Eq A b e -> @Eq A c f -> @Eq A (g a b c) (g d e f) :=
  (by grind)

theorem phase00_example43_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A -> A -> A -> A) -> @Eq A a d -> @Eq A b e -> @Eq A c f -> @Eq A (g a b c) (g d e f) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))) (of_eq_true (eq_true h3))))) (eq_false_intro goal)))


-- problems/phase00/example43_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example43_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (F : A -> A -> A -> A -> A) -> @Eq A a e -> @Eq A b f -> @Eq A (F a b c d) (F e f g d) :=
  (by sorry)


-- problems/phase00/example44.lean
theorem phase00_example44 : (A : Type) -> (P : A -> A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> @Eq A a d -> @Eq A b e -> @Eq A c f -> P a b c -> P d e f :=
  (by grind)

theorem phase00_example44_proof : (A : Type) -> (P : A -> A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> @Eq A a d -> @Eq A b e -> @Eq A c f -> P a b c -> P d e f :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h4)) (Eq.trans (congr (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))) (of_eq_true (eq_true h3))) (eq_false_intro goal))))


-- problems/phase00/example44_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example44_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (F : A -> A -> A -> A) -> @Eq A a d -> @Eq A b e -> @Eq A c f -> @Eq A (F a b d) (F c e f) :=
  (by sorry)


-- problems/phase00/example45.lean
theorem phase00_example45 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (h : A) -> (F : A -> A -> A -> A -> A) -> @Eq A a e -> @Eq A b f -> @Eq A c g -> @Eq A d h -> @Eq A (F a b c d) (F e f g h) :=
  (by grind)

theorem phase00_example45_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (h : A) -> (F : A -> A -> A -> A -> A) -> @Eq A a e -> @Eq A b f -> @Eq A c g -> @Eq A d h -> @Eq A (F a b c d) (F e f g h) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (F : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))) (of_eq_true (eq_true h3))) (of_eq_true (eq_true h4))))) (eq_false_intro goal)))


-- problems/phase00/example45_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example45_f : (A : Type) -> (P : A -> A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> @Eq A a d -> @Eq A b e -> @Eq A c f -> P a b c -> P d e d :=
  (by sorry)


-- problems/phase00/example46.lean
theorem phase00_example46 : (A : Type) -> (P : A -> A -> A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (h : A) -> @Eq A a e -> @Eq A b f -> @Eq A c g -> @Eq A d h -> P a b c d -> P e f g h :=
  (by grind)

theorem phase00_example46_proof : (A : Type) -> (P : A -> A -> A -> A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (h : A) -> @Eq A a e -> @Eq A b f -> @Eq A c g -> @Eq A d h -> P a b c d -> P e f g h :=
  fun (A : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => fun (h5 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h5)) (Eq.trans (congr (congr (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))) (of_eq_true (eq_true h3))) (of_eq_true (eq_true h4))) (eq_false_intro goal))))


-- problems/phase00/example47.lean
theorem phase00_example47 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (F : A -> A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a c -> @Eq A b d -> @Eq A (F (g a) (h b)) (F (g c) (h d)) :=
  (by grind)

theorem phase00_example47_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (F : A -> A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a c -> @Eq A b d -> @Eq A (F (g a) (h b)) (F (g c) (h d)) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (F : _) => fun (g : _) => fun (h : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (congr rfl (of_eq_true (eq_true h1)))) (congr rfl (of_eq_true (eq_true h2)))))) (eq_false_intro goal)))


-- problems/phase00/example47_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example47_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A (f c) d -> @Eq A (g (f a)) (g (f d)) :=
  (by sorry)


-- problems/phase00/example48.lean
theorem phase00_example48 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A d e -> @Eq A e f -> @Eq A f g -> @Eq A a g :=
  (by grind)

theorem phase00_example48_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A d e -> @Eq A e f -> @Eq A f g -> @Eq A a g :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => fun (h5 : _) => fun (h6 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (of_eq_true (eq_true h1)) (Eq.trans (of_eq_true (eq_true h2)) (Eq.trans (of_eq_true (eq_true h3)) (Eq.trans (of_eq_true (eq_true h4)) (Eq.trans (of_eq_true (eq_true h5)) (of_eq_true (eq_true h6))))))))) (eq_false_intro goal)))


-- problems/phase00/example49.lean
theorem phase00_example49 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (h : A) -> (F : A -> A -> A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A e f -> @Eq A f g -> @Eq A g h -> @Eq A (F a e) (F d h) :=
  (by grind)

theorem phase00_example49_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (e : A) -> (f : A) -> (g : A) -> (h : A) -> (F : A -> A -> A) -> @Eq A a b -> @Eq A b c -> @Eq A c d -> @Eq A e f -> @Eq A f g -> @Eq A g h -> @Eq A (F a e) (F d h) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (e : _) => fun (f : _) => fun (g : _) => fun (h : _) => fun (F : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => fun (h5 : _) => fun (h6 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (Eq.trans (of_eq_true (eq_true h1)) (Eq.trans (of_eq_true (eq_true h2)) (of_eq_true (eq_true h3))))) (Eq.trans (of_eq_true (eq_true h4)) (Eq.trans (of_eq_true (eq_true h5)) (of_eq_true (eq_true h6))))))) (eq_false_intro goal)))


-- problems/phase00/example50.lean
theorem phase00_example50 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f (f a))) (f (f (f b))) :=
  (by grind)

theorem phase00_example50_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f (f (f a))) (f (f (f b))) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (congr rfl (of_eq_true (eq_true h1))))))) (eq_false_intro goal)))


-- problems/phase00/example51.lean
theorem phase00_example51 : (A : Type) -> (P : A -> Prop) -> (Q : A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A c (f b) -> P (g a) -> Q c -> P (g b) :=
  (by grind)

theorem phase00_example51_proof : (A : Type) -> (P : A -> Prop) -> (Q : A -> Prop) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> (g : A -> A) -> @Eq A a b -> @Eq A c (f b) -> P (g a) -> Q c -> P (g b) :=
  fun (A : _) => fun (P : _) => fun (Q : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h3)) (Eq.trans (congr rfl (congr rfl (of_eq_true (eq_true h1)))) (eq_false_intro goal))))


-- problems/phase00/example52.lean
theorem phase00_example52 : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A -> A) -> @Eq A a b -> @Eq A (f c) d -> @Eq A (g a (f c)) (g b d) :=
  (by grind)

theorem phase00_example52_proof : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A -> A) -> @Eq A a b -> @Eq A (f c) d -> @Eq A (g a (f c)) (g b d) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))))) (eq_false_intro goal)))


-- problems/phase00/example53.lean
theorem phase00_example53 : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (f : A -> B) -> @Eq A a b -> @Eq B (f a) (f b) :=
  (by grind)

theorem phase00_example53_proof : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (f : A -> B) -> @Eq A a b -> @Eq B (f a) (f b) :=
  fun (A : _) => fun (B : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (of_eq_true (eq_true h1))))) (eq_false_intro goal)))


-- problems/phase00/example54.lean
theorem phase00_example54 : (A : Type) -> (B : Type) -> (P : B -> Prop) -> (a : A) -> (b : A) -> (f : A -> B) -> @Eq A a b -> P (f a) -> P (f b) :=
  (by grind)

theorem phase00_example54_proof : (A : Type) -> (B : Type) -> (P : B -> Prop) -> (a : A) -> (b : A) -> (f : A -> B) -> @Eq A a b -> P (f a) -> P (f b) :=
  fun (A : _) => fun (B : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h2)) (Eq.trans (congr rfl (congr rfl (of_eq_true (eq_true h1)))) (eq_false_intro goal))))


-- problems/phase00/example55.lean
theorem phase00_example55 : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> B) -> @Eq A a b -> @Eq A c d -> @Eq B (f a c) (f b d) :=
  (by grind)

theorem phase00_example55_proof : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A -> B) -> @Eq A a b -> @Eq A c d -> @Eq B (f a c) (f b d) :=
  fun (A : _) => fun (B : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (d : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))))) (eq_false_intro goal)))


-- problems/phase00/example56.lean
theorem phase00_example56 : (A : Type) -> (B : Type) -> (P : B -> A -> Prop) -> (a : A) -> (b : A) -> (x : B) -> (y : B) -> @Eq A a b -> @Eq B x y -> P x a -> P y b :=
  (by grind)

theorem phase00_example56_proof : (A : Type) -> (B : Type) -> (P : B -> A -> Prop) -> (a : A) -> (b : A) -> (x : B) -> (y : B) -> @Eq A a b -> @Eq B x y -> P x a -> P y b :=
  fun (A : _) => fun (B : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (x : _) => fun (y : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h3)) (Eq.trans (congr (congr rfl (of_eq_true (eq_true h2))) (of_eq_true (eq_true h1))) (eq_false_intro goal))))


-- problems/phase00/example57.lean
theorem phase00_example57 : (A : Type) -> (B : Type) -> (C : Type) -> (a : A) -> (b : A) -> (f : A -> B) -> (g : B -> C) -> @Eq A a b -> @Eq C (g (f a)) (g (f b)) :=
  (by grind)

theorem phase00_example57_proof : (A : Type) -> (B : Type) -> (C : Type) -> (a : A) -> (b : A) -> (f : A -> B) -> (g : B -> C) -> @Eq A a b -> @Eq C (g (f a)) (g (f b)) :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (g : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (congr rfl (of_eq_true (eq_true h1)))))) (eq_false_intro goal)))


-- problems/phase00/example58.lean
theorem phase00_example58 : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (c : A) -> (x : B) -> (y : B) -> (z : B) -> (f : A -> B) -> @Eq A a b -> @Eq A b c -> @Eq B x y -> @Eq B y z -> @Eq B (f a) x -> @Eq B (f c) z :=
  (by grind)

theorem phase00_example58_proof : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (c : A) -> (x : B) -> (y : B) -> (z : B) -> (f : A -> B) -> @Eq A a b -> @Eq A b c -> @Eq B x y -> @Eq B y z -> @Eq B (f a) x -> @Eq B (f c) z :=
  fun (A : _) => fun (B : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (x : _) => fun (y : _) => fun (z : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => fun (h5 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (Eq.trans (Eq.symm (congr rfl (Eq.trans (of_eq_true (eq_true h1)) (of_eq_true (eq_true h2))))) (Eq.trans (of_eq_true (eq_true h5)) (Eq.trans (of_eq_true (eq_true h3)) (of_eq_true (eq_true h4))))))) (eq_false_intro goal)))


-- problems/phase00/example59.lean
theorem phase00_example59 : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (x : B) -> (y : B) -> (f : A -> B -> B) -> @Eq A a b -> @Eq B x y -> @Eq B (f a x) (f b y) :=
  (by grind)

theorem phase00_example59_proof : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (x : B) -> (y : B) -> (f : A -> B -> B) -> @Eq A a b -> @Eq B x y -> @Eq B (f a x) (f b y) :=
  fun (A : _) => fun (B : _) => fun (a : _) => fun (b : _) => fun (x : _) => fun (y : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h2))))) (eq_false_intro goal)))


-- problems/phase00/example60.lean
theorem phase00_example60 : (A : Type) -> (B : Type) -> (P : B -> Prop) -> (a : A) -> (b : A) -> (c : B) -> (f : A -> B) -> @Eq A a b -> @Eq B (f a) c -> P c -> P (f b) :=
  (by grind)

theorem phase00_example60_proof : (A : Type) -> (B : Type) -> (P : B -> Prop) -> (a : A) -> (b : A) -> (c : B) -> (f : A -> B) -> @Eq A a b -> @Eq B (f a) c -> P c -> P (f b) :=
  fun (A : _) => fun (B : _) => fun (P : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h3)) (Eq.trans (congr rfl (Eq.trans (Eq.symm (of_eq_true (eq_true h2))) (congr rfl (of_eq_true (eq_true h1))))) (eq_false_intro goal))))


-- problems/phase00/example61.lean
theorem phase00_example61 : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (c : A) -> (x : B) -> (y : B) -> (f : A -> B -> A -> B) -> @Eq A a b -> @Eq A c b -> @Eq B x y -> @Eq B (f a x c) (f b y b) :=
  (by grind)

theorem phase00_example61_proof : (A : Type) -> (B : Type) -> (a : A) -> (b : A) -> (c : A) -> (x : B) -> (y : B) -> (f : A -> B -> A -> B) -> @Eq A a b -> @Eq A c b -> @Eq B x y -> @Eq B (f a x c) (f b y b) :=
  fun (A : _) => fun (B : _) => fun (a : _) => fun (b : _) => fun (c : _) => fun (x : _) => fun (y : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr (congr (congr rfl (of_eq_true (eq_true h1))) (of_eq_true (eq_true h3))) (of_eq_true (eq_true h2))))) (eq_false_intro goal)))


-- problems/phase00/example62.lean
theorem phase00_example62 : (A : Type) -> (B : Type) -> (P : B -> Prop) -> (Q : A -> Prop) -> (a : A) -> (b : A) -> (x : B) -> (f : A -> B) -> @Eq A a b -> Q a -> @Eq B (f a) x -> P x -> P (f b) :=
  (by grind)

theorem phase00_example62_proof : (A : Type) -> (B : Type) -> (P : B -> Prop) -> (Q : A -> Prop) -> (a : A) -> (b : A) -> (x : B) -> (f : A -> B) -> @Eq A a b -> Q a -> @Eq B (f a) x -> P x -> P (f b) :=
  fun (A : _) => fun (B : _) => fun (P : _) => fun (Q : _) => fun (a : _) => fun (b : _) => fun (x : _) => fun (f : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h4)) (Eq.trans (congr rfl (Eq.trans (Eq.symm (of_eq_true (eq_true h3))) (congr rfl (of_eq_true (eq_true h1))))) (eq_false_intro goal))))


-- problems/phase00/example63.lean
theorem phase00_example63 : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f a) (f b) :=
  (by grind)

theorem phase00_example63_proof : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A a b -> @Eq A (f a) (f b) :=
  fun (A : _) => fun (a : _) => fun (b : _) => fun (f : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true (congr rfl (of_eq_true (eq_true h1))))) (eq_false_intro goal)))


-- problems/phase00/example64_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example64_f : (A : Type) -> (a : A) -> (b : A) -> (f : A -> A) -> @Eq A (f a) (f b) :=
  (by sorry)


-- problems/phase00/example65_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example65_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (f : A -> A) -> @Eq A b c -> @Eq A (f a) (f b) :=
  (by sorry)


-- problems/phase00/example66_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase00_example66_f : (A : Type) -> (a : A) -> (b : A) -> (c : A) -> (d : A) -> (f : A -> A) -> (g : A -> A) -> (h : A -> A) -> @Eq A a (f b) -> @Eq A (f b) (g c) -> @Eq A (g c) (h d) -> @Eq A d a -> @Eq A (g (f (h a))) (g (f (g b))) :=
  (by sorry)


-- problems/phase10/example01.lean
theorem phase10_example01 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> And (P x) (@Eq A x y) -> P y :=
  (by grind)

theorem phase10_example01_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> And (P x) (@Eq A x y) -> P y :=
  fun (A : _) => fun (P : _) => fun (x : _) => fun (y : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (and_elim_left (eq_true h1))) (Eq.trans (congr rfl (of_eq_true (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1)))) (eq_false_intro goal))))


-- problems/phase10/example02.lean
theorem phase10_example02 : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (P x -> P y) -> P x -> P y :=
  (by grind)

theorem phase10_example02_proof : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y : A) -> (P x -> P y) -> P x -> P y :=
  fun (A : _) => fun (P : _) => fun (x : _) => fun (y : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (modus_ponens (eq_true h1) (eq_true h2))) (eq_false_intro goal)))


-- problems/phase10/example03.lean
theorem phase10_example03 : (A : Prop) -> (B : Prop) -> A -> (A -> B) -> B :=
  (by grind)

theorem phase10_example03_proof : (A : Prop) -> (B : Prop) -> A -> (A -> B) -> B :=
  fun (A : _) => fun (B : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (modus_ponens (eq_true h2) (eq_true h1))) (eq_false_intro goal)))


-- problems/phase10/example04_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase10_example04_f : (A : Prop) -> (B : Prop) -> A -> (B -> A) -> B :=
  (by sorry)


-- problems/phase10/example05.lean
theorem phase10_example05 : (T : Type) -> (A : Prop) -> (B : Prop) -> (P : T -> Prop) -> Or A B -> (x : T) -> (y : T) -> (A -> @Eq T x y) -> (B -> @Eq T x y) -> P x -> P y :=
  (by grind)

theorem phase10_example05_proof : (T : Type) -> (A : Prop) -> (B : Prop) -> (P : T -> Prop) -> Or A B -> (x : T) -> (y : T) -> (A -> @Eq T x y) -> (B -> @Eq T x y) -> P x -> P y :=
  fun (T : _) => fun (A : _) => fun (B : _) => fun (P : _) => fun (h1 : _) => fun (x : _) => fun (y : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (or_elim (eq_true h1) (fun (h_case_7_left : _) => Eq.trans (Eq.symm (eq_true h4)) (Eq.trans (congr rfl (of_eq_true (modus_ponens (eq_true h2) (eq_true h_case_7_left)))) (eq_false_intro goal))) (fun (h_case_7_right : _) => Eq.trans (Eq.symm (eq_true h4)) (Eq.trans (congr rfl (of_eq_true (modus_ponens (eq_true h3) (eq_true h_case_7_right)))) (eq_false_intro goal)))))


-- problems/phase10/example06.lean
theorem phase10_example06 : (P : Prop) -> (Q : Prop) -> (P -> Q) -> (Q -> False) -> P -> False :=
  (by grind)

theorem phase10_example06_proof : (P : Prop) -> (Q : Prop) -> (P -> Q) -> (Q -> False) -> P -> False :=
  fun (P : _) => fun (Q : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.symm (modus_ponens (eq_true h2) (modus_ponens (eq_true h1) (eq_true h3)))))


-- problems/phase10/example07.lean
theorem phase10_example07 : (A : Prop) -> (B : Prop) -> Or A B -> Or B A :=
  (by grind)

theorem phase10_example07_proof : (A : Prop) -> (B : Prop) -> Or A B -> Or B A :=
  fun (A : _) => fun (B : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (or_eq_true_of_right_true (Eq.trans (Eq.symm (or_eq_of_right_false (or_elim_left_false (eq_false_intro goal)))) (eq_true h1)))) (eq_false_intro goal)))


-- problems/phase10/example08.lean
theorem phase10_example08 : (A : Prop) -> (B : Prop) -> (C : Prop) -> (D : Prop) -> Or A (Or B C) -> (A -> D) -> (B -> D) -> (C -> D) -> D :=
  (by grind)

theorem phase10_example08_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> (D : Prop) -> Or A (Or B C) -> (A -> D) -> (B -> D) -> (C -> D) -> D :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (D : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => fun (h4 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (or_elim (eq_true h1) (fun (h_case_10_left : _) => Eq.trans (Eq.symm (modus_ponens (eq_true h2) (eq_true h_case_10_left))) (eq_false_intro goal)) (fun (h_case_10_right : _) => or_elim (eq_true h_case_10_right) (fun (h_case_9_left : _) => Eq.trans (Eq.symm (modus_ponens (eq_true h3) (eq_true h_case_9_left))) (eq_false_intro goal)) (fun (h_case_9_right : _) => Eq.trans (Eq.symm (modus_ponens (eq_true h4) (eq_true h_case_9_right))) (eq_false_intro goal)))))


-- problems/phase10/example09.lean
theorem phase10_example09 : (A : Prop) -> (B : Prop) -> (C : Prop) -> And (Or A B) (And (A -> C) (B -> C)) -> C :=
  (by grind)

theorem phase10_example09_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> And (Or A B) (And (A -> C) (B -> C)) -> C :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (or_elim (and_elim_left (eq_true h1)) (fun (h_case_8_left : _) => Eq.trans (Eq.symm (modus_ponens (and_elim_left (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))) (eq_true h_case_8_left))) (eq_false_intro goal)) (fun (h_case_8_right : _) => Eq.trans (Eq.symm (modus_ponens (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))))) (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))) (eq_true h_case_8_right))) (eq_false_intro goal))))


-- problems/phase10/example10.lean
theorem phase10_example10 : (A : Prop) -> False -> A :=
  (by grind)

theorem phase10_example10_proof : (A : Prop) -> False -> A :=
  fun (A : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.symm (eq_true h1)))


-- problems/phase10/example11_f.lean

/-- warning: declaration uses `sorry` -/
#guard_msgs in
theorem phase10_example11_f : (A : Prop) -> (B : Prop) -> (A -> B) -> B -> A :=
  (by sorry)


-- problems/phase10/example12.lean
theorem phase10_example12 : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> B) -> (B -> C) -> A -> C :=
  (by grind)

theorem phase10_example12_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> B) -> (B -> C) -> A -> C :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (modus_ponens (eq_true h2) (modus_ponens (eq_true h1) (eq_true h3)))) (eq_false_intro goal)))


-- problems/phase10/example13.lean
theorem phase10_example13 : (A : Prop) -> (B : Prop) -> And A B -> And B A :=
  (by grind)

theorem phase10_example13_proof : (A : Prop) -> (B : Prop) -> And A B -> And B A :=
  fun (A : _) => fun (B : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h1)) (Eq.trans (congr (congr rfl (Eq.trans (and_elim_left (eq_true h1)) (Eq.trans (Eq.symm (eq_true h1)) (and_eq_right_of_left_true (and_elim_left (eq_true h1)))))) (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (Eq.trans (eq_true h1) (Eq.symm (and_elim_left (eq_true h1)))))) (eq_false_intro goal))))


-- problems/phase10/example14.lean
theorem phase10_example14 : (A : Prop) -> (B : Prop) -> (C : Prop) -> Or A (Or B C) -> Or (Or A B) C :=
  (by grind)

theorem phase10_example14_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> Or A (Or B C) -> Or (Or A B) C :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h1)) (Eq.trans (or_eq_of_left_false (or_elim_left_false (or_elim_left_false (eq_false_intro goal)))) (Eq.trans (congr (Eq.trans (Eq.symm (congr rfl (Eq.trans (or_elim_left_false (or_elim_left_false (eq_false_intro goal))) (Eq.trans (Eq.symm (or_elim_left_false (eq_false_intro goal))) (or_eq_of_left_false (or_elim_left_false (or_elim_left_false (eq_false_intro goal)))))))) (congr rfl (Eq.trans (or_elim_left_false (or_elim_left_false (eq_false_intro goal))) (Eq.symm (or_elim_left_false (eq_false_intro goal)))))) rfl) (eq_false_intro goal)))))


-- problems/phase10/example15.lean
theorem phase10_example15 : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> B -> C) -> B -> A -> C :=
  (by grind)

theorem phase10_example15_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> B -> C) -> B -> A -> C :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (modus_ponens (modus_ponens (eq_true h1) (eq_true h3)) (eq_true h2))) (eq_false_intro goal)))


-- problems/phase10/example16.lean
theorem phase10_example16 : (A : Prop) -> A -> (A -> False) -> False :=
  (by grind)

theorem phase10_example16_proof : (A : Prop) -> A -> (A -> False) -> False :=
  fun (A : _) => fun (h1 : _) => fun (h2 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.symm (modus_ponens (eq_true h2) (eq_true h1))))


-- problems/phase10/example17.lean
theorem phase10_example17 : (A : Prop) -> (B : Prop) -> (C : Prop) -> And A (And B C) -> And (And A B) C :=
  (by grind)

theorem phase10_example17_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> And A (And B C) -> And (And A B) C :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (eq_true h1)) (Eq.trans (and_eq_right_of_left_true (and_elim_left (eq_true h1))) (Eq.trans (congr (Eq.trans (Eq.symm (congr rfl (Eq.trans (and_elim_left (eq_true h1)) (Eq.symm (and_elim_left (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))))))) (congr rfl (Eq.trans (and_elim_left (eq_true h1)) (Eq.trans (Eq.symm (eq_true h1)) (Eq.trans (and_eq_right_of_left_true (and_elim_left (eq_true h1))) (congr (Eq.symm (congr rfl (Eq.trans (and_elim_left (eq_true h1)) (Eq.symm (and_elim_left (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))))))) (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))))) (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (Eq.trans (eq_true h1) (Eq.symm (and_elim_left (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h1)))) (eq_true h1))))))))))))) rfl) (eq_false_intro goal)))))


-- problems/phase10/example18.lean
theorem phase10_example18 : (A : Prop) -> (B : Prop) -> (C : Prop) -> Or A (And B C) -> And (Or A B) (Or A C) :=
  (by grind)

theorem phase10_example18_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> Or A (And B C) -> And (Or A B) (Or A C) :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (or_elim (eq_true h1) (fun (h_case_10_left : _) => Eq.trans (Eq.symm (or_eq_true_of_left_true (eq_true h_case_10_left))) (Eq.trans (Eq.symm (and_eq_right_of_left_true (or_eq_true_of_left_true (eq_true h_case_10_left)))) (eq_false_intro goal))) (fun (h_case_10_right : _) => Eq.trans (Eq.symm (eq_true h_case_10_right)) (Eq.trans (congr (congr rfl (Eq.trans (and_elim_left (eq_true h_case_10_right)) (Eq.trans (Eq.symm (eq_true h1)) (congr rfl (Eq.trans (eq_true h_case_10_right) (Eq.symm (and_elim_left (eq_true h_case_10_right)))))))) (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (eq_true h_case_10_right)))) (Eq.trans (eq_true h_case_10_right) (Eq.trans (Eq.symm (eq_true h1)) (congr rfl (and_eq_right_of_left_true (and_elim_left (eq_true h_case_10_right)))))))) (eq_false_intro goal)))))


-- problems/phase10/example19.lean
theorem phase10_example19 : (A : Prop) -> (B : Prop) -> (C : Prop) -> (And A B -> C) -> A -> B -> C :=
  (by grind)

theorem phase10_example19_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> (And A B -> C) -> A -> B -> C :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => fun (h2 : _) => fun (h3 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (Eq.trans (Eq.symm (modus_ponens (eq_true h1) (Eq.trans (and_eq_right_of_left_true (eq_true h2)) (eq_true h3)))) (eq_false_intro goal)))


-- problems/phase10/example20.lean
theorem phase10_example20 : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> And B C) -> And (A -> B) (A -> C) :=
  (by grind)

theorem phase10_example20_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> And B C) -> And (A -> B) (A -> C) :=
  (by sorry)
