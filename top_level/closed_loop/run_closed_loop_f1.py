#!/usr/bin/env python3
"""
run_closed_loop.py - generator deck, pengecek statis, runner ngspice, dan analisis
bitstream untuk loop tertutup Sigma-Delta orde-2 (STAGE1 + STAGE2 + StrongARM +
SR latch + DAC 1-bit + cabang sampling umpan balik).

Alur aman (sesuai dossier: satu langkah per eksperimen):
  1) python3 run_closed_loop.py --check                 # statis, tanpa ngspice
  2) python3 run_closed_loop.py --run --cycles 24 --reset-us 2 --dc-mv 0   # smoke
  3) python3 run_closed_loop.py --run --cycles 512 --dc-mv 100             # tes DC
  4) python3 run_closed_loop.py --run --cycles 4096 --amp-mv 300 --bin 13  # sinus
  5) python3 run_closed_loop.py --analyze results/<run>/waveform.dat ...   # ulang analisis

Status hasil memakai label dossier: NOT_RUN, CHECK_FAILED, SIMULATION_FAILED,
SIMULATED_NOT_FINAL_PASS. Skrip ini TIDAK PERNAH menulis PASS.

STATUS SKRIP: bagian ngspice belum pernah dieksekusi (sandbox pembuat tidak punya
ngspice/PDK). --check dan --selftest sudah dijalankan. Jalankan langkah (2) dulu.
"""
import argparse
import datetime
import json
import math
import os
import re
import shutil
import subprocess
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
SPICE_DIR = os.path.join(HERE, "spice")
DEFAULT_PDK = "/foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice"

# ----------------------------------------------------------------------------
# Konfigurasi
# ----------------------------------------------------------------------------


