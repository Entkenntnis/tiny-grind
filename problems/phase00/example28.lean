def phase00_example28 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A -> A) ->
    @Eq A a b ->
    @Eq A c d ->
    @Eq A (f a c) (f b d) :=
  by grind
