#!/usr/bin/env python3
"""run_tahap6.py - tahap 6: AC OTA, Cc (MF) 80 vs 100 dan bias loop vs bias Block 1.

Subperintah:
  netlist   xschem -> netlist untuk 6A..6D   (butuh xschem)
  sim       ngspice -b tiap netlist          (butuh ngspice + PDK)
  analyze   tabel A0/UGF/PM vs baseline 6A dan vs laporan Block 1
  selftest  uji parser dengan log sintetis (tanpa xschem/ngspice)
Status: NOT_RUN sampai dijalankan; hasil terukur = MEASURED_NOT_FINAL. Tidak ada kriteria PASS.
"""
import argparse, os, re, shutil, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SIMDIR = os.path.join("blocks", "01_OTA", "sim")
NAMES = ["6A_MF80_base", "6B_MF100", "6C_bias058", "6D_vbz18"]
NOTE = {"6A_MF80_base": "baseline (MF=80, Vbias 0.507621, Vbz 1.5)",
        "6B_MF100": "hanya Cc: MF=100", "6C_bias058": "hanya Vbias=0.58", "6D_vbz18": "hanya Vbz=1.8"}
REF = dict(a0=69.34, ugf=3.15312e6, pm=61.3704)      # laporan Block 1 (TT/1.8V/27C, MF=80)

KEYS = {"a0": "a0", "g_100k": "g_100k", "g_1m": "g_1m", "ugf": "ugf", "pm": "phase_ugf",
        "vout_p": r"v\(vout_p\)", "vout_n": r"v\(vout_n\)", "vbias": r"v\(vbias\)"}


def parse_log(text):
    res = {}
    for k, pat in KEYS.items():
        ms = re.findall(r"^\s*" + pat + r"\s*=\s*([-+]?[0-9.]+(?:[eE][-+]?[0-9]+)?)", text, flags=re.I | re.M)
        if ms:
            res[k] = float(ms[-1])
    if "pm" in res:                      # phase_ugf = fase(-Av) pada UGF; PM = 180 + fase
        res["pm"] = 180.0 + res["pm"]
    res["done"] = "TB_6_DONE" in text
    res["errors"] = [l for l in text.splitlines() if re.search(r"\bError\b|fatal|singular matrix|no convergence", l, re.I)]
    return res


def do_netlist(a):
    if shutil.which(a.xschem) is None:
        print(f"NOT_RUN: xschem '{a.xschem}' tidak ditemukan"); return 3
    out = os.path.abspath(a.out); os.makedirs(os.path.join(out, "netlist"), exist_ok=True)
    rc = 0
    for n in NAMES:
        sch = os.path.join(os.path.abspath(a.repo), SIMDIR, f"tb_{n}.sch")
        if not os.path.exists(sch):
            print(f"NETLIST_FAILED: {sch} tidak ada"); rc = 4; continue
        cmd = [a.xschem, "-x", "-n", "-q", "-o", os.path.join(out, "netlist"), "-N", f"tb_{n}.spice", sch]
        print("jalankan:", " ".join(cmd))
        r = subprocess.run(cmd, cwd=os.path.abspath(a.repo))
        sp = os.path.join(out, "netlist", f"tb_{n}.spice")
        ok = os.path.exists(sp) and os.path.getsize(sp) > 0
        print(f"  exit={r.returncode} netlist={'ada' if ok else 'TIDAK ADA'} -> {sp}")
        if not ok:
            rc = 4
    return rc


def do_sim(a):
    if shutil.which(a.ngspice) is None:
        print(f"NOT_RUN: ngspice '{a.ngspice}' tidak ditemukan"); return 3
    out = os.path.abspath(a.out); rc = 0
    for n in NAMES:
        sp = os.path.join(out, "netlist", f"tb_{n}.spice")
        if not os.path.exists(sp):
            print(f"NOT_RUN: {sp} belum ada (jalankan netlist dulu)"); rc = 3; continue
        log = os.path.join(out, f"tb_{n}.log")
        r = subprocess.run([a.ngspice, "-b", "-o", log, sp], cwd=out)
        p = parse_log(open(log, errors="replace").read()) if os.path.exists(log) else {"done": False, "errors": ["log tidak ada"]}
        ok = r.returncode == 0 and p["done"] and not p["errors"]
        print(f"{n}: exit={r.returncode} marker={p['done']} error={p['errors'][:1] or '-'} -> {'MEASURED_NOT_FINAL' if ok else 'SIMULATION_FAILED'}")
        if not ok:
            rc = 4
    return rc


