def demo3_base_universe : Sort 2 :=
  Type

def demo3_alias_universe : Sort 2 :=
  demo3_base_universe

def demo3_delta_alias_chain :
  demo3_base_universe -> demo3_alias_universe :=
  fun (u : demo3_base_universe) => u
