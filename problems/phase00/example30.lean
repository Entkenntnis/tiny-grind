def phase00_example30 :
    (A : Type) ->
    (P : A -> A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    (d : A) ->
    @Eq A a b ->
    @Eq A c d ->
    P a c ->
    P b d :=
  by grind
