theorem pelletier_05 :
    (P : Prop) ->
    (Q : Prop) ->
    (R : Prop) ->
    (Or P Q -> Or P R) ->
    Or P (Q -> R) :=
  by grind
