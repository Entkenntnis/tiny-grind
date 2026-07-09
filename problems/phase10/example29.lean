def phase10_example29 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    (P x -> (@Eq A x y -> False)) ->
    ((P x -> @Eq A x y) -> (P x -> False)) :=
  by grind
