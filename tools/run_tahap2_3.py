#!/usr/bin/env python3
"""
run_tahap2_3.py - runner dan analisis untuk tahap 2 (hold error Block 5) dan
tahap 3 (kapasitansi MIM).

Subperintah:
  netlist        xschem -> netlist .spice untuk tiap testbench
  sim            ngspice -b untuk tiap netlist
  analyze-hold   tabel pedestal/feedthrough/drift dari tb_5F_*.dat
  analyze-mim    tabel kapasitansi dan N_eff dari tb_MIM_C_AC.dat
  analyze-aperture  E7: bagian langkah input yang tertangkap vs waktu langkah
  analyze-level     E8: pedestal vs level sinyal (fit linear/kuadrat)
  selftest       uji jalur analisis dengan data sintetis (tanpa xschem/ngspice)

STATUS: skrip ini belum pernah dijalankan dengan Xschem/ngspice nyata (sandbox
pembuat tidak punya keduanya). Yang sudah dijalankan: selftest. Status hasil memakai
label dossier: NOT_RUN, NETLIST_FAILED, SIMULATION_FAILED, MEASURED_NOT_FINAL.
Tidak ada PASS/FAIL: belum ada batas numerik penerimaan yang disepakati.
"""
import argparse
import os
import re
import shutil
import subprocess
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

HOLD_TBS = ["E1_baseline", "E2_input_frozen", "E3_step_late", "E4_ch_2p", "E5_edge_5n", "E6_standardVt"]
sys.path.insert(0, HERE)
from make_tb import APERTURE_DELTAS, LEVELS   # noqa: E402  (satu sumber kebenaran untuk stimulus E7/E8)

HOLD_EXTRA = ["E7_aperture", "E8_level_sweep"]
HOLD_DIR = os.path.join("blocks", "05_Switch_Network", "sim")
MIM_TB = ("tb_MIM_C_AC", os.path.join("blocks", "01_OTA", "sim"))

# langkah input di dalam HOLD per eksperimen (ns); kosong = input diam selama HOLD
HOLD_STEPS = {
    "E1_baseline": [160, 410], "E2_input_frozen": [], "E3_step_late": [240, 490],
    "E4_ch_2p": [160, 410], "E5_edge_5n": [160, 410], "E6_standardVt": [160, 410],
}
# referensi dari BLOCK5_XSCHEM_PYTHON_READINESS.md (smoke dinamis Anda; stimulusnya tidak saya miliki)
READINESS_REF = {130: (1.100, 0.700), 200: (1.10330, 0.69817), 350: (0.700, 1.100), 450: (0.724952, 1.08579)}


def read_wrdata(path):
    with open(path, errors="replace") as f:
        first = f.readline().split()
    names = [re.sub(r"^v\((.*)\)$", r"\1", t.lower()) for t in first]
    data = np.loadtxt(path, skiprows=1)
    return {n: data[:, i] for i, n in enumerate(names)}


# ---------------------------------------------------------------------------
# netlist / sim
# ---------------------------------------------------------------------------

ONLY = [None]   # diisi dari --only (substring nama testbench)


def tb_list(which):
    items = _tb_list(which)
    if ONLY[0]:
        items = [(n, d) for n, d in items if ONLY[0] in n]
    return items


def _tb_list(which):
    items = []
    if which in ("hold", "all"):
        items += [(f"tb_5F_{n}", HOLD_DIR) for n in HOLD_TBS + HOLD_EXTRA]
    if which in ("mim", "all"):
        items.append(MIM_TB)
    return items


def do_netlist(a):
    if shutil.which(a.xschem) is None:
        print(f"NOT_RUN: xschem '{a.xschem}' tidak ditemukan"); return 3
    out = os.path.abspath(a.out)
    os.makedirs(os.path.join(out, "netlist"), exist_ok=True)
    rc_all = 0
    for name, d in tb_list(a.which):
        sch = os.path.join(os.path.abspath(a.repo), d, f"{name}.sch")
        if not os.path.exists(sch):
            print(f"NETLIST_FAILED: {sch} tidak ada"); rc_all = 4; continue
        cmd = [a.xschem, "-x", "-n", "-q", "-o", os.path.join(out, "netlist"), "-N", f"{name}.spice", sch]
        print("jalankan:", " ".join(cmd))
        r = subprocess.run(cmd, cwd=os.path.abspath(a.repo))
        sp = os.path.join(out, "netlist", f"{name}.spice")
        ok = os.path.exists(sp) and os.path.getsize(sp) > 0
        # catatan Readiness: mode text-only dapat mengembalikan status 10 padahal netlist ada
        print(f"  exit={r.returncode}  netlist={'ada' if ok else 'TIDAK ADA'} -> {sp}")
        if not ok:
            rc_all = 4
    return rc_all


