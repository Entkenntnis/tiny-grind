import sys
from pathlib import Path


# Setup paths
ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from core.prelude import load_prelude
from core.kernel import Kernel
from core.parser import parse_declarations
from core.checker import TypeError as KernelTypeError


# Colors
GREEN, RED, YELLOW, RESET = "\033[92m", "\033[91m", "\033[93m", "\033[0m"


def run_tests():
    examples_dir = ROOT / "examples"
    files = sorted(examples_dir.rglob("*.lean"))
    unexpected = 0

    for path in files:
        rel_path = path.relative_to(examples_dir)
        should_fail = "should-fail" in path.parts

        try:
            # Run typecheck
            kernel = Kernel()
            load_prelude(kernel)
            for decl in parse_declarations(path.read_text(encoding="utf-8")):
                kernel.add_decl(decl)
            succeeded = True
            error_msg = ""
        except (ValueError, KernelTypeError, OSError) as e:
            succeeded = False
            error_msg = str(e).split("\n")[0]  # Get first line of error

        # Determine status
        is_ok = (succeeded and not should_fail) or (not succeeded and should_fail)

        if is_ok:
            tag = f"{GREEN}[PASS]{RESET}" if succeeded else f"{GREEN}[XFAIL]{RESET}"
        else:
            tag = (
                f"{RED}[DID NOT FAIL]{RESET}"
                if succeeded
                else f"{RED}[DID NOT PASS]{RESET}"
            )
            unexpected += 1

        print(
            f"{tag} {rel_path} {f'({YELLOW}{error_msg}{RESET})' if error_msg and not is_ok else ''}"
        )

    # Final Summary
    print(f"\nTotal: {len(files)} | Unexpected: {unexpected}")
    if unexpected == 0:
        print(f"{GREEN}✨ Everything went well!{RESET}")
        sys.exit(0)
    else:
        print(f"{RED}❌ Some tests failed.{RESET}")
        sys.exit(1)


if __name__ == "__main__":
    run_tests()
