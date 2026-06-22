/-- `grind` failed -/
#guard_msgs (substring := true) in
def basic_subst : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y: A) -> @Eq A x y -> P y :=
    by grind
