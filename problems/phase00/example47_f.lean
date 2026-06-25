def phase00_example47_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A (f c) d ->
    @Eq A (g (f a)) (g (f d)) :=
  by grind
