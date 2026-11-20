#!/usr/bin/env python3
"""DSP analysis of the decimation chain: 1-bit bitstream (4 MHz) -> sinc^3 CIC (R=80) -> FIR (50 kS/s).

Uses the bit-exact models of Block 7 (cic_ref.py) and Block 8 (fir_ref.py) and the behavioral
modulator model (sd_behavioral.py). Writes figures/*.png and results.json next to this script.

Sections (all printed and stored in results.json):
  A  frequency responses of CIC, FIR and CIC*FIR
  B  aliasing of the CIC: attenuation of the bands that fold into the passband, and a noise budget
  C  SNDR after decimation versus SNDR taken directly from the bitstream
  D  word lengths: CIC output truncation, FIR coefficient width, FIR output width
  E  idle tones for small DC inputs
  F  spectral-estimation method (window, coherent sampling)
  G  alternative chain: CIC R=40 + compensating FIR at 100 kS/s, decimate by 2 (not a true half-band)
  H  cross-check on the transistor-level bitstream f6 (4096 bits)

Status of every number: SIMULATED_NOT_FINAL_PASS. Sections A, B (response part), D and G (response part)
are exact filter math; sections B (noise budget), C, D, E, F, G use the IDEAL behavioral modulator, not the
transistor-level circuit, except section H.

Run (inside the container, from the repository root):
  python3 top_level/dsp_analysis/dsp_analysis.py
"""
import json
import math
import sys
from pathlib import Path

import numpy as np
from scipy import signal
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "blocks/07_Digital_CIC/python"))
sys.path.insert(0, str(ROOT / "blocks/08_Digital_FIR/python"))
sys.path.insert(0, str(ROOT / "top_level/closed_loop"))
from cic_ref import cic_exact, cic_bitexact, DEF_BS          # noqa: E402
from fir_ref import design, quantise, fir_conv, h_cic         # noqa: E402
from sd_behavioral import simulate                             # noqa: E402

FS, R, N = 4e6, 80, 3
FS_OUT = FS / R
FULL = R ** N                     # CIC full scale 512000
VREF_D = 0.6                      # differential full scale of the modulator (V)
FB15, FB25 = 15e3, 25e3
NTAP, FP, FBITS, CW = 21, 15e3, 16, 18
NDEC = 8192                       # decimated samples per long run
NBIT = NDEC * R                   # 655360 modulator bits
FIG = HERE / "figures"
FIG.mkdir(exist_ok=True)
RES = {}


# ---------------------------------------------------------------- helpers
def coherent_tone(nbits, f_target):
    """Tone with an odd integer number of cycles in nbits samples (coherent at fs and fs/R)."""
    k = int(round(f_target / FS * nbits))
    k += (k % 2 == 0)
    return k, k / nbits * FS


WARM = 64                         # decimated warm-up samples (CIC + FIR settling), discarded
WB = WARM * R                     # the same warm-up in modulator bits


def run_model(amp_dbfs, f_target, nbits=NBIT, dc=None, ktc=True, seed=1):
    """Returns WB + nbits bits. The tone is periodic in nbits, so any window of nbits bits
    (or nbits/R decimated samples) after the warm-up is coherent."""
    n = np.arange(nbits + WB)
    if dc is None:
        k, f0 = coherent_tone(nbits, f_target)
        u = VREF_D * 10 ** (amp_dbfs / 20) * np.sin(2 * np.pi * k * n / nbits)
    else:
        f0 = 0.0
        u = np.full(n.size, dc * VREF_D)
    kw = dict(cs1=1e-12, cd1=1e-12, cs2=1e-12, cd2=1e-12) if ktc else {}
    r = simulate(u, a1=0.5, a2=0.5, b1=0.5, b2=0.5, vref_d=VREF_D, seed=seed, **kw)
    return np.asarray(r["bits"]), f0


def bwin(b, nbits=NBIT):
    """Analysis window of the bitstream (after the warm-up)."""
    return np.asarray(b)[WB:WB + nbits]


