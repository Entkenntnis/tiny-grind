def phase00_example58 :
    (A : Type) ->
    (B : Type) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (x : B) ->
    (y : B) ->
    (z : B) ->
    (f : A -> B) ->
    @Eq A a b ->
    @Eq A b c ->
    @Eq B x y ->
    @Eq B y z ->
    @Eq B (f a) x ->
    @Eq B (f c) z :=
  by grind
