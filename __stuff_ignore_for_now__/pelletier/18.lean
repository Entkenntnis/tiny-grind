-- grind struggles with the textbook formalization of the drinkers paradox
-- preprocess by clausification, skolemification and preinstantiation
-- and make explicit that at least one person exists
theorem pelletier_18 :
    (A : Type) ->
    (F : A -> Prop) ->
    (g : A -> A) ->
    (some : A) ->
    (forall (y : A), F y) ->
    (forall (z : A), Not (F (g z))) ->
    -- preinstantiate forall with some
    F some ->
    Not (F (g some)) ->
    False := by
  grind


-- this is a more textbook-like formalization and proof:

-- import Mathlib

-- theorem pelletier_18_textbook_like (A : Type) [Nonempty A] (F : A → Prop) :
--     ∃ y : A, ∀ x : A, F y → F x := by
--   by_cases h : ∀ x, F x
--   · -- all x satisfy F x; pick any element of A
--     obtain ⟨y⟩ := ‹Nonempty A›
--     refine ⟨y, fun x _ => h x⟩
--   · -- there is some x with ¬ F x
--     push Not at h
--     obtain ⟨y, hy⟩ := h
--     refine ⟨y, fun x hFy => absurd hFy hy⟩
