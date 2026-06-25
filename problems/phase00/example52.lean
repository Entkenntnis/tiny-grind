def phase00_example52 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A) ->
    (g : A -> A -> A) ->
    @Eq A a b ->
    @Eq A (f c) d ->
    @Eq A (g a (f c)) (g b d) :=
  by grind
