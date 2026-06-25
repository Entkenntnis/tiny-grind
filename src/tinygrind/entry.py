# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from typing import Literal
from scaffolding.printer import print_term
from scaffolding.syntax import App, Definition, ElabTactic, Lam, Pi, Sort, Term, Var


from tinygrind import egraph
from tinygrind.egraph import (
    Application,
    Constant_,
    EGraph,
    EGraph_,
    Equals,
    Equals_,
    FalseTerm_,
    FunctionApplication_,
    FunctionSymbol_,
    PredicateApplication_,
    PredicateSymbol_,
    Symbol,
    TrueTerm_,
    ValueTerm_,
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

    egraph_ = EGraph_()
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
            _ = egraph_.addTerm(Constant_(name))
            egraph.addSymbol(Symbol(name, 0, "Sort"))
            names.append(name)
        elif name and isFunction(type, env):
            arity = compute_arity(type)
            arities[name] = arity
            env[name] = "function"
            print(f"    - Adding new function {name} with arity {arity}")
            _ = egraph_.addTerm(FunctionSymbol_(name, arity))
            egraph.addSymbol(Symbol(name, arity, "Sort"))
            names.append(name)
        elif name and isPredicate(type, env):
            arity = compute_arity(type)
            arities[name] = arity
            env[name] = "predicate"
            print(f"    - Adding new predicate {name} with arity {arity}")
            _ = egraph_.addTerm(PredicateSymbol_(name, arity))
            egraph.addSymbol(Symbol(name, arity, "Prop"))
            names.append(name)
        elif isinstance(type, App):
            print(f"    - add hypothesis {print_term(type)} to egraph")
            eg_term = lean_to_egraph_(type, env, arities)
            if not isinstance(eg_term, Equals_) and not isinstance(
                eg_term, PredicateApplication_
            ):
                raise RuntimeError(f"Egraph term {eg_term} must be a predicate")
            proof_name = f"h{h_counter}"
            h_counter += 1
            _ = egraph_.addTerm(eg_term, Var(proof_name))
            egraph.addProp(lean_to_egraph(type, env, arities), Var(proof_name))
            names.append(proof_name)
        else:
            print(f"TODO: Handling {name} / {type} with type {print_term(type)}")

    goal_eg = lean_to_egraph_(goal, env, arities)

    if (
        not isinstance(goal_eg, TrueTerm_)
        and not isinstance(goal_eg, FalseTerm_)
        and not isinstance(goal_eg, Equals_)
        and not isinstance(goal_eg, PredicateApplication_)
    ):
        raise RuntimeError("Expect PropTerm as goal")

    _ = egraph_.addGoal(goal_eg, Var("goal"))
    egraph.addGoal(lean_to_egraph(goal, env, arities), Var("goal"))

    if egraph_.isBottom():
        print(f"   = egraph found solution, TODO: generate proof")
        body = App(
            Var("Classical.byContradiction"),
            Lam(
                "goal",
                Var("_"),
                App(
                    Var("false_of_true_eq_false"),
                    egraph_.find_proof(TrueTerm_(), FalseTerm_()),
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


def lean_to_egraph_(term: Term, env: Env, arities: dict[str, int]) -> egraph.Term_:
    if isinstance(term, App):
        args: list[Term] = []
        t = term
        while isinstance(t, App):
            args.insert(0, t.n)
            t = t.m
        head = lean_to_egraph_(t, env, arities)

        def convertValue(term: Term) -> ValueTerm_:
            t = lean_to_egraph_(term, env, arities)
            if not isinstance(t, Constant_) and not isinstance(t, FunctionApplication_):
                raise RuntimeError(f"Value expected, instead got {t}")
            return t

        if isinstance(head, FunctionSymbol_):
            if head.name == "@Eq":
                return Equals_(convertValue(args[1]), convertValue(args[2]))
            return FunctionApplication_(head, tuple([convertValue(x) for x in args]))
        elif isinstance(head, PredicateSymbol_):
            return PredicateApplication_(head, tuple([convertValue(x) for x in args]))
        else:
            raise RuntimeError(f"Can't handle {term} in app with head {head}")
    elif isinstance(term, Var):
        if term.name == "@Eq":
            return FunctionSymbol_("@Eq", -1)
        elif env[term.name] == "constant":  # special case here
            return Constant_(term.name)
        elif env[term.name] == "function" and term.name in arities:
            return FunctionSymbol_(term.name, arities[term.name])
        elif env[term.name] == "predicate" and term.name in arities:
            return PredicateSymbol_(term.name, arities[term.name])
        raise RuntimeError(f"Can't handle {term} in var")
    else:
        raise RuntimeError(f"Can't convert {term} to egraph")


def lean_to_egraph(term: Term, env: Env, arities: dict[str, int]) -> egraph.Term:
    if isinstance(term, App):
        args: list[Term] = []
        t = term
        while isinstance(t, App):
            args.insert(0, t.n)
            t = t.m
        head = lean_to_egraph(t, env, arities)

        def convertValue(term: Term) -> egraph.Term:
            t = lean_to_egraph(term, env, arities)
            # if not isinstance(t, Symbol) and not isinstance(t, Application):
            #     raise RuntimeError(f"Value expected, instead got {t}")
            return t

        if isinstance(head, Symbol):
            if head.name == "@Eq":
                return Equals(convertValue(args[1]), convertValue(args[2]))
            return Application(head, tuple([convertValue(x) for x in args]))
        else:
            raise RuntimeError(f"Can't handle {term} in app with head {head}")
    elif isinstance(term, Var):
        if term.name == "@Eq":
            return Symbol("@Eq", -1, "Prop")
        elif env[term.name] == "constant":  # special case here
            return Symbol(term.name, 0, "Sort")
        elif env[term.name] == "function" and term.name in arities:
            return Symbol(term.name, arities[term.name], "Prop")
        elif env[term.name] == "predicate" and term.name in arities:
            return Symbol(term.name, arities[term.name], "Sort")
        raise RuntimeError(f"Can't handle {term} in var")
    else:
        raise RuntimeError(f"Can't convert {term} to egraph")