def ywin(y, ndec=NDEC):
    """Analysis window of a 50 kS/s sequence (after the warm-up)."""
    return np.asarray(y)[WARM:WARM + ndec]


def sndr_band(x, fs, f0, fband, window="hann", sig_half=3, skip_dc=3):
    """SNDR in 0..fband of a (possibly decimated) sequence, tone at f0, coherent FFT."""
    x = np.asarray(x, dtype=float)
    x = x - x.mean()
    n = x.size
    w = {"hann": np.hanning(n), "rect": np.ones(n),
         "bh": signal.windows.blackmanharris(n)}[window]
    p = np.abs(np.fft.rfft(x * w)) ** 2
    kb = int(math.floor(fband / fs * n))
    k0 = int(round(f0 / fs * n))
    sig = np.zeros(p.size, bool)
    sig[max(k0 - sig_half, 0):k0 + sig_half + 1] = True
    band = np.zeros(p.size, bool)
    band[skip_dc:kb + 1] = True
    ps = p[sig & band].sum()
    pn = p[band & ~sig].sum()
    return 10 * np.log10(ps / pn)


def decimate_chain(bits_pm1, q=None, cw_trunc=None, out_bits=None):
    """bits (+-1) -> CIC (exact integers) -> optional truncation -> FIR (bit-exact) -> optional rounding."""
    bits01 = (np.asarray(bits_pm1) > 0).astype(int)
    c = cic_exact(bits01, N, R).astype(np.int64)
    if cw_trunc is not None and cw_trunc < 20:
        sh = 20 - cw_trunc
        c = (c >> sh) << sh                         # keep the top cw_trunc bits of 20
    if q is None:
        q = quantise(design(NTAP, FP), FBITS, CW)
    y = np.asarray(fir_conv(c, q, FBITS), dtype=np.int64)
    if out_bits is not None:
        sh = 21 - out_bits
        if sh > 0:
            y = ((y + (1 << (sh - 1))) >> sh) << sh
    return c, y


def fir_resp(q, f, fbits=FBITS, fs=FS_OUT):
    return np.abs(signal.freqz(np.asarray(q, float) / 2 ** fbits, worN=f, fs=fs)[1])


Q = quantise(design(NTAP, FP), FBITS, CW)

# ---------------------------------------------------------------- A: responses
f_all = np.linspace(1, FS / 2, 200001)
H_cic_all = np.abs(h_cic(f_all))
f_pb = np.linspace(0, FS_OUT / 2, 2001)
Hc, Hf = np.abs(h_cic(f_pb)), fir_resp(Q, f_pb)
Ht = Hc * Hf
m15 = f_pb <= FB15
m25 = f_pb <= FB25
RES["A"] = dict(
    cic_droop_db_at_15k=float(20 * np.log10(h_cic([15e3])[0])),
    cic_droop_db_at_25k=float(20 * np.log10(h_cic([25e3])[0])),
    chain_dev_db_0_15k=[float(20 * np.log10(Ht[m15].min())), float(20 * np.log10(Ht[m15].max()))],
    chain_gain_db_at_20k=float(20 * np.log10(Ht[np.argmin(abs(f_pb - 20e3))])),
    chain_gain_db_at_25k=float(20 * np.log10(Ht[-1])),
    fir_max_gain_db=float(20 * np.log10(Hf.max())),
)
fig, ax = plt.subplots(1, 2, figsize=(15, 5))
ax[0].plot(f_all / 1e3, 20 * np.log10(H_cic_all + 1e-12), lw=0.7)
for k in range(1, 6):
    ax[0].axvspan((k * FS_OUT - FB25) / 1e3, (k * FS_OUT + FB25) / 1e3, color="r", alpha=0.08)
