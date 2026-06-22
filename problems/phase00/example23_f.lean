def phase00_example23_f :
    (A : Type) ->
    (P : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A a (f b) ->
    P (f b) ->
    P b :=
  by grind