def table(results):
    base = results.get("6A_MF80_base")
    print(f"{'exp':14s} {'A0 dB':>8s} {'UGF MHz':>9s} {'PM deg':>8s} {'G@100k':>8s} {'G@1M':>8s} {'Vout_p':>7s} {'Vout_n':>7s}   perubahan terhadap 6A")
    for n in NAMES:
        r = results.get(n)
        if not r or "a0" not in r:
            print(f"{n:14s} NOT_RUN / tidak ada hasil"); continue
        d = ""
        if base and n != "6A_MF80_base" and "a0" in base:
            d = (f"dA0={r['a0']-base['a0']:+.2f} dB  dUGF={100*(r['ugf']/base['ugf']-1):+.1f}%  "
                 f"dPM={r['pm']-base['pm']:+.2f} deg")
        print(f"{n:14s} {r['a0']:8.2f} {r['ugf']/1e6:9.4f} {r['pm']:8.2f} {r.get('g_100k', float('nan')):8.2f} "
              f"{r.get('g_1m', float('nan')):8.2f} {r.get('vout_p', float('nan')):7.3f} {r.get('vout_n', float('nan')):7.3f}   {d}")


def do_analyze(a):
    out = os.path.abspath(a.out); results = {}; failed = {}
    for n in NAMES:
        log = os.path.join(out, f"tb_{n}.log")
        if os.path.exists(log):
            p = parse_log(open(log, errors="replace").read())
            if p["done"] and not p["errors"]:
                results[n] = p
            else:
                failed[n] = p
    for n, p in failed.items():
        vp = p.get("vout_p"); vn = p.get("vout_n")
        print(f"{n}: SIMULATION_FAILED  (marker={p['done']}, error={p['errors'][:1]})")
        if vp is not None:
            print(f"    OP: Vout_p={vp:.3f} V, Vout_n={vn:.3f} V, A0={p.get('a0', float('nan')):.2f} dB")
            if vp > 1.6 or vp < 0.2:
                print("    -> keluaran menempel di rail pada titik DC: OTA di luar daerah kerja pada harness ini "
                      "(CM keluaran tidak diregulasi oleh Vcmfb1 tetap). Ini batas HARNESS, bukan sifat OTA terkarakterisasi.")
    table(results)
    b = results.get("6A_MF80_base")
    if b and "a0" in b:
        ok = abs(b["a0"] - REF["a0"]) < 0.05 and abs(b["ugf"] / REF["ugf"] - 1) < 0.005 and abs(b["pm"] - REF["pm"]) < 0.1
        print(f"\nBaseline 6A vs laporan Block 1 (A0 {REF['a0']} dB, UGF {REF['ugf']/1e6:.4f} MHz, PM = 180 + phase_ugf = {REF['pm']} deg): "
              f"{'REPRODUKSI COCOK (toleransi 0.05 dB / 0.5% / 0.1 deg)' if ok else 'TIDAK COCOK - periksa bias/testbench sebelum membaca 6B..6D'}")
    r = results.get("6B_MF100")
    if b and r:
        print(f"Hipotesis (BUKAN fakta): UGF ~ 1/Cc -> rasio MF 80/100 memperkirakan dUGF = {100*(80/100-1):+.0f}%; terukur {100*(r['ugf']/b['ugf']-1):+.1f}%.")
    print("\nStatus: MEASURED_NOT_FINAL. Lingkup: OTA berdiri sendiri, CMFB ideal (Vcmfb1 tetap 0.9 V), beban 20 pF per sisi, TT/27C. "
          "Belum mencakup SC-CMFB loop, beban sebenarnya (sampling cap), atau PVT.")
    return 0


SYN = """Doing analysis
v(vbias) = 5.07621e-01
v(vout_p) = 8.99e-01
v(vout_n) = 9.01e-01
a0                  =  6.934000e+01
g_100k              =  5.1e+01
g_1m                =  2.2e+01
ugf                 =  3.153120e+06
phase_ugf           = -1.186296e+02
TB_6_DONE
"""


def do_selftest(a):
    p = parse_log(SYN)
    ok = (abs(p["a0"] - 69.34) < 1e-9 and abs(p["ugf"] - 3153120) < 1 and abs(p["pm"] - 61.3704) < 1e-6
          and p["done"] and not p["errors"] and abs(p["vout_p"] - 0.899) < 1e-9)
    bad = parse_log("Error: no such vector\nTB_6_DONE\n")
    ok = ok and bool(bad["errors"])
    table({"6A_MF80_base": p, "6B_MF100": dict(p, ugf=2.52e6, pm=58.0, a0=69.5)})
    print("selftest:", "OK" if ok else "GAGAL")
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["netlist", "sim", "analyze", "selftest"])
    ap.add_argument("--repo", default=".")
    ap.add_argument("--out", default=os.path.join("results", "tahap6"))
    ap.add_argument("--xschem", default="xschem")
    ap.add_argument("--ngspice", default="ngspice")
    a = ap.parse_args()
    sys.exit({"netlist": do_netlist, "sim": do_sim, "analyze": do_analyze, "selftest": do_selftest}[a.cmd](a))


if __name__ == "__main__":
    main()
