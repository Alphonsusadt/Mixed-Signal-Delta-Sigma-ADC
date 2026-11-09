#!/usr/bin/env python3
"""F5 comparator-clock chain over PVT, with the resistor-reference bias generator (pure ngspice, no closed loop).

Same circuit as tools/f5_clkcmp_delay.py (B6_NONOV -> real switch load, clk_cmp = phi2b -> N x B6_INV), but:
  * corner / temperature / VDD are swept (default 5 x 3 x 3 = 45 points),
  * VBN/VBP come from the generator (--bias res: R + tc1/tc2, NMOS diode + mirror + PMOS diode), or ideal (--bias ideal),
  * measurement thresholds scale with VDD (10/50/90 %).
Prints per point: delay phi2-fall -> clk-rise, clk high time, clk-rise -> phi1-rise, edge times, clk levels,
and whether the comparator clock rises inside the non-overlap gap (after phi2 falls, before phi1 rises).
The load on clk is a PLACEHOLDER (--cload), not the extracted StrongARM capacitance. Status: MEASURED_NOT_FINAL.
Margins are reported, not judged: the acceptance criterion is written separately.

Run from top_level/closed_loop:
  python3 tools/f5_clkcmp_pvt.py --run
  python3 tools/f5_clkcmp_pvt.py --run --corners tt,ss --temps=-40,125 --vdds 1.62,1.98 --jobs 2
"""
import argparse, csv, itertools, os, re, subprocess, sys, concurrent.futures as cf

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import f5_clkcmp_delay as F

PN = "nf=1 ad=0.145 as=0.145 pd=1.58 ps=1.58 nrd=0.58 nrs=0.58 sa=0 sb=0 sd=0 mult=1"
PP = "nf=1 ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29 sa=0 sb=0 sd=0 mult=1"


def bias_text(a):
    if a.bias == "ideal":
        return f"VBN vbn 0 {a.vbn}\nVBP vbp 0 {a.vbp}\n"
    return (f"RB1 vdd vbn {a.rbias:.6e} tc1=-1.47e-3 tc2=2.7e-6\n"
            f"XBN1 vbn vbn 0 0 sky130_fd_pr__nfet_01v8 L=1 W=0.5 {PN}\n"
            f"XBN2 vbp vbn 0 0 sky130_fd_pr__nfet_01v8 L=1 W=0.5 {PN}\n"
            f"XBP1 vbp vbp vdd vdd sky130_fd_pr__pfet_01v8 L=1 W=1 {PP}\n")


def deck(a, n, corner, temp, vdd):
    po = F.pins(a.b6, "B6_NONOV"); pi = F.pins(a.b6, "B6_INV")
    mp = dict(clk="clkm", phi1="phi1", phi1b="phi1b", phi2="phi2", phi2b="phi2b", vdd="vdd", gnd="0", vbp="vbp", vbn="vbn")
    chain, prev = "", "phi2b"
    for k in range(1, n + 1):
        nxt = "clkc" if k == n else f"c{k}"
        chain += f"XI{k} " + F.conn(pi, {"in": prev, "out": nxt, "vdd": "vdd", "gnd": "0"}, "B6_INV") + " B6_INV\n"
        prev = nxt
    v = float(vdd); h, lo, hi = v / 2, 0.1 * v, 0.9 * v
    load = F.REALLOAD.replace("Vm vm 0 0.9", f"Vm vm 0 {h:g}")
    return f""".option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp {temp}
.lib {a.pdk} {corner}
.include {os.path.abspath(a.b6)}
* F5 PVT N={n}: clk_cmp = phi2b -> {n} x B6_INV. Load on clk {a.cload} = PLACEHOLDER. bias = {a.bias}
VDD vdd 0 {vdd}
{bias_text(a)}VCLKM clkm 0 PULSE({vdd} 0 15.6n 1n 1n 124n 250n)
XNONOV {F.conn(po, mp, "B6_NONOV")} B6_NONOV
{load}{chain}CL clkc 0 {a.cload}
.control
tran 0.1n 2u 0 0.1n
echo ===== F5_MEAS =====
meas tran D_P2F_CLKR TRIG v(phi2) VAL={h:g} FALL=1 TD=500n TARG v(clkc) VAL={h:g} RISE=1 TD=500n
meas tran D_P2R_CLKF TRIG v(phi2) VAL={h:g} RISE=1 TD=500n TARG v(clkc) VAL={h:g} FALL=1 TD=500n
meas tran CLK_HIGH TRIG v(clkc) VAL={h:g} RISE=1 TD=500n TARG v(clkc) VAL={h:g} FALL=1 TD=500n
meas tran CLKR_TO_P1R TRIG v(clkc) VAL={h:g} RISE=1 TD=500n TARG v(phi1) VAL={h:g} RISE=1 TD=500n
meas tran TR_CLK TRIG v(clkc) VAL={lo:g} RISE=1 TD=500n TARG v(clkc) VAL={hi:g} RISE=1 TD=500n
meas tran TF_CLK TRIG v(clkc) VAL={hi:g} FALL=1 TD=500n TARG v(clkc) VAL={lo:g} FALL=1 TD=500n
meas tran CLK_MAX MAX v(clkc) FROM=500n TO=1.5u
meas tran CLK_MIN MIN v(clkc) FROM=500n TO=1.5u
echo F5_DONE
.endc
.end
"""


