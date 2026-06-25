def phase00_example53 :
    (A : Type) ->
    (B : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> B) ->
    @Eq A a b ->
    @Eq B (f a) (f b) :=
  by grind
