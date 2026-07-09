def phase10_example25 :
    (A : Type) ->
    (P : A -> Prop) ->
    (f : A -> A) ->
    (x : A) ->
    (y : A) ->
    Or (@Eq A x y) (@Eq A (f x) (f y)) ->
    P (f x) ->
    P (f y) :=
  by grind
