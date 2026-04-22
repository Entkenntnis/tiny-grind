from core.eval import Globals, Reducer, whnf
from core.syntax import Axiom, Definition, Sort
from core.checker import TypeError, check, infer


class Kernel:
    def __init__(self) -> None:
        self.globals: Globals = {}
        self.reducers: dict[str, Reducer] = {}

    def register_reducer(self, name: str, fn: Reducer):
        self.reducers[name] = fn

    def add_axiom(self, axiom: Axiom) -> None:
        if axiom.name in self.globals:
            raise TypeError(f"Definition '{axiom.name}' already exists")

        type_of_type = infer(axiom.type, [], self.globals, self.reducers)
        if not isinstance(whnf(type_of_type, self.globals, self.reducers), Sort):
            raise TypeError(f"Axiom '{axiom.name}' type must be a Sort")

        self.globals[axiom.name] = (axiom.type, None)

    def add_definition(self, defn: Definition) -> None:
        """
        Verifies a definition and adds it to the global environment
        """
        if defn.name in self.globals:
            raise TypeError(f"Definition '{defn.name}' already exists.")

        try:
            # 1. First, ensure the 'type' provided is actually a valid type.
            # In our system, the type of a type muste be a Sort (Prop or Type).
            # We don't know the level, so we just infer and check if it's a Sort.
            type_of_type = infer(defn.type, [], self.globals, self.reducers)
            if not isinstance(type_of_type, Sort):
                raise TypeError(
                    f"The type provided for '{defn.name}' is not a valid Sort."
                )
            check(defn.value, defn.type, [], self.globals, self.reducers)
            self.globals[defn.name] = (defn.type, defn.value)
        except TypeError as e:
            raise TypeError(f"Error in definition '{defn.name}': {e}")
