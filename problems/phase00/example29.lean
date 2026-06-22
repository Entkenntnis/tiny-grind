def phase00_example29 :
    (A : Type) ->
    (P : A -> A -> Prop) ->
    (a : A) ->
    (b : A) ->
    (c : A) ->
    @Eq A a b ->
    P a c ->
    P b c :=
  by grind
