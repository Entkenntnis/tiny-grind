def phase00_example25_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A (f a) (g b) ->
    @Eq A (f c) (g d) ->
    @Eq A a c :=
  by grind
