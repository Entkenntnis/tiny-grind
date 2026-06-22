def phase00_example31 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (f : A -> A -> A) ->
    (g : A -> A) ->
    @Eq A a b ->
    @Eq A (f (g a) c) (f (g b) c) :=
  by grind
