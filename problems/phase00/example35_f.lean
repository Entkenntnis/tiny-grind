def phase00_example35_f :
    (A : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    (f : A -> A -> A) ->
    @Eq A a b ->
    @Eq A (f a c) (f b d) :=
  by grind