def do_sim(a):
    if shutil.which(a.ngspice) is None:
        print(f"NOT_RUN: ngspice '{a.ngspice}' tidak ditemukan"); return 3
    out = os.path.abspath(a.out)
    rc_all = 0
    for name, _ in tb_list(a.which):
        sp = os.path.join(out, "netlist", f"{name}.spice")
        if not os.path.exists(sp):
            print(f"NOT_RUN: {sp} belum ada (jalankan netlist dulu)"); rc_all = 3; continue
        log = os.path.join(out, f"{name}.log")
        cmd = [a.ngspice, "-b", "-o", log, sp]
        print("jalankan:", " ".join(cmd), "(cwd =", out, ")")
        r = subprocess.run(cmd, cwd=out)
        text = open(log, errors="replace").read() if os.path.exists(log) else ""
        errs = [l for l in text.splitlines() if re.search(r"\bError\b|fatal|singular matrix|no convergence", l, re.I)]
        done = ("TB_5F_DONE" in text) or ("TB_MIM_DONE" in text)
        status = "MEASURED_NOT_FINAL" if (r.returncode == 0 and done and not errs) else "SIMULATION_FAILED"
        print(f"  exit={r.returncode} selesai_marker={done} error_pertama={errs[0] if errs else '-'} -> {status}")
        if status != "MEASURED_NOT_FINAL":
            rc_all = 4
    return rc_all


# ---------------------------------------------------------------------------
# analisis hold
# ---------------------------------------------------------------------------

def at(t, y, t_ns):
    return float(np.interp(t_ns * 1e-9, t, y))


def hold_metrics(cols, steps):
    t = cols["time"]
    hp, hn = cols["hold_p"], cols["hold_n"]
    out = []
    for c in (1, 2):
        t0 = 250 * (c - 1)
        row = dict(cycle=c)
        for ch, h in (("P", hp), ("N", hn)):
            v_trk = at(t, h, t0 + 139)
            v_ped = at(t, h, t0 + 155)
            v_end = at(t, h, t0 + 270)
            row[f"{ch}_trk"] = v_trk
            row[f"{ch}_ped_mV"] = (v_ped - v_trk) * 1e3
            row[f"{ch}_hold_total_mV"] = (v_end - v_trk) * 1e3
            if steps:
                s = steps[c - 1]
                v_pre = at(t, h, s - 1)
                v_imm = at(t, h, s + 6)
                row[f"{ch}_step_imm_mV"] = (v_imm - v_pre) * 1e3
                row[f"{ch}_step_drift_mV"] = (v_end - v_imm) * 1e3
        out.append(row)
    return out


