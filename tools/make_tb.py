#!/usr/bin/env python3
"""
make_tb.py - membangkitkan testbench Xschem tahap 2 (hold error Block 5) dari kerangka
tb_5A_track_hold.sch milik repo. Koordinat wire/pin dipertahankan persis seperti tb_5A
(yang sudah dipakai di Xschem Anda); yang diganti hanya teks judul, nilai sumber,
simbol DUT, komponen tambahan (E4), dan blok kode ngspice.

Jalankan dari folder pack:  python3 tools/make_tb.py
Keluaran: blocks/05_Switch_Network/sim/tb_5F_*.sch
"""
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
TEMPLATE = os.path.join(HERE, "_template_tb_5A.sch")
OUT = os.path.join(ROOT, "blocks", "05_Switch_Network", "sim")

DUT_STD = "blocks/05_Switch_Network/xschem/Block5_SH.sym"
DUT_LVT = "blocks/05_Switch_Network/xschem/Block5_SH_LVT.sym"

V_HI, V_LO = 1.1, 0.7           # sinyal diferensial +/-0.2 V di sekitar VCM = 0.9 V
T_SIM = 700                     # ns: tiga periode clock 250 ns


def pwl(steps, edge_ns=1.0, t_sim=None):
    """steps = [(t_ns, vp)] mulai dari t=0; kembalikan string PWL dengan tepi edge_ns."""
    pts = []
    cur = steps[0][1]
    pts.append((0.0, cur))
    for t, v in steps[1:]:
        pts.append((t, cur))
        pts.append((t + edge_ns, v))
        cur = v
    pts.append(((t_sim or T_SIM) + 100.0, cur))
    return "PWL(" + " ".join(f"{t:g}n {v:g}" for t, v in pts) + ")"


# Setiap eksperimen: HANYA SATU hal berbeda dari E1 (kecuali E6, lihat README).
EXPERIMENTS = {
    "E1_baseline": dict(
        title="5F-E1 BASELINE: rekonstruksi smoke dinamis (input berubah saat HOLD)",
        steps_p=[(0, V_HI), (160, V_LO), (410, V_HI)],
        dut=DUT_LVT, ch_extra=False, edge=1.0,
        note="Input berubah 18 ns setelah switch mati, di kedua siklus. Rekonstruksi: stimulus asli smoke dinamis tidak ada di berkas yang saya terima."),
    "E2_input_frozen": dict(
        title="5F-E2: input DIAM selama HOLD (hanya pedestal turn-off)",
        steps_p=[(0, V_HI), (330, V_LO)],
        dut=DUT_LVT, ch_extra=False, edge=1.0,
        note="Input hanya berubah saat track siklus 2 (t=330 ns). Selama kedua HOLD input konstan."),
    "E3_step_late": dict(
        title="5F-E3: langkah input TERLAMBAT di HOLD (98 ns setelah switch mati)",
        steps_p=[(0, V_HI), (240, V_LO), (490, V_HI)],
        dut=DUT_LVT, ch_extra=False, edge=1.0,
        note="Sama dengan E1 tetapi langkah input digeser dari +18 ns ke +98 ns setelah switch mati."),
    "E4_ch_2p": dict(
        title="5F-E4: CH 2p per sisi (tambahan 1p paralel di testbench)",
        steps_p=[(0, V_HI), (160, V_LO), (410, V_HI)],
        dut=DUT_LVT, ch_extra=True, edge=1.0,
        note="Sama dengan E1; hanya CH efektif menjadi 2p (DUT tidak diubah)."),
    "E5_edge_5n": dict(
        title="5F-E5: tepi clock 5 ns (E1 memakai 1 ns)",
        steps_p=[(0, V_HI), (160, V_LO), (410, V_HI)],
        dut=DUT_LVT, ch_extra=False, edge=5.0,
        note="Sama dengan E1; hanya waktu naik/turun PHI_SH dan PHI_SHB 5 ns."),
    "E6_standardVt": dict(
        title="5F-E6: DUT standard-Vt Block5_SH (BUKAN satu variabel murni)",
        steps_p=[(0, V_HI), (160, V_LO), (410, V_HI)],
        dut=DUT_STD, ch_extra=False, edge=1.0,
        note="Stimulus sama dengan E1; DUT = Block5_SH (TG_SC standard-Vt). Berbeda juga di panjang PMOS (TG_SC.sch: 0.15 vs LVT 0.35)."),
}


