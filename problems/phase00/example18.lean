def phase00_example18 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A (f (g b)) (f (g a)) :=
  by grind
