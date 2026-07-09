
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

theorem push_not_or {A B : Prop} (h: (A ∨ B) = False) : (¬ A ∧ ¬ B) = True :=
eq_true ⟨
    fun hA => of_eq_false h (Or.inl hA),
    fun hB => of_eq_false h (Or.inr hB)
  ⟩
-- problems/phase10/example20.lean
theorem phase10_example20 : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> And B C) -> And (A -> B) (A -> C) :=
  (by grind)

theorem phase10_example20_proof : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> And B C) -> And (A -> B) (A -> C) :=
  fun (A : _) => fun (B : _) => fun (C : _) => fun (h1 : _) => Classical.byContradiction (fun (goal : _) => false_of_true_eq_false (or_elim (push_not_and (eq_false_intro goal)) (fun (h_case_20_left : _) => Eq.trans (Eq.symm (eq_true h1)) (Eq.trans (congr rfl (Eq.trans (and_eq_false_of_left_false (eq_false_of_not_eq_true (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_left)))))) (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_left)))))) (Eq.symm (eq_false_of_not_eq_true (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_left)))))) (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_left)))))))) (eq_false_of_not_eq_true (eq_true h_case_20_left)))) (fun (h_case_20_right : _) => Eq.trans (Eq.symm (eq_true h1)) (Eq.trans (congr rfl (Eq.trans (and_eq_false_of_right_false (eq_false_of_not_eq_true (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_right)))))) (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_right)))))) (Eq.symm (eq_false_of_not_eq_true (Eq.trans (Eq.symm (and_eq_right_of_left_true (and_elim_left (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_right)))))) (push_not_imp (eq_false_of_not_eq_true (eq_true h_case_20_right)))))))) (eq_false_of_not_eq_true (eq_true h_case_20_right))))))


