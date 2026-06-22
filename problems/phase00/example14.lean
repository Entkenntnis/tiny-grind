def phase00_example14 :
    (A : Type) ->
    (P : A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    @Eq A a b ->
    @Eq A b c ->
    P a ->
    P c :=
  by grind
