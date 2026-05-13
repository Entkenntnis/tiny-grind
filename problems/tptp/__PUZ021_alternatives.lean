-- GRIND is not good at instantiation, so help grind by explicitly providing plausible candidates
-- this works quite nicely
-- the model encoding stuff is seriously crazy and fancy
axiom Person : Type
axiom me : Person
axiom Stmt : Type
axiom knight : Person -> Stmt
axiom knave : Person -> Stmt
axiom rich : Person -> Stmt
axiom poor : Person -> Stmt
axiom and : Stmt -> Stmt -> Stmt
axiom is_saying : Person -> Stmt -> Prop
axiom a_truth : Stmt -> Stmt -> Prop

axiom h_neg_conj_1 :
  forall (X : Stmt),
        (Or (Not (is_saying me X))
            (Not (a_truth (and (knave me) (rich me)) X)))

axiom h_neg_conj_2 :
  forall (X : Stmt),
        (Or (is_saying me X)
            (a_truth (and (knave me) (rich me)) X))


grind_pattern h_neg_conj_1 => is_saying _ X

theorem can_convince_alternative :
    (h_not_knight_and_knave :
      forall (p : Person),
      forall (c : Stmt),
        Not (And (a_truth (knight p) c) (a_truth (knave p) c))) ->
    (h_knight_or_knave :
      forall (p : Person),
      forall (c : Stmt),
        Or (a_truth (knight p) c) (a_truth (knave p) c)) ->
    (h_not_rich_and_poor :
      forall (p : Person),
      forall (c : Stmt),
        Not (And (a_truth (rich p) c) (a_truth (poor p) c))) ->
    (h_rich_or_poor :
      forall (p : Person),
      forall (c : Stmt),
        Or (a_truth (rich p) c) (a_truth (poor p) c)) ->
    (h_knights__tell_truth1 :
      forall (p : Person),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth (knight p) Z -> is_saying p Y -> a_truth Y Z) ->
    (h_knights__tell_truth2 :
      forall (p : Person),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth (knight p) Z -> a_truth Y Z -> is_saying p Y) ->
    (h_knaves_lie1 :
      forall (p : Person),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth (knave p) Z -> is_saying p Y -> Not (a_truth Y Z)) ->
    (h_knaves_lie2 :
      forall (p : Person),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth (knave p) Z -> Not (a_truth Y Z) -> is_saying p Y) ->
    (h_conjunction1 :
      forall (X : Stmt),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth (and X Y) Z -> a_truth X Z) ->
    (h_conjunction2 :
      forall (X : Stmt),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth (and X Y) Z -> a_truth Y Z) ->
    (h_conjunction3 :
      forall (X : Stmt),
      forall (Y : Stmt),
      forall (Z : Stmt),
        a_truth X Z -> a_truth Y Z -> a_truth (and X Y) Z) ->
    False
  := by
  intros
  expose_names
  have := h_neg_conj_1 (and (poor me) (knave me))
  grind (instances := 10000)[h_neg_conj_2]


-- theorem can_convince_alt3 :
--     (Person : Type) ->
--     (me : Person) ->
--     (Stmt : Type) ->
--     (knight : Person -> Stmt) ->
--     (knave : Person -> Stmt) ->
--     (rich : Person -> Stmt) ->
--     (poor : Person -> Stmt) ->
--     (and : Stmt -> Stmt -> Stmt) ->
--     (is_saying : Person -> Stmt -> Prop) ->
--     (a_truth : Stmt -> Stmt -> Prop) ->
--     (h_not_knight_and_knave :
--       forall (p : Person),
--       forall (c : Stmt),
--         Not (And (a_truth (knight p) c) (a_truth (knave p) c))) ->
--     (h_knight_or_knave :
--       forall (p : Person),
--       forall (c : Stmt),
--         Or (a_truth (knight p) c) (a_truth (knave p) c)) ->
--     (h_not_rich_and_poor :
--       forall (p : Person),
--       forall (c : Stmt),
--         Not (And (a_truth (rich p) c) (a_truth (poor p) c))) ->
--     (h_rich_or_poor :
--       forall (p : Person),
--       forall (c : Stmt),
--         Or (a_truth (rich p) c) (a_truth (poor p) c)) ->
--     (h_knights__tell_truth1 :
--       forall (p : Person),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth (knight p) Z -> is_saying p Y -> a_truth Y Z) ->
--     (h_knights__tell_truth2 :
--       forall (p : Person),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth (knight p) Z -> a_truth Y Z -> is_saying p Y) ->
--     (h_knaves_lie1 :
--       forall (p : Person),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth (knave p) Z -> is_saying p Y -> Not (a_truth Y Z)) ->
--     (h_knaves_lie2 :
--       forall (p : Person),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth (knave p) Z -> Not (a_truth Y Z) -> is_saying p Y) ->
--     (h_conjunction1 :
--       forall (X : Stmt),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth (and X Y) Z -> a_truth X Z) ->
--     (h_conjunction2 :
--       forall (X : Stmt),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth (and X Y) Z -> a_truth Y Z) ->
--     (h_conjunction3 :
--       forall (X : Stmt),
--       forall (Y : Stmt),
--       forall (Z : Stmt),
--         a_truth X Z -> a_truth Y Z -> a_truth (and X Y) Z) ->
--     -- explicitly list all 8 plausible statements
--     (h_neg_conj_1 :
--       forall (X : Stmt),
--         (Or (Not (is_saying me X))
--             (Not (a_truth (and (knave me) (rich me)) X)))) ->
--     (h_neg_conj_2 :
--       forall (X : Stmt),
--         (Or (is_saying me X)
--             (a_truth (and (knave me) (rich me)) X))) ->
--     -- grind hints
--     (hint1 : h_neg_conj_1 (and (poor me) (knave me)))
--     False
--   := by
--   intros
--   expose_names
--   have := h_neg_conj_1 (and (poor me) (knave me))
--   grind
