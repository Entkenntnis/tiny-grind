def demo3_function_alias : Sort 2 :=
  Type -> Type

def demo3_function_alias_equiv : demo3_function_alias :=
  fun (A : Type) => A
