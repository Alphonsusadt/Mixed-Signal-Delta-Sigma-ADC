#!/usr/bin/env python3
"""Bias generator experiments for Block 6 (NONOV). Replica-diode bias, ideal or resistor-fed.

Subcommands
  calib    ideal-current replica diodes (VBP, optionally VBN)           [stage 2a, done]
  res      ONE resistor reference + current mirror makes VBN and VBP    [stage 2b]
  opmap    DC operating points of the resistor generator over 45 PVT    (no NONOV simulation, ~1-2 min)
  startup  VDD ramp 0 -> VDD: does the generator reach its operating point?

Resistor generator (4 elements, no ideal current source):
  RB1  VDD VBN  R                       current I = (VDD - VBN)/R
  XBN1 VBN VBN GND  nfet W=0.5 L=1     NMOS replica of XMNS, diode -> VBN
  XBN2 VBP VBN GND  nfet W=0.5 L=1     mirrors I into the PMOS diode
  XBP1 VBP VBP VDD  pfet W=1   L=1     PMOS replica of XMPS, diode -> VBP = VDD - Vsg
R is an IDEAL resistor (no temperature coefficient, no process spread): its variation is
tested separately with --rscale, because delay is about 1/I (see the Iref sensitivity run).
Start-up is inherent: R pulls VBN up, there is no zero-current stable state.

Typical use (repo root):
  python3 tools/bias_gen_block6.py res    --repo /headless/tidy_test
  python3 tools/bias_gen_block6.py opmap  --repo /headless/tidy_test
  python3 tools/bias_gen_block6.py startup --repo /headless/tidy_test
  python3 tools/pvt_block6.py --repo /headless/tidy_test --deck <printed deck> --out results/pvt_block6_biasgen_res --jobs 2
Status labels: MEASURED_NOT_FINAL.
"""
import argparse, itertools, json, re, subprocess, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pvt_block6 as P

LIBLINE = re.compile(r"^\s*\.lib\s+(\"[^\"]+\"|'[^']+'|\S+)\s+\S+\s*$", re.I)
VBN_RE = re.compile(r"^\s*vbnsrc\s+\S+\s+\S+\s+\S+.*$", re.I)
VBP_RE = re.compile(r"^\s*vbpsrc\s+\S+\s+\S+\s+\S+.*$", re.I)
PAR = "nf=1 ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29 sa=0 sb=0 sd=0 mult=1"
PARN = "nf=1 ad=0.145 as=0.145 pd=1.58 ps=1.58 nrd=0.58 nrs=0.58 sa=0 sb=0 sd=0 mult=1"


def find_lib(lines):
    for l in lines:
        m = LIBLINE.match(l)
        if m:
            return m.group(1).strip("\"'")
    raise SystemExit("no .lib line in deck")


def res_body(R):
    return (f"RB1 VDD VBN {R:.6e}\n"
            f"XBN1 VBN VBN 0 0 sky130_fd_pr__nfet_01v8 L=1 W=0.5 {PARN}\n"
            f"XBN2 VBP VBN 0 0 sky130_fd_pr__nfet_01v8 L=1 W=0.5 {PARN}\n"
            f"XBP1 VBP VBP VDD VDD sky130_fd_pr__pfet_01v8 L=1 W=1 {PAR}\n")


def run_ngspice(deck_text, tag, work, ngspice, timeout=180):
    deck = work / f"{tag}.spice"; log = work / f"{tag}.log"
    deck.write_text(deck_text)
    subprocess.run([ngspice, "-b", "-o", str(log), str(deck)], capture_output=True, text=True, timeout=timeout)
    return log.read_text(errors="replace") if log.exists() else ""


def val(text, name):
    m = re.search(rf"^{name}\s*=\s*([-+0-9.eE]+)", text, re.I | re.M)
    return float(m.group(1)) if m else None