ax[0].set_xlim(0, 400); ax[0].set_ylim(-160, 5)
ax[0].set_title("sinc^3 CIC, R = 80 (shaded: bands that alias into 0-25 kHz)")
ax[0].set_xlabel("frequency [kHz] (modulator rate 4 MHz)"); ax[0].set_ylabel("dB")
ax[1].plot(f_pb / 1e3, 20 * np.log10(Hc), label="CIC")
ax[1].plot(f_pb / 1e3, 20 * np.log10(Hf), label="FIR (21 taps, 18-bit coefficients)")
ax[1].plot(f_pb / 1e3, 20 * np.log10(Ht), "k", lw=2, label="CIC x FIR")
ax[1].axvline(15, color="g", ls="--", label="compensated band edge 15 kHz")
ax[1].set_ylim(-12, 6); ax[1].set_xlabel("frequency [kHz] (output rate 50 kS/s)")
ax[1].set_title("Passband up to the output Nyquist frequency (25 kHz)")
for a in ax:
    a.grid(alpha=0.3)
ax[1].legend(fontsize=8)
fig.tight_layout(); fig.savefig(FIG / "A_responses.png", dpi=110); plt.close(fig)

# ---------------------------------------------------------------- B: aliasing
alias = []
for k in range(1, 6):
    for fb in (FB15, FB25):
        ff = np.linspace(k * FS_OUT - fb, k * FS_OUT + fb, 2001)
        alias.append(dict(k=k, band_khz=fb / 1e3,
                          min_atten_db=float(-20 * np.log10(np.abs(h_cic(ff)).max()))))
RES["B_alias_attenuation"] = alias
# noise budget from a long behavioral run: PSD of the bitstream shaped by CIC*FIR, folded to 0..fb
bits, f0 = run_model(-6, 12.7e3)
bits = bwin(bits)
fw, pxx = signal.welch(bits, fs=FS, window="hann", nperseg=2 ** 16)
toneband = np.abs(fw - f0) < 3 * FS / 2 ** 16
pxx = np.where(toneband, np.interp(fw, fw[~toneband], pxx[~toneband]), pxx)
Hcf = np.abs(h_cic(fw)) * fir_resp(Q, np.mod(fw, FS_OUT), FBITS, FS_OUT)
shaped = pxx * Hcf ** 2
budget = {}
for fb in (FB15, FB25):
    native = shaped[(fw > 300) & (fw <= fb)].sum()
    ali = 0.0
    for k in range(1, int(FS / 2 / FS_OUT) + 1):
        ali += shaped[(fw >= k * FS_OUT - fb) & (fw <= k * FS_OUT + fb)].sum()
    budget[f"{int(fb / 1e3)}k"] = dict(
                                       aliased_over_native_db=float(10 * np.log10(ali / native)))
RES["B_noise_budget"] = budget

# ---------------------------------------------------------------- C: SNDR before / after decimation
c_rows = []
for f_t in (1e3, 12.7e3):
    for amp in (-6, -20, -40):
        b, f0 = run_model(amp, f_t)
        _, y = decimate_chain(b)
        y = ywin(y)
        row = dict(f0_hz=f0, amp_dbfs=amp,
                   bits_15k=sndr_band(bwin(b), FS, f0, FB15), bits_25k=sndr_band(bwin(b), FS, f0, FB25),
                   dec_15k=sndr_band(y, FS_OUT, f0, FB15))
        row["dec_loss_db_15k"] = row["bits_15k"] - row["dec_15k"]
        c_rows.append(row)
RES["C_sndr"] = c_rows
bC, f0C = run_model(-6, 12.7e3)
cC, yC = decimate_chain(bC)
fig, ax = plt.subplots(1, 2, figsize=(15, 5))
for a, x, fs, ttl in ((ax[0], bwin(bC), FS, "bitstream (4 MHz), behavioral model"),
                      (ax[1], ywin(yC), FS_OUT, "after CIC + FIR (50 kS/s), bit-exact")):
    xx = np.asarray(x, float); xx = xx - xx.mean()
    w = np.hanning(xx.size)
    p = np.abs(np.fft.rfft(xx * w)) ** 2
    p /= p.max()
    ff = np.arange(p.size) * fs / xx.size
    a.semilogx(ff[1:], 10 * np.log10(p[1:] + 1e-30), lw=0.5)
    a.axvline(FB15, color="g", ls="--", label="15 kHz"); a.axvline(FB25, color="r", ls="--", label="25 kHz")
    a.set_title(ttl); a.set_xlabel("Hz"); a.set_ylabel("dB rel. tone"); a.grid(alpha=0.3, which="both")
    a.set_ylim(-170, 5); a.legend(fontsize=8)
