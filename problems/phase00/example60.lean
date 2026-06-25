def phase00_example60 :
    (A : Type) ->
    (B : Type) ->
    (P : B -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : B) ->
    (f : A -> B) ->
    @Eq A a b ->
    @Eq B (f a) c ->
    P c ->
    P (f b) :=
  by grind
