# pyright: reportImportCycles=false

from core.eval import Globals, Reducer, whnf
from core.syntax import Axiom, Definition, Sort
from core.checker import TypeChecker, TypeError
from frontend.elaborator import Elaborator


class Kernel:
    def __init__(self) -> None:
        self.globals: Globals = {}
        self.reducers: dict[str, Reducer] = {}
        self.elaborator: Elaborator = Elaborator(self)

    def register_reducer(self, name: str, fn: Reducer):
        self.reducers[name] = fn

    def add_decl(self, decl: Axiom | Definition) -> None:
        if decl.name in self.globals:
            raise TypeError(f"Declaration '{decl.name}' already exists")

        # Elaborate the type (it may contain tactics inside annotations, e.g.)
        elaborated_type = self.elaborator.elaborate(decl.type, [], None)

        checker = TypeChecker(self.globals, self.reducers)
        type_of_type = whnf(checker.infer(elaborated_type), self.globals, self.reducers)
        if not isinstance(type_of_type, Sort):
            raise TypeError(f"The type provided for '{decl.name}' is not a valid Sort.")
        match decl:
            case Axiom(name, type):
                self.globals[name] = (type, None)
            case Definition(name, type, value):
                elaborated_value = self.elaborator.elaborate(value, [], elaborated_type)
                checker.check(elaborated_value, elaborated_type)
                self.globals[name] = (elaborated_type, elaborated_value)
