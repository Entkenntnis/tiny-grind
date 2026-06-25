from collections import deque
from dataclasses import dataclass
from enum import Enum
from typing import cast

from scaffolding import syntax

# Defining the structure of the term variants
type HigherOrderTerm = FunctionSymbol | PredicateSymbol
type ValueTerm = Constant | FunctionApplication
type PropTerm = PredicateApplication | Equals | TrueTerm | FalseTerm
type Term = HigherOrderTerm | ValueTerm | PropTerm

# Term classes describe input syntax = public AST
# Classes recursively contain other classes
# Example: FunctionApplication(FunctionSymbol("f"), Constant("a"))


@dataclass(frozen=True)
class Constant:
    name: str


@dataclass(frozen=True)
class FunctionSymbol:
    name: str
    arity: int


@dataclass(frozen=True)
class PredicateSymbol:
    name: str
    arity: int


@dataclass(frozen=True)
class FunctionApplication:
    function: FunctionSymbol
    arguments: tuple[ValueTerm, ...]


@dataclass(frozen=True)
class PredicateApplication:
    predicate: PredicateSymbol
    arguments: tuple[ValueTerm, ...]


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


@dataclass(frozen=True)
class NodeId:
    value: int


@dataclass(frozen=True)
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
    arity: int


@dataclass(frozen=True)
class _PredicateSymbolNode:
    name: str
    arity: int


@dataclass(frozen=True)
class _FunctionApplicationNode:
    function: Node
    arguments: tuple[Node, ...]


@dataclass(frozen=True)
class _PredicateApplicationNode:
    predicate: Node
    arguments: tuple[Node, ...]


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
    _FunctionApplicationClassKey | _PredicateApplicationClassKey | _EqualsClassKey
)

# The class keys will be used for congruence closure
# They make it easier to check for all applications & equals, whether
# their arguments are in the same equivalence class


@dataclass(frozen=True)
class _FunctionApplicationClassKey:
    function_class: int
    argument_classes: tuple[int, ...]


