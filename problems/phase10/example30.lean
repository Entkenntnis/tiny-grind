def phase10_example30 :
    (T : Type) ->
    (f : T -> T) ->
    (x : T) ->
    (y : T) ->
    (z : T) ->
    (A : Prop) ->
    (B : Prop) ->
    (A -> @Eq T (f x) (f y)) ->
    (B -> @Eq T (f y) (f z)) ->
    (And A B -> @Eq T (f x) (f z)) :=
  by grind
