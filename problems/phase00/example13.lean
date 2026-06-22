def phase00_example13 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    (h : A -> A) ->
    @Eq A (f a) b ->
    @Eq A (g b) c ->
    @Eq A (h c) a ->
    @Eq A (f (h (g (f a)))) (f a) :=
  by grind