# E7: waktu langkah input relatif terhadap awal turun PHI_SH (T = 141 ns + 250k). Level input bergantian tiap siklus.
APERTURE_DELTAS = [-20, -8, -5, -3, -1, 0, 1, 3, 6, 12]          # ns


def _e7_steps():
    st = [(0, V_HI)]
    for k, d in enumerate(APERTURE_DELTAS):
        st.append((141 + 250 * k + d, V_LO if k % 2 == 0 else V_HI))
    return st


# E8: level input per siklus (sisi P; sisi N = 1.8 - P). Level diganti 100 ns sebelum switch mati.
LEVELS = [0.2, 0.4, 0.6, 0.8, 0.9, 1.0, 1.2, 1.4, 1.6]


def _e8_steps():
    st = [(0, LEVELS[0])]
    for k in range(1, len(LEVELS)):
        st.append((250 * k + 40, LEVELS[k]))
    return st


EXPERIMENTS["E7_aperture"] = dict(
    title="5F-E7: waktu langkah input di sekitar turn-off (aperture), 10 siklus",
    steps_p=_e7_steps(), t_sim=250 * len(APERTURE_DELTAS) + 100,
    dut=DUT_LVT, ch_extra=False, edge=1.0,
    note="Langkah input digeser per siklus relatif terhadap awal turun PHI_SH: " + " ".join(f"{d:+d}" for d in APERTURE_DELTAS) + " ns.")
EXPERIMENTS["E8_level_sweep"] = dict(
    title="5F-E8: pedestal terhadap level sinyal, 9 siklus",
    steps_p=_e8_steps(), t_sim=250 * len(LEVELS) + 100,
    dut=DUT_LVT, ch_extra=False, edge=1.0,
    note="Level sisi P per siklus: " + " ".join(f"{v:g}" for v in LEVELS) + " V; sisi N = 1.8 - P. Input diam selama HOLD.")


def code_block(name, t_sim=T_SIM):
    return (
        f"* {name}: diagnosa hold error Block 5 (tahap 2). TT, 1.8 V, 27 C.\n"
        "* .ic hanya kondisi awal numerik, bukan rangkaian reset.\n"
        ".option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8\n"
        ".temp 27\n"
        ".ic V(HOLD_P)=0.9 V(HOLD_N)=0.9\n"
        ".control\n"
        "save all\n"
        "set wr_singlescale\n"
        "set wr_vecnames\n"
        "set numdgt=15\n"
        f"tran 0.1n {t_sim}n 0 0.1n\n"
        f"wrdata tb_5F_{name}.dat v(SRC_P) v(SRC_N) v(VIN_P) v(VIN_N) v(HOLD_P) v(HOLD_N) v(PHI_SH) v(PHI_SHB)\n"
        "echo TB_5F_DONE\n"
        ".endc\n"
    )


