-- GRIND is not good at instantiation, so help grind by explicitly providing plausible candidates
-- this works quite nicely
-- the model encoding stuff is seriously crazy and fancy

theorem can_convince :
    (Person : Type) ->
    (me : Person) ->
    (Stmt : Type) ->
    (knight : Person -> Stmt) ->
    (knave : Person -> Stmt) ->
    (rich : Person -> Stmt) ->
    (poor : Person -> Stmt) ->
    (and : Stmt -> Stmt -> Stmt) ->
    (is_saying : Person -> Stmt -> Prop) ->
    (a_truth : Stmt -> Stmt -> Prop) ->
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
    -- explicitly list all 8 plausible statements
    (S1 : Stmt) ->
    (h_S1 : @Eq Stmt S1 (and (poor me) (knave me))) ->
    (S2 : Stmt) ->
    (h_S2 : @Eq Stmt S2 (and (rich me) (knave me))) ->
    (S3 : Stmt) ->
    (h_S3 : @Eq Stmt S3 (and (poor me) (knight me))) ->
    (S4 : Stmt) ->
    (h_S4 : @Eq Stmt S4 (and (rich me) (knight me))) ->
    (S5 : Stmt) ->
    (h_S5 : @Eq Stmt S5 (poor me)) ->
    (S6 : Stmt) ->
    (h_S6 : @Eq Stmt S6 (rich me)) ->
    (S7 : Stmt) ->
    (h_S7 : @Eq Stmt S7 (knight me)) ->
    (S8 : Stmt) ->
    (h_S8 : @Eq Stmt S8 (knave me)) ->
    -- one of the statements is convincing
    (Or
      (Iff (is_saying me S1) (a_truth (and (knave me) (rich me)) S1))
      (Or
        (Iff (is_saying me S2) (a_truth (and (knave me) (rich me)) S2))
        (Or
          (Iff (is_saying me S3) (a_truth (and (knave me) (rich me)) S3))
          (Or
            (Iff (is_saying me S4) (a_truth (and (knave me) (rich me)) S4))
            (Or
              (Iff (is_saying me S5) (a_truth (and (knave me) (rich me)) S5))
              (Or
                (Iff (is_saying me S6) (a_truth (and (knave me) (rich me)) S6))
                (Or
                  (Iff (is_saying me S7) (a_truth (and (knave me) (rich me)) S7))
                  (Iff (is_saying me S8) (a_truth (and (knave me) (rich me)) S8)))))))))
  := by
  grind
