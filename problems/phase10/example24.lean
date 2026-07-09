def phase10_example24 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    @Eq A x y ->
    P x ->
    Not (P y) ->
    False :=
  by grind