def op(lib, corner, temp, vdd, body, ngspice, work, tag, nodes=("vbn", "vbp")):
    pr = "\n".join(f"print v({n})" for n in nodes)
    txt = (f"* op\n.option scale=1e-6\n.lib {lib} {corner}\n.temp {temp}\nVVDD VDD 0 {vdd}\n{body}"
           f".control\nop\n{pr}\n.endc\n.end\n")
    t = run_ngspice(txt, tag, work, ngspice)
    out = {}
    for n in nodes:
        m = re.search(rf"v\({n}\)\s*=\s*([-+0-9.eE]+)", t, re.I)
        if not m:
            raise SystemExit(f"could not read v({n}) from {work}/{tag}.log")
        out[n] = float(m.group(1))
    return out


# ---------------------------------------------------------------- calib (ideal Iref)
def op_ideal(lib, vdd, temp, corner, ip, ngspice, work, kind):
    if kind == "p":
        body = f"XMREF VBP VBP VDD VDD sky130_fd_pr__pfet_01v8 L=1 W=1 {PAR}\nIREFP VBP 0 {ip:.6e}\n"; n = "vbp"
    else:
        body = f"XMREFN VBN VBN 0 0 sky130_fd_pr__nfet_01v8 L=1 W=0.5 {PARN}\nIREFN VDD VBN {ip:.6e}\n"; n = "vbn"
    return op(lib, corner, temp, vdd, body, ngspice, work, f"calib_{kind}", nodes=(n,))[n]


def solve_current(target_v, kind, lib, ngspice, work):
    lo, hi = -9.0, -2.7
    for _ in range(28):
        mid = 0.5 * (lo + hi)
        v = op_ideal(lib, 1.8, 27, "tt", 10 ** mid, ngspice, work, kind)
        too_big = (v < target_v) if kind == "p" else (v > target_v)
        if too_big: hi = mid
        else: lo = mid
        if abs(v - target_v) < 0.0005:
            break
    return 10 ** mid, v


def write_deck(lines, deck, suffix, vbn_lines, vbp_lines):
    out, n = [], 0
    for l in lines:
        if VBP_RE.match(l):
            out += vbp_lines; n += 1
        elif vbn_lines is not None and VBN_RE.match(l):
            out += vbn_lines
        else:
            out.append(l)
    if not n:
        sys.exit("no VBPSRC line found in the deck")
    nd = deck.with_name(deck.stem + suffix + deck.suffix)
    nd.write_text("\n".join(out) + "\n")
    return nd


def cmd_calib(a, lines, deck, lib, work):
    ip = a.ip
    if ip is None:
        ip, v = solve_current(1.8 - a.vsg, "p", lib, a.ngspice, work)
        print(f"PMOS replica: Iref = {ip:.4e} A gives VBP = {v:.4f} V (Vsg = {1.8 - v:.4f} V) at TT 27C 1.8V")
    inn = None
    if a.nmos_diode:
        inn = a.inn
        if inn is None:
            inn, v = solve_current(a.vbn, "n", lib, a.ngspice, work)
            print(f"NMOS replica: Iref = {inn:.4e} A gives VBN = {v:.4f} V at TT 27C 1.8V")
    vp = ["* VBPSRC replaced by PMOS replica diode + ideal Iref (bias_gen_block6.py)",
          f"XMREFP VBP VBP VDD VDD sky130_fd_pr__pfet_01v8 L=1 W=1 {PAR}", f"IREFP VBP 0 {ip:.6e}"]
    vn = None
    if inn is not None:
        vn = ["* VBNSRC replaced by NMOS replica diode + ideal Iref (bias_gen_block6.py)",
              f"XMREFN VBN VBN 0 0 sky130_fd_pr__nfet_01v8 L=1 W=0.5 {PARN}", f"IREFN VDD VBN {inn:.6e}"]
    nd = write_deck(lines, deck, "_biasgen_pn" if inn is not None else "_biasgen_p", vn, vp)
    print("wrote", nd)
    print(f"\nNext:\n  python3 tools/pvt_block6.py --repo {a.repo_abs} --deck {nd} --out results/pvt_block6_biasgen --jobs 2")


