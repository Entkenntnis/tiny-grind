def phase10_example45 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (D : Prop) ->
    (E : Prop) ->
    And A B -> And E (And C D) ->
    C :=
  by grind