fig.suptitle(f"-6 dBFS tone at {f0C / 1e3:.2f} kHz, {NBIT} bits -> {NDEC} decimated samples")
fig.tight_layout(); fig.savefig(FIG / "C_spectra.png", dpi=110); plt.close(fig)

# ---------------------------------------------------------------- D: word lengths
ref = sndr_band(ywin(decimate_chain(bC)[1]), FS_OUT, f0C, FB15)
d_cic = [dict(bits=wb, sndr=sndr_band(ywin(decimate_chain(bC, cw_trunc=wb)[1]), FS_OUT, f0C, FB15))
         for wb in (10, 12, 14, 16, 18, 20)]
d_coef = []
h = design(NTAP, FP)
for cw in (8, 10, 12, 14, 16, 18):
    fb_ = cw - 2
    q = quantise(h, fb_, cw)
    ht = np.abs(h_cic(f_pb)) * fir_resp(q, f_pb, fb_)
    s = sndr_band(ywin(decimate_chain(bC, q=q)[1]), FS_OUT, f0C, FB15)
    d_coef.append(dict(cw=cw, dev_db=[float(20 * np.log10(ht[m15].min())), float(20 * np.log10(ht[m15].max()))],
                       sndr=s))
d_out = [dict(bits=ob, sndr=sndr_band(ywin(decimate_chain(bC, out_bits=ob)[1]), FS_OUT, f0C, FB15))
         for ob in (10, 12, 14, 16, 18, 21)]
RES["D"] = dict(reference_sndr_15k=ref, cic_out_bits=d_cic, fir_coef_width=d_coef, fir_out_bits=d_out,
                cic_register_bits_needed=float(1 + N * math.log2(R)))
fig, ax = plt.subplots(1, 3, figsize=(16, 4.5))
ax[0].plot([d["bits"] for d in d_cic], [d["sndr"] for d in d_cic], "o-")
ax[0].set_title("CIC output kept bits (of 20) -> SNDR 0-15 kHz"); ax[0].set_xlabel("bits")
ax[1].plot([d["cw"] for d in d_coef], [d["sndr"] for d in d_coef], "o-", label="SNDR")
ax1b = ax[1].twinx()
ax1b.plot([d["cw"] for d in d_coef], [max(abs(x) for x in d["dev_db"]) for d in d_coef], "s--", color="C1",
          label="max passband deviation")
ax1b.set_yscale("log"); ax1b.set_ylabel("dB (deviation)")
ax[1].set_title("FIR coefficient width"); ax[1].set_xlabel("bits (fractional = width - 2)")
ax[2].plot([d["bits"] for d in d_out], [d["sndr"] for d in d_out], "o-")
ax[2].set_title("FIR output kept bits (of 21)"); ax[2].set_xlabel("bits")
for a in ax:
    a.set_ylabel("SNDR [dB]") if a is not ax1b else None
    a.grid(alpha=0.3)
fig.suptitle("Word-length study, behavioral bitstream, -6 dBFS tone, 0-15 kHz band (selected widths: 20 / 18 / 21)")
fig.tight_layout(); fig.savefig(FIG / "D_wordlength.png", dpi=110); plt.close(fig)

