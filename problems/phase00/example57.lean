def phase00_example57 :
    (A : Type) ->
    (B : Type) ->
    (C : Type) ->
    (a : A) ->
    (b : A) ->
    (f : A -> B) ->
    (g : B -> C) ->
    @Eq A a b ->
    @Eq C (g (f a)) (g (f b)) :=
  by grind