def do_analyze_hold(a):
    out = os.path.abspath(a.out)
    results = {}
    for n in HOLD_TBS:
        dat = os.path.join(out, f"tb_5F_{n}.dat")
        if not os.path.exists(dat):
            print(f"NOT_RUN: {dat} tidak ada"); continue
        cols = read_wrdata(dat)
        results[n] = hold_metrics(cols, HOLD_STEPS[n])
        if n == "E1_baseline":
            t = cols["time"]
            print("\n[E1] bandingkan dengan smoke dinamis di BLOCK5_XSCHEM_PYTHON_READINESS.md "
                  "(stimulus asli tidak saya miliki; selisih besar = stimulus berbeda, bukan rangkaian):")
            print("  t(ns)   HOLD_P   ref_P   dP(mV)   HOLD_N   ref_N   dN(mV)")
            for tt, (rp, rn) in READINESS_REF.items():
                p, nn = at(t, cols["hold_p"], tt), at(t, cols["hold_n"], tt)
                print(f"  {tt:5d}  {p:.5f}  {rp:.5f}  {(p-rp)*1e3:+7.2f}   {nn:.5f}  {rn:.5f}  {(nn-rn)*1e3:+7.2f}")
    if not results:
        print("MEASURED: tidak ada data."); return 3
    print("\nSemua nilai mV; ped = HOLD(t_off+13ns) - HOLD(t_off-2ns), step_imm = respons 6 ns setelah langkah input,")
    print("step_drift = perubahan dari situ sampai akhir HOLD. Status: MEASURED_NOT_FINAL (tidak ada batas penerimaan).\n")
    keys = ["P_trk", "P_ped_mV", "P_step_imm_mV", "P_step_drift_mV", "N_trk", "N_ped_mV", "N_step_imm_mV", "N_step_drift_mV"]
    print(f"{'exp':16s} cyc " + " ".join(f"{k:>15s}" for k in keys))
    for n, rows in results.items():
        for r in rows:
            vals = " ".join(f"{r[k]:15.3f}" if k in r else f"{'-':>15s}" for k in keys)
            print(f"{n:16s} {r['cycle']:3d} {vals}")
    if "E1_baseline" in results:
        print("\nRasio terhadap E1 (cycle 1, |nilai| pedestal dan step_imm; hipotesis 1/CH => E4/E1 ~ 0.5):")
        base = results["E1_baseline"][0]
        for n in results:
            if n == "E1_baseline":
                continue
            r = results[n][0]
            bits = []
            for k in ("P_ped_mV", "N_ped_mV", "P_step_imm_mV", "N_step_imm_mV"):
                if k in r and k in base and abs(base[k]) > 0.05:   # < 50 uV = derau numerik, rasio tak bermakna
                    bits.append(f"{k}: {r[k]/base[k]:6.2f}")
            print(f"  {n:16s} " + "  ".join(bits))
    print("\n(step_imm/step_drift di bawah 0.05 mV dianggap nol numerik; rasio tidak dicetak untuk nilai itu.)")
    return 0


# ---------------------------------------------------------------------------
# analisis MIM
# ---------------------------------------------------------------------------

def do_analyze_mim(a):
    dat = os.path.join(os.path.abspath(a.out), "tb_MIM_C_AC.dat")
    if not os.path.exists(dat):
        print(f"NOT_RUN: {dat} tidak ada"); return 3
    cols = read_wrdata(dat)
    f = cols["frequency"]
    i = int(np.argmin(np.abs(f - 1e6)))
    C = {k.replace("c_", "").upper(): float(v[i]) for k, v in cols.items() if k.startswith("c_")}
    print(f"f terdekat 1 MHz: {f[i]:.4g} Hz (baris {i})")
    ref = C.get("REF")
    print(f"\nKalibrasi metode: C_REF terukur {ref*1e15:.2f} fF (nilai ideal 1000 fF) -> "
          f"{'metode OK (<2%)' if ref and abs(ref/1e-12-1) < 0.02 else 'METODE TIDAK TERKALIBRASI, jangan pakai angka di bawah'}")
    unit = C.get("E")
    var = {"A": (100, 100), "B": (100, 1), "C": (1, 100), "D": (1000, 1), "E": (1, 1)}
    print("\nvarian        MF     m     C (fF)     N_eff = C/C(E)   cocok dengan")
    for k in ("E", "B", "C", "D", "A"):
        if k not in C:
            continue
        mf, m = var[k]
        n_eff = C[k] / unit if unit else float("nan")
        cands = {"MF x m": mf * m, "hanya MF": mf, "hanya m": m, "max(MF,m)": max(mf, m)}
        match = [nm for nm, v in cands.items() if abs(n_eff / v - 1) < 0.1]
        print(f"{k:8s}  {mf:7d} {m:5d}  {C[k]*1e15:10.2f}  {n_eff:14.2f}   {', '.join(match) or '(tidak ada yang cocok)'}")
    for k in ("SYM100", "SYM1000"):
        if k in C:
            print(f"simbol {k}: C = {C[k]*1e15:.2f} fF  (N_eff = {C[k]/unit:.1f}) -> bandingkan dengan varian A-E; "
                  f"lihat juga baris netlist 'XC_{k}' yang DIEMIT Xschem")
    print("\nStatus: MEASURED_NOT_FINAL. Pembacaan: bila A ~ 10000 maka MF dan m berlipat ganda (efektif MF x m).")
    return 0


# ---------------------------------------------------------------------------
# E7: aperture (waktu langkah input vs turn-off)
# ---------------------------------------------------------------------------

