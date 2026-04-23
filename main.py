import sys
from pathlib import Path


# Setup paths
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))


from core.syntax import Axiom, Definition
from core.parser import parse_declarations
from core.kernel import Kernel
from core.prelude import load_prelude


CODE = """

def proj1 : (A : Prop) -> (B : Prop) -> And A B -> A :=
    fun (A : Prop) (B : Prop) (p : And A B) =>
        @And.rec A B (fun (_ : And A B) => A) (fun (a : A) (b : B) => a) p

def and_swap : (A : Prop) -> (B : Prop) -> And A B -> And B A :=
    fun (A : Prop) (B : Prop) (p : And A B) =>
        @And.rec A B (fun (_ : And A B) => (And B A))
            (fun (a : A) (b : B) =>
                @And.intro B A b a
            )
            p

def contradiction : (A : Prop) -> A -> Not A -> False :=
    fun (A : Prop) (a : A) (na : Not A) =>
        na a

def ex_falso_example : False -> And True True :=
    fun (f : False) =>
        @False.rec (fun (_ : False) => (And True True)) f

def complex_ste : (A : Prop) -> (B : Prop) -> And A B -> And B True :=
    fun (A : Prop) (B : Prop) (p : And A B) =>
        @And.rec A B (fun (_ : And A B) => (And B True))
            (fun (a : A) (b : B) =>
                @And.intro B True b @True.intro
            )
            p


def distribute : (A : Prop) -> (B : Prop) -> (C : Prop) -> And A (Or B C) -> Or (And A B) (And A C) :=
    fun (A : Prop) (B : Prop) (C : Prop) (p : And A (Or B C)) =>
        @And.rec A (Or B C) (fun (_ : And A (Or B C)) => Or (And A B) (And A C))
            (fun (a : A) (bc : Or B C) =>
                @Or.rec B C (fun (_ : Or B C) => Or (And A B) (And A C))
                    (fun (b : B) => @Or.inl (And A B) (And A C) (@And.intro A B a b))
                    (fun (c : C) => @Or.inr (And A B) (And A C) (@And.intro A C a c))
                    bc
            )
            p


def symm : (A : Type) -> (x : A) -> (y : A) -> @Eq A x y -> @Eq A y x :=
    fun (A : Type) (x : A) (y : A) (p : @Eq A x y) =>
        @Eq.rec A x
            -- motive
            (fun (z : A) (t : @Eq A x z) => @Eq A z x)
            -- base case
            (@Eq.refl A x)
            y p


def trans : (A : Type) -> (x : A) -> (y : A) -> (z : A) -> @Eq A x y -> @Eq A y z -> @Eq A x z :=
    fun (A : Type) (x : A) (y : A) (z : A) (p : @Eq A x y) (q : @Eq A y z) =>
        (@Eq.rec A x
            
            (fun (target : A) (t : @Eq A x target) =>
                @Eq A target z -> @Eq A x z
            )

            (fun (h : @Eq A x z) => h)

            y p
        )
        q

def cong : (A : Type) -> (B : Type) -> (f : A -> B) -> (x : A) -> (y : A) -> @Eq A x y -> @Eq B (f x) (f y) :=
    fun (A : Type) (B : Type) (f : A -> B) (x : A) (y : A) (p : @Eq A x y) =>
        @Eq.rec A x
            (fun (target : A) (t : @Eq A x target) => @Eq B (f x) (f target))
            (@Eq.refl B (f x))
            y p


def de_morgan_1 : (A : Prop) -> (B : Prop) -> Not (Or A B) -> And (Not A) (Not B) :=
    fun (A : Prop) (B : Prop) (h : Not (Or A B)) =>
        @And.intro (Not A) (Not B)
            (fun (a : A) => h (@Or.inl A B a))
            (fun (b : B) => h (@Or.inr A B b))


def curry : (A : Prop) -> (B : Prop) -> (C : Prop) -> (And A B -> C) -> (A -> B -> C) :=
    fun (A : Prop) (B : Prop) (C : Prop) (f : And A B -> C) (a : A) (b : B) =>
        f (@And.intro A B a b)


def uncurry : (A : Prop) -> (B : Prop) -> (C : Prop) -> (A -> B -> C) -> (And A B -> C) :=
    fun (A : Prop) (B : Prop) (C : Prop) (f : A -> B -> C) (p: And A B) =>
        @And.rec A B (fun (t : And A B) => C)
            (fun (a : A) (b : B) => f a b)
            p

def subst : (A : Type) -> (P : A -> Prop) -> (x : A) -> (y: A) -> @Eq A x y -> P x -> P y :=
    fun (A : Type) (P : A -> Prop) (x : A) (y : A) (p : @Eq A x y) (px : P x) =>
        (@Eq.rec A x
            (fun (target: A) (t : @Eq A x target) => P x -> P target)
            (fun (h : P x) => h)
            y p
        )
        px

def triv_example : @Eq Prop True True :=
    @Eq.refl Prop True



"""

kernel = Kernel()
load_prelude(kernel)
for decl in parse_declarations(CODE):
    match decl:
        case Definition():
            kernel.add_definition(decl)
        case Axiom():
            kernel.add_axiom(decl)
