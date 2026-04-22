def f36_u0 : Sort 2 :=
  Type

def f36_u1 : Sort 2 :=
  f36_u0

def f36_id_alias : f36_u1 -> f36_u0 :=
  fun (U : f36_u1) => U

def f36_bad_level : Sort 3 :=
  f36_u1

