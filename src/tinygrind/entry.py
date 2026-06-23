# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from typing import Literal
from scaffolding.printer import print_term
from scaffolding.syntax import App, Definition, ElabTactic, Pi, Sort, Term, Var

import sys

from tinygrind import egraph
from tinygrind.egraph import (
    Constant,
    EGraph,
    Equals,
    FunctionSymbol,
    PredicateApplication,
    PredicateSymbol,
)

type Env = dict[str, Literal["type", "constant", "function", "predicate"]]


def tinygrind(definition: Definition) -> Term:
    print("  > tinygrind")

    theorem = definition.type

    context: list[tuple[str | None, Term]] = []

    while isinstance(theorem, Pi):
        context.append((theorem.var, theorem.var_type))
        theorem = theorem.body

    goal = theorem

    env: Env = {}
    arities: dict[str, int] = {}

    egraph = EGraph()

    for name, type in context:
        if isinstance(type, Sort) and type.level == 1 and name:
            if "type" in env.values():
                raise RuntimeError("We only support at most one type right now.")
            print(f"    - Adding new type {name} to env")
            env[name] = "type"
        elif isinstance(type, Var) and name and env[type.name] == "type":
            print(f"    - Adding new constant {name}")
            env[name] = "constant"
            _ = egraph.addTerm(Constant(name))
        elif name and isFunction(type, env):
            arity = compute_arity(type)
            arities[name] = arity
            env[name] = "function"
            print(f"    - Adding new function {name} with arity {arity}")
            _ = egraph.addTerm(FunctionSymbol(name, arity))
        elif name and isPredicate(type, env):
            arity = compute_arity(type)
            arities[name] = arity
            env[name] = "predicate"
            print(f"    - Adding new predicate {name} with arity {arity}")
            _ = egraph.addTerm(PredicateSymbol(name, arity))
        elif isinstance(type, App):
            print(f"    - (todo) add hypothesis {print_term(type)} to egraph")
            eg_term = lean_to_egraph(type, env, arities)
            if not isinstance(eg_term, Equals) or not isinstance(
                eg_term, PredicateApplication
            ):
                pass
                # raise RuntimeError("Egraph Term must be a predicate")
            # _ = egraph.addTerm(eg_term)
        else:
            print(f"TODO: Handling {name} / {type} with type {print_term(type)}")

    # TODO: negate goal, check for bottom, return sorry or proof (todo)


def isFunction(type: Term, env: Env) -> bool:
    # check if the type is a function
    if (
        isinstance(type, Pi)
        and isinstance(type.var_type, Var)
        and env[type.var_type.name] == "type"
    ):
        # we have a function application
        if isinstance(type.body, Var) and env[type.body.name] == "type":
            return True
        else:
            return isFunction(type.body, env)

    return False


def isPredicate(type: Term, env: Env) -> bool:
    # check if the type is a function
    if (
        isinstance(type, Pi)
        and isinstance(type.var_type, Var)
        and env[type.var_type.name] == "type"
    ):
        # we have a function application
        if isinstance(type.body, Sort) and type.body.level == 0:
            return True
        else:
            return isPredicate(type.body, env)

    return False


def compute_arity(t: Term) -> int:
    count = 0
    while isinstance(t, Pi):
        count += 1
        t = t.body
    return count


def lean_to_egraph(term: Term, env: Env, arities: dict[[str, str]]) -> egraph.Term:
    # NEXTUP
    pass
