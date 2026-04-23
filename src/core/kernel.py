from core.eval import Globals, Reducer, whnf
from core.syntax import Axiom, Definition, Sort
from core.checker import TypeChecker, TypeError


class Kernel:
    def __init__(self) -> None:
        self.globals: Globals = {}
        self.reducers: dict[str, Reducer] = {}

    def register_reducer(self, name: str, fn: Reducer):
        self.reducers[name] = fn

    def add_decl(self, decl: Axiom | Definition) -> None:
        if decl.name in self.globals:
            raise TypeError(f"Declaration '{decl.name}' already exists")
        checker = TypeChecker(self.globals, self.reducers)
        type_of_type = whnf(checker.infer(decl.type), self.globals, self.reducers)
        if not isinstance(type_of_type, Sort):
            raise TypeError(f"The type provided for '{decl.name}' is not a valid Sort.")
        match decl:
            case Axiom(name, type):
                self.globals[name] = (type, None)
            case Definition(name, type, value):
                checker.check(value, type)
                self.globals[name] = (type, value)