def make_parser():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--check", action="store_true", help="pemeriksaan statis deck/netlist (tanpa ngspice)")
    g.add_argument("--run", action="store_true", help="bangun deck lalu jalankan ngspice")
    g.add_argument("--analyze", metavar="WAVEFORM", help="analisis ulang file waveform .dat")
    g.add_argument("--selftest", action="store_true", help="uji jalur parser/analisis dengan waveform sintetis")
    ap.add_argument("--name", default=None, help="nama run (default: timestamp)")
    ap.add_argument("--outroot", default=os.path.join(HERE, "results", "closed_loop"))
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--pdk-lib", default=DEFAULT_PDK)
    ap.add_argument("--corner", default="tt")
    ap.add_argument("--temp", type=float, default=27.0)
    ap.add_argument("--vdd", type=float, default=1.8)
    ap.add_argument("--vcm", type=float, default=0.9)
    ap.add_argument("--vrefp", type=float, default=1.2)
    ap.add_argument("--vrefn", type=float, default=0.6)
    # bias: default = nilai testbench I2 (kalibrasi stage-2). Untuk stage-1 belum diverifikasi.
    ap.add_argument("--vbias1", type=float, default=0.58)
    ap.add_argument("--vbias2", type=float, default=0.58)
    ap.add_argument("--vcs1", type=float, default=0.925908120449107)
    ap.add_argument("--vcs2", type=float, default=0.925908120449107)
    ap.add_argument("--vcms1", type=float, default=0.60354572, help="vcm_stage1 stage 1")
    ap.add_argument("--vcms2", type=float, default=0.60354572, help="vcm_stage1 stage 2")
    ap.add_argument("--vbz", type=float, default=1.8)
    ap.add_argument("--fb2", choices=["swap", "straight"], default="swap",
                    help="polaritas cabang DAC stage 2. smoke2 (straight) = umpan balik positif di I2; default swap")
    ap.add_argument("--cd1", default="1p", help="kapasitor sampling DAC stage 1 (b1 = Cd1/Cf1)")
    ap.add_argument("--cd2", default="1p", help="kapasitor sampling DAC stage 2 (b2 = Cd2/Cf2)")
    # waktu (default = timing testbench I2/4E)
    ap.add_argument("--period-ns", type=float, default=250.0)
    ap.add_argument("--phi1-delay-ns", type=float, default=30.0)
    ap.add_argument("--phi2-delay-ns", type=float, default=155.0)
    ap.add_argument("--phi-width-ns", type=float, default=110.0)
    ap.add_argument("--clk-delay-ns", type=float, default=20.0, help="tepi naik komparator (relatif periode)")
    ap.add_argument("--clk-width-ns", type=float, default=110.0)
    ap.add_argument("--edge-ns", type=float, default=1.0)
    ap.add_argument("--phi-source", choices=["ideal", "block6"], default="ideal",
                    help="ideal = sumber PULSE (baseline); block6 = B6_NONOV nyata (F1). clk/rst tetap ideal")
    ap.add_argument("--b6-spice", default=os.path.join(HERE, "spice", "b6_nonov.spice"),
                    help="subckt Blok 6 hasil tools/extract_b6_subckts.py")
    ap.add_argument("--b6-vbn", type=float, default=0.70, help="VBN ideal (provisional)")
    ap.add_argument("--b6-vbp", type=float, default=0.71, help="VBP ideal (provisional, dari VBP_MATCH)")
    ap.add_argument("--clk-source", choices=["ideal", "phi2b-chain"], default="ideal",
                    help="ideal = VCLK PULSE (baseline); phi2b-chain = clk komparator dari phi2b lewat N x B6_INV (F5; perlu --phi-source block6)")
    ap.add_argument("--clk-chain", type=int, default=2, help="jumlah B6_INV (genap) pada rantai clk (F5)")
    ap.add_argument("--b6-clk-delay-ns", type=float, default=15.6,
                    help="CLK master turun pada t (phi1 aktif saat CLK rendah); 15.6 -> phi1 naik ~30 ns")
    ap.add_argument("--b6-clk-low-ns", type=float, default=124.0, help="lebar CLK rendah (master)")
    ap.add_argument("--read-ns", type=float, default=60.0, help="Q dibaca t_clk + read-ns")
    ap.add_argument("--reset-us", type=float, default=20.0, help="durasi precharge (belum disahkan sebagai syarat desain)")
    ap.add_argument("--cycles", type=int, default=64, help="jumlah siklus setelah reset dilepas")
    ap.add_argument("--tmax", default="100p")
    ap.add_argument("--tstep", default="1n", help="grid linearize/wrdata")
    ap.add_argument("--no-linearize", action="store_true")
    ap.add_argument("--save-min", action="store_true",
                    help="simpan hanya q, o1_p/n, o2_p/n, phi1, phi2, clk (hemat RAM; rangkaian & solver tidak berubah)")
    # stimulus
    ap.add_argument("--dc-mv", type=float, default=None, help="input diferensial DC (mV)")
    ap.add_argument("--amp-mv", type=float, default=None, help="amplitudo sinus diferensial puncak (mV)")
    ap.add_argument("--bin", type=int, default=13, help="bin koheren; fin = bin/(n_fft*T)")
    # analisis
    ap.add_argument("--osr", type=int, default=80)
    ap.add_argument("--warmup", type=int, default=16, help="siklus dibuang setelah reset dilepas")
    ap.add_argument("--vref-d", type=float, default=0.6)
    ap.add_argument("--model", action="store_true", help="bandingkan dengan model perilaku (a=b=0.5)")
    return ap


# ----------------------------------------------------------------------------
# Generator deck
# ----------------------------------------------------------------------------

def fmt_t(sec):
    return f"{sec:.6e}"


def n_fft_of(cfg):
    """n_fft = pangkat dua terbesar <= cycles - warmup."""
    avail = max(cfg.cycles - cfg.warmup, 0)
    return 1 << (avail.bit_length() - 1) if avail >= 1 else 0


def timing(cfg):
    T = cfg.period_ns * 1e-9
    t_rst = cfg.reset_us * 1e-6
    tstop = t_rst + cfg.cycles * T + T
    return T, t_rst, tstop


def b6_pins(path, sub="B6_NONOV"):
    """Urutan pin subckt Blok 6 dibaca dari baris .subckt netlist (huruf kecil)."""
    if not os.path.exists(path):
        raise SystemExit(f"{path} tidak ada; jalankan tools/extract_b6_subckts.py dulu")
    for ln in open(path, errors="replace"):
        t = ln.split()
        if len(t) > 2 and t[0].lower() == ".subckt" and t[1].lower() == sub.lower():
            return [x.lower() for x in t[2:] if "=" not in x]
    raise SystemExit(f"subckt {sub} tidak ditemukan di " + path)


