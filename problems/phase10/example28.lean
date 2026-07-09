def phase10_example28 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    Or (P x -> @Eq A x y) (@Eq A x y -> P x) :=
  by grind
