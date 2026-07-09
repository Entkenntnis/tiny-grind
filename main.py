import sys
from pathlib import Path


# make sure that python can find our packages
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

sys.setrecursionlimit(100000)

# =====================================================

import os

from scaffolding.parser import parse_declarations
from scaffolding.printer import print_program
from scaffolding.syntax import Definition
from scaffolding.helper import substitute_grind
from tinygrind.entry import tinygrind
import subprocess
import argparse

parser = argparse.ArgumentParser(description="Process Lean problems with tinygrind.")
_ = parser.add_argument(
    "--theorem",
    type=str,
    default=None,
    help="Process only the file whose first definition has this exact name.",
)
args = parser.parse_args()


output = """
def Imp (A : Prop) (B : Prop) := A → B

theorem eq_false_intro {a : Prop} (h : ¬a) : a = False := propext (iff_false_intro h)

theorem and_elim_left {a b : Prop} (h : (a ∧ b) = True) : a = True := eq_true (of_eq_true h).left

theorem and_elim_right {a b : Prop} (h : (a ∧ b) = True) : b = True := eq_true (of_eq_true h).right

theorem and_eq_false_of_left_false {a b : Prop} (ha : a = False) : (a ∧ b) = False := eq_false_intro (fun h => of_eq_false ha h.left)

theorem and_eq_false_of_right_false {a b : Prop} (hb : b = False) : (a ∧ b) = False := eq_false_intro (fun h => of_eq_false hb h.right)

theorem and_eq_right_of_left_true {a b : Prop} (ha : a = True) : (a ∧ b) = b := propext (Iff.intro (fun h => h.right) (fun hb => And.intro (of_eq_true ha) hb))

theorem and_eq_left_of_right_true {a b : Prop} (hb : b = True) : (a ∧ b) = a := propext (Iff.intro (fun h => h.left) (fun ha => And.intro ha (of_eq_true hb)))

theorem or_eq_true_of_left_true {a b : Prop} (ha : a = True) : (a ∨ b) = True := eq_true (Or.inl (of_eq_true ha))

theorem or_eq_true_of_right_true {a b : Prop} (hb : b = True) : (a ∨ b) = True := eq_true (Or.inr (of_eq_true hb))

theorem or_eq_of_left_false {a b : Prop} (ha : a = False) : (a ∨ b) = b := propext (Iff.intro (fun h => Or.elim h (fun hleft => False.elim (of_eq_false ha hleft)) id) (fun hb => Or.inr hb))

theorem or_eq_of_right_false {a b : Prop} (hb : b = False) : (a ∨ b) = a := propext (Iff.intro (fun h => Or.elim h id (fun hright => False.elim (of_eq_false hb hright))) (fun ha => Or.inl ha))

theorem or_elim_left_false {a b : Prop} (h : (a ∨ b) = False) : a = False := eq_false_intro (fun ha => of_eq_false h (Or.inl ha))

theorem or_elim_right_false {a b : Prop} (h : (a ∨ b) = False) : b = False := eq_false_intro (fun hb => of_eq_false h (Or.inr hb))

theorem not_eq_false_of_arg_true {a : Prop} (ha : a = True) : (¬a) = False := eq_false_intro (fun hn => hn (of_eq_true ha))

theorem not_eq_true_of_arg_false {a : Prop} (ha : a = False) : (¬a) = True := eq_true (fun h => of_eq_false ha h)

theorem eq_false_of_not_eq_true {a : Prop} (hn : (¬a) = True) : a = False := eq_false_intro (fun ha => (of_eq_true hn) ha)

theorem eq_true_of_not_eq_false {a : Prop} (hn : (¬a) = False) : a = True := eq_true (Classical.byContradiction (fun hna => of_eq_false hn hna))

theorem modus_ponens {a b : Prop} (imp: (a → b) = True) (ha : a = True) : b = True := eq_true ((of_eq_true imp) (of_eq_true ha))

theorem or_elim {A B : Prop} (hor : (A ∨ B) = True) (hA : A -> (True = False)) (hB : B -> (True = False)) : True = False := Or.elim (of_eq_true hor) hA hB

theorem push_not_and {A B : Prop} (h: (A ∧ B) = False) : (¬ A ∨ ¬ B) = True := eq_true (
    match Classical.em A with
    | Or.inl hA =>
        Or.inr (fun hB => of_eq_false h ⟨hA, hB⟩)
    | Or.inr hnA =>
        Or.inl hnA
  )

theorem push_not_imp {A B : Prop} (h: (A → B) = False) : (A ∧ ¬ B) = True := 
eq_true ⟨
    Classical.byContradiction
      (fun hnA => of_eq_false h (fun hA => False.elim (hnA hA))),
    fun hB => of_eq_false h (fun _ => hB)
  ⟩

theorem push_not_or {A B : Prop} (h: (A ∨ B) = False) : (¬ A ∧ ¬ B) = True :=
eq_true ⟨
    fun hA => of_eq_false h (Or.inl hA),
    fun hB => of_eq_false h (Or.inr hB)
  ⟩

theorem imp_eq_true_of_left_false {A B : Prop} (h : A = False) : (A → B) = True :=
  eq_true (fun (a : A) => False.elim (of_eq_true (Eq.trans (Eq.symm h) (eq_true a))))

theorem imp_eq_true_of_right_true {A B : Prop} (h : B = True) : (A → B) = True :=
  eq_true (fun a => of_eq_true h)



"""


def process_problem(dirpath: str, filename: str, target_name: str | None = None):
    if (
        not filename.endswith(".lean")
        or filename == "__output.lean"
        or dirpath.startswith("problems/.lake/")
        or filename.startswith("__")
    ):
        return
    global output
    full_path = os.path.join(dirpath, filename)
    with open(full_path, "r", encoding="utf-8") as f:
        content = f.read()

    if len(content.strip()) == 0:
        return

    # might make this more clever by explicitly looking for "by grind" and operating on it
    # but hey, for now, this should be fine
    decls = parse_declarations(content)
    if not isinstance(decls[0], Definition):
        raise RuntimeError("No declaration found")

    definition = decls[0]

    if target_name is not None and definition.name != target_name:
        return

    print(f"Processing {full_path}")

    proof = tinygrind(definition)

    if definition.name.endswith("_f"):

        output += f"-- {full_path}\n\n"
        output += "/-- warning: declaration uses `sorry` -/\n"
        output += "#guard_msgs in\n"
        output += print_program(
            [
                Definition(
                    name=f"{definition.name}",
                    type=definition.type,
                    value=substitute_grind(definition.value, proof),
                )
            ]
        )

    else:
        proof_def = Definition(
            name=f"{definition.name}_proof",
            type=definition.type,
            value=substitute_grind(definition.value, proof),
        )
        # print(decls)
        # print(print_program(decls))
        output += f"-- {full_path}\n"
        output += print_program(decls)
        output += "\n\n"
        output += print_program([proof_def])

    output += "\n\n\n"


def traverse_folder(root_dir: str, target_name: str | None = None):
    for dirpath, dirnames, filenames in os.walk(root_dir):
        dirnames.sort()
        filenames.sort()

        for filename in filenames:
            process_problem(dirpath, filename, target_name=target_name)


traverse_folder("problems", args.theorem)  # pyright: ignore
with open("problems/__output.lean", "w", encoding="utf-8") as f:
    _ = f.write(output)

print("\nProofs saved to problems/__output.lean\n")

result = subprocess.run(["lake", "build", "__output"], cwd="problems")
