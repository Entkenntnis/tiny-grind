def phase10_example02 :
    (A : Type) ->
    (P : A -> Prop) ->
    (x : A) ->
    (y : A) ->
    ((P x) -> (P y))->
    P x ->
    P y :=
  by grind
