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

class EGraph:
    """Representing the EGraph
    
    Attributes:
        _parents: union-find parent array
        _sizes: stores the size of each union-find tree
        _nodes: stores the public graph handles
        _node_terms: stores internal meaning of each node handle
        _term_to_node: maps public_input_syntax to existing nodes (makes sure to reuse nodes)
        _node_term_to_node: maps internal node terms to existing nodes
        _congruence_nodes: contains nodes that are being checked during congruence closure
        _equality_nodes: subset of _congruence_nodes, containing only equality proposition nodes
        _true_node: built in node for True
        _false_node: built in node for False
    """
    def __init__(self) -> None:
        self._parents: list[int] = []
        self._sizes: list[int] = []
        self._nodes: list[Node] = []
        self._node_terms: list[_NodeTerm] = []
        self._term_to_node: dict[Term, Node] = {}
        self._node_term_to_node: dict[_NodeTerm, Node] = {}
        self._congruence_nodes: set[Node] = set()
        self._equality_nodes: set[Node] = set()

        self._true_node: Node = self._add_node(TrueTerm(), _TrueNode(), NodeKind.PROP)
        self._false_node: Node = self._add_node(
            FalseTerm(),
            _FalseNode(),
            NodeKind.PROP
        )
    
    def addTerm(self, term: Term) -> Node:
        """Calling the private add functions, or returning the existing True/False Node
        """
        if isinstance(term, Constant):
            return self._add_constant_term(term)
        
        if isinstance(term, FunctionSymbol):
            return self._add_function_symbol_term(term)
        
        if isinstance(term, PredicateSymbol):
            return self._add_predicate_symbol_term(term)
        
        if isinstance(term, FunctionApplication):
            return self.addPredicateApplication(term.predicate, term.argument)
        
        if isinstance(term, PredicateApplication):
            return self._add_predicate_application_term(term)
        
        if isinstance(term, Equals):
            return self._add_true_equality_term(term)
        
        if isinstance(term, TrueTerm):
            return self._true_node
        
        return self._false_node
    
    def addGoal(self, prop: PropTerm) -> Node: # the prop term is not negated, we negate it in here
        prop_node = self._add_prop_term(prop)
        _ = self._union_nodes(prop_node, self._false_node)
        return prop_node
    
    def addNewConstant(self, name: str) -> Node:
        return self._add_constant_term(Constant(name))
    
    def addNewFunctionSymbol(self, name: str) -> Node:
        return self._add_function_symbol_term(FunctionSymbol(name))
    
    def addNewPredicateSymbol(self, name: str) -> Node:
        return self._add_predicate_symbol_term(PredicateSymbol(name))
    
    def addEquation(self, left: Term, right: Term) -> Node:
        return self._add_true_equality_term(Equals(left, right))
    
    def addPredicateApplication(
        self, predicate: PredicateSymbol, argument: ValueTerm
    ) -> Node:
        """Adds a Predicate Application and unions it with True
            Returns: The Node
        """
        prop_node = self._add_predicate_application_term(
            PredicateApplication(predicate, argument)
        )

        _ = self._union_nodes(prop_node, self._true_node)
        return prop_node
    
    def hasFact(self, prop: PropTerm) -> bool:
        """Checks if a proposition is marked as True.
            Mostly helpful for debugging, maybe proof generation.
            (Checks both Equals(a, b) and Equals(b, a))

            Returns: If the proposition is marked as True
        """
        prop_node = self._add_prop_term(prop)
        if self.sameClass(prop_node, self._true_node):
            return True
        
        if isinstance(prop, Equals):
            reversed_node = self._add_equals_term(Equals(prop.right, prop.left))
            return self.sameClass(reversed_node, self._true_node)
        
        return False
    
    def findClass(self, node: Node) -> EClass:
        """Mostly helpful for debugging
            
            Returns: The EClass of this node
        """
        return EClass(self._find_index(self._node_index(node)))
    
    def sameClass(self, left: Node, right: Node) -> bool:
        """Returns: True if the two Nodes are in the same equivalence class,
                    False, otherwise
        """
        return self._find_index(self._node_index(left)) == self._find_index(self._node_index(right))
    
    def findBottom(self) -> BottomResult:
        """Checks if True and False are in the same equivalence class 
            Returns: A Bottom result either with a witness or with found=False
        """
        if self.sameClass(self._true_node, self._false_node):
            return BottomResult(    #TODO: well Bottom Result will always have this exact shape so maybe left and right are unneccessary, but maybe helpful later?
                found=True,
                left=self._true_node,
                right=self._false_node
            )

        return BottomResult(found=False)
        
    def isBottom(self) -> bool:
        return self.findBottom().found

    def _add_constant_term(self, term: Constant) -> Node:
        """Adds a node for this constant term
            Returns: this node
        """
        return self._add_node(term, _ConstantNode(term.name), NodeKind.VALUE)
    
    def _add_function_symbol_term(self, term: FunctionSymbol) -> Node:
        """Adds a node for this function symbol
            Returns: this node
        """
        return self._add_node(
            term,
            _FunctionSymbolNode(term.name),
            NodeKind.HIGHER_ORDER
        )
    
    def _add_predicate_symbol_term(self, term: PredicateSymbol) -> Node:
        """Adds a node for this predicate symbol
            Returns: this node
        """
        return self._add_node(
            term,
            _PredicateSymbolNode(term.name),
            NodeKind.HIGHER_ORDER
        )
    
    def _add_function_application_term(self, term: FunctionApplication) -> Node:
        """Adds a node for this function application by:
            - Adding its FunctionSymbol and its Argument 
            - Creating a FunctionApplicationNode
            - Adding this Node to the list of _congruence_nodes
            - Rebuilding the graph, trying to find new congruence closures
                
            Returns: this node
        """
        function_node = self._add_function_symbol_term(term.function)
        argument_node = self._add_value_term(term.argument)
        node_term = _FunctionApplicationNode(function_node, argument_node)
        node = self._add_node(term, node_term, NodeKind.VALUE)
        self._congruence_nodes.add(node)
        self._rebuild()
        
        return node
    
    def _add_predicate_application_term(self, term: PredicateApplication) -> Node:
        """Adds a node for this predicate application by:
            - Adding its PredicateSymbol and its Argument 
            - Creating a PredicateApplicationNode
            - Adding this Node to the list of _congruence_nodes
            - Rebuilding the graph, trying to find new congruence closures
                
            Returns: this node
        """
        predicate_node = self._add_predicate_symbol_term(term.predicate)
        argument_node = self._add_value_term(term.argument)
        node_term = _PredicateApplicationNode(predicate_node, argument_node)
        node = self._add_node(term, node_term, NodeKind.PROP)
        self._congruence_nodes.add(node)
        self._rebuild()

        return node
    
    def _add_true_equality_term(self, term: Equals):
        """Adds a Equality and asserts it as true
            - Calls _add_equals_term to add the Node
            - Unions the left and right side of the equality, since they are equal
            - Unions the equality with the True node
                
            Returns: this node
        """
        equality_node = self._add_equals_term(term)
        equality_node_term = self._node_terms[self._node_index(equality_node)]
        if not isinstance(equality_node_term, _EqualsNode):
            raise TypeError(f"Node is not an equality node: {equality_node!r}")

        _ = self._union_nodes(equality_node_term.left, equality_node_term.right)
        _ = self._union_nodes(equality_node, self._true_node)
        return equality_node
    
    def _add_equals_term(self, term: Equals) -> Node:
        """Adds a node for this equals term by:
            - Adding its left side and its right side
            - Creating a EqualsNode
            - Adding this Node to the list of _congruence_nodes
            - Rebuilding the graph, trying to find new congruence closures
                
            Returns: this node
        """
        left_node = self._add_value_term(term.left)
        right_node = self._add_value_term(term.right)
        node_term = _EqualsNode(left_node, right_node)
        node = self._add_node(term, node_term, NodeKind.PROP)
        self._congruence_nodes.add(node)
        self._rebuild()

        return node

    def _add_value_term(self, term: Term) -> Node:
        if isinstance(term, Constant):
            return self._add_constant_term(term)
        if isinstance(term, FunctionApplication):
            return self._add_function_application_term(term)
        
        raise TypeError(f"Expected a value term, got {term!r}")
    
    def _add_prop_term(self, term: Term) -> Node:
        if isinstance(term, PredicateApplication):
            return self._add_predicate_application_term(term)
        
        if isinstance(term, Equals):
            return self._add_equals_term(term)

        if isinstance(term, TrueTerm):
            return self._true_node

        if isinstance(term, FalseTerm):
            return self._false_node

        raise TypeError(f"Expected a proposition term, got {term!r}")
        
    def _add_node(
        self,
        public_term: Term,
        node_term: _NodeTerm,
        kind: NodeKind,
    ) -> Node:
        """Adds a node by:
            - returning it if it already exists based on its syntax/ internal node
            - or creating a new node and updating private variables
            returns: 
            the node
        """
        #check if this syntax already has a node
        existing = self._term_to_node.get(public_term)
        if existing is not None:
            self._term_to_node[public_term] = existing
            #node exists, return it
            return existing
        
        #check if this internal node already has a node
        existing = self._node_term_to_node.get(node_term)
        if existing is not None:
            self._term_to_node[public_term] = existing
            #node exists, return it
            return existing

        #this node does not already exist -> create it
        node = Node(NodeId(len(self._nodes)), kind) #TODO: do this more elaborately?
        self._nodes.append(node)
        self._node_terms.append(node_term)
        self._parents.append(self._node_index(node))
        self._sizes.append(1) #TODO: should sizes be a dict from ids -> int?
        self._term_to_node[public_term] = node
        self._node_term_to_node[node_term] = node

        return node

    def _node_index(self, node: Node) -> int:
        """Returns the int value of the id of a node
        """
        return node.id.value  #TODO: is this necessary? Should this be a property of the node class?    

    def _union_nodes(self, left: Node, right: Node) -> bool:
        changed = self._union_nodes_without_rebuild(left, right)
        if changed:
            self._rebuild()
        return changed



        
        



