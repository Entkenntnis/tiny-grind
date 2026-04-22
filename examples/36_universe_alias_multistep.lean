def p36_u0 : Sort 2 :=
  Type

def p36_u1 : Sort 2 :=
  p36_u0

def p36_u2 : Sort 2 :=
  p36_u1

def p36_alias_id : p36_u2 -> p36_u0 :=
  fun (U : p36_u2) => U

def p36_alias_back : p36_u0 -> p36_u2 :=
  fun (U : p36_u0) => U

