from glob import glob


counter = 0

for filename in glob("_tptp_raw/TPTP-v9.2.1/Problems/**/*.p", recursive=True):
    if not filename.endswith(".p"):
        continue
    with open(filename, "r") as f:
        content = f.read()
        if "% SPC      : CNF_UNS_" in content:
            print(filename)
            counter += 1

print(f"Total: {counter}")
