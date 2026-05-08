# In the most basic use case, the entry point to tinygrind gets a definition of a type
# and will generate a proof for this exact definition

from scaffolding.syntax import Definition, ElabTactic, Term


def tinygrind(definition: Definition) -> Term:
    print("  > tinygrind")
    # print(definition)

    # TODO: read all Pi's (auto-intro everything)

    return ElabTactic("sorry")