@dataclass(frozen=True)
class _PredicateApplicationClassKey:
    predicate_class: int
    argument_classes: tuple[int, ...]


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

        # store proofs between two nodes that are merged, syntax.Term is a lean proof term
        self._nodes_to_proof: dict[Node, dict[Node, syntax.Term]] = {}

        self._true_node: Node = self._add_node(TrueTerm(), _TrueNode(), NodeKind.PROP)
        self._false_node: Node = self._add_node(
            FalseTerm(), _FalseNode(), NodeKind.PROP
        )

    def addTerm(self, term: Term, proof: syntax.Term | None = None) -> Node:
        """Calling the private add functions, or returning the existing True/False Node"""
        self._validate_term(term)

        if isinstance(term, Constant):
            return self._add_constant_term(term)

        if isinstance(term, FunctionSymbol):
            return self._add_function_symbol_term(term)

        if isinstance(term, PredicateSymbol):
            return self._add_predicate_symbol_term(term)

        if isinstance(term, FunctionApplication):
            return self._add_function_application_term(term)

        if isinstance(term, PredicateApplication) and proof:
            return self.addPredicateApplication(term.predicate, term.arguments, proof)

        if isinstance(term, Equals) and proof:
            return self._add_true_equality_term(term, proof)

        if isinstance(term, TrueTerm) and proof:
            _ = self._union_nodes(self._true_node, self._true_node, proof)
            return self._true_node

        # if we add a false term e get an immediate contradiction
        if isinstance(term, FalseTerm) and proof:
            _ = self._union_nodes(self._false_node, self._true_node, proof)
            return self._false_node

        raise TypeError(f"Unknown term type: {term!r}")

    def addGoal(
        self, prop: PropTerm, proof: syntax.Term
    ) -> Node:  # the prop term is not negated, we negate it in here
        self._validate_term(prop)  # PG: needs proof

        prop_node = self._add_prop_term(prop)
        _ = self._union_nodes(
            prop_node, self._false_node, syntax.App(syntax.Var("eq_false_intro"), proof)
        )
        return prop_node

    def addNewConstant(self, name: str) -> Node:
        return self._add_constant_term(Constant(name))

    def addNewFunctionSymbol(self, name: str, arity: int) -> Node:
        return self._add_function_symbol_term(FunctionSymbol(name, arity))

    def addNewPredicateSymbol(self, name: str, arity: int) -> Node:
        return self._add_predicate_symbol_term(PredicateSymbol(name, arity))

    # def addEquation(self, left: Term, right: Term) -> Node:
    #     self._validate_term(left)
    #     self._validate_term(right)

    #     return self._add_true_equality_term(Equals(left, right))

    def addPredicateApplication(
        self,
        predicate: PredicateSymbol,
        arguments: tuple[ValueTerm, ...],
        proof: syntax.Term,
    ) -> Node:  # PG: name of the proof (hypothesis)
        """Adds a Predicate Application and unions it with True
        Returns: The Node
        """
        for arg in arguments:
            self._validate_term(arg)

        prop_node = self._add_predicate_application_term(
            PredicateApplication(predicate, arguments)
        )

        _ = self._union_nodes(
            prop_node, self._true_node, syntax.App(syntax.Var("eq_true"), proof)
        )  # PG: add proof here
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
        return self._find_index(self._node_index(left)) == self._find_index(
            self._node_index(right)
        )

    def findBottom(self) -> BottomResult:
        """Checks if True and False are in the same equivalence class
        Returns: A Bottom result either with a witness or with found=False
        """
        if self.sameClass(self._true_node, self._false_node):
            return BottomResult(  # TODO: well Bottom Result will always have this exact shape so maybe left and right are unneccessary, but maybe helpful later?
                found=True, left=self._true_node, right=self._false_node
            )

        return BottomResult(found=False)

    def isBottom(self) -> bool:
        return self.findBottom().found

    def _validate_term(self, term: Term) -> None:
        """Validate a term is well-formed for this graph.

        - Equals sides must be value terms
        - Applications must match their symbol's arity
        - All arguments are recursively validated
        """
        if isinstance(term, Constant):
            # Constants are always valid
            pass
        elif isinstance(term, FunctionSymbol):
            # Symbols themselves are valid
            pass
        elif isinstance(term, PredicateSymbol):
            # Symbols themselves are valid
            pass
        elif isinstance(term, FunctionApplication):
            # Validate arity matches
            if len(term.arguments) != term.function.arity:
                raise TypeError(
                    f"Function {term.function.name}/{term.function.arity} got {len(term.arguments)} arguments, expected {term.function.arity}"
                )
            # Recursively validate all arguments (must be value terms)
            for _, arg in enumerate(term.arguments):
                self._validate_term(arg)
        elif isinstance(term, PredicateApplication):
            if len(term.arguments) != term.predicate.arity:
                raise TypeError(
                    f"Predicate {term.predicate.name}/{term.predicate.arity} got {len(term.arguments)} arguments, expected {term.predicate.arity}"
                )
            for _, arg in enumerate(term.arguments):
                self._validate_term(arg)
        elif isinstance(term, Equals):
            self._validate_term(term.left)
            self._validate_term(term.right)
        elif isinstance(term, TrueTerm):
            pass

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
            term, _FunctionSymbolNode(term.name, term.arity), NodeKind.HIGHER_ORDER
        )

    def _add_predicate_symbol_term(self, term: PredicateSymbol) -> Node:
        """Adds a node for this predicate symbol
        Returns: this node
        """
        return self._add_node(
            term, _PredicateSymbolNode(term.name, term.arity), NodeKind.HIGHER_ORDER
        )

    def _add_function_application_term(self, term: FunctionApplication) -> Node:
        """Adds a node for this function application by:
        - Adding its FunctionSymbol and its Arguments
        - Creating a FunctionApplicationNode
        - Adding this Node to the list of _congruence_nodes
        - Rebuilding the graph, trying to find new congruence closures

        Returns: this node
        """
        function_node = self._add_function_symbol_term(term.function)

        argument_nodes: list[Node] = []
        for arg in term.arguments:
            arg_node = self._add_value_term(arg)
            argument_nodes.append(arg_node)

        node_term = _FunctionApplicationNode(function_node, tuple(argument_nodes))
        node = self._add_node(term, node_term, NodeKind.VALUE)
        self._congruence_nodes.add(node)
        self._rebuild()

        return node

    def _add_predicate_application_term(self, term: PredicateApplication) -> Node:
        """Adds a node for this predicate application by:
        - Adding its PredicateSymbol and its Arguments
        - Creating a PredicateApplicationNode
        - Adding this Node to the list of _congruence_nodes
        - Rebuilding the graph, trying to find new congruence closures

        Returns: this node
        """
        predicate_node = self._add_predicate_symbol_term(term.predicate)
        argument_nodes: list[Node] = []
        for arg in term.arguments:
            arg_node = self._add_value_term(arg)
            argument_nodes.append(arg_node)
        node_term = _PredicateApplicationNode(predicate_node, tuple(argument_nodes))
        node = self._add_node(term, node_term, NodeKind.PROP)
        self._congruence_nodes.add(node)
        self._rebuild()

        return node

    def _add_true_equality_term(self, term: Equals, proof: syntax.Term):
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

        _ = self._union_nodes(equality_node_term.left, equality_node_term.right, proof)
        _ = self._union_nodes(
            equality_node,
            self._true_node,
            syntax.App(syntax.Var("eq_true_intro"), proof),
        )
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
        self._equality_nodes.add(node)
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
        # check if this syntax already has a node
        existing = self._term_to_node.get(public_term)
        if existing is not None:
            self._term_to_node[public_term] = existing
            # node exists, return it
            return existing

        # check if this internal node already has a node
        existing = self._node_term_to_node.get(node_term)
        if existing is not None:
            self._term_to_node[public_term] = existing
            # node exists, return it
            return existing

        # this node does not already exist -> create it
        node = Node(NodeId(len(self._nodes)), kind)  # TODO: do this more elaborately?
        self._nodes.append(node)
        self._node_terms.append(node_term)
        self._parents.append(self._node_index(node))
        self._sizes.append(1)  # TODO: should sizes be a dict from ids -> int?
        self._term_to_node[public_term] = node
        self._node_term_to_node[node_term] = node

        return node

    def _node_index(self, node: Node) -> int:
        """Returns the int value of the id of a node"""
        return (
            node.id.value
        )  # TODO: is this necessary? Should this be a property of the node class?

    def _union_nodes(self, left: Node, right: Node, proof: syntax.Term) -> bool:
        changed: bool = self._union_nodes_without_rebuild(left, right, proof)
        if changed:
            self._rebuild()
        return changed

    def _union_nodes_without_rebuild(
        self, left: Node, right: Node, proof: syntax.Term
    ) -> bool:  # PG: gets a proof, and stores it in nodes_to_proof
        """Union of union-find.
        Unions two two nodes, if they are not already in the same equivalence class,
        by adding the smaller e-class to the bigger-class.
        Returns:
        True, if e-classes were changed
        """
        # get representative of their e-class
        left_root: int = self._find_index(node_id=self._node_index(node=left))
        right_root: int = self._find_index(node_id=self._node_index(node=right))

        if left_root == right_root:
            # they are already in the same e-class
            return False

        # make sure we add the smaller tree to the larger one
        if self._sizes[left_root] < self._sizes[right_root]:
            left_root, right_root = right_root, left_root

        # left(bigger tree) is now representative of right
        self._parents[right_root] = left_root
        # add right to size of left, bc tree was added
        self._sizes[left_root] += self._sizes[right_root]

        # add proofs in both directions, assume that proof is left = right

        if proof:  # DEBUG!!!
            self._nodes_to_proof.setdefault(left, {})[right] = proof
            self._nodes_to_proof.setdefault(right, {})[left] = syntax.App(
                syntax.Var("Eq.symm"), proof
            )

        return True

    def find_proof(self, A: Term, B: Term) -> syntax.Term:
        # PG: use proofs to create an equality between two nodes
        nodeA = self._term_to_node[A]
        nodeB = self._term_to_node[B]
        return self._find_proof_between_nodes(nodeA, nodeB)

    def _find_proof_between_nodes(self, nodeA: Node, nodeB: Node) -> syntax.Term:
        if nodeA == nodeB:
            return syntax.App(syntax.Var("rfl"), syntax.Var("_"))

        queue: deque[Node] = deque([nodeA])
        visited: set[Node] = {nodeA}
        parent: dict[Node, tuple[Node, syntax.Term]] = {}

        while queue:
            current = queue.popleft()
            if current == nodeB:
                output = parent[current][1]  # this is the proof from parent to my
                node = parent[current][0]
                while node != nodeA:
                    # extend the proof to include new node in chain
                    (prev, proof) = parent[node]
                    output = syntax.App(
                        syntax.App(syntax.Var("Eq.trans"), proof), output
                    )
                    node = prev
                return output

            for neighbor, proof in self._nodes_to_proof.get(current, {}).items():
                if neighbor not in visited:
                    visited.add(neighbor)
                    parent[neighbor] = (current, proof)
                    queue.append(neighbor)

        print(f"No proof found between {nodeA} and {nodeB}")
        return syntax.ElabTactic("sorry")

    def _find_index(self, node_id: int) -> int:
        """Find of union-find.
        Finds the representative of the equivalence class this Node is in.
        Returns:
        The node id of the representative
        """
        if node_id < 0 or node_id >= len(self._parents):
            raise IndexError(f"Unknown EGraph node id: {node_id}")

        parent: int = self._parents[node_id]
        if parent != node_id:
            # recursively calling this function until we find the representative (where index and value of array match)
            parent = self._find_index(node_id=parent)
            # update parents array, next time find is faster
            self._parents[node_id] = parent
        return parent

    def _rebuild(self) -> None:
        """Computes congruence closure until the graph is stable
        Returns: None
        """
        changed: bool = True

        # loops while something changed
        while changed:
            changed = False
            seen: dict[_CongruenceKey, Node] = {}

            # goes through all congruence-relevant nodes (function applications, predicate applications, equality propositions?)
            for node in sorted(
                self._congruence_nodes,
                key=self._node_index,
            ):
                # get canonical key, the keys of two function-application-nodes only match if for example both
                #   - their function symbol
                #   - AND their arguments
                # are in the SAME equivalence class
                # because then they are congruent
                key: _CongruenceKey = self._congruence_key(node)

                # check if we have seen this key before = if there is a congruence
                previous = seen.get(key)
                if previous is None:
                    # no congruence yet, but we store the key
                    seen[key] = node
                else:

                    # we found a congruence, union the congruent nodes

                    # first, build a proof
                    prev_term = self._node_terms[self._node_index(previous)]
                    node_term = self._node_terms[self._node_index(node)]

                    if isinstance(prev_term, _EqualsNode):
                        changed = (
                            self._union_nodes_without_rebuild(
                                left=previous,
                                right=node,
                                proof=None,
                            )
                            or changed
                        )
                        continue

                    if not isinstance(
                        prev_term, _FunctionApplicationNode
                    ) and not isinstance(prev_term, _PredicateApplicationNode):
                        raise RuntimeError(
                            f"Can't generate proof of non-callable nodes prev_term {prev_term}"
                        )

                    name = ""

                    if isinstance(prev_term, _FunctionApplicationNode):
                        name = cast(
                            str,
                            self._node_terms[self._node_index(prev_term.function)].name,
                        )
                    if isinstance(prev_term, _PredicateApplicationNode):
                        name = cast(
                            str,
                            self._node_terms[
                                self._node_index(prev_term.predicate)
                            ].name,
                        )

                    if len(prev_term.arguments) != 1:
                        print("Arity > 1 for congruence closure not implemented yet")

                    if not isinstance(
                        node_term, _FunctionApplicationNode
                    ) and not isinstance(node_term, _PredicateApplicationNode):
                        raise RuntimeError(
                            f"Can't generate proof of non-callable nodes node {node}"
                        )

                    proof = self._find_proof_between_nodes(
                        prev_term.arguments[0], node_term.arguments[0]
                    )

                    changed = (
                        self._union_nodes_without_rebuild(
                            left=previous,
                            right=node,
                            proof=syntax.App(
                                syntax.App(syntax.Var("congrArg"), syntax.Var(name)),
                                proof,
                            ),
                        )
                        or changed
                    )
                    # PG: generate proof, get function/predicate symbol + all arguments,
                    # von nodes(zeigen auf symbol und arguments)

            # handles equality-as-fact behaviour
            changed = self._reflect_equalities_once() or changed

    def _reflect_equalities_once(self) -> bool:
        changed: bool = False
        equality_nodes_by_key: dict[_EqualsClassKey, list[Node]] = {}
        true_keys: set[_EqualsClassKey] = set[_EqualsClassKey]()
        false_keys: set[_EqualsClassKey] = set[_EqualsClassKey]()

        # goes through all equality proposition nodes
        for node in sorted(self._equality_nodes, key=self._node_index):
            # computes the canonical key
            # For `Equals(a, b)`, this key is:
            # (class(a), class(b))
            key: _EqualsClassKey = self._equals_class_key(node)
            # collect all equality nodes that share the same key in a list, grouped by their key
            equality_nodes_by_key.setdefault(key, []).append(node)

            # both keys are in the same class, so the eq-propostion is true
            # so union the equality node with the True node
            if key.left_class == key.right_class:
                changed = (
                    self._union_nodes_without_rebuild(
                        left=node, right=self._true_node, proof=None
                    )
                    or changed
                )
                # PG: generate proof

            # record which equality keys are known true/false
            if self.sameClass(left=node, right=self._true_node):
                true_keys.add(key)

            if self.sameClass(left=node, right=self._false_node):
                false_keys.add(key)

        for key, nodes in equality_nodes_by_key.items():
            reversed_key: _EqualsClassKey = _EqualsClassKey(
                left_class=key.right_class, right_class=key.left_class
            )
            if key in true_keys or reversed_key in true_keys:
                for node in nodes:
                    changed = (
                        self._union_nodes_without_rebuild(
                            left=node, right=self._true_node, proof=None
                        )
                        or changed
                    )  # PG: see above (generate proof)

            if key in false_keys or reversed_key in false_keys:
                for node in nodes:
                    changed = (
                        self._union_nodes_without_rebuild(
                            left=node, right=self._false_node, proof=None
                        )
                        or changed
                    )  # PG: see above (generate proof)

        return changed

    def _congruence_key(self, node: Node) -> _CongruenceKey:
        """This computes the canonical congruence key for a congruence-relevant node.
        Returns: the congruence key
        """
        node_term: _NodeTerm = self._node_terms[self._node_index(node)]

        if isinstance(node_term, _FunctionApplicationNode):
            argument_classes = tuple(
                self._find_index(self._node_index(arg)) for arg in node_term.arguments
            )
            return _FunctionApplicationClassKey(
                function_class=self._find_index(
                    node_id=self._node_index(node=node_term.function)
                ),
                argument_classes=argument_classes,
            )

        if isinstance(node_term, _PredicateApplicationNode):
            argument_classes = tuple(
                self._find_index(self._node_index(arg)) for arg in node_term.arguments
            )
            return _PredicateApplicationClassKey(
                predicate_class=self._find_index(self._node_index(node_term.predicate)),
                argument_classes=argument_classes,
            )

        if isinstance(node_term, _EqualsNode):
            return self._equals_class_key(node)

        raise TypeError(f"Node is not a congruence node: {node!r}")

    def _equals_class_key(self, node: Node) -> _EqualsClassKey:
        node_term: _NodeTerm = self._node_terms[self._node_index(node)]
        if not isinstance(node_term, _EqualsNode):
            raise TypeError(f"Node is not an equality node: {node!r}")

        return _EqualsClassKey(
            left_class=self._find_index(node_id=self._node_index(node=node_term.left)),
            right_class=self._find_index(
                node_id=self._node_index(node=node_term.right)
            ),
        )
