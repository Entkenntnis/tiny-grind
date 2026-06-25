def phase00_example62 :
    (A : Type) ->
    (B : Type) ->
    (P : B -> Prop) ->
    (Q : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (x : B) ->
    (f : A -> B) ->
    @Eq A a b ->
    Q a ->
    @Eq B (f a) x ->
    P x ->
    P (f b) :=
  by grind