def build(name, cfg):
    s = open(TEMPLATE).read()
    # judul
    s = s.replace("5A FIRST TESTBENCH: TRACK / HOLD, NO OTA", cfg["title"])
    s = s.replace("TT, 1.8 V, 27 C; CH=1p per side inside Block5_SH; WN/WP=2/4 um; L=0.15 um.",
                  "TT, 1.8 V, 27 C, VCM=0.9 V, clock 4 MHz. " + cfg["note"][:150])
    s = s.replace("SOURCES: input P/N, VDD, clock/complement, common-mode. Both inputs change while HOLD is active.",
                  "SOURCES: input P/N (PWL, lihat nilai tiap sumber), VDD, PHI_SH/PHI_SHB (4 MHz), VCM. Rs=100 ohm di testbench.")
    s = s.replace("Plots and .dat come from ngspice after simulation. Expected reference values are in START_HERE_XSCHEM_ID.md.",
                  "Keluaran: tb_5F_<nama>.dat (wrdata). Tidak ada kriteria pass/fail; angka dibaca oleh analyze-hold.")
    s = s.replace("Verify this schematic and its exported netlist before running the Python sweeps.",
                  "Tahap 2: ukur pedestal, feedthrough, drift. Analisis: tools/run_tahap2_3.py analyze-hold.")
    # sumber input
    ts = cfg.get("t_sim", T_SIM)
    vp = pwl(cfg["steps_p"], t_sim=ts)
    vn = pwl([(t, 2 * 0.9 - v) for t, v in cfg["steps_p"]], t_sim=ts)
    s = s.replace('PULSE(0.95 0.85 180n 1n 1n 249n 500n)', vp)
    s = s.replace('PULSE(0.85 0.95 180n 1n 1n 249n 500n)', vn)
    # tepi clock
    e = cfg["edge"]
    s = s.replace('PULSE(0 1.8 30n 1n 1n 110n 250n)', f"PULSE(0 1.8 30n {e:g}n {e:g}n 110n 250n)")
    s = s.replace('PULSE(1.8 0 30n 1n 1n 110n 250n)', f"PULSE(1.8 0 30n {e:g}n {e:g}n 110n 250n)")
    # DUT
    s = s.replace("blocks/05_Switch_Network/xschem/Block5_SH.sym", cfg["dut"])
    # kode ngspice: ganti seluruh isi code.sym SIM
    s = re.sub(r'(C \{code\.sym\} 740 100 0 0 \{name=SIM only_toplevel=true value=")(.*?)("\})',
               lambda m: m.group(1) + "\n" + code_block(name, cfg.get("t_sim", T_SIM)) + m.group(3), s, flags=re.S)
    # CH tambahan (E4): dua kapasitor 1p paralel dengan CH di DUT
    if cfg["ch_extra"]:
        s = s.rstrip("\n") + "\n"
        s += "C {capa.sym} 1000 -200 0 0 {name=CHX_P m=1 value=1p}\n"
        s += "C {lab_pin.sym} 1000 -230 0 1 {name=lCHXP1 lab=HOLD_P}\n"
        s += "C {lab_pin.sym} 1000 -170 0 1 {name=lCHXP2 lab=VCM}\n"
        s += "C {capa.sym} 1060 -200 0 0 {name=CHX_N m=1 value=1p}\n"
        s += "C {lab_pin.sym} 1060 -230 0 1 {name=lCHXN1 lab=HOLD_N}\n"
        s += "C {lab_pin.sym} 1060 -170 0 1 {name=lCHXN2 lab=VCM}\n"
    return s


def main():
    os.makedirs(OUT, exist_ok=True)
    for name, cfg in EXPERIMENTS.items():
        text = build(name, cfg)
        path = os.path.join(OUT, f"tb_5F_{name}.sch")
        with open(path, "w") as f:
            f.write(text)
        print("ditulis:", os.path.relpath(path, ROOT))


if __name__ == "__main__":
    main()


# ----------------------------------------------------------------------------
# Tahap 3: uji kapasitansi MIM (multiplisitas MF / m)
# ----------------------------------------------------------------------------
OUT_OTA = os.path.join(ROOT, "blocks", "01_OTA", "sim")

MIM_VARIANTS = [  # nama, MF, m  (instans SPICE mentah di blok kode)
    ("A", 100, 100),    # persis baris di stage1_core.spice / stage2_core.spice
    ("B", 100, 1),
    ("C", 1, 100),
    ("D", 1000, 1),     # setara MF=1000 di OTA_CMFB.sch repo bila hanya MF yang berlaku
    ("E", 1, 1),        # satu unit (W=1 L=1): pembagi untuk N_eff
]