def build_deck(cfg):
    T, t_rst, tstop = timing(cfg)
    ns = 1e-9
    edge = cfg.edge_ns * ns
    sp = SPICE_DIR
    n_fft = n_fft_of(cfg)

    if cfg.amp_mv is not None:
        if n_fft < 1:
            raise SystemExit("cycles terlalu kecil untuk mode sinus (cycles > warmup)")
        # sinus koheren terhadap jendela analisis: n_fft siklus -> bin periode
        fin = cfg.bin / (n_fft * T)
        a = cfg.amp_mv * 1e-3 / 2.0
        td = t_rst + cfg.warmup * T
        vinp = f"SIN({cfg.vcm} {a} {fin:.9e} {fmt_t(td)})"
        vinn = f"SIN({cfg.vcm} {-a} {fin:.9e} {fmt_t(td)})"
        stim = f"sinus diferensial {cfg.amp_mv} mV pk, fin={fin:.6e} Hz (bin {cfg.bin}/{n_fft})"
    else:
        dc = (cfg.dc_mv if cfg.dc_mv is not None else 0.0) * 1e-3
        vinp = f"DC {cfg.vcm + dc / 2.0}"
        vinn = f"DC {cfg.vcm - dc / 2.0}"
        stim = f"DC diferensial {dc * 1e3} mV"

    def pulse(lo, hi, delay_ns, width_ns):
        return (f"PULSE({lo} {hi} {fmt_t(delay_ns * ns)} {fmt_t(edge)} {fmt_t(edge)} "
                f"{fmt_t(width_ns * ns)} {fmt_t(T)})")

    save = ("v(q) v(qb) v(dac_p) v(dac_n) v(clk) v(phi1) v(phi2) v(cmp_p) v(cmp_n) "
            "v(o1_p) v(o1_n) v(o2_p) v(o2_n) v(s1_p) v(s1_n) v(s2_p) v(s2_n) "
            "v(vcmfb_1) v(vcmfb_2) v(vo1a_1) v(vo1b_1) v(vo1a_2) v(vo1b_2)")
    names = ["q", "qb", "dac_p", "dac_n", "clk", "phi1", "phi2", "cmp_p", "cmp_n",
             "o1_p", "o1_n", "o2_p", "o2_n", "s1_p", "s1_n", "s2_p", "s2_n",
             "vcmfb_1", "vcmfb_2", "vo1a_1", "vo1b_1", "vo1a_2", "vo1b_2"]
    if cfg.save_min:
        names = ["q", "o1_p", "o1_n", "o2_p", "o2_n", "phi1", "phi2", "clk"]
        save = " ".join(f"v({n})" for n in names)
    wr = " ".join(f"v({n})" for n in names)

    if cfg.phi_source == "block6":
        pins = b6_pins(cfg.b6_spice)
        conn = {"clk": "clkm", "phi1": "phi1", "phi1b": "phi1b", "phi2": "phi2", "phi2b": "phi2b",
                "vdd": "vdd", "gnd": "0", "vbp": "vbp_b6", "vbn": "vbn_b6"}
        miss = [p for p in pins if p not in conn]
        if miss:
            raise SystemExit(f"pin B6_NONOV tak dikenal: {miss} (pin netlist: {pins})")
        b6_inc = f".include {os.path.abspath(cfg.b6_spice)}\n"
        phi_block = (f"* ---- phi dari Blok 6 (F1): master CLK ideal -> B6_NONOV; bias ideal ----\n"
                     f"VCLKM clkm 0 PULSE({cfg.vdd} 0 {fmt_t(cfg.b6_clk_delay_ns * ns)} {fmt_t(edge)} {fmt_t(edge)} "
                     f"{fmt_t(cfg.b6_clk_low_ns * ns)} {fmt_t(T)})\n"
                     f"VVBN vbn_b6 0 {cfg.b6_vbn}\nVVBP vbp_b6 0 {cfg.b6_vbp}\n"
                     f"XNONOV {' '.join(conn[p] for p in pins)} B6_NONOV\n")
    else:
        b6_inc = ""
        phi_block = (f"VPHI1 phi1 0 {pulse(0, cfg.vdd, cfg.phi1_delay_ns, cfg.phi_width_ns)}\n"
                     f"VPHI1B phi1b 0 {pulse(cfg.vdd, 0, cfg.phi1_delay_ns, cfg.phi_width_ns)}\n"
                     f"VPHI2 phi2 0 {pulse(0, cfg.vdd, cfg.phi2_delay_ns, cfg.phi_width_ns)}\n"
                     f"VPHI2B phi2b 0 {pulse(cfg.vdd, 0, cfg.phi2_delay_ns, cfg.phi_width_ns)}\n")

    if cfg.clk_source == "phi2b-chain":
        if cfg.phi_source != "block6" or cfg.clk_chain < 2 or cfg.clk_chain % 2:
            raise SystemExit("--clk-source phi2b-chain butuh --phi-source block6 dan --clk-chain genap >= 2")
        pi = b6_pins(cfg.b6_spice, "B6_INV")
        chain, prev = "", "phi2b"
        for k in range(1, cfg.clk_chain + 1):
            nxt = "clk" if k == cfg.clk_chain else f"clkc{k}"
            mp = {"in": prev, "out": nxt, "vdd": "vdd", "gnd": "0"}
            bad = [x for x in pi if x not in mp]
            if bad:
                raise SystemExit(f"pin B6_INV tak dikenal: {bad} (pin netlist: {pi})")
            chain += f"XCI{k} " + " ".join(mp[x] for x in pi) + " B6_INV\n"
            prev = nxt
        clk_block = (f"* ---- clk komparator dari phi2b via {cfg.clk_chain} x B6_INV (F5) ----\n" + chain)
    else:
        clk_block = f"VCLK clk 0 {pulse(0, cfg.vdd, cfg.clk_delay_ns, cfg.clk_width_ns)}\n"

    lin = "" if cfg.no_linearize else "linearize\n"
    deck = f"""* closed-loop Sigma-Delta orde-2 (dibangkitkan run_closed_loop.py)
* stimulus : {stim}
* STATUS   : SIMULATED_NOT_FINAL_PASS bila selesai; tidak ada kriteria pass/fail final.
* bias default = nilai testbench I2 (dikalibrasi untuk stage-2); stage-1 BELUM diverifikasi.

.option scale=1e-6
.option reltol=1e-5 vntol=1e-8 abstol=1e-13
.temp {cfg.temp}
.lib {cfg.pdk_lib} {cfg.corner}

.param cd1={cfg.cd1} cd2={cfg.cd2}

.include {sp}/stage1_core.spice
.include {sp}/stage2_core.spice
.include {sp}/blocks_quantizer_dac.spice
.include {sp}/fb_sampler.spice
{b6_inc}
* ---- supply / referensi / bias ----
VDD vdd 0 {cfg.vdd}
VCM vcm 0 {cfg.vcm}
VREFP vrefp 0 {cfg.vrefp}
VREFN vrefn 0 {cfg.vrefn}
VBIAS1 vbias1 0 {cfg.vbias1}
VBIAS2 vbias2 0 {cfg.vbias2}
VCS1 vcs1 0 {cfg.vcs1}
VCS2 vcs2 0 {cfg.vcs2}
VCMS1 vcms1 0 {cfg.vcms1}
VCMS2 vcms2 0 {cfg.vcms2}
VBZL vbz_l 0 {cfg.vbz}
VBZR vbz_r 0 {cfg.vbz}

* ---- clock (ideal), reset ----
{phi_block}{clk_block}VRST rst 0 PWL(0 {cfg.vdd} {fmt_t(t_rst)} {cfg.vdd} {fmt_t(t_rst + 1e-9)} 0 {fmt_t(tstop)} 0)
VRSTB rstb 0 PWL(0 0 {fmt_t(t_rst)} 0 {fmt_t(t_rst + 1e-9)} {cfg.vdd} {fmt_t(tstop)} {cfg.vdd})

* ---- input diferensial ----
VINP vin_p 0 {vinp}
VINN vin_n 0 {vinn}

* ---- integrator ----
X1 vin_p vin_n o1_p o1_n s1_p s1_n vo1a_1 vo1b_1 vcmfb_1 vdd vcm vbias1 vbz_l vbz_r vcs1 vcms1 phi1 phi1b phi2 phi2b rst rstb STAGE1
X2 o1_p o1_n o2_p o2_n s2_p s2_n vo1a_2 vo1b_2 vcmfb_2 vdd vcm vbias2 vbz_l vbz_r vcs2 vcms2 phi1 phi1b phi2 phi2b rst rstb STAGE2

* ---- umpan balik DAC -> node sum (tanda: lihat README) ----
XFB1 dac_p dac_n s1_p s1_n vcm phi1 phi1b phi2 phi2b vdd 0 FB_SAMP_SWAP
XFB2 dac_p dac_n s2_p s2_n vcm phi1 phi1b phi2 phi2b vdd 0 {'FB_SAMP_SWAP' if cfg.fb2 == 'swap' else 'FB_SAMP_STRAIGHT'}

* ---- quantizer -> latch -> DAC (blok 4E apa adanya) ----
XCMP vdd clk cmp_p cmp_n o2_p o2_n 0 StrongARM
XBP vdd cmp_p p_buf 0 BUF_B01
XBN vdd cmp_n n_buf 0 BUF_B01
XSR p_buf n_buf q qb 0 vdd SR_Latch
XDAC vrefp vrefn q qb vdd 0 dac_p dac_n DAC_1bit

.nodeset v(q)=0 v(qb)={cfg.vdd}
.save {save}

.control
set wr_singlescale
set wr_vecnames
set numdgt=10
tran {cfg.tstep} {fmt_t(tstop)} 0 {cfg.tmax}
{lin}wrdata waveform.dat {wr}
echo CLOSED_LOOP_RUN_DONE
.endc

.end
"""
    return deck, names


