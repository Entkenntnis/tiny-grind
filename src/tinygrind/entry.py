# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from scaffolding.printer import print_term
from scaffolding.syntax import Definition, ElabTactic, Pi, Sort, Term

import sys


def tinygrind(definition: Definition) -> Term:

    return ElabTactic("sorry")
    print("  > tinygrind")

    theorem = definition.type

    context: list[tuple[str | None, Term]] = []

    theType: str | None = None

    while isinstance(theorem, Pi):
        var = theorem.var
        var_type = theorem.var_type

        if (isinstance(var_type, Sort)) and var_type.level == 1:
            if theType == None:
                print(f"registering the variable type as {var}")
                theType = var
            else:
                print("[!] We are not supporting multiple types yet")
                return ElabTactic("sorry")

        # it's a little bit tricky, because the interface will work through
        # all possible system states

        print(f"var: {var}, var_type: {print_term(var_type)}")

        context.append((var, var_type))
        theorem = theorem.body

    goal = context.pop()

    print(f"    context: {", ".join([f"{v} : {print_term(t)}" for (v, t) in context])}")
    print(f"    goal: {print_term(goal[1])}")

    sys.exit()
