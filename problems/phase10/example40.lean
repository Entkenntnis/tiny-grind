def phase10_example40 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (D : Prop) ->
    And (Or A B) (Or C D) ->
    Or (Or (Or (And A C) (And A D)) (And B C)) (And B D) :=
  by grind