# ----------------------------------------------------------------------------
# Pengecek statis (parser SPICE mini)
# ----------------------------------------------------------------------------

PRIMITIVE_PINS = (("sky130_fd_pr__nfet", 4), ("sky130_fd_pr__pfet", 4), ("sky130_fd_pr__cap_mim", 2))


def read_logical_lines(path, seen=None, out_includes=None):
    """Baca file, gabung baris lanjutan '+', buang komentar; ikuti .include (relatif/absolut)."""
    seen = seen if seen is not None else set()
    real = os.path.realpath(path)
    if real in seen:
        return []
    seen.add(real)
    lines = []
    with open(path, errors="replace") as f:
        raw = f.read().splitlines()
    cur = None
    for ln in raw:
        s = ln.rstrip()
        if not s.strip():
            continue
        if s.lstrip().startswith("*"):
            continue
        if s.startswith("+") and cur is not None:
            cur += " " + s[1:].strip()
            continue
        if cur is not None:
            lines.append(cur)
        cur = s.strip()
    if cur is not None:
        lines.append(cur)
    expanded = []
    for ln in lines:
        m = re.match(r"^\.include\s+(\S+)", ln, re.I)
        if m:
            inc = m.group(1).strip("\"'")
            if not os.path.isabs(inc):
                inc = os.path.join(os.path.dirname(path), inc)
            if out_includes is not None:
                out_includes.append(inc)
            if os.path.exists(inc):
                expanded += read_logical_lines(inc, seen, out_includes)
            else:
                expanded.append(f".missing_include {inc}")
        else:
            expanded.append(ln)
    return expanded


