def phase00_example55 :
    (A : Type) ->
    (B : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A -> B) ->
    @Eq A a b ->
    @Eq A c d ->
    @Eq B (f a c) (f b d) :=
  by grind
