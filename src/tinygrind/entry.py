# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from typing import Literal
from scaffolding.printer import print_term
from scaffolding.syntax import App, Definition, ElabTactic, Lam, Pi, Sort, Term, Var


from tinygrind import egraph
from tinygrind.egraph import (
    Application,
    EGraph,
    Equals,
    FalseTerm,
    Symbol,
    TrueTerm,
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

    egraph = EGraph(debug=True)

    names: list[str] = []
    h_counter = 1

    for name, type in context:
        if isinstance(type, Sort) and type.level == 1 and name:
            if "type" in env.values():
                raise RuntimeError("We only support at most one type right now.")
            print(f"    - Adding new type {name} to env")
            env[name] = "type"
            names.append(name)
        elif isinstance(type, Var) and name and env[type.name] == "type":
            print(f"    - Adding new constant {name}")
            env[name] = "constant"
            egraph.addSymbol(Symbol(name, 0))
            names.append(name)
        elif name and isFunction(type, env):
            arity = compute_arity(type)
            arities[name] = arity
            env[name] = "function"
            print(f"    - Adding new function {name} with arity {arity}")
            egraph.addSymbol(Symbol(name, arity))
            names.append(name)
        elif name and isPredicate(type, env):
            arity = compute_arity(type)
            arities[name] = arity
            env[name] = "predicate"
            print(f"    - Adding new predicate {name} with arity {arity}")
            egraph.addSymbol(Symbol(name, arity))
            names.append(name)
        elif isinstance(type, App):
            print(f"    - add hypothesis {print_term(type)} to egraph")
            proof_name = f"h{h_counter}"
            h_counter += 1
            egraph.addProp(lean_to_egraph(type, env, arities), Var(proof_name))
            names.append(proof_name)
        else:
            print(f"TODO: Handling {name} / {type} with type {print_term(type)}")

    egraph.addGoal(lean_to_egraph(goal, env, arities), Var("goal"))

    if egraph.isBottom():
        print(f"   = egraph found solution, TODO: generate proof")
        body = App(
            Var("Classical.byContradiction"),
            Lam(
                "goal",
                Var("_"),
                App(
                    Var("false_of_true_eq_false"),
                    egraph.findProof(TrueTerm(), FalseTerm()),
                ),
            ),
        )
        for name in reversed(names):
            body = Lam(name, Var("_"), body)
        return body
    else:
        print(f"   = no proof here")
        return ElabTactic("sorry")


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


def lean_to_egraph(term: Term, env: Env, arities: dict[str, int]) -> egraph.Term:
    if isinstance(term, App):
        appHead = term
        while isinstance(appHead, App):
            appHead = appHead.m
        if isinstance(appHead, Var) and appHead.name == "@Eq":
            t = term
            args: list[Term] = []
            while isinstance(t, App):
                args.insert(0, t.n)
                t = t.m
            return Equals(
                lean_to_egraph(args[1], env, arities),
                lean_to_egraph(args[2], env, arities),
            )
        else:
            head = lean_to_egraph(term.m, env, arities)
            arg = lean_to_egraph(term.n, env, arities)
            return Application(head, arg)
    elif isinstance(term, Var):
        if term.name == "@Eq":
            return Symbol("@Eq", -1)
        elif env[term.name] == "constant":  # special case here
            return Symbol(term.name, 0)
        elif env[term.name] == "function" and term.name in arities:
            return Symbol(term.name, arities[term.name])
        elif env[term.name] == "predicate" and term.name in arities:
            return Symbol(term.name, arities[term.name])
        raise RuntimeError(f"Can't handle {term} in var")
    else:
        raise RuntimeError(f"Can't convert {term} to egraph")
