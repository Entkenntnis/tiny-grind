def phase10_example23 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    (P x -> @Eq A x y) ->
    (Not ((P x) -> @Eq A x y)) ->
    @Eq A x y :=
  by grind
