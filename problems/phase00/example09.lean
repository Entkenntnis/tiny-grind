def phase00_example09 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A (f (g a)) (f (g b)) :=
  by grind
