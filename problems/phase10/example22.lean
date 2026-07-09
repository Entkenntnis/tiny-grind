def phase10_example22:
    (A : Type) ->
    (x : A) ->
    (y : A) ->
    Not (Not (@Eq A x y)) ->
    @Eq A x y :=
  by grind
