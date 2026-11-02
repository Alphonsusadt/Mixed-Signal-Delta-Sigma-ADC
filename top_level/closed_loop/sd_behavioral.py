#!/usr/bin/env python3
"""
sd_behavioral.py - model perilaku modulator Sigma-Delta orde-2 SC (1 bit)
yang mengikuti struktur rangkaian STAGE1/STAGE2 + cabang sampling DAC.

Struktur yang dimodelkan (semua tahap sampling di PHI1, transfer di PHI2,
dua integrator inverting, quantizer membaca selisih out2_p - out2_n):

    y1[n+1] = al1*y1[n] - a1*u[n]  + b1*v[n]         a1=Cs1/Cf1, b1=Cd1/Cf1  (DAC BERTUKAR sisi)
    y2[n+1] = al2*y2[n] - a2*y1[n] - b2*v[n]         a2=Cs2/Cf2, b2=Cd2/Cf2  (DAC TIDAK bertukar)
    v[n+1]  = +VREF_D jika y2[n+1] + vos >= 0 else -VREF_D

Polaritas (hasil turunan + uji numerik): dua integrator inverting. Tahap 1:
cabang DAC menyampel DAC_N ke sisi P dan DAC_P ke sisi N (tanda +b1*v).
Tahap 2: cabang DAC menyampel DAC_P ke sisi P dan DAC_N ke sisi N (tanda
-b2*v). Jika tahap 2 juga bertukar, umpan balik ke I2 positif dan loop
tidak stabil. y1 memakai y1[n] (bukan y1[n+1])
karena STAGE2 menyampel di PHI1 sebelum STAGE1 mentransfer di PHI2.

Ini model ideal + non-idealitas sederhana (kT/C, gain OTA hingga, settling,
offset komparator). BUKAN pengganti simulasi transistor-level.
"""
import argparse
import csv
import json
import math
import os

import numpy as np

K_B = 1.380649e-23


def kt_over_c_sigma(c_farad, temp_k=300.15):
    """sigma (V rms) kT/C untuk satu kapasitor sampling single-ended."""
    return math.sqrt(K_B * temp_k / c_farad)


def simulate(u, a1=0.5, a2=0.5, b1=0.5, b2=0.5, vref_d=0.6,
             cs1=None, cd1=None, cs2=None, cd2=None, noise_mult=2.0, temp_k=300.15,
             a0_db=None, settle_err=0.0, vos=0.0, ylim=None, seed=1):
    """Simulasikan loop. u: array tegangan input diferensial (V).

    Noise kT/C (opsional): jika cs*/cd* diberikan (F), variansi diferensial per
    sampel = noise_mult * 2 * kT / C (faktor 2: sisi P dan N; noise_mult: asumsi
    kasar untuk kontribusi fase integrasi/OTA, default 2).
    Return dict: bits (+1/-1), y1, y2, overload_index (None jika stabil).
    """
    u = np.asarray(u, dtype=float)
    n_samp = u.size
    rng = np.random.default_rng(seed)

    def noise(c):
        if c is None:
            return np.zeros(n_samp)
        sig = math.sqrt(noise_mult * 2.0 * K_B * temp_k / c)
        return rng.normal(0.0, sig, n_samp)

    ns1, nd1, ns2, nd2 = noise(cs1), noise(cd1), noise(cs2), noise(cd2)

    if a0_db is None:
        al1 = al2 = 1.0
        g1 = g2 = 1.0
    else:
        a0 = 10 ** (a0_db / 20.0)
        al1 = 1.0 - (1.0 + a1 + b1) / a0
        al2 = 1.0 - (1.0 + a2 + b2) / a0
        g1 = al1
        g2 = al2
    g1 *= (1.0 - settle_err)
    g2 *= (1.0 - settle_err)

    bits = np.empty(n_samp)
    y1a = np.empty(n_samp)
    y2a = np.empty(n_samp)
    y1 = 0.0
    y2 = 0.0
    bit = 1.0
    overload = None
    for n in range(n_samp):
        v = vref_d * bit
        y1n = al1 * y1 + g1 * (-a1 * (u[n] + ns1[n]) + b1 * (v + nd1[n]))
        y2n = al2 * y2 + g2 * (-a2 * (y1 + ns2[n]) - b2 * (v + nd2[n]))
        y1, y2 = y1n, y2n
        bit = 1.0 if (y2 + vos) >= 0.0 else -1.0
        bits[n] = bit
        y1a[n] = y1
        y2a[n] = y2
        if overload is None and ylim is not None and (abs(y1) > ylim or abs(y2) > ylim):
            overload = n
    return dict(bits=bits, y1=y1a, y2=y2a, overload_index=overload)


def coherent_sine(n_samp, bin_m, amp_d, vcm=0.0):
    k = np.arange(n_samp)
    return vcm + amp_d * np.sin(2 * np.pi * bin_m * k / n_samp)


