def pahse10_example27 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    ((@Eq A x y -> P x) -> @Eq A x y) ->
    @Eq A x y :=
  by grind
