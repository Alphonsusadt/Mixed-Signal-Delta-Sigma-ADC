#!/usr/bin/env python3
"""run_block6.py - netlist / sim / analyze testbench Blok 6 (pola run_tahap6.py).
  netlist   xschem -> blocks/06_Clock_gen/sim/out/netlist/<tb>.spice   (butuh xschem)
  sim       ngspice -b per netlist, log + .dat di sim/out/               (butuh ngspice + PDK)
  analyze   tabel hasil dari log (status: NOT_RUN / SIMULATION_FAILED / MEASURE_MISSING / MEASURED_NOT_FINAL /
            SIMULATED_NOT_FINAL_PASS / CHECK_FAILED). Skrip ini TIDAK PERNAH menulis PASS.
  selftest  uji parser dengan log sintetis (tanpa xschem/ngspice)
Jalankan dari root repo:  python3 tools/run_block6.py netlist|sim|analyze|selftest
"""
import argparse, glob, os, re, shutil, subprocess, sys

SIM = os.path.join("blocks", "06_Clock_gen", "sim")

def tbs(repo):
    return sorted(os.path.basename(p)[:-4] for p in glob.glob(os.path.join(repo, SIM, "tb_6*.sch")))

def parse_log(text):
    m = {}
    for ln in text.splitlines():
        r = re.match(r"^\s*([A-Za-z_]\w*)\s*=\s*([-+]?\d+\.?\d*(?:[eE][-+]?\d+)?)", ln)
        if r: m[r.group(1).lower()] = float(r.group(2))
    return m, ("TB6_DONE" in text)

def do_netlist(a):
    if shutil.which(a.xschem) is None: print(f"NOT_RUN: xschem '{a.xschem}' tidak ditemukan"); return 3
    out = os.path.join(a.repo, SIM, "out"); os.makedirs(os.path.join(out, "netlist"), exist_ok=True); rc = 0
    for n in tbs(a.repo):
        sch = os.path.join(SIM, n + ".sch")
        cmd = [a.xschem, "-x", "-n", "-q", "-o", os.path.join(out, "netlist"), "-N", n + ".spice", sch]
        r = subprocess.run(cmd, cwd=os.path.abspath(a.repo)); print(n, "netlist rc", r.returncode); rc |= r.returncode
    return rc

def do_sim(a):
    if shutil.which(a.ngspice) is None: print(f"NOT_RUN: ngspice '{a.ngspice}' tidak ditemukan"); return 3
    out = os.path.join(a.repo, SIM, "out"); rc = 0
    for n in tbs(a.repo):
        sp = os.path.join("netlist", n + ".spice")
        if not os.path.exists(os.path.join(out, sp)): print(n, "NOT_RUN: netlist belum ada"); continue
        log = n + ".log"
        r = subprocess.run([a.ngspice, "-b", "-o", log, sp], cwd=out); print(n, "ngspice rc", r.returncode, "(rc bukan bukti desain lulus)")
        rc |= r.returncode
    return rc

def ns(x): return f"{x*1e9:8.3f} ns"

def row_status(n, m, done, log_exists):
    if not log_exists: return "NOT_RUN", {}
    if not done: return "SIMULATION_FAILED", {}
    return None, m

def do_analyze(a):
    out = os.path.join(a.repo, SIM, "out"); lines = []
    for n in tbs(a.repo):
        lp = os.path.join(out, n + ".log")
        text = open(lp, errors="replace").read() if os.path.exists(lp) else ""
        m, done = parse_log(text)
        st, m = row_status(n, m, done, bool(text))
        if st: lines.append(f"{n:28s} {st}"); continue
        if n.startswith("tb_6C"):
            exp = {"00": (0, 0), "10": (1, 0), "01": (1, 0), "11": (0, 1)}
            bad = []
            for k, (x, an) in exp.items():
                for nm, e in ((f"xor_{k}", x), (f"and_{k}", an)):
                    v = m.get(nm)
                    if v is None or (e == 1 and v < 1.7) or (e == 0 and v > 0.1): bad.append(nm)
            lines.append(f"{n:28s} " + ("SIMULATED_NOT_FINAL_PASS (tabel kebenaran sesuai)" if not bad else "CHECK_FAILED: " + ",".join(bad)))
        elif n.startswith("tb_6B"):
            tr, tf = m.get("td_r"), m.get("td_f")
            if tr is None or tf is None: lines.append(f"{n:28s} MEASURE_MISSING (tidak ada crossing; td di luar jendela)"); continue
            lines.append(f"{n:28s} MEASURED_NOT_FINAL  td_r{ns(tr)}  td_f{ns(tf)}  Iavg {m.get('ivdd_avg', float('nan'))*1e6:8.3f} uA")
        else:
            keys = ["dt_1f2r","dt_2f1r","w_phi1","w_phi2","skew_p1r","skew_p1f","skew_p2r","skew_p2f","tr_phi1","tf_phi1","tr_phi2","tf_phi2"]
            miss = [k for k in keys if k not in m]
            if miss: lines.append(f"{n:28s} MEASURE_MISSING: {','.join(miss)}"); continue
            lines.append(f"{n:28s} MEASURED_NOT_FINAL")
            for k in keys: lines.append(f"    {k:10s}{ns(m[k])}")
            for k in ("tr_phi1b","tf_phi1b","tr_phi2b","tf_phi2b"):
                if k in m: lines.append(f"    {k:10s}{ns(m[k])}")
            lines.append(f"    ovl_prod  {m.get('ovl_prod', float('nan')):8.4f} V^2 (diagnostik, tanpa batas)")
            lines.append(f"    phi1 min/max {m.get('phi1_min',float('nan')):.3f}/{m.get('phi1_max',float('nan')):.3f} V ; phi2 min/max {m.get('phi2_min',float('nan')):.3f}/{m.get('phi2_max',float('nan')):.3f} V")
            lines.append("    Catatan: lebar dan jeda dibandingkan dengan 110 ns / 15 ns hanya sebagai referensi loop, bukan batas lulus.")
    print("\n".join(lines)); open(os.path.join(a.repo, SIM, "out", "summary_block6.txt"), "w").write("\n".join(lines) + "\n") if os.path.isdir(out) else None
    return 0

def do_selftest(a):
    log = "x\n===== TB6_MEAS =====\ntd_r                =  1.5e-08 targ= 1 trig= 2\ntd_f = 1.4e-08\nivdd_avg = -1.0e-06\nTB6_DONE\n"
    m, d = parse_log(log); assert d and abs(m["td_r"] - 1.5e-8) < 1e-12 and abs(m["ivdd_avg"] + 1e-6) < 1e-15
    m, d = parse_log("nothing"); assert not d and m == {}
    print("selftest OK (parser)"); return 0

def main():
    ap = argparse.ArgumentParser(); ap.add_argument("cmd", choices=["netlist","sim","analyze","selftest"])
    ap.add_argument("--repo", default="."); ap.add_argument("--xschem", default="xschem"); ap.add_argument("--ngspice", default="ngspice")
    a = ap.parse_args(); sys.exit({"netlist":do_netlist,"sim":do_sim,"analyze":do_analyze,"selftest":do_selftest}[a.cmd](a))
if __name__ == "__main__": main()