def sndr_from_bits(bits, osr=80, fin_bin=13, sig_half=3, skip_low=3, window="hann"):
    """SNDR in-band dari bitstream +/-1 (sampling koheren). Return dict (dB)."""
    x = np.asarray(bits, dtype=float)
    n_samp = x.size
    x = x - x.mean()
    if window == "hann":
        w = np.hanning(n_samp)
    else:
        w = np.ones(n_samp)
    spec = np.fft.rfft(x * w)
    p = (np.abs(spec) ** 2)
    nb = n_samp // (2 * osr)          # bin batas pita
    sig_bins = np.arange(fin_bin - sig_half, fin_bin + sig_half + 1)
    psig = p[sig_bins].sum()
    band = np.arange(skip_low, nb + 1)
    mask = np.ones(band.size, dtype=bool)
    mask[np.isin(band, sig_bins)] = False
    pnoise = p[band[mask]].sum()
    # koreksi bin rendah yang dilewati (kira-kira, noise ~ f^4 jadi kecil)
    sndr = 10 * math.log10(psig / pnoise) if pnoise > 0 else float("inf")
    return dict(sndr_db=sndr, enob=(sndr - 1.76) / 6.02, nb=nb, psig=psig, pnoise=pnoise)


def amplitude_sweep(params, amps_dbfs, n_samp=2 ** 15, osr=80, fin_bin=13, vref_d=0.6, **sim_kw):
    rows = []
    for a_db in amps_dbfs:
        amp = vref_d * 10 ** (a_db / 20.0)
        u = coherent_sine(n_samp, fin_bin, amp)
        r = simulate(u, vref_d=vref_d, **params, **sim_kw)
        s = sndr_from_bits(r["bits"], osr=osr, fin_bin=fin_bin)
        rows.append(dict(amp_dbfs=a_db, sndr_db=s["sndr_db"],
                         y1_pk=float(np.max(np.abs(r["y1"]))), y2_pk=float(np.max(np.abs(r["y2"])))))
    return rows


def dynamic_range(rows, a_max_dbfs):
    """DR = A_max - A(SNR=0 dB), dengan A(SNR=0) diekstrapolasi dari daerah linier (SNR<60 dB)."""
    lin = [r for r in rows if r["sndr_db"] < 60 and r["sndr_db"] > 5]
    if len(lin) < 2:
        return None
    k = np.mean([r["sndr_db"] - r["amp_dbfs"] for r in lin])
    a_zero = -k
    return dict(dr_db=a_max_dbfs - a_zero, k=float(k), a_zero_dbfs=float(a_zero))


def main():
    ap = argparse.ArgumentParser(description="Model perilaku Sigma-Delta orde-2 (mengikuti STAGE1/STAGE2)")
    ap.add_argument("--n", type=int, default=2 ** 15)
    ap.add_argument("--osr", type=int, default=80)
    ap.add_argument("--bin", type=int, default=13)
    ap.add_argument("--amp-dbfs", type=float, default=-6.0)
    ap.add_argument("--a1", type=float, default=0.5)
    ap.add_argument("--a2", type=float, default=0.5)
    ap.add_argument("--b1", type=float, default=0.5)
    ap.add_argument("--b2", type=float, default=0.5)
    ap.add_argument("--vref-d", type=float, default=0.6)
    ap.add_argument("--cs", type=float, default=None, help="Cs=Cd (F) untuk noise kT/C, semua tahap")
    ap.add_argument("--a0-db", type=float, default=None)
    ap.add_argument("--settle-err", type=float, default=0.0)
    ap.add_argument("--vos", type=float, default=0.0)
    ap.add_argument("--sweep", action="store_true", help="sapuan amplitudo + estimasi DR")
    ap.add_argument("--out", default="results")
    args = ap.parse_args()

    params = dict(a1=args.a1, a2=args.a2, b1=args.b1, b2=args.b2,
                  cs1=args.cs, cd1=args.cs, cs2=args.cs, cd2=args.cs,
                  a0_db=args.a0_db, settle_err=args.settle_err, vos=args.vos)
    os.makedirs(args.out, exist_ok=True)
    amp = args.vref_d * 10 ** (args.amp_dbfs / 20.0)
    u = coherent_sine(args.n, args.bin, amp)
    r = simulate(u, vref_d=args.vref_d, **params)
    s = sndr_from_bits(r["bits"], osr=args.osr, fin_bin=args.bin)
    print(f"amp={args.amp_dbfs:.1f} dBFS ({amp*1e3:.1f} mV diff pk)  SNDR={s['sndr_db']:.1f} dB  "
          f"ENOB={s['enob']:.2f}  |y1|pk={np.max(np.abs(r['y1'])):.3f} V  |y2|pk={np.max(np.abs(r['y2'])):.3f} V")
    if args.sweep:
        amps = list(range(-90, -2, 4)) + [-3]
        rows = amplitude_sweep({k: v for k, v in params.items()}, amps, n_samp=args.n, osr=args.osr,
                               fin_bin=args.bin, vref_d=args.vref_d)
        best = max(rows, key=lambda x: x["sndr_db"])
        dr = dynamic_range(rows, a_max_dbfs=best["amp_dbfs"])
        with open(os.path.join(args.out, "behavioral_sweep.csv"), "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
        print(f"peak SNDR={best['sndr_db']:.1f} dB @ {best['amp_dbfs']} dBFS; DR (ekstrapolasi)={dr['dr_db']:.1f} dB" if dr else "DR: data tidak cukup")
        with open(os.path.join(args.out, "behavioral_summary.json"), "w") as f:
            json.dump(dict(params=params, peak=best, dr=dr), f, indent=2, default=str)


if __name__ == "__main__":
    main()
