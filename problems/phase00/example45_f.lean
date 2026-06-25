def phase00_example45_f :
    (A : Type) ->
    (P : A -> A -> A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    @Eq A a d ->
    @Eq A b e ->
    @Eq A c f ->
    P a b c ->
    P d e d :=
  by grind
