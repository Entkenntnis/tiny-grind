def phase10_example18 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    Or A (And B C) ->
    And (Or A B) (Or A C) :=
  by grind
