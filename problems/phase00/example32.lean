def phase00_example32 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A -> A) ->
    (g : A -> A -> A) ->
    @Eq A a b ->
    @Eq A c d ->
    @Eq A (f a c) (g b d) ->
    @Eq A (f a c) (g a d) :=
  by grind
