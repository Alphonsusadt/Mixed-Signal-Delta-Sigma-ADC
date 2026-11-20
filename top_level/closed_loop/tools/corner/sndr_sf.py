"""SNDR of the SF/125C/1.98V tracking-bias full run.

Run inside the directory that holds full_f7_sf_125_v198_trackbias.raw
(top_level/xschem/sim_out/full_f7_sf_125_v198_trackbias/, not committed).
Samples q at 20 ns + k*250 ns + 60 ns after reset (5 us) + 16 warm-up cycles.
"""
import sys, math
import numpy as np
sys.path.insert(0, "/foss/designs/Portfolio_Mixed_repo/top_level/closed_loop")
sys.path.insert(0, "/foss/designs/Portfolio_Mixed_repo/top_level/closed_loop/tools")
from view_raw import read_raw
from sd_behavioral import sndr_from_bits

sig = read_raw("full_f7_sf_125_v198_trackbias.raw")
if isinstance(sig, tuple):
    sig = [s for s in sig if isinstance(s, dict)][0]
print("signals:", list(sig.keys()))
t = np.asarray(sig["time"]).real
q = np.asarray(sig["q"]).real
T = 250e-9
k0 = int(math.ceil((9e-6 - 20e-9) / T))           # reset 5 us + 16 warmup cycles
ts = 20e-9 + (k0 + np.arange(4096)) * T + 60e-9
assert ts[-1] <= t[-1], (ts[-1], t[-1])
qv = np.interp(ts, t, q)
thr = 0.5 * (qv.max() + qv.min())
bits = np.where(qv > thr, 1.0, -1.0)
print("k0", k0, "last sample %.3f us, tstop %.3f us" % (ts[-1] * 1e6, t[-1] * 1e6))
print("q levels ok:", bool(np.all((qv < 0.2 * 1.98) | (qv > 0.8 * 1.98))), "thr %.3f" % thr)
print("mean bit %.4f, transitions/100 %.1f" % (bits.mean(), 100 * np.mean(bits[1:] != bits[:-1])))
win = t > 9e-6
for st, (p, n) in {"I1": ("o1_p", "o1_n"), "I2": ("o2_p", "o2_n")}.items():
    if p in sig:
        cm = 0.5 * (sig[p] + sig[n])[win]; df = (sig[p] - sig[n])[win]
        print(f"{st}: CM mean {cm.mean():.3f} [{cm.min():.3f},{cm.max():.3f}]  diff [{df.min():+.3f},{df.max():+.3f}]")
for osr in (80, 32, 16):
    r = sndr_from_bits(bits, osr=osr, fin_bin=13)
    print(f"OSR {osr}: SNDR {r['sndr_db']:.2f} dB, ENOB {r['enob']:.2f}")
np.savetxt("bits_sf_trackbias.txt", bits, fmt="%d")
