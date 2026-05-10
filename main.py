import sys
from pathlib import Path


# make sure that python can find our packages
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

# =====================================================

import os

from scaffolding.parser import parse_declarations
from scaffolding.printer import print_program
from scaffolding.syntax import Definition
from scaffolding.helper import substitute_grind
from tinygrind.entry import tinygrind

output = ""


def process_problem(dirpath: str, filename: str):
    if (
        not filename.endswith(".lean")
        or filename == "__output.lean"
        or dirpath.startswith("problems/.lake/")
    ):
        return
    global output
    full_path = os.path.join(dirpath, filename)
    print(f"Processing {full_path}")
    with open(full_path, "r", encoding="utf-8") as f:
        content = f.read()

    if len(content.strip()) == 0:
        return

    # might make this more clever by explicitly looking for "by grind" and operating on it
    # but hey, for now, this should be fine
    decls = parse_declarations(content)
    if isinstance(decls[0], Definition):
        definition = decls[0]
    else:
        raise RuntimeError("No declaration found")

    proof = tinygrind(definition)

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


def traverse_folder(root_dir: str):
    for dirpath, dirnames, filenames in os.walk(root_dir):
        dirnames.sort()
        filenames.sort()

        for filename in filenames:
            process_problem(dirpath, filename)


traverse_folder("problems")
with open("problems/__output.lean", "w", encoding="utf-8") as f:
    _ = f.write(output)

print("\nProofs saved to problems/__output.lean\nBYE")
