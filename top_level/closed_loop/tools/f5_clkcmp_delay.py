#!/usr/bin/env python3
"""F5 (langkah 1): ukur tunda rantai inverter B6_INV yang menurunkan clk komparator dari phi2b.
clk_cmp = phi2b -> N x B6_INV (N genap, tidak membalik).  clk naik = phi2 turun + tunda.
Hanya ngspice murni (tanpa xschem); memakai spice/b6_nonov.spice hasil extract_b6_subckts.py.
STATUS: pra-layout, TT 1.8 V 27 C. Beban clk = PLACEHOLDER (--cload), bukan kapasitansi StrongARM terekstraksi.
Pemakaian (dari top_level/closed_loop):  python3 tools/f5_clkcmp_delay.py --run
"""
import argparse, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

def pins(path, sub):
    for ln in open(path, errors="replace"):
        t = ln.split()
        if len(t) > 2 and t[0].lower() == ".subckt" and t[1].lower() == sub.lower():
            return [x.lower() for x in t[2:] if "=" not in x]
    sys.exit(f"subckt {sub} tidak ada di {path}")

def conn(order, mp, sub):
    miss = [p for p in order if p not in mp]
    if miss: sys.exit(f"pin {sub} tak dikenal: {miss} (pin netlist: {order})")
    return " ".join(mp[p] for p in order)

REALLOAD = "Vm vm 0 0.9\n" + "".join(
    f"XLN{i}A vm phi{i} vm 0 sky130_fd_pr__nfet_01v8_lvt W=4 L=0.15 nf=1 mult=1 m=16\n"
    f"XLN{i}B vm phi{i} vm 0 sky130_fd_pr__nfet_01v8 W=2 L=0.15 nf=1 mult=1 m=8\n"
    f"XLP{i}A vm phi{i}b vm vdd sky130_fd_pr__pfet_01v8_lvt W=8 L=0.35 nf=1 mult=1 m=16\n"
    f"XLP{i}B vm phi{i}b vm vdd sky130_fd_pr__pfet_01v8 W=4 L=0.15 nf=1 mult=1 m=8\n" for i in (1, 2))

def deck(a, n):
    po = pins(a.b6, "B6_NONOV"); pi = pins(a.b6, "B6_INV")
    mp = dict(clk="clkm", phi1="phi1", phi1b="phi1b", phi2="phi2", phi2b="phi2b", vdd="vdd", gnd="0", vbp="vbp", vbn="vbn")
    chain, prev = "", "phi2b"
    for k in range(1, n + 1):
        nxt = "clkc" if k == n else f"c{k}"
        chain += f"XI{k} " + conn(pi, dict(**{"in": prev, "out": nxt, "vdd": "vdd", "gnd": "0"}), "B6_INV") + " B6_INV\n"
        prev = nxt
    return f""".option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
.lib {a.pdk} tt
.include {os.path.abspath(a.b6)}
* F5 N={n}: clk_cmp = phi2b -> {n} x B6_INV. Beban clk {a.cload} = PLACEHOLDER.
VDD vdd 0 1.8
VBN vbn 0 {a.vbn}
VBP vbp 0 {a.vbp}
VCLKM clkm 0 PULSE(1.8 0 15.6n 1n 1n 124n 250n)
XNONOV {conn(po, mp, "B6_NONOV")} B6_NONOV
{REALLOAD}{chain}CL clkc 0 {a.cload}
.control
set wr_singlescale
set numdgt=12
tran 0.1n 2u 0 0.1n
wrdata f5_n{n}.dat v(clkm) v(phi1) v(phi2) v(phi2b) v(clkc)
echo ===== F5_MEAS N={n} =====
meas tran D_P2F_CLKR TRIG v(phi2) VAL=0.9 FALL=1 TD=500n TARG v(clkc) VAL=0.9 RISE=1 TD=500n
meas tran D_P2R_CLKF TRIG v(phi2) VAL=0.9 RISE=1 TD=500n TARG v(clkc) VAL=0.9 FALL=1 TD=500n
meas tran CLK_HIGH TRIG v(clkc) VAL=0.9 RISE=1 TD=500n TARG v(clkc) VAL=0.9 FALL=1 TD=500n
meas tran CLKR_TO_P1R TRIG v(clkc) VAL=0.9 RISE=1 TD=500n TARG v(phi1) VAL=0.9 RISE=1 TD=500n
meas tran TR_CLK TRIG v(clkc) VAL=0.18 RISE=1 TD=500n TARG v(clkc) VAL=1.62 RISE=1 TD=500n
meas tran TF_CLK TRIG v(clkc) VAL=1.62 FALL=1 TD=500n TARG v(clkc) VAL=0.18 FALL=1 TD=500n
meas tran CLK_MAX MAX v(clkc) FROM=500n TO=1.5u
meas tran CLK_MIN MIN v(clkc) FROM=500n TO=1.5u
echo F5_DONE
.endc
.end
"""

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--b6", default=os.path.join(ROOT, "spice", "b6_nonov.spice"))
    ap.add_argument("--pdk", default="/foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice")
    ap.add_argument("--n", type=int, nargs="+", default=[2, 4, 6, 8, 10, 12, 16, 20, 24])
    ap.add_argument("--vbn", type=float, default=0.70)
    ap.add_argument("--vbp", type=float, default=0.71)
    ap.add_argument("--cload", default="20f", help="PLACEHOLDER beban clk (bukan StrongARM terekstraksi)")
    ap.add_argument("--out", default=os.path.join(ROOT, "results", "f5_clkcmp"))
    ap.add_argument("--run", action="store_true")
    a = ap.parse_args()
    for n in a.n:
        if n % 2: sys.exit("N harus genap (rantai tidak boleh membalik)")
    os.makedirs(a.out, exist_ok=True)
    rows = []
    for n in a.n:
        p = os.path.join(a.out, f"f5_n{n}.cir"); open(p, "w").write(deck(a, n))
        if not a.run:
            print("deck:", p); continue
        r = subprocess.run(["ngspice", "-b", "-o", f"f5_n{n}.log", f"f5_n{n}.cir"], cwd=a.out, capture_output=True, text=True)
        log = open(os.path.join(a.out, f"f5_n{n}.log"), errors="replace").read()
        v = {m.group(1).lower(): float(m.group(2)) for m in re.finditer(r"^(\w+)\s+=\s+([-+0-9.eE]+)", log, re.M)}
        rows.append((n, r.returncode, "F5_DONE" in log or "F5_DONE" in r.stdout, v))
    if a.run:
        print("N | rc | DONE | phi2 turun->clk naik (ns) | phi2 naik->clk turun (ns) | lebar clk (ns) | clk naik->phi1 naik (ns) | tr/tf clk (ns) | clk max/min (V)")
        for n, rc, done, v in rows:
            g = lambda k, s=1e9: ("%.2f" % (v[k] * s)) if k in v else "MISSING"
            print(n, rc, done, g("d_p2f_clkr"), g("d_p2r_clkf"), g("clk_high"), g("clkr_to_p1r"),
                  g("tr_clk") + "/" + g("tf_clk"), ("%.2f/%.2f" % (v["clk_max"], v["clk_min"])) if "clk_max" in v else "MISSING")
        print("STATUS: MEASURED_NOT_FINAL bila semua DONE; pra-layout; beban clk placeholder. rc 0 bukan PASS.")

if __name__ == "__main__":
    main()
