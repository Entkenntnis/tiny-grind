from core.syntax import Ann, App, Axiom, Definition, Lam, Let, Pi, Sort, Term, Var


def print_term(term: Term, prec: int = 0) -> str:
    """
    Converts a Term dataclass into a string representation.
    prec: Current precedence level
        0: Lowest (Pi, Lam, Let)
        1: Ann
        2: App
        3: Highest (Atoms: Var, Sort, Parens)
    """
    match term:
        case Var(name):
            return name

        case Sort(level):
            match level:
                case 0:
                    res = "Prop"
                case 1:
                    res = "Type"
                case _:
                    res = f"Sort {level}"
            return res

        case App(m, n):
            # App is level 2. Left-associative:
            # m can be level 2 (another App), but n must be level 3 (an atom)
            res = f"{print_term(m, 2)} {print_term(n, 3)}"
            return f"({res})" if prec > 2 else res

        case Ann(expr, expr_type):
            # Ann is level 1.
            res = f"{print_term(expr, 2)} : {print_term(expr_type, 1)}"
            return f"({res})" if prec > 1 else res

        case Lam(var, var_type, body):
            # Lam is level 0.
            res = f"fun ({var} : {print_term(var_type, 0)}) => {print_term(body, 0)}"
            return f"({res})" if prec > 0 else res

        case Let(var, var_type, value, body):
            # Let is level 0.
            res = (
                f"let {var} : {print_term(var_type, 0)} := "
                f"{print_term(value, 0)}; {print_term(body, 0)}"
            )
            return f"({res})" if prec > 0 else res

        case Pi(var, var_type, body):
            # Pi is level 0.
            if var is None:
                # Simple arrow: A -> B. Right-associative.
                # Domain needs level 1 to force parens if it's a Pi/Lam
                res = f"{print_term(var_type, 1)} -> {print_term(body, 0)}"
            else:
                # Dependent Pi: (x : A) -> B
                res = f"({var} : {print_term(var_type, 0)}) -> {print_term(body, 0)}"
            return f"({res})" if prec > 0 else res


def print_definition(defn: Definition) -> str:
    """Prints a full definition in a Lean-like syntax."""
    return (
        f"def {defn.name} : {print_term(defn.type, 0)} :=\n"
        f"  {print_term(defn.value, 0)}"
    )


def print_axiom(ax: Axiom) -> str:
    return f"axiom {ax.name} : {print_term(ax.type, 0)}"


def print_program(decls: list[Definition | Axiom]) -> str:
    """Prints a list of definitions separated by newlines."""
    res: list[str] = []
    for d in decls:
        match d:
            case Axiom():
                res.append(print_axiom(d))
            case Definition():
                res.append(print_definition(d))

    return "\n\n".join(res)
