from dataclasses import dataclass
from enum import Enum

# Defining the structure of the term variants
type HigherOrderTerm = FunctionSymbol | PredicateSymbol
type ValueTerm = Constant | FunctionApplication
type PropTerm = PredicateApplication | Equals | TrueTerm | FalseTerm
type Term = HigherOrderTerm | ValueTerm | PropTerm

#Term classes describe input syntax = public AST
#Classes recursively contain other classes
#Example: FunctionApplication(FunctionSymbol("f"), Constant("a"))

@dataclass(frozen=True)
class Constant:
    name: str

@dataclass(frozen=True)
class FunctionSymbol:
    name: str

@dataclass(frozen=True)
class PredicateSymbol:
    name: str

@dataclass(frozen=True)
class FunctionApplication:
    function: FunctionSymbol
    argument: ValueTerm

@dataclass(frozen=True)
class PredicateApplication:
    predicate: PredicateSymbol
    argument: ValueTerm

@dataclass(frozen=True)
class Equals:
    left: Term
    right: Term

@dataclass(frozen=True)
class TrueTerm:
    pass

@dataclass(frozen=True)
class FalseTerm:
    pass

class NodeKind(Enum):
    VALUE = "value"
    PROP = "prop"
    HIGHER_ORDER = "higher_order"

@dataclass (frozen=True)
class NodeId:
    value: int  

@dataclass (frozen=True)
class Node:
    """Represents a node in the e-graph.
    
    Attributes:
        id: Unique identifier for the node
    """
    id: NodeId
    kind: NodeKind

@dataclass(frozen=True)
class EClass:
    """Represents a equivalence class in the e-graph.
    
    Attributes:
        id: Representative id of a union-find class (for looking up via findClass)
    """
    id: int

@dataclass(frozen=True)
class BottomResult:
    """The return object for findBottom()
        Returns if we found a contradiction, and which nodes witnessed it
    
    Attributes:
        found: if we found a contradiction
        left: could be True/False
        right: could be True/False
    """
    found: bool
    left: Node | None = None
    right: Node | None = None


# Node classes describe graph storage = Egraph representation
# Nodes directly point to other nodes 

type _NodeTerm = (
    _ConstantNode
    | _FunctionSymbolNode
    | _PredicateSymbolNode
    | _FunctionApplicationNode
    | _PredicateApplicationNode
    | _EqualsNode
    | _TrueNode
    | _FalseNode
)

type _CongruenceNodeTerm = (
    _FunctionApplicationNode | _PredicateApplicationNode | _EqualsNode
)

@dataclass(frozen=True)
class _ConstantNode:
    name: str

@dataclass(frozen=True)
class _FunctionSymbolNode:
    name: str

@dataclass(frozen=True)
class _PredicateSymbolNode:
    name: str

@dataclass(frozen=True)
class _FunctionApplicationNode:
    function: Node
    argument: Node

@dataclass(frozen=True)
class _PredicateApplicationNode:
    predicate: Node
    argument: Node

@dataclass(frozen=True)
class _EqualsNode:
    left: Node
    right: Node

@dataclass(frozen=True)
class _TrueNode:
    pass

@dataclass(frozen=True)
class _FalseNode:
    pass

type _CongruenceKey = (
    _FunctionApplicationClassKey  | _PredicateApplicationClassKey | _EqualsClassKey
)

#The class keys will be used for congruence closure
#They make it easier to check for all applications & equals, whether 
#their arguments are in the same equivalence class

@dataclass(frozen=True)
class _FunctionApplicationClassKey:
    function_class: int
    argument_class: int

@dataclass(frozen=True)
class _PredicateApplicationClassKey:
    predicate_class: int
    argument_class: int

@dataclass(frozen=True)
class _EqualsClassKey:
    left_class: int
    right_class: int

