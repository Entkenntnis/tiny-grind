def phase00_example56 :
    (A : Type) ->
    (B : Type) ->
    (P : B -> A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (x : B) ->
    (y : B) ->
    @Eq A a b ->
    @Eq B x y ->
    P x a ->
    P y b :=
  by grind
