def phase10_example26 :
    (A : Type) ->
    (B : Type) ->
    (P : A -> Prop) ->
    (Q : B -> Prop) ->
    (R : Prop) ->
    (f : A -> A) ->
    (x : A) ->
    (y : A) ->
    (z : B) ->
    And (@Eq A x y) (P (f x)) ->
    (P (f y) -> Q z) ->
    (Q z -> R) ->
    R :=
  by grind
