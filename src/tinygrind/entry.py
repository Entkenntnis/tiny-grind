# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

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


def tinygrind(definition: Definition) -> Term:
    theorem = definition.type
    context: list[tuple[str | None, Term]] = []
    while isinstance(theorem, Pi):
        context.append((theorem.var, theorem.var_type))
        theorem = theorem.body
    goal = theorem

    egraph = EGraph()
    names: list[str] = []
    h_counter = 1

    for name, type in context:
        if isinstance(type, Sort) and type.level == 1 and name:
            names.append(name)
        elif name:
            # functions and implications are not differentiated, uff
            # interesting
            # but that's kinda complicated, no?
            # later on I should probably make this a bit more robust
            egraph.addSymbol(Symbol(name))
            names.append(name)
        elif isinstance(type, App) or isinstance(type, Pi) or isinstance(type, Var):
            proof_name = f"h{h_counter}"
            h_counter += 1
            egraph.addProp(lean_to_egraph(type), Var(proof_name))
            names.append(proof_name)
        else:
            raise RuntimeError(f"Unknown context {name}, {type}")

    egraph.addGoal(lean_to_egraph(goal), Var("goal"))

    if egraph.isBottom():
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
        return ElabTactic("sorry")


def lean_to_egraph(term: Term) -> egraph.Term:
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
                lean_to_egraph(args[1]),
                lean_to_egraph(args[2]),
            )
        else:
            head = lean_to_egraph(term.m)
            arg = lean_to_egraph(term.n)
            return Application(head, arg)
    elif isinstance(term, Var):
        return Symbol(term.name)
    elif isinstance(term, Pi):
        return Application(
            Application(Symbol("Imp"), lean_to_egraph(term.var_type)),
            lean_to_egraph(term.body),
        )
    else:
        raise RuntimeError(f"Can't convert {term} to egraph")
