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
theorem eq_false_intro {a : Prop} (h : ¬a) : a = False := propext (iff_false_intro h)

theorem and_elim_left {a b : Prop} (h : (a ∧ b) = True) : a = True := eq_true (of_eq_true h).left

theorem and_elim_right {a b : Prop} (h : (a ∧ b) = True) : b = True := eq_true (of_eq_true h).right

theorem modus_ponens {a b : Prop} (imp: (a → b) = True) (ha : a = True) : b = True := eq_true ((of_eq_true imp) (of_eq_true ha))

theorem or_elim {A B : Prop} (hor : (A ∨ B) = True) (hA : A -> (True = False)) (hB : B -> (True = False)) : True = False := Or.elim (of_eq_true hor) hA hB

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