def split_params(tokens):
    """Pisahkan token jadi (positional, params) pada 'params:' atau token pertama ber-'='."""
    for i, t in enumerate(tokens):
        if t.lower() == "params:" or "=" in t:
            return tokens[:i], tokens[i:]
    return tokens, []


def parse_design(lines):
    subckts = {}
    top = []
    cur = None
    for ln in lines:
        low = ln.lower()
        if low.startswith(".subckt"):
            toks = ln.split()
            pos, _ = split_params(toks[2:])
            cur = dict(name=toks[1].lower(), pins=[p.lower() for p in pos], insts=[], elems=[])
            subckts[cur["name"]] = cur
            continue
        if low.startswith(".ends"):
            cur = None
            continue
        if low.startswith("."):
            top.append(("dot", ln))
            continue
        target = cur["insts"] if cur is not None else top
        toks = ln.split()
        c = toks[0][0].lower()
        if c == "x":
            pos, _ = split_params(toks[1:])
            model = pos[-1].lower()
            pins = [p.lower() for p in pos[:-1]]
            (cur["insts"] if cur is not None else top).append(("x", toks[0], pins, model))
        elif c in "rcvil":
            nodes = [t.lower() for t in toks[1:3]]
            (cur["elems"] if cur is not None else top).append((c, toks[0], nodes))
    return subckts, top


