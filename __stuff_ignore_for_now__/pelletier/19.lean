-- import Mathlib

theorem pelletier_19 :
    (A : Type) ->
    (P : A -> Prop) ->
    (Q : A -> Prop) ->
    (f : A -> A) ->
    (g : A -> A) ->
    (forall (x : A), (Or (Not (P (f x))) (Q (g x)))) ->
    (forall (x : A), P x) ->
    (forall (x : A), Not (Q x)) ->
    (some : A) ->
    -- again, grind will not try "some", so help a bit by
    -- preinstantiate some into foralls
    (Or (Not (P (f some))) (Q (g some))) ->
    P some ->
    Not (Q some) ->
    False := by
  grind


-- theorem pelletier_19_textbook (A : Type) (P Q : A -> Prop) (some : A):
--     ∃ x, ∀ y, ∀ z, (P y -> Q z) -> (P x -> Q x) := by
--   sorry
