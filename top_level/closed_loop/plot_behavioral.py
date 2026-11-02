#!/usr/bin/env python3
"""Gambar ringkasan model perilaku: PSD bitstream dan SNDR vs amplitudo."""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from sd_behavioral import simulate, coherent_sine, sndr_from_bits, amplitude_sweep

BASE = dict(a1=0.5, a2=0.5, b1=0.5, b2=0.5)
N, FS = 2 ** 16, 4e6
fig, ax = plt.subplots(1, 2, figsize=(12, 4.6))

# (a) PSD, ideal, -6 dBFS
u = coherent_sine(N, 13, 0.6 * 10 ** (-6 / 20))
r = simulate(u, **BASE)
x = r["bits"] - r["bits"].mean()
p = np.abs(np.fft.rfft(x * np.hanning(N))) ** 2
p = p / p.max()
f = np.arange(p.size) * FS / N
ax[0].semilogx(f[1:], 10 * np.log10(p[1:] + 1e-30), lw=0.6, label="bitstream (ideal)")
for osr, c in ((80, "tab:red"), (256, "tab:green")):
    ax[0].axvline(FS / (2 * osr), color=c, ls="--", lw=1, label=f"BW OSR={osr} ({FS/(2*osr)/1e3:.1f} kHz)")
ax[0].set_xlabel("Frekuensi (Hz)"); ax[0].set_ylabel("dB relatif puncak")
ax[0].set_title("Spektrum bitstream, -6 dBFS, a1=a2=b1=b2=0.5"); ax[0].legend(fontsize=8); ax[0].grid(alpha=.3, which="both")

# (b) SNDR vs amplitudo
amps = list(range(-90, -9, 6)) + [-8, -6, -4.5, -3, -1.5]
for osr, c in ((80, "tab:red"), (256, "tab:green")):
    rows = amplitude_sweep(BASE, amps, n_samp=N, osr=osr, fin_bin=13)
    ok = [q for q in rows if q["y1_pk"] < 3 and q["y2_pk"] < 3]
    ax[1].plot([q["amp_dbfs"] for q in ok], [q["sndr_db"] for q in ok], "o-", color=c, ms=3, label=f"ideal, OSR={osr}")
ax[1].axhline(99, color="k", ls=":", lw=1, label="target DR 99 dB")
ax[1].set_xlabel("Amplitudo input (dBFS, FS = 0.6 V diff pk)"); ax[1].set_ylabel("SNDR (dB)")
ax[1].set_title("SNDR vs amplitudo (kuantisasi saja)"); ax[1].legend(fontsize=8); ax[1].grid(alpha=.3)
plt.tight_layout(); plt.savefig("results/behavioral_overview.png", dpi=130)
print("ok")
