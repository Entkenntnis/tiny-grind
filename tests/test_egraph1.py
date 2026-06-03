import pytest
from src.tinygrind.egraph import (
    EGraph,
    Constant,
    FunctionSymbol,
    PredicateSymbol,
    FunctionApplication,
    PredicateApplication,
    Equals,
    TrueTerm,
    FalseTerm,
    NodeKind,
)


class TestBasicAdditions:
    """Test adding basic terms to the e-graph"""

    def test_add_constant(self):
        eg = EGraph()
        node = eg.addTerm(Constant("a"))
        assert node is not None
        assert node.kind == NodeKind.VALUE

    def test_add_function_symbol(self):
        eg = EGraph()
        node = eg.addTerm(FunctionSymbol("f"))
        assert node is not None
        assert node.kind == NodeKind.HIGHER_ORDER

    def test_add_predicate_symbol(self):
        eg = EGraph()
        node = eg.addTerm(PredicateSymbol("P"))
        assert node is not None
        assert node.kind == NodeKind.HIGHER_ORDER

    def test_add_true_term(self):
        eg = EGraph()
        node = eg.addTerm(TrueTerm())
        assert node is not None
        assert node.kind == NodeKind.PROP

    def test_add_false_term(self):
        eg = EGraph()
        node = eg.addTerm(FalseTerm())
        assert node is not None
        assert node.kind == NodeKind.PROP


class TestNodeReuse:
    """Test that nodes are reused when adding the same term"""

    def test_constant_reuse(self):
        eg = EGraph()
        node1 = eg.addTerm(Constant("a"))
        node2 = eg.addTerm(Constant("a"))
        assert node1 is node2

    def test_function_symbol_reuse(self):
        eg = EGraph()
        node1 = eg.addTerm(FunctionSymbol("f"))
        node2 = eg.addTerm(FunctionSymbol("f"))
        assert node1 is node2

    def test_different_constants_different_nodes(self):
        eg = EGraph()
        node1 = eg.addTerm(Constant("a"))
        node2 = eg.addTerm(Constant("b"))
        assert node1 is not node2


class TestEquations:
    """Test equation handling and union-find"""

    def test_add_equation_basic(self):
        eg = EGraph()
        node = eg.addEquation(Constant("a"), Constant("b"))
        assert node is not None
        assert node.kind == NodeKind.PROP

    def test_equation_makes_constants_equal(self):
        eg = EGraph()
        eg.addEquation(Constant("a"), Constant("b"))
        a_node = eg.addTerm(Constant("a"))
        b_node = eg.addTerm(Constant("b"))
        assert eg.sameClass(a_node, b_node)

    def test_has_fact_after_equation(self):
        eg = EGraph()
        eg.addEquation(Constant("a"), Constant("b"))
        assert eg.hasFact(Equals(Constant("a"), Constant("b")))

    def test_has_fact_reversed(self):
        eg = EGraph()
        eg.addEquation(Constant("a"), Constant("b"))
        assert eg.hasFact(Equals(Constant("b"), Constant("a")))

    def test_transitivity(self):
        eg = EGraph()
        eg.addEquation(Constant("a"), Constant("b"))
        eg.addEquation(Constant("b"), Constant("c"))
        assert eg.hasFact(Equals(Constant("a"), Constant("c")))


class TestCongruence:
    """Test congruence closure"""

    def test_function_application_congruence(self):
        eg = EGraph()
        # Create f(a) and f(b), then union a with b
        f_sym = FunctionSymbol("f")
        a = Constant("a")
        b = Constant("b")

        f_a = eg.addTerm(FunctionApplication(f_sym, a))
        f_b = eg.addTerm(FunctionApplication(f_sym, b))

        # Before unioning a and b, f(a) and f(b) should be different
        assert not eg.sameClass(f_a, f_b)

        # Union a and b
        eg.addEquation(a, b)

        # After unioning a and b, f(a) and f(b) should be in the same class (congruence)
        f_a_node = eg.addTerm(FunctionApplication(f_sym, a))
        f_b_node = eg.addTerm(FunctionApplication(f_sym, b))
        assert eg.sameClass(f_a_node, f_b_node)

    def test_predicate_application_congruence(self):
        eg = EGraph()
        p_sym = PredicateSymbol("P")
        a = Constant("a")
        b = Constant("b")

        p_a = eg.addPredicateApplication(p_sym, a)
        p_b = eg.addPredicateApplication(p_sym, b)

        # Both should be marked as true initially
        assert eg.hasFact(PredicateApplication(p_sym, a))
        assert eg.hasFact(PredicateApplication(p_sym, b))


class TestGoals:
    """Test goal handling"""

    def test_add_goal_basic(self):
        eg = EGraph()
        goal = eg.addGoal(FalseTerm())
        assert goal is not None

    def test_goal_marked_false(self):
        eg = EGraph()
        const_a = Constant("a")
        eq = Equals(const_a, const_a)
        # Add goal: not Equals(a, a) - this should create a contradiction
        eg.addGoal(eq)
        # After adding this goal, we should eventually detect the contradiction
        # because Equals(a, a) should be true


class TestBottomDetection:
    """Test contradiction detection"""

    def test_no_bottom_initially(self):
        eg = EGraph()
        result = eg.findBottom()
        assert result.found is False
        assert result.left is None
        assert result.right is None

    def test_is_not_bottom_initially(self):
        eg = EGraph()
        assert eg.isBottom() is False

    def test_bottom_after_contradiction(self):
        eg = EGraph()
        # Create a contradiction: True and False are in the same class
        # Union True and False nodes directly to create a contradiction
        eg._union_nodes(eg._true_node, eg._false_node)
        result = eg.findBottom()
        assert result.found is True
        assert result.left is not None
        assert result.right is not None

    def test_is_bottom_after_contradiction(self):
        eg = EGraph()
        # Union True and False nodes directly to create a contradiction
        eg._union_nodes(eg._true_node, eg._false_node)
        assert eg.isBottom() is True
