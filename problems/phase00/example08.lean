def phase00_example08 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A (f b) (g a) ->
    @Eq A (f a) (g b) :=
  by grind