def aperture_metrics(cols):
    t = cols["time"]
    rows = []
    for k, d in enumerate(APERTURE_DELTAS):
        t_fall = 141 + 250 * k
        up_p = (k % 2 == 1)                       # P naik 0.7 -> 1.1 pada siklus ganjil
        vo_p, vn_p = (0.7, 1.1) if up_p else (1.1, 0.7)
        vo_n, vn_n = 1.8 - vo_p, 1.8 - vn_p
        hp, hn = at(t, cols["hold_p"], t_fall + 30), at(t, cols["hold_n"], t_fall + 30)
        rows.append(dict(k=k, delta=d, up_p=up_p,
                         dP_mV=(hp - vo_p) * 1e3, dN_mV=(hn - vo_n) * 1e3,
                         fP=(hp - vo_p) / (vn_p - vo_p), fN=(hn - vo_n) / (vn_n - vo_n)))
    return rows


def do_analyze_aperture(a):
    dat = os.path.join(os.path.abspath(a.out), "tb_5F_E7_aperture.dat")
    if not os.path.exists(dat):
        print(f"NOT_RUN: {dat} tidak ada"); return 3
    rows = aperture_metrics(read_wrdata(dat))
    print("E7: HOLD pada t_fall+30 ns, relatif terhadap level LAMA (V_lama). delta = waktu langkah input relatif terhadap")
    print("awal turun PHI_SH (negatif = sebelum switch mati). f = bagian langkah yang ikut tertangkap (termasuk pedestal).")
    print("Referensi Readiness @450 ns (P naik 0.4 V): dP = +24.95 mV (f = 6.2%), dN = -14.21 mV (f = 3.6%)\n")
    print(" k  delta(ns) arahP   dP(mV)    fP(%)    dN(mV)    fN(%)")
    for r in rows:
        print(f"{r['k']:2d}  {r['delta']:8d}  {'naik' if r['up_p'] else 'turun':5s} {r['dP_mV']:9.3f} {100*r['fP']:8.2f} {r['dN_mV']:9.3f} {100*r['fN']:8.2f}")
    print("\nStatus: MEASURED_NOT_FINAL. Bandingkan baris naik dengan referensi: f ~ 6%/3.6% menunjukkan langkah pada delta di mana switch masih sebagian menyala.")
    return 0


# ---------------------------------------------------------------------------
# E8: pedestal terhadap level
# ---------------------------------------------------------------------------

def level_metrics(cols):
    t = cols["time"]
    pts = []      # (level V, pedestal mV)
    dif = []      # (D_in, delta D mV)
    for k, v in enumerate(LEVELS):
        t0 = 250 * k
        ped = {}
        for ch, h, lvl in (("P", cols["hold_p"], v), ("N", cols["hold_n"], 1.8 - v)):
            trk = at(t, h, t0 + 139)
            ped[ch] = (at(t, h, t0 + 155) - trk) * 1e3
            pts.append((lvl, ped[ch], ch, k))
        dif.append((2 * (v - 0.9), ped["P"] - ped["N"]))
    return pts, dif


