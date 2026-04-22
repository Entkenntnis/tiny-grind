def demo2_bad_universe_k_target :
  (U : Sort 2) -> (V : Sort 3) -> U -> V -> U :=
  fun (U : Sort 2) (V : Sort 3) (u : U) (v : V) => v
