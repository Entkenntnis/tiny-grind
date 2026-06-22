def phase00_example20 :
    (A : Type) ->
    (P : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (f : A -> A) ->
    @Eq A a b ->
    P (f b) ->
    P (f a) :=
  by grind