def static_check(deck_path, pdk_lib=None):
    problems, warns, info = [], [], []
    includes = []
    lines = read_logical_lines(deck_path, out_includes=includes)
    for ln in lines:
        if ln.startswith(".missing_include"):
            problems.append(f"include tidak ditemukan: {ln.split(None, 1)[1]}")
    subckts, top = parse_design(lines)
    info.append(f"{len(subckts)} subckt terdefinisi: " + ", ".join(sorted(subckts)))

    def prim_pins(model):
        for pref, n in PRIMITIVE_PINS:
            if model.startswith(pref):
                return n
        return None

    def check_insts(owner, insts):
        for item in insts:
            _, iname, pins, model = item
            exp = prim_pins(model)
            if exp is None and model in subckts:
                exp = len(subckts[model]["pins"])
            if exp is None:
                problems.append(f"{owner}: {iname} memanggil subckt tidak terdefinisi '{model}'")
            elif exp != len(pins):
                problems.append(f"{owner}: {iname} -> {model}: {len(pins)} pin diberikan, {exp} diharapkan")

    for sc in subckts.values():
        check_insts(f"subckt {sc['name']}", sc["insts"])
    top_x = [t for t in top if t[0] == "x"]
    check_insts("top", top_x)

    # konektivitas: node dengan satu sambungan (non-port)
    def connectivity(owner, ports, insts, elems, exempt=()):
        cnt = {}
        for _, iname, pins, model in insts:
            for p in pins:
                cnt[p] = cnt.get(p, 0) + 1
        for _, ename, nodes in elems:
            for p in nodes:
                cnt[p] = cnt.get(p, 0) + 1
        for p in ports:
            cnt[p] = cnt.get(p, 0) + 1   # sambungan dari luar
        for n, k in sorted(cnt.items()):
            if n in ("0", "gnd!") or n in exempt:
                continue
            if k == 1:
                warns.append(f"{owner}: node '{n}' hanya punya satu sambungan")
        for p in ports:
            inside = sum(1 for _, _, pins, _ in insts for q in pins if q == p) + \
                     sum(1 for _, _, nodes in elems for q in nodes if q == p)
            if inside == 0:
                warns.append(f"{owner}: port '{p}' tidak dipakai di dalam subckt")

    for sc in subckts.values():
        connectivity(f"subckt {sc['name']}", sc["pins"], sc["insts"], sc["elems"])
    saved = set()
    for item in top:
        kind, ln = item[0], item[1]
        if kind == "dot" and ln.lower().startswith(".save"):
            saved |= set(re.findall(r"v\((\w+)\)", ln.lower()))
    top_elems = [t for t in top if t[0] in tuple("rcvil")]
    connectivity("top", [], top_x, top_elems, exempt=saved)

    if pdk_lib and not os.path.exists(pdk_lib):
        warns.append(f"PDK .lib tidak ada di mesin ini: {pdk_lib} (periksa path di lingkungan simulasi Anda)")
    return problems, warns, info


# ----------------------------------------------------------------------------
# Parser waveform & analisis
# ----------------------------------------------------------------------------

def read_wrdata(path):
    """Baca wrdata (wr_singlescale, wr_vecnames). Return (t, {nama: array})."""
    with open(path, errors="replace") as f:
        first = f.readline().split()
    has_header = any(re.search(r"[A-Za-z]", tok) and not re.fullmatch(r"[-+0-9.eE]+", tok) for tok in first)
    data = np.loadtxt(path, skiprows=1 if has_header else 0)
    if has_header:
        names = []
        for tok in first:
            m = re.fullmatch(r"v\((.+)\)", tok.lower())
            names.append(m.group(1) if m else tok.lower())
    else:
        names = ["time"] + [f"col{i}" for i in range(1, data.shape[1])]
    t = data[:, 0]
    cols = {}
    for i, n in enumerate(names[1:], start=1):
        if n == "time":
            continue
        cols[n] = data[:, i]
    return t, cols


def sample_bits(t, q, cfg, t_rst):
    """Ambil bit +/-1 dari Q pada t = clk_delay + k*T + read, k=1.. , dibuang sebelum warmup."""
    T = cfg.period_ns * 1e-9
    k0 = int(math.ceil((t_rst + cfg.warmup * T - cfg.clk_delay_ns * 1e-9) / T))
    ks, vals = [], []
    k = max(k0, 1)
    while True:
        ts = cfg.clk_delay_ns * 1e-9 + k * T + cfg.read_ns * 1e-9
        if ts > t[-1]:
            break
        ks.append(k)
        vals.append(np.interp(ts, t, q))
        k += 1
    vals = np.array(vals)
    thr = 0.5 * (vals.max() + vals.min()) if len(vals) else 0.9
    return np.array(ks), np.where(vals > thr, 1.0, -1.0), vals


