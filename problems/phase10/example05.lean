def phase10_example05 :
    (T: Type) ->
    (A: Prop) ->
    (B: Prop) ->
    (P : T -> Prop) ->
    (Or A B) ->
    (x : T) ->
    (y : T) ->
    (A -> @Eq T x y) ->
    (B -> @Eq T x y) ->
    P x ->
    P y :=
  by grind
