theorem pelletier_13 :
    (P : Prop) ->
    (Q : Prop) ->
    (R : Prop) ->
    (Iff
      (Or P (And Q R))
      (And (Or P Q) (Or P R))) :=
  by grind
