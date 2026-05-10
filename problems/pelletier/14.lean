theorem pelletier_14 :
    (P : Prop) ->
    (Q : Prop) ->
    (Iff (Iff P Q) (And (Or Q (Not P)) (Or (Not Q) P))) :=
  by grind