# ---------------------------------------------------------------- E: idle tones
e_rows = []
fig, ax = plt.subplots(1, 1, figsize=(12, 5))
for dc in (0.0, 1 / 256, 1 / 64, 0.1):
    b, _ = run_model(None, None, nbits=2 ** 18, dc=dc, ktc=False)
    b = bwin(b, 2 ** 18)
    xx = b - b.mean()
    p = np.abs(np.fft.rfft(xx * np.hanning(xx.size))) ** 2
    p_ref = (np.hanning(xx.size).sum() / 2) ** 2 * 1.0       # full-scale (+-1) sine in a bin
    ff = np.arange(p.size) * FS / xx.size
    band = (ff > 200) & (ff <= FB25)
    spur = 10 * np.log10(p[band].max() / p_ref)
    e_rows.append(dict(dc_fs=dc, max_inband_spur_dbfs=float(spur),
                       spur_freq_hz=float(ff[band][np.argmax(p[band])])))
    ax.semilogx(ff[1:], 10 * np.log10(p[1:] / p_ref + 1e-30), lw=0.5, label=f"DC = {dc:.4f} FS")
ax.axvline(FB25, color="r", ls="--")
ax.set_xlim(100, 2e6); ax.set_ylim(-180, 0); ax.grid(alpha=0.3, which="both"); ax.legend(fontsize=8)
ax.set_title("Idle tones of the ideal 2nd-order 1-bit loop (no noise, no dither)")
ax.set_xlabel("Hz"); ax.set_ylabel("dBFS")
fig.tight_layout(); fig.savefig(FIG / "E_idle_tones.png", dpi=110); plt.close(fig)
# same with kT/C noise acting as dither
for dc in (1 / 256, 1 / 64):
    b, _ = run_model(None, None, nbits=2 ** 18, dc=dc, ktc=True)
    b = bwin(b, 2 ** 18)
    xx = b - b.mean()
    p = np.abs(np.fft.rfft(xx * np.hanning(xx.size))) ** 2
    p_ref = (np.hanning(xx.size).sum() / 2) ** 2
    ff = np.arange(p.size) * FS / xx.size
    band = (ff > 200) & (ff <= FB25)
    e_rows.append(dict(dc_fs=dc, with_ktc_noise=True,
                       max_inband_spur_dbfs=float(10 * np.log10(p[band].max() / p_ref))))
RES["E_idle_tones"] = e_rows

# ---------------------------------------------------------------- F: estimation method
nb = 2 ** 15
n = np.arange(nb)
f_rows = []
b_coh, f_coh = run_model(-6, 12.7e3, nbits=nb)
f_nc = 12.7e3 + 0.37 * FS / nb                             # deliberately between bins
u_nc = VREF_D * 10 ** (-6 / 20) * np.sin(2 * np.pi * f_nc * n / FS)
b_nc = np.asarray(simulate(u_nc, a1=0.5, a2=0.5, b1=0.5, b2=0.5, vref_d=VREF_D,
                           cs1=1e-12, cd1=1e-12, cs2=1e-12, cd2=1e-12)["bits"])
for win in ("rect", "hann", "bh"):
    f_rows.append(dict(window=win,
                       coherent=sndr_band(bwin(b_coh, nb), FS, f_coh, FB25, window=win),
                       non_coherent=sndr_band(b_nc, FS, f_nc, FB25, window=win, sig_half=6)))
RES["F_method"] = f_rows

# ---------------------------------------------------------------- G: alternative CIC R=40 + compensating FIR, decimate by 2
R2, FS_MID = 40, FS / 40
def h_cic40(f):
    x = np.pi * np.asarray(f, float) / FS
    o = np.ones_like(x); nz = x != 0
    o[nz] = (np.sin(x[nz] * R2) / (R2 * np.sin(x[nz]))) ** N
    return o
FP2, FSB2, NT2 = 20e3, 30e3, 41
fb = np.linspace(0, FP2, 100)
bands, des = [], []
for a_, b_ in zip(fb[:-1], fb[1:]):
    bands += [a_, b_]; des += [1 / h_cic40([a_])[0], 1 / h_cic40([b_])[0]]
