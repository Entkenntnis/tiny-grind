# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from scaffolding.printer import print_term
from scaffolding.syntax import Definition, ElabTactic, Pi, Term


def tinygrind(definition: Definition) -> Term:
    print("  > tinygrind")

    theorem = definition.type

    context: list[tuple[str | None, Term]] = []

    while isinstance(theorem, Pi):
        context.append((theorem.var, theorem.var_type))
        theorem = theorem.body

    goal = context.pop()

    print(f"    context: {", ".join([f"{v} : {print_term(t)}" for (v, t) in context])}")
    print(f"    goal: {print_term(goal[1])}")

    return ElabTactic("sorry")
