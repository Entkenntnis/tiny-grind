from scaffolding.syntax import Ann, App, ElabTactic, Lam, Let, Pi, Sort, Term, Var


def substitute_grind(term: Term, proof: Term) -> Term:
    """
    Recursively replace any ElabTactic("grind") with the given proof term.
    The original term is not mutated; a new term is returned.
    """
    match term:
        case ElabTactic(name="grind"):
            return proof
        case ElabTactic():
            # keep other tactics (e.g., "sorry", "grind" already handled)
            return term
        case Var():
            return term
        case Sort():
            return term
        case App(m, n):
            return App(
                m=substitute_grind(m, proof),
                n=substitute_grind(n, proof),
            )
        case Ann(expr, expr_type):
            return Ann(
                term=substitute_grind(expr, proof),
                type=substitute_grind(expr_type, proof),
            )
        case Lam(var, var_type, body):
            return Lam(
                var=var,
                var_type=substitute_grind(var_type, proof),
                body=substitute_grind(body, proof),
            )
        case Pi(var, var_type, body):
            return Pi(
                var=var,
                var_type=substitute_grind(var_type, proof),
                body=substitute_grind(body, proof),
            )
        case Let(var, var_type, value, body):
            return Let(
                var=var,
                var_type=substitute_grind(var_type, proof),
                value=substitute_grind(value, proof),
                body=substitute_grind(body, proof),
            )
