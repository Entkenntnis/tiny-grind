def demo2_universe_s :
  (U : Sort 2) -> (V : Sort 2) -> (W : Sort 3) ->
  (U -> V -> W) -> (U -> V) -> U -> W :=
  fun (U : Sort 2) (V : Sort 2) (W : Sort 3)
      (s : U -> V -> W) (g : U -> V) (u : U) =>
    s u (g u)
