#!/usr/bin/env python3
"""Stage 2b-iii: replace the ideal resistor of the Block 6 bias generator by a SKY130 poly resistor.

Needs tools/bias_gen_block6.py and tools/pvt_block6.py in the same folder.
  1. calibrates the resistor length L (W fixed) so that VBN = 0.700 V at TT / 27 C / 1.8 V,
  2. writes the deck  ..._biasgen_rpdk.spice  (VBPSRC/VBNSRC replaced by the generator),
  3. prints the DC operating points (VBN, VBP, VDD-VBP, I) over the 45 PVT points.
The resistor model carries its own temperature coefficient (tc1 = -1.47e-3 /K, tc2 = 2.7e-6 /K
for res_xhigh_po) and its voltage coefficient; whether it also moves with the process corner is
visible in the printed I(corner) table.  No Monte Carlo (MC_MM_SWITCH stays at its default).

Use (repo root):
  python3 tools/bias_gen_rpdk.py --repo /headless/tidy_test
  python3 tools/pvt_block6.py --repo /headless/tidy_test --deck <printed deck> --out results/pvt_block6_biasgen_rpdk --jobs 2
Status labels: MEASURED_NOT_FINAL.
"""
import argparse, csv, itertools, re, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pvt_block6 as P
import bias_gen_block6 as B

MODELS = {"xhigh": "sky130_fd_pr__res_xhigh_po_1p41", "high": "sky130_fd_pr__res_high_po_1p41"}


def body(model, w, l):
    ln = B.res_body(1.0).splitlines()
    ln[0] = f"VIRB VDD VDDI 0\nXRB1 VDDI VBN 0 {model} w={w} l={l:.5g}"
    return "\n".join(ln) + "\n"


def op3(lib, corner, temp, vdd, bd, ngspice, work, tag):
    txt = (f"* op\n.option scale=1e-6\n.lib {lib} {corner}\n.temp {temp}\nVVDD VDD 0 {vdd}\n{bd}"
           f".control\nop\nprint v(vbn)\nprint v(vbp)\nprint i(virb)\n.endc\n.end\n")
    t = B.run_ngspice(txt, tag, work, ngspice)
    out = {}
    for k, pat in (("vbn", r"v\(vbn\)"), ("vbp", r"v\(vbp\)"), ("i", r"i\(virb\)")):
        m = re.search(pat + r"\s*=\s*([-+0-9.eE]+)", t, re.I)
        if not m:
            sys.exit(f"could not read {k} from {work}/{tag}.log (is the resistor model found? look at that log)")
        out[k] = float(m.group(1))
    out["i"] = abs(out["i"])
    return out


def calib_L(lib, a, work, model):
    v = [op3(lib, "tt", 27, 1.8, body(model, a.w, l), a.ngspice, work, "rp_chk")["vbn"] for l in (100.0, 1000.0)]
    if abs(v[0] - v[1]) < 0.01:
        sys.exit("VBN does not change with l: the instance parameter l= is not applied by this model. "
                 "Send me work/rp_chk.log and the subckt header.")
    lo, hi = 0.0, 4.0                      # log10(L in um)
    for _ in range(30):
        mid = 0.5 * (lo + hi)
        r = op3(lib, "tt", 27, 1.8, body(model, a.w, 10 ** mid), a.ngspice, work, "rp_cal")
        if r["vbn"] > a.vbn: lo = mid      # longer resistor -> smaller current -> smaller VBN
        else: hi = mid
        if abs(r["vbn"] - a.vbn) < 0.0005:
            break
    return 10 ** mid, r


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--repo", default=".")
    ap.add_argument("--deck", default=P.DEF_DECK)
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--model", choices=list(MODELS), default="xhigh")
    ap.add_argument("--w", type=float, default=1.41, help="resistor width, um (1p41 = minimum)")
    ap.add_argument("--l", type=float, default=None, help="resistor length, um (default: calibrate)")
    ap.add_argument("--vbn", type=float, default=0.70)
    ap.add_argument("--corners", default="tt,ss,ff,sf,fs")
    ap.add_argument("--temps", default="-40,27,125")
    ap.add_argument("--vdds", default="1.62,1.8,1.98")
    ap.add_argument("--no-opmap", action="store_true")
    a = ap.parse_args()

    repo = Path(a.repo).resolve()
    deck = (repo / a.deck) if not Path(a.deck).is_absolute() else Path(a.deck)
    if not deck.exists():
        sys.exit(f"Deck not found: {deck}")
    lines = P.read_deck(deck); lib = B.find_lib(lines)
    work = repo / "results" / "pvt_block6_biasgen"; work.mkdir(parents=True, exist_ok=True)
    model = MODELS[a.model]

    if a.l is None:
        L, r = calib_L(lib, a, work, model)
    else:
        L = a.l; r = op3(lib, "tt", 27, 1.8, body(model, a.w, L), a.ngspice, work, "rp_cal")
    print(f"{model}: W = {a.w} um, L = {L:.2f} um ({L / a.w:.0f} squares) -> at TT 27C 1.8V: "
          f"VBN = {r['vbn']:.4f} V, VBP = {r['vbp']:.4f} V (VDD-VBP = {1.8 - r['vbp']:.4f} V), I = {r['i']:.4e} A")
    print("reference (ideal R): VBN 0.7001 V, VBP 0.7133 V, I 8.81e-07 A")

    bd = body(model, a.w, L)
    vp = ["* VBPSRC/VBNSRC replaced by bias generator with SKY130 poly resistor (bias_gen_rpdk.py)"] + bd.splitlines()
    nd = B.write_deck(lines, deck, "_biasgen_rpdk", [], vp)
    print("wrote", nd)

    if not a.no_opmap:
        print("\ncorner  T(C)   VDD    VBN     VBP   VDD-VBP   I(uA)")
        rows = []
        for c, T, v in itertools.product(a.corners.split(","), a.temps.split(","), a.vdds.split(",")):
            x = op3(lib, c, T, v, bd, a.ngspice, work, f"rp_{c}_{T}_{v}".replace("-", "m").replace(".", "p"))
            vd = float(v); rows.append((c, T, v, x["vbn"], x["vbp"], vd - x["vbp"], x["i"] * 1e6))
            print(f"{c:>5s} {T:>6s} {v:>6s}  {x['vbn']:.3f}  {x['vbp']:.3f}   {vd - x['vbp']:.3f}   {x['i'] * 1e6:.3f}")
        I = [x[6] for x in rows]
        print(f"\nI range {min(I):.3f} .. {max(I):.3f} uA (nominal 0.885; ideal-R run: 0.685 .. 1.083)")
        with open(work / "rpdk_opmap.csv", "w", newline="") as fh:
            w = csv.writer(fh); w.writerow(["corner", "temp", "vdd", "vbn", "vbp", "vdd_minus_vbp", "i_uA"]); w.writerows(rows)
        print("csv :", work / "rpdk_opmap.csv")
    print(f"\nNext:\n  python3 tools/pvt_block6.py --repo {repo} --deck {nd} --out results/pvt_block6_biasgen_rpdk --jobs 2")


if __name__ == "__main__":
    main()
