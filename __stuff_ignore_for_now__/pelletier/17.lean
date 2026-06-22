theorem pelletier_17 :
    (P : Prop) ->
    (Q : Prop) ->
    (R : Prop) ->
    (S : Prop) ->
    (Iff
      ((And P (Q -> R)) -> S)
      (And
        (Or (Not P) (Or Q S))
        (Or (Not P) (Or (Not R) S)))) :=
  by grind
