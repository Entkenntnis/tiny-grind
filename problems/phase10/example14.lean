def phase10_example14 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    Or A (Or B C) ->
    Or (Or A B) C :=
  by grind
