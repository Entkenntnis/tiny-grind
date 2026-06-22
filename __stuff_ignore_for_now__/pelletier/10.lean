theorem pelletier_10 :
    (P : Prop) ->
    (Q : Prop) ->
    (R : Prop) ->
    (Q -> R) ->
    (R -> (And P Q)) ->
    (P -> (Or Q R)) ->
    Iff P Q :=
  by grind
