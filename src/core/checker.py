from core.eval import Globals, Reducer, is_equivalent, whnf
from core.logic import substitute
from core.syntax import Ann, App, Lam, Pi, Sort, Term, Var

# mapping of variables and their types
type Context = list[tuple[str, Term]]


class TypeError(Exception):
    pass


def infer(
    term: Term, ctx: Context, globals: Globals, reducers: dict[str, Reducer]
) -> Term:
    match term:
        case Var(name):
            # 1. Search local context (most recent first)
            for var_name, var_type in reversed(ctx):
                if var_name == name:
                    return var_type
            # 2. search global definitions
            if name in globals:
                return globals[name][0]

            raise TypeError(f"Unknown variable {name}")

        case Sort(level):
            return Sort(level + 1)

        case App(m, n):
            # Infer the type of the function
            m_type = whnf(infer(m, ctx, globals, reducers), globals, reducers)
            match m_type:
                case Pi(var, var_type, body):
                    # Check that the argument matches the expected input type
                    check(n, var_type, ctx, globals, reducers)
                    # If the Pi is dependant, substitute the argument into the body
                    if var is not None:
                        return substitute(body, var, n)
                    return body
                case _:
                    raise TypeError(f"Expected a function type for {m}, got {m_type}")

        case Pi(var, var_type, body):
            t1 = whnf(infer(var_type, ctx, globals, reducers), globals, reducers)
            if not isinstance(t1, Sort):
                raise TypeError(f"Domain of Pi must be a Sort, got {t1}")

            new_ctx = ctx + ([(var, var_type)] if var else [])
            t2 = whnf(infer(body, new_ctx, globals, reducers), globals, reducers)
            if not isinstance(t2, Sort):
                raise TypeError(f"Body of Pi must be a Sort, got {t2}")

            if t2.level == 0:
                return Sort(0)  # Prop is impredicative!
            return Sort(max(t1.level, t2.level))

        case Ann(term, type):
            type_of_type = whnf(infer(type, ctx, globals, reducers), globals, reducers)
            if not isinstance(type_of_type, Sort):
                raise TypeError(
                    f"Annotation type must have a Sort kind, got {type_of_type}"
                )
            check(term, type, ctx, globals, reducers)
            return type

        case Lam():
            raise TypeError(
                "Cannot infer type of lambda. Use an annotation or check it against a Pi."
            )


def check(
    term: Term,
    expected_type: Term,
    ctx: Context,
    globals: Globals,
    reducers: dict[str, Reducer],
) -> None:
    match (term, whnf(expected_type, globals, reducers)):
        case (Lam(v1, vt1, body), Pi(v2, vt2, pi_body)):
            if not is_equivalent(vt1, vt2, globals, reducers):
                raise TypeError(f"Lambda param type {vt1} doesn't match Pi {vt2}")

            # The name in the Pi might be different from the name in the Lambda.
            # Substitute the lambda's variable intot the Pi's body to unify names.
            target_body = pi_body
            if v2 is not None:
                target_body = substitute(pi_body, v2, Var(v1))

            check(body, target_body, ctx + [(v1, vt1)], globals, reducers)
            return
        case _:
            pass

    inferred_type = infer(term, ctx, globals, reducers)
    if not is_equivalent(inferred_type, expected_type, globals, reducers):
        raise TypeError(
            f"Type mismatch, Term: {term}, Expected: {expected_type}, Inferred: {inferred_type}"
        )
