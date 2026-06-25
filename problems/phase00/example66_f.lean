def phase00_example66_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    (h : A -> A) ->
    @Eq A a (f b) ->
    @Eq A (f b) (g c) ->
    @Eq A (g c) (h d) ->
    @Eq A d a ->
    @Eq A (g (f (h a))) (g (f (g b))) :=
  by grind
