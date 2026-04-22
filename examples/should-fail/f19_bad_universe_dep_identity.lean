def demo2_bad_universe_dep_identity :
  (U : Sort 2) -> (F : U -> Sort 2) -> (u : U) -> F u -> F u :=
  fun (U : Sort 2) (F : U -> Sort 2) (u : U) (fu : F u) =>
    u
