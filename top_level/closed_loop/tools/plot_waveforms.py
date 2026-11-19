#!/usr/bin/env python3
"""plot_waveforms.py - waveform figures for one closed-loop run (Block 6 + modulator + Block 7 CIC).

Usage (from top_level/closed_loop):
    python3 tools/plot_waveforms.py results/closed_loop/<run> [--out DIR] [--cycles-zoom 24]

Needs <run>/waveform.dat (ngspice wrdata) and <run>/manifest.json. Writes into DIR
(default <run>/figures): wf_phases.png, wf_integrators.png, wf_reconstruction.png,
wf_psd.png and waveform_summary.json. Panels whose signals were not saved are skipped.
Gap and width are read from 0.5*VDD crossings on the 1 ns wrdata grid (about +-1 ns).
Status of everything shown: SIMULATED_NOT_FINAL_PASS.
"""
import argparse
import json
import sys
from pathlib import Path
from types import SimpleNamespace

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(HERE.parent))
sys.path.insert(0, str(ROOT / "blocks/07_Digital_CIC/python"))
import run_closed_loop_f1 as rc                      # noqa: E402
from sd_behavioral import sndr_from_bits             # noqa: E402
from cic_ref import cic_bitexact                     # noqa: E402

STATUS = "SIMULATED_NOT_FINAL_PASS"
C1, C2, C3 = "#1f77b4", "#d62728", "#2ca02c"


def crossings(t, v, thr):
    s = v > thr
    idx = np.where(s[1:] != s[:-1])[0]
    rise, fall = [], []
    for i in idx:
        tc = t[i] + (thr - v[i]) * (t[i + 1] - t[i]) / (v[i + 1] - v[i])
        (rise if v[i + 1] > v[i] else fall).append(tc)
    return np.array(rise), np.array(fall)


def following(starts, ends):
    out = []
    for x in starts:
        nxt = ends[ends > x]
        if nxt.size:
            out.append(nxt[0] - x)
    return np.array(out) * 1e9


def stat(a):
    return dict(n=int(a.size), mean=float(a.mean()), min=float(a.min()), max=float(a.max())) if a.size else dict(n=0)


