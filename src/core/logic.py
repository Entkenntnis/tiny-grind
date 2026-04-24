from core.syntax import Ann, App, Lam, Let, Pi, Sort, Term, Var


def get_free_vars(term: Term) -> set[str]:
    match term:
        case Var(name):
            return {name}
        case App(m, n) | Ann(m, n):
            return get_free_vars(m) | get_free_vars(n)
        case Lam(var, var_type, body) | Pi(var, var_type, body):
            # the binder is not a free var in body, so subtract it
            # var type can access variables from the outside, so union them
            # Pi var could be none, empty set then
            return get_free_vars(var_type) | (
                get_free_vars(body) - ({var} if var else set())
            )
        case Let(var, var_type, value, body):
            return (
                get_free_vars(var_type)
                | get_free_vars(value)
                | (get_free_vars(body) - {var})
            )
        case _:
            return set()


def fresh_name(base: str, forbidden: set[str]) -> str:
    """
    Generates a name like x, x_1, x_2 that is not in the forbidden set.
    """
    name = base
    counter = 1
    while name in forbidden:
        name = f"{base}_{counter}"
        counter += 1
    return name


def rename(term: Term, old: str, new: str) -> Term:
    """
    A simple var rename as a helper
    """
    match term:
        case Var(name):
            return Var(new) if name == old else term
        case App(m, n):
            return App(rename(m, old, new), rename(n, old, new))
        case Ann(term, type):
            return Ann(rename(term, old, new), rename(type, old, new))
        case Lam(var, var_type, body):
            new_var_type = rename(var_type, old, new)
            new_body = body if var == old else rename(body, old, new)
            return Lam(var, new_var_type, new_body)
        case Pi(var, var_type, body):
            new_var_type = rename(var_type, old, new)
            new_body = body if var == old else rename(body, old, new)
            return Pi(var, new_var_type, new_body)
        case Let(var, var_type, value, body):
            new_var_type = rename(var_type, old, new)
            new_value = rename(value, old, new)
            new_body = body if var == old else rename(body, old, new)
            return Let(var, new_var_type, new_value, new_body)
        case _:
            return term


def substitute(term: Term, target: str, replacement: Term) -> Term:
    """
    Replace all free occurances of 'target' with 'replacement' in 'term'
    Implements capture-avoiding substitution.
    """
    match term:
        case Var(name):
            return replacement if name == target else term
        case App(m, n):
            return App(
                substitute(m, target, replacement),
                substitute(n, target, replacement),
            )
        case Ann(term, type):
            return Ann(
                term=substitute(term, target, replacement),
                type=substitute(type, target, replacement),
            )
        case Sort():
            return term
        case Lam(var, var_type, body) | Pi(var, var_type, body):
            new_var_type = substitute(var_type, target, replacement)

            # ignore shadowing
            if var == target:
                if isinstance(term, Lam) and var is not None:
                    return Lam(var, new_var_type, body)
                return Pi(var, new_var_type, body)

            current_var = var
            current_body = body

            if (
                current_var is not None
                and target in get_free_vars(current_body)
                and current_var in get_free_vars(replacement)
            ):
                # we don't touch the replacement, but rename the binder in the body instead
                # before we start the substitution run
                new_binder_name = fresh_name(
                    current_var,
                    get_free_vars(current_body) | get_free_vars(replacement),
                )

                current_body = rename(current_body, current_var, new_binder_name)
                current_var = new_binder_name

            new_body = substitute(current_body, target, replacement)

            if isinstance(term, Lam):
                assert current_var is not None
                return Lam(current_var, new_var_type, new_body)
            return Pi(current_var, new_var_type, new_body)
        case Let(var, var_type, value, body):
            new_var_type = substitute(var_type, target, replacement)
            new_value = substitute(value, target, replacement)

            if var == target:
                return Let(var, new_var_type, new_value, body)

            current_var = var
            current_body = body
            if target in get_free_vars(current_body) and current_var in get_free_vars(
                replacement
            ):
                new_binder_name = fresh_name(
                    current_var,
                    get_free_vars(current_body) | get_free_vars(replacement),
                )
                current_body = rename(current_body, current_var, new_binder_name)
                current_var = new_binder_name

            new_body = substitute(current_body, target, replacement)
            return Let(current_var, new_var_type, new_value, new_body)
        case _:
            return term
