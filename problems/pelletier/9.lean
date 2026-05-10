theorem pelletier_9 :
    (P : Prop) ->
    (Q : Prop) ->
    ((And (Or P Q) (And (Or (Not P) Q) (Or P (Not Q))))) ->
    Not (Or (Not P) (Not Q)) :=
  by grind
