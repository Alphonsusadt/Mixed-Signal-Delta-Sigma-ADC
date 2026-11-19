#!/usr/bin/env python3
"""cic_ref.py - bit-exact reference model of the sinc^N CIC decimator (Block 7).

Input : +-1 bitstream from the closed-loop run (bitstream.txt, one value per line).
Model : N integrators -> decimate by R -> N combs, all in W-bit two's complement
        with wrap-around (same arithmetic as rtl/cic3.v). Input mapping: bit 1 -> +1,
        bit 0 -> -1.
Output: data/*.mem files for the Verilog testbench and the FPGA ROM, plus golden
        values. Status of all numbers: SIMULATED_NOT_FINAL_PASS (one 4096-bit run).

Checks done on every run:
  1. W-bit wrap-around model == exact integer model (cumsum/diff, no wrap)
  2. model == sinc^N FIR (boxcar of length R convolved N times, sampled every R)
  3. full-scale input (all +1 / all -1) stays inside W bits
"""
import argparse
import os
import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[3]
DEF_BS = ROOT / "top_level/closed_loop/results/closed_loop/f6_sine300_b6res_n4096/bitstream.txt"


def wrap(v, w):
    v &= (1 << w) - 1
    return v - (1 << w) if v >> (w - 1) else v


def cic_bitexact(bits01, n=3, r=80, w=20):
    """Cascade form identical to the RTL: integrator i uses the NEW value of i-1."""
    ints = [0] * n
    combs = [0] * n
    out, cnt = [], 0
    for b in bits01:
        acc = 1 if b else -1
        for i in range(n):
            ints[i] = wrap(ints[i] + acc, w)
            acc = ints[i]
        if cnt == r - 1:
            cnt = 0
            v = acc
            for i in range(n):
                d = combs[i]
                combs[i] = v
                v = wrap(v - d, w)
            out.append(v)
        else:
            cnt += 1
    return out


def cic_exact(bits01, n=3, r=80):
    y = np.where(np.asarray(bits01) > 0, 1, -1).astype(np.int64)
    for _ in range(n):
        y = np.cumsum(y)
    y = y[r - 1::r]
    for _ in range(n):
        y = np.diff(y, prepend=0)
    return y


def cic_fir(bits01, n=3, r=80):
    x = np.where(np.asarray(bits01) > 0, 1, -1).astype(np.int64)
    h = np.ones(1, dtype=np.int64)
    box = np.ones(r, dtype=np.int64)
    for _ in range(n):
        h = np.convolve(h, box)
    y = np.convolve(x, h)[:x.size]
    return y[r - 1::r]


def write_set(outdir, tag, bits01, nout_bits, n, r, w):
    out = cic_bitexact(bits01[:nout_bits], n, r, w)
    pre = "" if tag == "f6" else tag + "_"
    with open(outdir / f"{pre}bitstream.mem", "w") as f:
        f.write("\n".join(str(int(b)) for b in bits01) + "\n")
    with open(outdir / f"{pre}golden.mem", "w") as f:
        f.write("\n".join(f"{v & ((1 << w) - 1):05x}" for v in out) + "\n")
    with open(outdir / f"{pre}golden.txt", "w") as f:
        f.write("\n".join(str(v) for v in out) + "\n")
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    ap.add_argument("--bitstream", default=str(DEF_BS))
    ap.add_argument("--outdir", default=str(ROOT / "blocks/07_Digital_CIC/data"))
    ap.add_argument("--n", type=int, default=3, help="CIC order")
    ap.add_argument("--r", type=int, default=80, help="decimation ratio")
    ap.add_argument("--w", type=int, default=20, help="register width")
    ap.add_argument("--nbits", type=int, default=4096, help="bits used (same 4096 as the SNDR FFT)")
    a = ap.parse_args()

    x = np.loadtxt(a.bitstream)
    bits = (x[:a.nbits] > 0).astype(int)
    if bits.size < a.nbits:
        sys.exit(f"bitstream has {bits.size} bits, need {a.nbits}")
    nout = a.nbits // a.r
    use = nout * a.r
    outdir = Path(a.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    gain = a.r ** a.n
    need_w = int(np.ceil(np.log2(gain + 1))) + 1
    print(f"CIC sinc^{a.n}, R={a.r}, W={a.w}: DC gain R^N = {gain}, minimum signed width = {need_w}")
    if a.w < need_w:
        sys.exit("W too small for full-scale input")

    out = write_set(outdir, "f6", bits, use, a.n, a.r, a.w)
    ex = cic_exact(bits[:use], a.n, a.r)
    fir = cic_fir(bits[:use], a.n, a.r)
    ok1 = np.array_equal(np.array(out), ex)
    ok2 = np.array_equal(np.array(out), fir)
    print(f"bits used {use}/{a.nbits}, outputs {len(out)}")
    print(f"check 1 wrap-around == exact integer model : {'PASS' if ok1 else 'FAIL'}")
    print(f"check 2 model == sinc^N FIR                : {'PASS' if ok2 else 'FAIL'}")

    ones = np.ones(a.nbits, dtype=int)
    zeros = np.zeros(a.nbits, dtype=int)
    o1 = write_set(outdir, "ones", ones, use, a.n, a.r, a.w)
    o0 = write_set(outdir, "zeros", zeros, use, a.n, a.r, a.w)
    ok3 = (max(o1) == gain and min(o0) == -gain and max(o1) < (1 << (a.w - 1)) and min(o0) >= -(1 << (a.w - 1)))
    print(f"check 3 full scale +-{gain} fits in {a.w} bits : {'PASS' if ok3 else 'FAIL'}")

    # sine fit on the decimated f6 output (illustrative only: ~47 points)
    y = np.array(out, dtype=float) / gain
    k0 = a.n + 1
    ys = y[k0:]
    fin_over_fsout = 13.0 / 4096.0 * a.r
    kk = np.arange(k0, k0 + ys.size)
    M = np.column_stack([np.sin(2 * np.pi * fin_over_fsout * kk), np.cos(2 * np.pi * fin_over_fsout * kk), np.ones(kk.size)])
    c, *_ = np.linalg.lstsq(M, ys, rcond=None)
    amp = float(np.hypot(c[0], c[1]))
    f = fin_over_fsout / a.r
    droop = (np.sin(np.pi * f * a.r) / (a.r * np.sin(np.pi * f))) ** a.n
    exp_amp = 0.5 * droop
    res = ys - M @ c
    print(f"sine fit (illustrative, {ys.size} points): amplitude {amp:.4f} FS; expected 0.5 x CIC droop {droop:.4f} = {exp_amp:.4f}")
    rr = float(np.sqrt(np.mean(res ** 2)))
    print(f"fit residual rms {rr:.2e} FS; signal/residual {20 * np.log10((amp / np.sqrt(2)) / rr):.1f} dB "
          f"(illustrative only: 3-parameter fit on {ys.size} points, NOT an SNDR)")
    print(f"files written to {outdir}")
    return 0 if (ok1 and ok2 and ok3) else 1


if __name__ == "__main__":
    sys.exit(main())
