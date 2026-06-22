def phase00_example15 :
    (A : Type) ->
    (P : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A a (f b) ->
    P (f b) ->
    P a :=
  by grind
