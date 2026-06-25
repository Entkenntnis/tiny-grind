def phase00_example59 :
    (A : Type) ->
    (B : Type) ->
    (a : A) ->
    (b : A) ->
    (x : B) ->
    (y : B) ->
    (f : A -> B -> B) ->
    @Eq A a b ->
    @Eq B x y ->
    @Eq B (f a x) (f b y) :=
  by grind