# ---------------------------------------------------------------- res (resistor reference)
def calib_R(lib, a, work):
    lo, hi = 4.0, 8.5     # log10(R)
    for _ in range(30):
        mid = 0.5 * (lo + hi)
        r = op(lib, "tt", 27, 1.8, res_body(10 ** mid), a.ngspice, work, "res_cal")
        # larger R -> smaller I -> smaller VBN
        if r["vbn"] > a.vbn: lo = mid
        else: hi = mid
        if abs(r["vbn"] - a.vbn) < 0.0005:
            break
    return 10 ** mid, r


def load_cal(work):
    p = work / "res_cal.json"
    if not p.exists():
        raise SystemExit(f"{p} not found: run the 'res' subcommand first")
    return json.loads(p.read_text())


def cmd_res(a, lines, deck, lib, work):
    if a.r is None:
        R, r = calib_R(lib, a, work)
    else:
        R = a.r
        r = op(lib, "tt", 27, 1.8, res_body(R), a.ngspice, work, "res_cal")
    I = (1.8 - r["vbn"]) / R
    print(f"R = {R:.5e} ohm  ->  at TT 27C 1.8V: VBN = {r['vbn']:.4f} V, VBP = {r['vbp']:.4f} V "
          f"(VDD-VBP = {1.8 - r['vbp']:.4f} V), I = {I:.4e} A")
    print("reference for the ideal-current version: VBN 0.700 V, VBP 0.711 V, I 9.1e-07 A")
    (work / "res_cal.json").write_text(json.dumps({"R": R, "vbn": r["vbn"], "vbp": r["vbp"]}))
    Rs = R * a.rscale
    if a.rscale != 1.0:
        print(f"deck uses R x {a.rscale} = {Rs:.5e} ohm")
    body = [l for l in res_body(Rs).splitlines()]
    vp = ["* VBPSRC/VBNSRC replaced by resistor-reference bias generator (bias_gen_block6.py)"] + body
    tag = f"_biasgen_res" + (f"_r{a.rscale:g}" if a.rscale != 1.0 else "")
    nd = write_deck(lines, deck, tag, [], vp)
    print("wrote", nd)
    out = "pvt_block6_biasgen_res" + (f"_r{a.rscale:g}" if a.rscale != 1.0 else "")
    print(f"\nNext:\n  python3 tools/bias_gen_block6.py opmap --repo {a.repo_abs}\n"
          f"  python3 tools/pvt_block6.py --repo {a.repo_abs} --deck {nd} --out results/{out} --jobs 2")


def cmd_opmap(a, lines, deck, lib, work):
    R = a.r if a.r is not None else load_cal(work)["R"]
    body = res_body(R * a.rscale)
    print(f"R = {R * a.rscale:.5e} ohm; 'need' = VDD-VBP range seen in the bias map (0.935 .. 1.210 V)")
    print("corner  T(C)   VDD    VBN     VBP   VDD-VBP   I(uA)")
    rows = []
    for c, T, v in itertools.product(a.corners.split(","), a.temps.split(","), a.vdds.split(",")):
        r = op(lib, c, T, v, body, a.ngspice, work, f"opmap_{c}_{T}_{v}".replace("-", "m").replace(".", "p"))
        vd = float(v); I = (vd - r["vbn"]) / R / a.rscale
        rows.append((c, T, v, r["vbn"], r["vbp"], vd - r["vbp"], I * 1e6))
        print(f"{c:>5s} {T:>6s} {v:>6s}  {r['vbn']:.3f}  {r['vbp']:.3f}   {vd - r['vbp']:.3f}   {I * 1e6:.3f}")
    I = [x[6] for x in rows]; vs = [x[5] for x in rows]; vn = [x[3] for x in rows]
    print(f"\nI range {min(I):.3f} .. {max(I):.3f} uA (nominal 0.885); VBN {min(vn):.3f} .. {max(vn):.3f} V; "
          f"VDD-VBP {min(vs):.3f} .. {max(vs):.3f} V")
    print("Delay is about 1/I: compare the I range with nominal 0.885 uA before running the 45-case sweep.")
    import csv
    with open(work / "opmap.csv", "w", newline="") as fh:
        w = csv.writer(fh); w.writerow(["corner", "temp", "vdd", "vbn", "vbp", "vdd_minus_vbp", "i_uA"]); w.writerows(rows)
    print("csv :", work / "opmap.csv")


