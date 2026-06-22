# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from typing import Literal
from scaffolding.printer import print_term
from scaffolding.syntax import Definition, ElabTactic, Pi, Sort, Term, Var

import sys


def tinygrind(definition: Definition) -> Term:
    print("  > tinygrind")

    theorem = definition.type

    context: list[tuple[str | None, Term]] = []

    while isinstance(theorem, Pi):
        var = theorem.var
        var_type = theorem.var_type

        print(f"var: {var}, var_type: {print_term(var_type)}")

        context.append((var, var_type))
        theorem = theorem.body

    goal = context.pop()

    print(f"    context: {", ".join([f"{v} : {print_term(t)}" for (v, t) in context])}")
    print(f"    goal: {print_term(goal[1])}")

    theType: str | None = None

    def checkContextTyp(
        t: Term, theType: str
    ) -> Literal["theType", "propDef", "funDef", "h"]:
        if isinstance(t, Sort) and t.level == 1:
            return "theType"
        if isinstance(t, Sort) and t.level == 0:
            return "h"
        if isinstance(t, Var) and t.name == theType:
            return "funDef"

        print(t)

    # TODO: go through the context and build

    for c in context:
        print(checkContextTyp(c, theType))
