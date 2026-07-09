def phase10_example45 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (D : Prop) ->
    (E : Prop) ->
    (F : Prop) ->
    And A (And B F) -> And E (And C D) ->
    C :=
  by grind