def do_analyze_level(a):
    dat = os.path.join(os.path.abspath(a.out), "tb_5F_E8_level_sweep.dat")
    if not os.path.exists(dat):
        print(f"NOT_RUN: {dat} tidak ada"); return 3
    pts, dif = level_metrics(read_wrdata(dat))
    pts_s = sorted(pts)
    print("E8: pedestal per level sinyal (satu sisi). ped = HOLD(t0+155) - HOLD(t0+139), mV.\n")
    print(" level(V)  ped(mV)  sisi")
    for lvl, ped, ch, k in pts_s:
        print(f"  {lvl:6.2f}  {ped:8.3f}   {ch}")
    x = np.array([p[0] - 0.9 for p in pts_s]); y = np.array([p[1] for p in pts_s])
    c1 = np.polyfit(x, y, 1); res1 = y - np.polyval(c1, x)
    c2 = np.polyfit(x, y, 2)
    print(f"\nFit linear   ped = {c1[1]:+.3f} mV {c1[0]:+.3f} mV/V * (V-0.9) ; residu maks {np.max(np.abs(res1)):.3f} mV")
    print(f"Fit kuadrat  koef (V-0.9)^2 = {c2[0]:+.3f} mV/V^2")
    # sisi P vs N pada level yang sama harus identik jika rangkaian simetris
    byl = {}
    for lvl, ped, ch, k in pts:
        byl.setdefault(round(lvl, 3), {})[ch] = ped
    both = [(l, d["P"], d["N"]) for l, d in byl.items() if len(d) == 2]
    if both:
        print("Level yang dicapai kedua sisi (cek simetri P vs N): " + ", ".join(f"{l:.2f}V: P={p:+.3f} N={n:+.3f}" for l, p, n in both))
    D = np.array([d[0] for d in dif]); E = np.array([d[1] for d in dif])
    cd = np.polyfit(D, E, 1); rd = E - np.polyval(cd, D)
    gain_pct = cd[0] * 1e-3 * 100          # mV/V -> fraksi -> persen
    span = float(np.max(D) - np.min(D))
    print(f"\nDiferensial: error = {cd[1]:+.3f} mV + {cd[0]:.3f} mV/V * D_in  (gain error {gain_pct:+.3f} % dari D_in)")
    print(f"Residu terhadap garis lurus maks {np.max(np.abs(rd)):.3f} mV = {np.max(np.abs(rd))*1e-3/span*100:.4f} % dari rentang D_in {np.min(D):.2f}..{np.max(D):.2f} V "
          f"({20*np.log10(np.max(np.abs(rd))*1e-3/span):.1f} dBFS-rentang, INL puncak)")
    print("Titik diferensial (D_in V, error mV): " + ", ".join(f"{d:+.1f}:{e:+.3f}" for d, e in sorted(zip(D, E))))
    print("Status: MEASURED_NOT_FINAL (nominal; tidak ada batas penerimaan).")
    return 0


# ---------------------------------------------------------------------------
# selftest (data sintetis)
# ---------------------------------------------------------------------------

