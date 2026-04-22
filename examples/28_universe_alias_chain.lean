def demo3_u0 : Sort 2 :=
  Type

def demo3_u1 : Sort 2 :=
  demo3_u0

def demo3_universe_alias_chain :
  demo3_u1 -> demo3_u0 :=
  fun (U : demo3_u1) => U
