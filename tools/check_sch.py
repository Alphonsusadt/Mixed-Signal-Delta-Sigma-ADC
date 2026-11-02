#!/usr/bin/env python3
"""
check_sch.py - pemeriksa konektivitas statis berkas Xschem .sch (tanpa Xschem).

Memeriksa: (1) setiap pin simbol yang dikenal jatuh tepat di ujung/badan wire atau
di lab_pin/gnd, (2) satu jaring tidak memiliki dua nama berbeda, (3) pin DUT ada di
jaring yang diharapkan. Ini BUKAN pengganti netlist Xschem: hanya menangkap salah
koordinat/label. Simbol yang tidak dikenal dilaporkan, bukan diabaikan diam-diam.

Pemakaian:  python3 tools/check_sch.py blocks/05_Switch_Network/sim/tb_5F_*.sch
"""
import re
import sys

# pin simbol (relatif, sebelum rotasi); None = tidak ada pin (code/corner/teks)
SYM_PINS = {
    "vsource.sym": [("p", 0, -30), ("n", 0, 30)],
    "res.sym": [("p", 0, -30), ("n", 0, 30)],
    "capa.sym": [("p", 0, -30), ("n", 0, 30)],
    "sky130_fd_pr/cap_mim_m3_1.sym": [("c0", 0, -30), ("c1", 0, 30)],
    "gnd.sym": [("g", 0, 0)],
    "lab_pin.sym": [("l", 0, 0)],
    "lab_wire.sym": None,
    "code.sym": None,
    "sky130_fd_pr/corner.sym": None,
}
BLOCK5_PINS = [("PHI_SH", -150, -40), ("PHI_SHB", -150, -20), ("VCM", -150, 0),
               ("VIN_P", -150, 20), ("VIN_N", -150, 40), ("HOLD_P", 150, 0),
               ("HOLD_N", 150, 20), ("VDD", 70, -120), ("GND", 70, 140)]
for _s in ("blocks/05_Switch_Network/xschem/Block5_SH.sym",
           "blocks/05_Switch_Network/xschem/Block5_SH_LVT.sym"):
    SYM_PINS[_s] = BLOCK5_PINS

DUT_EXPECT = {"PHI_SH": "PHI_SH", "PHI_SHB": "PHI_SHB", "VCM": "VCM", "VIN_P": "vin_p",
              "VIN_N": "vin_n", "HOLD_P": "HOLD_P", "HOLD_N": "HOLD_N", "VDD": "VDD", "GND": "0"}


def xform(x, y, rot, flip):
    if flip:
        x = -x
    return [(x, y), (-y, x), (-x, -y), (y, -x)][rot % 4]


def parse(path):
    comps, wires = [], []
    lines = open(path, errors="replace").read().split("\n")
    i = 0
    while i < len(lines):
        ln = lines[i]
        if ln.startswith("N "):
            m = re.match(r"N (-?\d+) (-?\d+) (-?\d+) (-?\d+) \{(.*)\}", ln)
            if m:
                x1, y1, x2, y2 = map(int, m.groups()[:4])
                lab = re.search(r"lab=(\S+?)(?:\s|$|\})", m.group(5) + " ")
                wires.append((x1, y1, x2, y2, lab.group(1) if lab else None))
        elif ln.startswith("C {"):
            m = re.match(r"C \{(.*?)\} (-?\d+) (-?\d+) (\d+) (\d+) \{(.*)", ln)
            if m:
                sym, x, y, rot, flip, rest = m.groups()
                text = rest
                depth = 1 + rest.count("{") - rest.count("}")
                while depth > 0 and i + 1 < len(lines):
                    i += 1
                    text += "\n" + lines[i]
                    depth += lines[i].count("{") - lines[i].count("}")
                name = re.search(r"name=([^\s}]+)", text)
                lab = re.search(r"\blab=([^\s}]+)", text)
                comps.append(dict(sym=sym, x=int(x), y=int(y), rot=int(rot), flip=int(flip),
                                  name=name.group(1) if name else "?", lab=lab.group(1) if lab else None,
                                  text=text))
        i += 1
    return comps, wires


def on_seg(px, py, w):
    x1, y1, x2, y2, _ = w
    if x1 == x2 == px:
        return min(y1, y2) <= py <= max(y1, y2)
    if y1 == y2 == py:
        return min(x1, x2) <= px <= max(x1, x2)
    return False


