def phase00_example11 :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (e : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    @Eq A b c ->
    @Eq A c d ->
    @Eq A d e ->
    @Eq A (f a) (f e) :=
  by grind
