def phase10_example33 :
    (A : Prop) ->
    (B : Prop) ->
    Or (A -> B) (B -> A) :=
  by grind