def check(path):
    comps, wires = parse(path)
    problems, notes = [], []
    parent = {}

    def find(a):
        parent.setdefault(a, a)
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def union(a, b):
        parent[find(a)] = find(b)

    for w in wires:
        union(("w", w[0], w[1]), ("w", w[2], w[3]))
    # titik wire yang menyentuh ujung wire lain
    wp = set()
    for w in wires:
        wp.add((w[0], w[1])); wp.add((w[2], w[3]))
    for w in wires:
        for (px, py) in wp:
            if on_seg(px, py, w):
                union(("w", px, py), ("w", w[0], w[1]))
    pinpoints = []   # (comp, pinname, x, y)
    unknown = set()
    for c in comps:
        key = c["sym"]
        if key not in SYM_PINS:
            unknown.add(key)
            continue
        pins = SYM_PINS[key]
        if pins is None:
            continue
        for pn, px, py in pins:
            dx, dy = xform(px, py, c["rot"], c["flip"])
            pinpoints.append((c, pn, c["x"] + dx, c["y"] + dy))
    names = {}   # root -> set(nama)
    def add_name(root, nm):
        names.setdefault(root, set()).add(nm)

    for w in wires:
        if w[4]:
            add_name(find(("w", w[0], w[1])), w[4])
    for c, pn, x, y in pinpoints:
        pt = ("w", x, y)
        touched = False
        for w in wires:
            if on_seg(x, y, w):
                union(pt, ("w", w[0], w[1])); touched = True
        if (x, y) in wp:
            touched = True
        c.setdefault("_pins", {})[pn] = (x, y)
        c.setdefault("_touch", {})[pn] = touched
    # label/gnd menempel di titik pin
    point_names = {}
    for c, pn, x, y in pinpoints:
        if c["sym"] == "lab_pin.sym" and c["lab"]:
            point_names.setdefault((x, y), set()).add(c["lab"])
        if c["sym"] == "gnd.sym":
            point_names.setdefault((x, y), set()).add("0")
    # sambungkan semua pin yang berada di titik yang sama
    byxy = {}
    for c, pn, x, y in pinpoints:
        byxy.setdefault((x, y), []).append((c, pn))
    for (x, y), lst in byxy.items():
        for a in lst[1:]:
            union(("w", x, y), ("w", x, y))
    for (x, y), nm in point_names.items():
        for n in nm:
            add_name(find(("w", x, y)), n)
    # gabungkan nama dengan root akhir
    final = {}
    for r, nm in names.items():
        final.setdefault(find(r), set()).update(nm)
    for r, nm in final.items():
        low = {n.lower() for n in nm}
        if len(low) > 1:
            problems.append(f"jaring dengan dua nama berbeda: {sorted(nm)}")
    # dangling & net per pin
    pinnet = {}
    for c, pn, x, y in pinpoints:
        if c["sym"] in ("lab_pin.sym", "gnd.sym"):
            continue
        r = find(("w", x, y))
        nm = final.get(r) or point_names.get((x, y))
        shared = len(byxy[(x, y)]) > 1
        if not (c["_touch"][pn] or shared):
            problems.append(f"{c['name']}.{pn} @({x},{y}) menggantung (tidak ada wire/label di pin)")
        pinnet[(c["name"], pn)] = sorted(nm) if nm else None
        if not nm:
            problems.append(f"{c['name']}.{pn} @({x},{y}) tanpa nama jaring")
    # lab_pin tanpa pasangan: harus bertemu pin lain atau wire
    for c, pn, x, y in pinpoints:
        if c["sym"] == "lab_pin.sym":
            lab = c["lab"]
            if lab and lab != "0" and not c.get("_touch", {}).get("l") and len(byxy[(x, y)]) == 1:
                notes.append(f"lab_pin {c['name']} ({lab}) berdiri sendiri @({x},{y}) - hanya terhubung via nama")
    # DUT
    for c in comps:
        if c["sym"].endswith("Block5_SH.sym") or c["sym"].endswith("Block5_SH_LVT.sym"):
            for pn, want in DUT_EXPECT.items():
                got = pinnet.get((c["name"], pn))
                if not got or want.lower() not in {g.lower() for g in got}:
                    problems.append(f"DUT {c['name']}.{pn}: jaring {got}, diharapkan {want}")
    if unknown:
        notes.append("simbol tidak dikenal checker (tidak diperiksa): " + ", ".join(sorted(unknown)))
    return problems, notes, comps


def main():
    rc = 0
    for p in sys.argv[1:]:
        problems, notes, comps = check(p)
        print(f"== {p}: {len(comps)} komponen")
        for n in notes:
            print("  NOTE :", n)
        for pr in problems:
            print("  ERROR:", pr)
            rc = 1
        if not problems:
            print("  OK (konektivitas statis)")
    sys.exit(rc)


if __name__ == "__main__":
    main()
