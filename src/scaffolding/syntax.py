from dataclasses import dataclass
from typing import final
from abc import ABC


# this is used for possible shared info like line number, e.g. in the future
# can not be instantiated
@dataclass(frozen=True)
class TermBase(ABC):
    pass


# no de bruijn here, possibly in other parts, but we stay close to the source
@final
@dataclass(frozen=True)
class Var(TermBase):
    name: str


# this is a lambda, so most proofs are lambda definitions
@final
@dataclass(frozen=True)
class Lam(TermBase):
    var: str
    var_type: Term
    body: Term


# this is a "forall"
@final
@dataclass(frozen=True)
class Pi(TermBase):
    var: str | None  # None indicates a simple arrow A -> B
    var_type: Term
    body: Term


# "method call"
@final
@dataclass(frozen=True)
class App(TermBase):
    m: Term
    n: Term


# type annotations, seems to be important for the type checker to work in complicated situations
@final
@dataclass(frozen=True)
class Ann(TermBase):
    term: Term
    type: Term


@final
@dataclass(frozen=True)
class Let(TermBase):
    var: str
    var_type: Term
    value: Term
    body: Term


# yeah, we kinda should support universes, Sort(0) = Prop, Sort(1) = Type, Sort(2) = Type 1, ...
@final
@dataclass(frozen=True)
class Sort(TermBase):
    level: int


@final
@dataclass(frozen=True)
class ElabTactic(TermBase):
    name: str  # "sorry" or "grind"
    args: list[str] | None = (
        None  # raw strings inside parentheses, e.g. "instances := 2000"
    )


# use this type for all signatures
type Term = Var | Lam | Pi | App | Ann | Let | Sort | ElabTactic


@final
@dataclass(frozen=True)
class Definition:
    name: str
    type: Term
    value: Term


@final
@dataclass(frozen=True)
class Axiom:
    name: str
    type: Term
