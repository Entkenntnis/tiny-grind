theorem pelletier_12 :
    (P : Prop) ->
    (Q : Prop) ->
    (R : Prop) ->
    Iff (Iff (Iff P Q) R) (Iff P (Iff Q R)) :=
  by grind