def phase_stats(t, p1, p2, vdd, t0, t1):
    m = (t >= t0) & (t <= t1)
    r1, f1 = crossings(t[m], p1[m], vdd / 2)
    r2, f2 = crossings(t[m], p2[m], vdd / 2)
    return dict(gap_phi1_fall_to_phi2_rise_ns=stat(following(f1, r2)),
                gap_phi2_fall_to_phi1_rise_ns=stat(following(f2, r1)),
                width_phi1_ns=stat(following(r1, f1)), width_phi2_ns=stat(following(r2, f2))), (r1, f1, r2, f2)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    ap.add_argument("run", help="run folder with waveform.dat and manifest.json")
    ap.add_argument("--out", default=None)
    ap.add_argument("--cycles-zoom", type=int, default=24, help="clock cycles shown in the time-domain panels")
    ap.add_argument("--waveform", default="waveform.dat")
    a = ap.parse_args()

    run = Path(a.run)
    out = Path(a.out) if a.out else run / "figures"
    out.mkdir(parents=True, exist_ok=True)
    man = json.load(open(run / "manifest.json"))
    cfg = SimpleNamespace(**man["args"])
    name = man["args"].get("name", run.name)
    t, c = rc.read_wrdata(str(run / a.waveform))
    T, t_rst, tstop = rc.timing(cfg)
    n_fft = rc.n_fft_of(cfg)
    td = t_rst + cfg.warmup * T                      # start of the analysis window / sine
    ks, bits, qraw = rc.sample_bits(t, c["q"], cfg, t_rst)
    vdd = cfg.vdd
    summary = dict(run=name, status=STATUS, n_bits=int(bits.size), n_fft=int(n_fft))

    # ---------------- Fig 1: phases and clock ----------------
    if "phi1" in c and "phi2" in c:
        tw0 = td + 100 * T
        st, (r1, f1, r2, f2) = phase_stats(t, c["phi1"], c["phi2"], vdd, tw0, min(tw0 + 600 * T, tstop))
        summary["phases"] = st
        fig = plt.figure(figsize=(11, 5.2))
        gs = fig.add_gridspec(3, 2, width_ratios=[2.2, 1], hspace=0.15, wspace=0.25)
        m = (t >= tw0) & (t <= tw0 + 3 * T)
        axs = []
        for i, (nm, col) in enumerate([("phi1", C1), ("phi2", C2), ("clk", C3)]):
            ax = fig.add_subplot(gs[i, 0], sharex=axs[0] if axs else None)
            if nm in c:
                ax.plot((t[m] - tw0) * 1e9, c[nm][m], color=col, lw=1.2)
            ax.set_ylabel(nm + " (V)"); ax.grid(alpha=.3); axs.append(ax)
            if i < 2:
                plt.setp(ax.get_xticklabels(), visible=False)
        axs[2].set_xlabel("time (ns)")
        axs[0].set_title(f"{name}: clock phases (3 periods)  [{STATUS}]", fontsize=10)
        axz = fig.add_subplot(gs[:, 1])
        if f1.size:
            tz = f1[len(f1) // 2]
            mz = (t >= tz - 30e-9) & (t <= tz + 50e-9)
            axz.plot((t[mz] - tz) * 1e9, c["phi1"][mz], color=C1, label="phi1")
            axz.plot((t[mz] - tz) * 1e9, c["phi2"][mz], color=C2, label="phi2")
            axz.axhline(vdd / 2, color="gray", lw=.6, ls="--")
            g = st["gap_phi1_fall_to_phi2_rise_ns"]
            if g["n"]:
                axz.set_title(f"zoom: gap phi1->phi2 mean {g['mean']:.1f} ns\n(min {g['min']:.1f}, max {g['max']:.1f}, n={g['n']})", fontsize=9)
            axz.set_xlabel("time from phi1 falling edge (ns)"); axz.set_ylabel("V"); axz.legend(); axz.grid(alpha=.3)
        fig.savefig(out / "wf_phases.png", dpi=160, bbox_inches="tight"); plt.close(fig)

    # ---------------- Fig 2: integrators and Q ----------------
    tw0 = td + 100 * T
    tw1 = tw0 + a.cycles_zoom * T
    m = (t >= tw0) & (t <= tw1)
    rows = [k for k, need in (("o1", ("o1_p", "o1_n")), ("o2", ("o2_p", "o2_n"))) if all(n in c for n in need)]
    if rows:
        fig, ax = plt.subplots(len(rows) + 1, 1, figsize=(11, 2.4 * (len(rows) + 1)), sharex=True)
        for i, k in enumerate(rows):
            p, n = c[k + "_p"][m], c[k + "_n"][m]
            ax[i].plot((t[m] - tw0) * 1e6, p - n, color=C1, lw=1.3, label=f"{k}_p - {k}_n (differential, left)")
            axc = ax[i].twinx()
            axc.plot((t[m] - tw0) * 1e6, 0.5 * (p + n), color="gray", lw=.9, ls="--", label="common mode (right)")
            axc.set_ylabel("common mode (V)", color="gray")
            h1, l1 = ax[i].get_legend_handles_labels(); h2, l2 = axc.get_legend_handles_labels()
            ax[i].legend(h1 + h2, l1 + l2, fontsize=8, loc="upper right")
            ax[i].set_ylabel(f"integrator {k[1]} (V)"); ax[i].grid(alpha=.3)
            win = t > td
            d = c[k + "_p"][win] - c[k + "_n"][win]
            cm = 0.5 * (c[k + "_p"][win] + c[k + "_n"][win])
            summary[k] = dict(diff_min=float(d.min()), diff_max=float(d.max()), cm_min=float(cm.min()), cm_max=float(cm.max()), cm_mean=float(cm.mean()))
        ax[-1].plot((t[m] - tw0) * 1e6, c["q"][m], color=C2, lw=1.3, label="Q (comparator latch)")
        if "clk" in c:
            ax[-1].plot((t[m] - tw0) * 1e6, c["clk"][m], color=C3, lw=.8, label="comparator clk")
        ax[-1].set_ylabel("V"); ax[-1].set_xlabel("time (us)"); ax[-1].legend(fontsize=8, loc="upper right"); ax[-1].grid(alpha=.3)
        ax[0].set_title(f"{name}: integrator outputs and quantizer ({a.cycles_zoom} cycles)  [{STATUS}]", fontsize=10)
        fig.savefig(out / "wf_integrators.png", dpi=160, bbox_inches="tight"); plt.close(fig)

    # ---------------- Fig 3: input, bitstream, CIC output ----------------
    if cfg.amp_mv is not None and n_fft and bits.size >= n_fft:
        R, N, W = 80, 3, 20
        x = bits[:n_fft]
        tb = cfg.clk_delay_ns * 1e-9 + ks[:n_fft] * T + cfg.read_ns * 1e-9      # sampling instants
        fin = cfg.bin / (n_fft * T)
        y = np.array(cic_bitexact((x > 0).astype(int), N, R, W), dtype=float) / R ** N * cfg.vref_d
        shift = N * (R - 1) / 2.0                                                # group delay in input samples
        idx_c = R * (np.arange(y.size) + 1) - 1 - shift
        ty = tb[0] + idx_c * T
        droop = (np.sin(np.pi * fin * T * R) / (R * np.sin(np.pi * fin * T))) ** N
        tt = np.linspace(tb[0], tb[-1], 6000)
        u = cfg.amp_mv * 1e-3 * np.sin(2 * np.pi * fin * (tt - td))
        npz = min(n_fft, int(1.0 / (fin * T)) + 1)                                # one input period
        fig, ax = plt.subplots(2, 1, figsize=(11, 5.6))
        ax[0].step((tb[:npz] - tb[0]) * 1e6, x[:npz], where="post", color=C1, lw=.8)
        ax[0].set_ylabel("bitstream (+-1)"); ax[0].set_xlabel("time (us), zoom: one input period"); ax[0].grid(alpha=.3)
        ax[0].set_title(f"{name}: bitstream and CIC reconstruction  [{STATUS}]", fontsize=10)
        ax[1].plot((tt - tb[0]) * 1e6, u, color="gray", lw=1.2, label=f"input, differential, {cfg.amp_mv:g} mV peak")
        ok = ty >= tb[0]
        ax[1].plot((ty[ok] - tb[0]) * 1e6, y[ok], "o-", color=C2, ms=3.5, lw=.9,
                   label=f"CIC sinc^3, R=80 output ({y.size} samples; droop {droop:.3f} = {20 * np.log10(droop):.1f} dB)")
        ax[1].set_ylabel("V (CIC output x VREF_D)"); ax[1].set_xlabel("time (us), full analysis window")
        ax[1].legend(fontsize=8, loc="upper right"); ax[1].grid(alpha=.3)
        fig.tight_layout()
        fig.savefig(out / "wf_reconstruction.png", dpi=160, bbox_inches="tight"); plt.close(fig)
        summary["cic_droop"] = float(droop)

        # ---------------- Fig 4: PSD ----------------
        w = np.hanning(n_fft)
        xs = x - x.mean()
        sp = np.abs(np.fft.rfft(xs * w)) * 2.0 / w.sum()
        f = np.arange(sp.size) / (n_fft * T)
        s = sndr_from_bits(x, osr=cfg.osr, fin_bin=cfg.bin)
        bw = 1.0 / (2 * T * cfg.osr)
        fig, ax = plt.subplots(figsize=(9, 4.4))
        ax.semilogx(f[1:], 20 * np.log10(sp[1:] + 1e-30), color=C1, lw=.7)
        ax.axvline(bw, color=C2, ls="--", lw=1, label=f"signal band edge {bw/1e3:.0f} kHz (OSR {cfg.osr})")
        ax.set_xlabel("frequency (Hz)"); ax.set_ylabel("amplitude (dBFS, Hann, 1 run)")
        ax.set_title(f"{name}: bitstream spectrum, SNDR {s['sndr_db']:.2f} dB, n={n_fft}  [{STATUS}]", fontsize=10)
        ax.legend(fontsize=8); ax.grid(alpha=.3, which="both"); ax.set_ylim(-140, 5)
        fig.savefig(out / "wf_psd.png", dpi=160, bbox_inches="tight"); plt.close(fig)
        summary["sndr_db"] = float(s["sndr_db"])

    json.dump(summary, open(out / "waveform_summary.json", "w"), indent=2)
    print(json.dumps(summary, indent=2))
    print("figures in", out)


if __name__ == "__main__":
    main()