def analyze(t, cols, cfg, outdir=None):
    T, t_rst, tstop = timing(cfg)
    res = {}
    ks, bits, qraw = sample_bits(t, cols["q"], cfg, t_rst)
    res["n_bits"] = int(bits.size)
    if bits.size:
        res["mean_bit"] = float(bits.mean())
        res["mean_dac_diff_v"] = float(bits.mean() * cfg.vref_d)
        res["transitions_per_100"] = float(100.0 * np.mean(bits[1:] != bits[:-1])) if bits.size > 1 else 0.0
        res["q_levels_ok"] = bool(np.all((qraw < 0.2 * cfg.vdd) | (qraw > 0.8 * cfg.vdd)))
    win = t > (t_rst + cfg.warmup * T)
    for stage, (p, n) in {"I1": ("o1_p", "o1_n"), "I2": ("o2_p", "o2_n")}.items():
        if p in cols and n in cols and win.any():
            cm = 0.5 * (cols[p] + cols[n])[win]
            df = (cols[p] - cols[n])[win]
            res[stage] = dict(cm_mean=float(cm.mean()), cm_min=float(cm.min()), cm_max=float(cm.max()),
                              diff_min=float(df.min()), diff_max=float(df.max()), diff_mean=float(df.mean()))
    if cfg.dc_mv is not None and "mean_bit" in res:
        res["dc_expected_dac_diff_v"] = cfg.dc_mv * 1e-3   # a1=b1 -> v_mean = u
    n_fft = n_fft_of(cfg)
    if cfg.amp_mv is not None and n_fft and bits.size >= n_fft:
        from sd_behavioral import sndr_from_bits
        nb = n_fft // (2 * cfg.osr)
        seg = bits[:n_fft]
        if nb >= 8:
            s = sndr_from_bits(seg, osr=cfg.osr, fin_bin=cfg.bin)
            res["sndr_db"] = float(s["sndr_db"]); res["enob"] = float(s["enob"])
            res["osr"] = cfg.osr
        else:
            res["sndr_note"] = (f"n_fft={n_fft}, OSR={cfg.osr}: hanya {nb} bin dalam pita; terlalu sedikit. "
                                f"Perbesar --cycles atau turunkan --osr untuk uji fungsional.")
    if cfg.model and cfg.amp_mv is not None and n_fft:
        from sd_behavioral import simulate, coherent_sine, sndr_from_bits
        u = coherent_sine(n_fft, cfg.bin, cfg.amp_mv * 1e-3 / 2.0 * 2.0 / 2.0 * 1.0)
        # amplitudo diferensial puncak = amp_mv (bukan amp_mv/2)
        u = coherent_sine(n_fft, cfg.bin, cfg.amp_mv * 1e-3)
        r = simulate(u, a1=0.5, a2=0.5, b1=0.5, b2=0.5, vref_d=cfg.vref_d)
        nb = n_fft // (2 * cfg.osr)
        if nb >= 8:
            res["model_sndr_db"] = float(sndr_from_bits(r["bits"], osr=cfg.osr, fin_bin=cfg.bin)["sndr_db"])
        res["model_mean_bit"] = float(r["bits"].mean())
    res["status"] = "SIMULATED_NOT_FINAL_PASS"
    if outdir:
        np.savetxt(os.path.join(outdir, "bitstream.txt"), bits, fmt="%d")
    return res, bits


# ----------------------------------------------------------------------------
# Mode
# ----------------------------------------------------------------------------

def new_run_dir(cfg):
    name = cfg.name or datetime.datetime.now().strftime("run_%Y%m%d_%H%M%S")
    d = os.path.join(cfg.outroot, name)
    os.makedirs(d, exist_ok=True)
    return d


def do_check(cfg, deck_path=None, quiet=False):
    d = new_run_dir(cfg) if deck_path is None else os.path.dirname(deck_path)
    deck, _ = build_deck(cfg)
    deck_path = os.path.join(d, "deck.spice")
    with open(deck_path, "w") as f:
        f.write(deck)
    problems, warns, info = static_check(deck_path, cfg.pdk_lib)
    for s in info:
        print("INFO :", s)
    for s in warns:
        print("WARN :", s)
    for s in problems:
        print("ERROR:", s)
    status = "CHECK_FAILED" if problems else "CHECK_OK"
    print(f"\nstatus: {status}  (deck: {deck_path})")
    return status, d, deck_path


