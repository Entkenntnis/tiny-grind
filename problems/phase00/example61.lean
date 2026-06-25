def phase00_example61 :
    (A : Type) ->
    (B : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (x : B) ->
    (y : B) ->
    (f : A -> B -> A -> B) ->
    @Eq A a b ->
    @Eq A c b ->
    @Eq B x y ->
    @Eq B (f a x c) (f b y b) :=
  by grind