def run_one(a, n, case):
    corner, temp, vdd = case
    tag = f"n{n}_{corner}_T{temp}_V{vdd}".replace("-", "m").replace(".", "p")
    cir = os.path.join(a.out, tag + ".cir"); log = tag + ".log"
    open(cir, "w").write(deck(a, n, corner, temp, vdd))
    try:
        subprocess.run([a.ngspice, "-b", "-o", log, tag + ".cir"], cwd=a.out, capture_output=True, text=True, timeout=a.timeout)
    except subprocess.TimeoutExpired:
        return dict(n=n, corner=corner, temp=temp, vdd=vdd, status="TIMEOUT")
    txt = open(os.path.join(a.out, log), errors="replace").read() if os.path.exists(os.path.join(a.out, log)) else ""
    v = {m.group(1).lower(): float(m.group(2)) for m in re.finditer(r"^(\w+)\s+=\s+([-+0-9.eE]+)", txt, re.M)}
    r = dict(n=n, corner=corner, temp=temp, vdd=vdd, status="MEASURED_NOT_FINAL" if ("F5_DONE" in txt and "d_p2f_clkr" in v and "clkr_to_p1r" in v) else "FAIL")
    for k in ("d_p2f_clkr", "d_p2r_clkf", "clk_high", "clkr_to_p1r", "tr_clk", "tf_clk", "clk_max", "clk_min"):
        r[k] = v.get(k)
    return r


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--b6", default=os.path.join(ROOT, "spice", "b6_nonov.spice"))
    ap.add_argument("--pdk", default="/foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice")
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--n", type=int, nargs="+", default=[2])
    ap.add_argument("--bias", choices=["res", "ideal"], default="res")
    ap.add_argument("--rbias", type=float, default=1.247933e6)
    ap.add_argument("--vbn", type=float, default=0.70)
    ap.add_argument("--vbp", type=float, default=0.71)
    ap.add_argument("--cload", default="20f", help="PLACEHOLDER clk load")
    ap.add_argument("--corners", default="tt,ss,ff,sf,fs")
    ap.add_argument("--temps", default="-40,27,125")
    ap.add_argument("--vdds", default="1.62,1.8,1.98")
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--timeout", type=int, default=900)
    ap.add_argument("--out", default=os.path.join(ROOT, "results", "f5_clkcmp_pvt"))
    ap.add_argument("--run", action="store_true")
    a = ap.parse_args()
    for n in a.n:
        if n % 2: sys.exit("N must be even")
    os.makedirs(a.out, exist_ok=True)
    cases = list(itertools.product(a.corners.split(","), a.temps.split(","), a.vdds.split(",")))
    jobs = [(n, c) for n in a.n for c in cases]
    if not a.run:
        for n, c in jobs[:1]:
            print(deck(a, n, *c)[:600], "...\n(add --run to simulate", len(jobs), "points)")
        return
    print(f"{len(jobs)} points, bias={a.bias}, cload={a.cload}, out={a.out}", flush=True)
    with cf.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        rows = list(ex.map(lambda j: run_one(a, j[0], j[1]), jobs))
    g = lambda r, k, s=1e9: ("%.2f" % (r[k] * s)) if r.get(k) is not None else "MISSING"
    print("\nN corner T(C)  VDD | phi2 fall->clk rise | clk high | clk rise->phi1 rise | tr/tf clk (ns) | clk max/min (V) | rise in gap?")
    ok = []
    for r in rows:
        if r["status"] != "MEASURED_NOT_FINAL":
            print(f"{r['n']} {r['corner']:>4s} {r['temp']:>5s} {r['vdd']:>5s} | {r['status']}"); continue
        ingap = r["d_p2f_clkr"] > 0 and r["clkr_to_p1r"] > 0
        ok.append(r)
        print(f"{r['n']} {r['corner']:>4s} {r['temp']:>5s} {r['vdd']:>5s} | {g(r,'d_p2f_clkr'):>8s} | {g(r,'clk_high'):>8s} | {g(r,'clkr_to_p1r'):>8s} | "
              f"{g(r,'tr_clk')}/{g(r,'tf_clk')} | {r['clk_max']:.2f}/{r['clk_min']:.3f} | {'yes' if ingap else 'NO'}")
    if ok:
        for k, nm in (("d_p2f_clkr", "phi2 fall -> clk rise"), ("clkr_to_p1r", "clk rise -> phi1 rise"), ("clk_high", "clk high")):
            x = [r[k] * 1e9 for r in ok]
            print(f"{nm}: {min(x):.2f} .. {max(x):.2f} ns over {len(ok)}/{len(rows)} valid points")
    with open(os.path.join(a.out, "f5_pvt_summary.csv"), "w", newline="") as fh:
        cols = ["n", "corner", "temp", "vdd", "status", "d_p2f_clkr", "d_p2r_clkf", "clk_high", "clkr_to_p1r", "tr_clk", "tf_clk", "clk_max", "clk_min"]
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); w.writeheader(); w.writerows(rows)
    print("csv :", os.path.join(a.out, "f5_pvt_summary.csv"))
    print("STATUS: MEASURED_NOT_FINAL where valid; pre-layout; clk load is a placeholder; no acceptance criterion applied.")


if __name__ == "__main__":
    main()