def build_mim():
    L = []
    L.append("v {xschem version=3.4.8RC file_version=1.3}\nG {}\nK {}\nV {}\nS {}\nF {}\nE {}")
    L.append("T {TAHAP 3: UJI KAPASITANSI MIM (AC), multiplisitas MF dan m} 100 -480 0 0 0.4 0.4 {}")
    L.append("T {Kapasitor MIM ada di dalam OTA (kompensasi), bukan di jalur Cs/Cf. C diukur dari -Im(I)/(2*pi*f) pada 1 MHz.} 100 -430 0 0 0.25 0.25 {}")
    L.append("T {REF=1p ideal (kalibrasi metode). SYM100/SYM1000 = simbol sky130 cap_mim_m3_1 (periksa baris netlist yang DIEMIT). A-E = baris SPICE mentah.} 100 -390 0 0 0.25 0.25 {}")
    branches = [("REF", 120), ("SYM100", 320), ("SYM1000", 520)]
    for nm, x in branches:
        # sumber AC: pin atas (x,70), pin bawah (x,130)
        L.append(f"N {x} 40 {x} 70 {{lab=N_{nm}}}")
        L.append(f"N {x} 130 {x} 150 {{lab=0}}")
        L.append(f"C {{lab_pin.sym}} {x} 40 0 1 {{name=lN{nm} lab=N_{nm}}}")
        L.append(f"C {{gnd.sym}} {x} 150 0 0 {{name=gN{nm} lab=0}}")
        L.append(f"C {{vsource.sym}} {x} 100 0 0 {{name=V{nm} value=\"dc 0 ac 1\" savecurrent=false}}")
    # perangkat uji, pin di label langsung
    # REF: capa.sym rot0 di (x,-100): pin (x,-130) dan (x,-70)
    x = 120
    L.append(f"C {{capa.sym}} {x} -100 0 0 {{name=C_REF m=1 value=1p}}")
    L.append(f"C {{lab_pin.sym}} {x} -130 0 1 {{name=lREF1 lab=N_REF}}")
    L.append(f"C {{lab_pin.sym}} {x} -70 0 1 {{name=lREF2 lab=0}}")
    # simbol MIM: rot 3 di (x,y): pin di (x-30,y) dan (x+30,y)  (diturunkan dari OTA.sch)
    for nm, x, mf in [("SYM100", 320, 100), ("SYM1000", 520, 1000)]:
        L.append(f"C {{sky130_fd_pr/cap_mim_m3_1.sym}} {x} -100 3 0 {{name=C_{nm} model=cap_mim_m3_1 W=1 L=1 MF={mf} spiceprefix=X}}")
        L.append(f"C {{lab_pin.sym}} {x-30} -100 0 1 {{name=l{nm}1 lab=N_{nm}}}")
        L.append(f"C {{lab_pin.sym}} {x+30} -100 0 1 {{name=l{nm}2 lab=0}}")
    L.append("C {sky130_fd_pr/corner.sym} 940 100 0 0 {name=CORNER only_toplevel=false corner=tt}")
    raw = ["* tahap 3: kapasitansi MIM via AC. TT, 27 C. Variabel dibedakan HANYA lewat MF dan m."]
    raw.append(".option scale=1e-6")
    raw.append(".temp 27")
    for nm, mf, m in MIM_VARIANTS:
        raw.append(f"V{nm} N_{nm} 0 dc 0 ac 1")
        raw.append(f"XC{nm} N_{nm} 0 sky130_fd_pr__cap_mim_m3_1 W=1 L=1 MF={mf} m={m}")
    raw += [
        ".control",
        "set wr_singlescale",
        "set wr_vecnames",
        "set numdgt=12",
        "ac dec 20 1e4 1e8",
        "let w = 2*pi*real(frequency)",
        "let C_REF = -imag(i(VREF))/w",
        "let C_SYM100 = -imag(i(VSYM100))/w",
        "let C_SYM1000 = -imag(i(VSYM1000))/w",
    ] + [f"let C_{nm} = -imag(i(V{nm}))/w" for nm, _, _ in MIM_VARIANTS] + [
        "wrdata tb_MIM_C_AC.dat C_REF C_SYM100 C_SYM1000 " + " ".join(f"C_{nm}" for nm, _, _ in MIM_VARIANTS),
        "echo TB_MIM_DONE",
        ".endc",
    ]
    L.append('C {code.sym} 740 100 0 0 {name=SIM only_toplevel=true value="\n' + "\n".join(raw) + '\n"}')
    return "\n".join(L) + "\n"


def main_mim():
    os.makedirs(OUT_OTA, exist_ok=True)
    path = os.path.join(OUT_OTA, "tb_MIM_C_AC.sch")
    with open(path, "w") as f:
        f.write(build_mim())
    print("ditulis:", os.path.relpath(path, ROOT))


if __name__ == "__main__":
    main_mim()
