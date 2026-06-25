def phase00_example43 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A) ->
    (g : A -> A -> A -> A) ->
    @Eq A a d ->
    @Eq A b e ->
    @Eq A c f ->
    @Eq A (g a b c) (g d e f) :=
  by grind
