def demo3_alias_type : Sort 2 :=
  Type

def demo3_delta_alias_domain : Type -> Type :=
  fun (A : demo3_alias_type) => A
