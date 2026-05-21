-- yeah, grind can't solve it completely by hand, but with some support, it can work out
-- the "boring" parts by itself

theorem ALG018_plus_1 :
    (u : Type) -> (op1 : u -> u -> u) -> (op2 : u -> u -> u) -> (h : u -> u) -> (j : u -> u)
    -> (S1 : u -> Prop) ->
    (S2 : u -> Prop) -> (ax1 : (U : u) -> S1 U -> (V : u) -> S1 V -> S1 (op1 U V)) ->
    (ax2 : (U : u) -> S2 U -> (V : u) -> S2 V -> S2 (op2 U V)) ->
    (ax3 : @Exists u (fun (U : u) => And (S1 U) ((V : u) -> S1 V -> @Eq u (op1 V V) U))) ->
    (ax4 : Not (@Exists u (fun (U : u) => And (S2 U) ((V : u) -> S2 V -> @Eq u (op2 V V) U)))) ->
     ((U : u) -> And (S1 U -> S2 (h U)) ((V : u) -> S2 V -> S1 (j V))) ->
     Not ((W : u) -> And (S1 W -> (X : u) -> S1 X -> @Eq u (h (op1 W X)) (op2 (h W) (h X)))
     ((Y : u) -> And (S2 Y -> (Z : u) -> S2 Z -> @Eq u (j (op2 Y Z)) (op1 (j Y) (j Z)))
     ((X1 : u) ->
     And (S2 X1 -> @Eq u (h (j X1)) X1) ((X2 : u) -> S1 X2 -> @Eq u (j (h X2)) X2)))) := by
  intros; expose_names
  intro H_iso
  obtain ⟨ U, hU ⟩ := ax3
  -- Extract the properties asserting that h and j map elements between S1 and S2
  have h_S2_S1 : ∀ X, S2 X → S1 (j X) := fun X => (h_1 U).2 X
  have hj_inv : ∀ X1, S2 X1 → h (j X1) = X1 := fun X1 hX1 => (((H_iso U).2 U).2 X1).1 hX1
  grind