def do_selftest(a):
    import tempfile
    d = tempfile.mkdtemp(prefix="t23_")
    t = np.arange(0, 700e-9, 0.1e-9)
    # hold sintetis: model sederhana, nilai diketahui
    def hold_wave(ped, step_imm, drift, v1, v2, steps):
        h = np.zeros_like(t)
        for k, (v, s) in enumerate(zip((v1, v2), steps)):
            pass
        return h
    # bangun HOLD_P: cycle1 track 1.1 -> ped +3 mV -> step +5 mV @160 -> drift +2 mV sampai 270
    #                cycle2 track 0.7 -> ped +4 mV -> step +20 mV @410 -> drift +6 mV sampai 520
    def sig(points):
        tt = np.array([p[0] for p in points]) * 1e-9
        vv = np.array([p[1] for p in points])
        return np.interp(t, tt, vv)
    hp = sig([(0, 1.1), (139, 1.1), (142, 1.103), (155, 1.103), (160, 1.103), (166, 1.108), (270, 1.110),
              (280, 1.110), (390, 0.7), (392, 0.704), (405, 0.704), (410, 0.704), (416, 0.724), (520, 0.730), (700, 0.730)])
    hn = 1.8 - hp
    cols = dict(time=t, hold_p=hp, hold_n=hn)
    rows = hold_metrics(cols, [160, 410])
    exp = dict(P_ped_mV=3.0, P_step_imm_mV=5.0 * 6 / 6, P_step_drift_mV=2.0)
    r1 = rows[0]
    ok = abs(r1["P_ped_mV"] - 3.0) < 0.2 and abs(r1["N_ped_mV"] + 3.0) < 0.2
    ok &= abs(r1["P_trk"] - 1.1) < 1e-3
    print("selftest hold: ped P =", round(r1["P_ped_mV"], 3), "mV (harap 3.0), ped N =", round(r1["N_ped_mV"], 3),
          "(harap -3.0); step_imm P =", round(r1["P_step_imm_mV"], 3), "step_drift P =", round(r1["P_step_drift_mV"], 3))
    # selftest MIM: file wrdata sintetis
    f = np.logspace(4, 8, 81)
    w = 2 * np.pi * f
    unit = 2e-15
    colsm = {"frequency": f, "c_ref": np.full_like(f, 1e-12), "c_sym100": np.full_like(f, 100 * unit),
             "c_sym1000": np.full_like(f, 1000 * unit), "c_a": np.full_like(f, 100 * 100 * unit),
             "c_b": np.full_like(f, 100 * unit), "c_c": np.full_like(f, 100 * unit),
             "c_d": np.full_like(f, 1000 * unit), "c_e": np.full_like(f, unit)}
    path = os.path.join(d, "tb_MIM_C_AC.dat")
    with open(path, "w") as fh:
        fh.write(" ".join(colsm) + "\n")
        for i in range(f.size):
            fh.write(" ".join(f"{colsm[k][i]:.12e}" for k in colsm) + "\n")
    a.out = d
    print()
    do_analyze_mim(a)
    # E8 sintetis: ped(V) = 0.5 + 10*(V-0.9) + 4*(V-0.9)^2 mV
    t8 = np.arange(0, 2400e-9, 0.1e-9)
    def ped_fn(v):
        return (0.5 + 10 * (v - 0.9) + 4 * (v - 0.9) ** 2) * 1e-3
    def synth_level(side):
        pts = []
        for k, v in enumerate(LEVELS):
            lvl = v if side == "P" else 1.8 - v
            t0 = 250 * k
            pts += [(t0 + 40, lvl), (t0 + 141, lvl), (t0 + 143, lvl + ped_fn(lvl)), (t0 + 249, lvl + ped_fn(lvl))]
        tt = np.array([p[0] for p in pts]) * 1e-9
        return np.interp(t8, tt, np.array([p[1] for p in pts]))
    pts8, dif8 = level_metrics(dict(time=t8, hold_p=synth_level("P"), hold_n=synth_level("N")))
    x = np.array([p[0] - 0.9 for p in pts8]); y = np.array([p[1] for p in pts8])
    c2 = np.polyfit(x, y, 2)
    ok8 = abs(c2[0] - 4) < 0.1 and abs(c2[1] - 10) < 0.1 and abs(c2[2] - 0.5) < 0.1
    print("selftest E8: koef kuadrat", np.round(c2, 3), "(harap 4, 10, 0.5):", "OK" if ok8 else "GAGAL")
    # E7 sintetis: fraksi tertangkap = 1 untuk delta<=-5, 0 untuk delta>=+3, linear di antaranya
    t7 = np.arange(0, 2700e-9, 0.1e-9)
    def frac(d):
        return float(np.clip((3 - d) / 8.0, 0, 1))
    def synth_ap(side):
        pts = []
        for k, d in enumerate(APERTURE_DELTAS):
            up = (k % 2 == 1)
            vo, vn = (0.7, 1.1) if up else (1.1, 0.7)
            if side == "N":
                vo, vn = 1.8 - vo, 1.8 - vn
            tf = 141 + 250 * k
            pts += [(tf - 30, vo), (tf + 5, vo + frac(d) * (vn - vo)), (tf + 100, vo + frac(d) * (vn - vo))]
        tt = np.array([p[0] for p in pts]) * 1e-9
        return np.interp(t7, tt, np.array([p[1] for p in pts]))
    rows7 = aperture_metrics(dict(time=t7, hold_p=synth_ap("P"), hold_n=synth_ap("N")))
    ok7 = all(abs(r["fP"] - frac(r["delta"])) < 0.01 for r in rows7)
    print("selftest E7: fraksi tertangkap cocok dengan model sintetis:", "OK" if ok7 else "GAGAL")
    print("\nselftest hold:", "OK" if ok else "GAGAL")
    return 0 if (ok and ok7 and ok8) else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["netlist", "sim", "analyze-hold", "analyze-mim", "analyze-aperture", "analyze-level", "selftest"])
    ap.add_argument("--only", default=None, help="hanya testbench yang namanya memuat teks ini (mis. E7)")
    ap.add_argument("--repo", default=ROOT, help="folder yang berisi blocks/ (cwd untuk xschem)")
    ap.add_argument("--out", default=os.path.join(ROOT, "results", "tahap2_3"))
    ap.add_argument("--which", choices=["hold", "mim", "all"], default="all")
    ap.add_argument("--xschem", default="xschem")
    ap.add_argument("--ngspice", default="ngspice")
    a = ap.parse_args()
    ONLY[0] = a.only
    rc = {"netlist": do_netlist, "sim": do_sim, "analyze-hold": do_analyze_hold,
          "analyze-mim": do_analyze_mim, "analyze-aperture": do_analyze_aperture,
          "analyze-level": do_analyze_level, "selftest": do_selftest}[a.cmd](a)
    sys.exit(rc)


if __name__ == "__main__":
    main()