bands += [FSB2, FS_MID / 2]; des += [0, 0]
hb = signal.firls(NT2, bands, des, weight=[1] * (len(fb) - 1) + [30], fs=FS_MID)
fq = np.linspace(0, FS_OUT / 2, 2001)
Halt = np.abs(h_cic40(fq)) * np.abs(signal.freqz(hb, worN=fq, fs=FS_MID)[1])
fst = np.linspace(FSB2, FS_MID / 2, 2001)
stop = np.abs(h_cic40(fst)) * np.abs(signal.freqz(hb, worN=fst, fs=FS_MID)[1])
m20 = fq <= FP2
RES["G_alternative"] = dict(cic_r=R2, fir_taps=NT2, fir_rate_hz=FS_MID, passband_hz=FP2,
                            dev_db_0_20k=[float(20 * np.log10(Halt[m20].min())), float(20 * np.log10(Halt[m20].max()))],
                            min_stop_atten_db_30_50k=float(-20 * np.log10(stop.max())))
# SNDR of the alternative (floating-point filters, decimated to 50 kS/s)
x01 = np.where(bC > 0, 1.0, -1.0)
box = np.ones(R2) / R2
hc = box
for _ in range(N - 1):
    hc = np.convolve(hc, box)
mid = np.convolve(x01, hc)[R2 - 1::R2]
yalt = ywin(np.convolve(mid, hb)[::2])
RES["G_alternative"]["sndr_0_20k"] = sndr_band(yalt, FS_OUT, f0C, FP2)
RES["G_alternative"]["sndr_current_chain_0_20k"] = sndr_band(ywin(yC), FS_OUT, f0C, FP2)
RES["G_alternative"]["bitstream_sndr_0_20k"] = sndr_band(bwin(bC), FS, f0C, FP2)
fig, ax = plt.subplots(figsize=(10, 5))
ax.plot(f_pb / 1e3, 20 * np.log10(Ht), label="current: CIC R=80 + 21-tap FIR at 50 kS/s")
ax.plot(fq / 1e3, 20 * np.log10(Halt), label=f"alternative: CIC R=40 + {NT2}-tap compensating FIR at 100 kS/s, decimate by 2")
ax.axvline(15, color="C0", ls=":"); ax.axvline(20, color="C1", ls=":")
ax.set_ylim(-8, 2); ax.grid(alpha=0.3); ax.legend(fontsize=8)
ax.set_xlabel("frequency [kHz]"); ax.set_ylabel("dB")
ax.set_title("Usable flat band at 50 kS/s output: 15 kHz (current) versus 20 kHz (alternative)")
fig.tight_layout(); fig.savefig(FIG / "G_alternative.png", dpi=110); plt.close(fig)

# ---------------------------------------------------------------- H: transistor-level f6 bitstream
bf6 = np.loadtxt(DEF_BS)[:4096]
k13 = 13
f0f6 = k13 / 4096 * FS
cic6 = cic_bitexact((bf6 > 0).astype(int))
RES["H_f6"] = dict(bits=4096, f0_hz=f0f6,
                   sndr_bitstream_25k=sndr_band(bf6, FS, f0f6, FB25),
                   sndr_bitstream_15k=sndr_band(bf6, FS, f0f6, FB15),
                   cic_samples=len(cic6),
                   cic_exact_equals_bitexact=bool(np.array_equal(
                       np.asarray(cic6), cic_exact((bf6 > 0).astype(int), N, R)[:len(cic6)])),
                   note="51 decimated samples are too few for a decimated-domain SNDR")

# ---------------------------------------------------------------- output
def clean(o):
    if isinstance(o, dict):
        return {k: clean(v) for k, v in o.items()}
    if isinstance(o, list):
        return [clean(v) for v in o]
    if isinstance(o, (np.floating, float)):
        return round(float(o), 3)
    if isinstance(o, np.integer):
        return int(o)
    return o

RES = clean(RES)
(HERE / "results.json").write_text(json.dumps(RES, indent=1))
print(json.dumps(RES, indent=1))
