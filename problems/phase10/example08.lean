def phase10_example08 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (D : Prop) ->
    Or A (Or B C) ->
    (A -> D) ->
    (B -> D) ->
    (C -> D) ->
    D :=
  by grind
