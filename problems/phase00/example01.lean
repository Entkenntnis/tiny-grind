def phase00_example01 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    @Eq A x y ->
    P x ->
    P y :=
  by grind
