from typing import Callable
from core.logic import fresh_name, get_free_vars, substitute, rename
from core.syntax import Ann, App, Lam, Pi, Sort, Term, Var

type Globals = dict[str, tuple[Term, Term | None]]  # name -> (type, value) - or axioms

type Reducer = Callable[[list[Term], Globals, dict[str, "Reducer"]], Term | None]


def whnf(term: Term, globals: Globals, reducers: dict[str, Reducer]) -> Term:
    """
    Weak Head Normal Form and beta-reduction
    """
    match term:
        # 1. unfold global definitions
        case Var(name) if name in globals:
            _, value = globals[name]
            # if it's axiom, we are stuck
            if value is None:
                return term
            return whnf(value, globals, reducers)

        # 2. Beta-reduction, so basically applying a lambda to an argument
        case App(m, n):
            match whnf(m, globals, reducers):
                case Lam(var, _, body):
                    # reduce the substituted body
                    return whnf(substitute(body, var, n), globals, reducers)
                case m_reduced:
                    head, args = collect_args(App(m_reduced, n))
                    if isinstance(head, Var) and head.name in reducers:
                        reduced = reducers[head.name](args, globals, reducers)
                        if reduced is not None:
                            return whnf(reduced, globals, reducers)

                    # application is stuck, don't process further
                    return App(m_reduced, n)

        # 3. strip annotations
        case Ann(inner, _):
            return whnf(inner, globals, reducers)

        case _:
            return term


def collect_args(term: Term) -> tuple[Term, list[Term]]:
    """Helper: App(App(f, x), y) -> (f, [x, y])"""
    args: list[Term] = []
    curr = term
    while isinstance(curr, App):
        args.append(curr.n)
        curr = curr.m
    return curr, list(reversed(args))


def is_equivalent(
    t1: Term, t2: Term, globals: Globals, reducers: dict[str, Reducer]
) -> bool:
    """
    Checks if two terms are 'definitionally equal'
    Handles alpha-equivalence (renaming) automatically using fresh vars
    """
    t1 = whnf(t1, globals, reducers)
    t2 = whnf(t2, globals, reducers)

    match (t1, t2):
        case (Var(n1), Var(n2)):
            return n1 == n2
        case (Sort(l1), Sort(l2)):
            return l1 == l2
        case (App(m1, n1), App(m2, n2)):
            return is_equivalent(m1, m2, globals, reducers) and is_equivalent(
                n1, n2, globals, reducers
            )
        case (Lam(v1, vt1, b1), Lam(v2, vt2, b2)):
            if not is_equivalent(vt1, vt2, globals, reducers):
                return False  # mismatching domain types
            z = fresh_name("z", get_free_vars(b1) | get_free_vars(b2))
            return is_equivalent(
                rename(b1, v1, z), rename(b2, v2, z), globals, reducers
            )
        case (Pi(v1, vt1, b1), Pi(v2, vt2, b2)):
            if not is_equivalent(vt1, vt2, globals, reducers):
                return False

            # difference between -> and Dependent Pis
            match (v1, v2):
                case (None, None):
                    return is_equivalent(b1, b2, globals, reducers)
                case (str(), str()):
                    z = fresh_name("z", get_free_vars(b1) | get_free_vars(b2))
                    return is_equivalent(
                        rename(b1, v1, z), rename(b2, v2, z), globals, reducers
                    )
                case (None, str()):
                    if v2 in get_free_vars(b2):
                        return False
                    return is_equivalent(b1, b2, globals, reducers)
                case (str(), None):
                    if v1 in get_free_vars(b1):
                        return False
                    return is_equivalent(b1, b2, globals, reducers)
        case _:
            return False
