def phase10_example07 :
    (A : Prop) ->
    (B : Prop) ->
    Or A B ->
    Or B A :=
  by grind