def do_run(cfg):
    status, d, deck_path = do_check(cfg)
    manifest = dict(timestamp=datetime.datetime.now().isoformat(), status=status, args=vars(cfg),
                    note="bias default = nilai testbench I2; belum diverifikasi untuk stage-1")
    if status != "CHECK_OK":
        manifest["status"] = "CHECK_FAILED"
        json.dump(manifest, open(os.path.join(d, "manifest.json"), "w"), indent=2, default=str)
        sys.exit(2)
    if shutil.which(cfg.ngspice) is None:
        manifest["status"] = "NOT_RUN"
        manifest["reason"] = f"ngspice '{cfg.ngspice}' tidak ditemukan"
        json.dump(manifest, open(os.path.join(d, "manifest.json"), "w"), indent=2, default=str)
        print("NOT_RUN: ngspice tidak ditemukan; deck sudah ditulis ke", deck_path)
        sys.exit(3)
    cmd = [cfg.ngspice, "-b", "-o", "ngspice.log", "deck.spice"]
    print("jalankan:", " ".join(cmd), "(cwd =", d, ")")
    r = subprocess.run(cmd, cwd=d)
    manifest["command"] = cmd
    manifest["exit_code"] = r.returncode
    wf = os.path.join(d, "waveform.dat")
    if r.returncode != 0 or not os.path.exists(wf):
        manifest["status"] = "SIMULATION_FAILED"
        json.dump(manifest, open(os.path.join(d, "manifest.json"), "w"), indent=2, default=str)
        print("SIMULATION_FAILED: lihat", os.path.join(d, "ngspice.log"), "(baca error pertama, bukan baris terakhir)")
        sys.exit(4)
    t, cols = read_wrdata(wf)
    res, _ = analyze(t, cols, cfg, d)
    manifest["status"] = res["status"]
    json.dump(manifest, open(os.path.join(d, "manifest.json"), "w"), indent=2, default=str)
    json.dump(res, open(os.path.join(d, "metrics.json"), "w"), indent=2)
    print(json.dumps(res, indent=2))


def do_analyze(cfg):
    t, cols = read_wrdata(cfg.analyze)
    d = os.path.dirname(os.path.abspath(cfg.analyze))
    res, _ = analyze(t, cols, cfg, d)
    print(json.dumps(res, indent=2))


def do_selftest(cfg):
    """Bangun waveform sintetis dari model perilaku, tulis format wrdata, baca & analisis kembali."""
    from sd_behavioral import simulate, coherent_sine
    cfg.cycles = 16 + 2048
    cfg.reset_us = 2.0
    cfg.amp_mv = 300.0
    cfg.osr = 16
    cfg.model = True
    T, t_rst, tstop = timing(cfg)
    n_fft = n_fft_of(cfg)
    u = coherent_sine(n_fft, cfg.bin, cfg.amp_mv * 1e-3)
    bits = simulate(u)["bits"]
    # waveform sintetis: Q mengikuti bit pada t_clk + k*T + 5 ns, grid 1 ns
    t = np.arange(0.0, tstop, 1e-9)
    q = np.full(t.size, 0.0)
    kfirst = int(math.ceil((t_rst + cfg.warmup * T - cfg.clk_delay_ns * 1e-9) / T))
    for i, b in enumerate(bits):
        k = kfirst + i
        t0 = cfg.clk_delay_ns * 1e-9 + k * T + 5e-9
        q[t >= t0] = cfg.vdd if b > 0 else 0.0
    d = new_run_dir(cfg)
    wf = os.path.join(d, "waveform_synthetic.dat")
    with open(wf, "w") as f:
        f.write("time v(q) v(o1_p) v(o1_n) v(o2_p) v(o2_n)\n")
        for i in range(t.size):
            f.write(f"{t[i]:.6e} {q[i]:.4f} 0.9 0.9 0.9 0.9\n")
    t2, cols = read_wrdata(wf)
    res, bits2 = analyze(t2, cols, cfg, d)
    n = min(bits.size, bits2.size)
    res["selftest_bits_match"] = bool(np.array_equal(bits[:n], bits2[:n]))
    res["selftest_bits_compared"] = int(n)
    print(json.dumps(res, indent=2))
    sys.exit(0 if res["selftest_bits_match"] else 1)


def main():
    cfg = make_parser().parse_args()
    if cfg.check:
        status, _, _ = do_check(cfg)
        sys.exit(0 if status == "CHECK_OK" else 2)
    elif cfg.run:
        do_run(cfg)
    elif cfg.analyze:
        do_analyze(cfg)
    elif cfg.selftest:
        do_selftest(cfg)
    else:
        make_parser().print_help()


if __name__ == "__main__":
    main()
