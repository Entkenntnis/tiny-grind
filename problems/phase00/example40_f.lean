def phase00_example40_f :
    (A : Type) ->
    (P : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    P a ->
    P b :=
  by grind