def cmd_startup(a, lines, deck, lib, work):
    R = a.r if a.r is not None else load_cal(work)["R"]
    print("corner  T(C)   VDD  | op VBN  op VBP | tran 0.5us  2us   5us  19us (VBN, VBP) | ok")
    for c, T, v in a.startup_cases:
        ref = op(lib, c, T, v, res_body(R * a.rscale), a.ngspice, work, "su_op")
        txt = (f"* startup\n.option scale=1e-6\n.lib {lib} {c}\n.temp {T}\nVVDD VDD 0 PWL(0 0 1u {v})\n"
               f"{res_body(R * a.rscale)}.control\ntran 5n 20u\n"
               + "".join(f"meas tran VN{k} FIND v(vbn) AT={t}\nmeas tran VP{k} FIND v(vbp) AT={t}\n"
                         for k, t in (("a", "0.5u"), ("b", "2u"), ("c", "5u"), ("d", "19u")))
               + ".endc\n.end\n")
        t = run_ngspice(txt, "su_tran", work, a.ngspice)
        vals = {k: (val(t, f"vn{k}"), val(t, f"vp{k}")) for k in "abcd"}
        fin = vals["d"]
        ok = fin[0] is not None and abs(fin[0] - ref["vbn"]) < 0.005 and abs(fin[1] - ref["vbp"]) < 0.005
        fmt = lambda p: "n/a" if p[0] is None else f"{p[0]:.3f},{p[1]:.3f}"
        print(f"{c:>5s} {T:>6s} {v:>6s} | {ref['vbn']:.3f}  {ref['vbp']:.3f} | "
              f"{fmt(vals['a'])}  {fmt(vals['b'])}  {fmt(vals['c'])}  {fmt(vals['d'])} | {'OK' if ok else 'CHECK'}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["calib", "res", "opmap", "startup"])
    ap.add_argument("--repo", default=".")
    ap.add_argument("--deck", default=P.DEF_DECK)
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--vsg", type=float, default=1.09, help="calib: nominal VDD-VBP (TT, 27 C, 1.8 V)")
    ap.add_argument("--vbn", type=float, default=0.70, help="calib/res: nominal VBN")
    ap.add_argument("--nmos-diode", action="store_true", help="calib: also replace VBNSRC by an NMOS replica diode")
    ap.add_argument("--ip", type=float, default=None, help="calib: use this PMOS reference current (A)")
    ap.add_argument("--in", dest="inn", type=float, default=None, help="calib: use this NMOS reference current (A)")
    ap.add_argument("--r", type=float, default=None, help="res/opmap/startup: resistor value (ohm), default from calibration")
    ap.add_argument("--rscale", type=float, default=1.0, help="multiply R (tests resistor spread; delay ~ 1/I)")
    ap.add_argument("--corners", default="tt,ss,ff,sf,fs")
    ap.add_argument("--temps", default="-40,27,125")
    ap.add_argument("--vdds", default="1.62,1.8,1.98")
    a = ap.parse_args()

    repo = Path(a.repo).resolve(); a.repo_abs = repo
    deck = (repo / a.deck) if not Path(a.deck).is_absolute() else Path(a.deck)
    if not deck.exists():
        sys.exit(f"Deck not found: {deck}")
    lines = P.read_deck(deck)
    lib = find_lib(lines)
    work = repo / "results" / "pvt_block6_biasgen"; work.mkdir(parents=True, exist_ok=True)
    a.startup_cases = [("tt", "27", "1.8"), ("ss", "-40", "1.62"), ("ff", "125", "1.98"), ("fs", "-40", "1.98")]
    {"calib": cmd_calib, "res": cmd_res, "opmap": cmd_opmap, "startup": cmd_startup}[a.cmd](a, lines, deck, lib, work)


if __name__ == "__main__":
    main()
