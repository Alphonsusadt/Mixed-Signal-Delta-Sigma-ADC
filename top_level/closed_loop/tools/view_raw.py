#!/usr/bin/env python3
"""view_raw.py - full-screen oscilloscope-style viewer for an ngspice binary .raw file.

Usage (inside the container, display via WSLg):
    python3 top_level/closed_loop/tools/view_raw.py [RAW] [--ch "vin_d,rec" --ch "q,dac_d" ...]

Default RAW: ~/.xschem/simulations/tb_SD_TOP.raw (written by top_level/xschem/tb_SD_TOP.sch).
Default channels follow the six graphs of tb_SD_TOP.sch. All channels share the time axis:
zoom/pan one (toolbar magnifier / cross) and the others follow. Press 'h' or Home to reset.
Status of everything shown: SIMULATED_NOT_FINAL_PASS.
"""
import argparse
import os
import sys

import numpy as np
import matplotlib
matplotlib.use("Qt5Agg")
import matplotlib.pyplot as plt

DEFAULT_RAW = os.path.expanduser("~/.xschem/simulations/tb_SD_TOP.raw")
DEFAULT_CH = ["vin_d,rec", "o1_d,o2_d", "o1_p,o1_n,o2_p,o2_n", "q,dac_d", "phi1,phi2,clk", "cmp_p,cmp_n"]


def read_raw(path):
    with open(path, "rb") as f:
        blob = f.read()
    hdr, sep, data = blob.partition(b"Binary:\n")
    if not sep:
        sys.exit("only binary ngspice raw files are supported: " + path)
    h = hdr.decode(errors="replace")
    nv = int(h.split("No. Variables:")[1].split()[0])
    npt = int(h.split("No. Points:")[1].split()[0])
    if "complex" in h.split("Flags:")[1].splitlines()[0]:
        sys.exit("complex (AC) raw files are not supported")
    names = [ln.split()[1] for ln in h.split("Variables:\n")[1].strip().splitlines()[:nv]]
    arr = np.frombuffer(data[: nv * npt * 8], dtype=np.float64).reshape(npt, nv)
    sig = {}
    for i, n in enumerate(names):
        key = n[2:-1] if n.lower().startswith("v(") and n.endswith(")") else n
        sig[key.lower()] = arr[:, i]
    return sig


class Cursors:
    """Two oscilloscope cursors (A, B) spanning all channels, with a live readout panel."""

    def __init__(self, fig, axes, t, sig, chans):
        self.fig, self.axes, self.t, self.sig = fig, axes, t, sig
        self.names = [[s.strip().lower() for s in ch.split(",") if s.strip().lower() in sig] for ch in chans]
        self.pos = {"A": None, "B": None}
        self.lines = {"A": [], "B": []}
        self.color = {"A": "tab:red", "B": "tab:blue"}
        self.drag = None
        self.text = fig.text(0.81, 0.95, "", va="top", ha="left", family="monospace", fontsize=8)
        fig.canvas.mpl_connect("button_press_event", self.on_press)
        fig.canvas.mpl_connect("motion_notify_event", self.on_move)
        fig.canvas.mpl_connect("button_release_event", lambda e: setattr(self, "drag", None))
        self.refresh()

    def toolbar_busy(self):
        tb = getattr(self.fig.canvas, "toolbar", None)
        return bool(tb is not None and getattr(tb, "mode", ""))

    def on_press(self, e):
        if e.inaxes not in self.axes or e.xdata is None or self.toolbar_busy():
            return
        key = "A" if e.button == 1 else "B" if e.button == 3 else None
        if key:
            self.drag = key
            self.set(key, e.xdata)

    def on_move(self, e):
        if self.drag and e.inaxes in self.axes and e.xdata is not None:
            self.set(self.drag, e.xdata)

    def set(self, key, x):
        self.pos[key] = float(np.clip(x, self.t[0], self.t[-1]))
        for ln in self.lines[key]:
            ln.remove()
        self.lines[key] = [ax.axvline(self.pos[key], color=self.color[key], lw=1, ls="--") for ax in self.axes]
        self.refresh()

    def value(self, name, x):
        return float(np.interp(x, self.t, self.sig[name]))

    def refresh(self):
        a, b = self.pos["A"], self.pos["B"]
        out = []
        out.append("A = %s us" % ("-" if a is None else "%.4f" % a))
        out.append("B = %s us" % ("-" if b is None else "%.4f" % b))
        if a is not None and b is not None and a != b:
            dt = abs(b - a)
            out.append("dt = %.4f us   1/dt = %.4g kHz" % (dt, 1e3 / dt))
        out.append("")
        for i, names in enumerate(self.names):
            out.append("CH%d" % (i + 1))
            for n in names:
                va = "" if a is None else "%+.4f" % self.value(n, a)
                vb = "" if b is None else "%+.4f" % self.value(n, b)
                d = "" if (a is None or b is None) else "  d=%+.4f" % (self.value(n, b) - self.value(n, a))
                out.append("  %-7s A %8s  B %8s%s" % (n, va, vb, d))
        self.text.set_text("\n".join(out))
        self.fig.canvas.draw_idle()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    ap.add_argument("raw", nargs="?", default=DEFAULT_RAW)
    ap.add_argument("--ch", action="append", help="comma-separated signals for one channel (repeatable)")
    ap.add_argument("--list", action="store_true", help="print the signal names and exit")
    a = ap.parse_args()

    sig = read_raw(a.raw)
    if a.list:
        print(" ".join(k for k in sig if k != "time"))
        return
    t = sig["time"] * 1e6
    chans = a.ch or DEFAULT_CH

    fig, axes = plt.subplots(len(chans), 1, sharex=True, squeeze=False)
    axes = axes[:, 0]
    for i, (ax, ch) in enumerate(zip(axes, chans)):
        for name in [s.strip().lower() for s in ch.split(",") if s.strip()]:
            if name not in sig:
                print("signal not in raw file, skipped:", name)
                continue
            ax.plot(t, sig[name], lw=0.8, label=name)
        ax.set_ylabel("CH%d (V)" % (i + 1))
        ax.grid(alpha=0.3)
        ax.legend(loc="upper right", fontsize=8)
    axes[-1].set_xlabel("time (us)")
    fig.suptitle("%s   [SIMULATED_NOT_FINAL_PASS]   cursors: left click/drag = A, right click/drag = B "
                 "(zoom/pan tool must be off)" % os.path.basename(a.raw), fontsize=9)
    fig.subplots_adjust(left=0.05, right=0.80, top=0.96, bottom=0.05, hspace=0.15)
    Cursors(fig, axes, t, sig, chans)
    try:
        fig.canvas.manager.window.showMaximized()
    except Exception:
        pass
    plt.show()


if __name__ == "__main__":
    main()
