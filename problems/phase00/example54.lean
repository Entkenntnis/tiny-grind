def phase00_example54 :
    (A : Type) ->
    (B : Type) ->
    (P : B -> Prop) ->
    (a : A) ->
    (b : A) ->
    (f : A -> B) ->
    @Eq A a b ->
    P (f a) ->
    P (f b) :=
  by grind
