def phase10_example09 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    And (Or A B) (And (A -> C) (B -> C)) ->
    C :=
  by grind
