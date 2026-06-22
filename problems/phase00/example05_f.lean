def phase00_example05_f :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    @Eq A x y ->
    P x :=
  by grind
