def phase10_example46 :
    (A : Prop) ->
    (B : Prop) ->
    (C : Prop) ->
    (D : Prop) ->
    (E : Prop) ->
    (And (And (And (And (And (And (And (And (And (Or A B) (Or (Not A) (Not B))) (Or B C)) (Or (Not B) (Not C))) (Or C D)) (Or (Not C) (Not D))) (Or D E)) (Or (Not D) (Not E))) (Or A E)) (Or (Not A) (Not E))) -> False :=
  by grind
