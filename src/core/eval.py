from typing import Callable

from core.logic import substitute
from core.syntax import Ann, App, Lam, Let, Term, Var

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

        case Let(var, _, value, body):
            return whnf(substitute(body, var, value), globals, reducers)

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
