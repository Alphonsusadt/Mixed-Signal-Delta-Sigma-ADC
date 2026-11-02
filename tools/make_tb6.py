#!/usr/bin/env python3
"""make_tb6.py - bangkitkan testbench tahap 6 dari tb_OTA_AC_experiment.sch milik repo.

Satu variabel per eksperimen terhadap baseline 6A (OTA_experiment, MF=80, Vbias=0.507621, Vbz=1.5):
  6A  baseline (tidak diubah)                     -> harus mereproduksi laporan Block 1
  6B  Cc: MF=100 (nilai yang dipakai loop)        -> hanya kapasitor Miller berubah
  6C  Vbias = 0.58 (nilai yang dipakai loop)      -> hanya bias berubah
  6D  Vbz = 1.8 (nilai yang dipakai loop)         -> hanya Vbz berubah
Hanya teks .sch yang diubah; transistor OTA tidak disentuh.
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REPO = sys.argv[1] if len(sys.argv) > 1 else ROOT          # tempat sumber asli (repo)
SIM = os.path.join("blocks", "01_OTA", "sim")
XS = os.path.join("blocks", "01_OTA", "xschem")
SRC_TB = os.path.join(REPO, SIM, "tb_OTA_AC_experiment.sch")
SYM80 = "blocks/01_OTA/xschem/OTA_experiment.sym"
SYM100 = "blocks/01_OTA/xschem/OTA_experiment_MF100.sym"

CODE = '''value="
.control
save all

op

echo ===== TAHAP6 {tag} OPERATING POINT =====
print v(vbias)
print v(vin_p)
print v(vin_n)
print v(vout_p)
print v(vout_n)

ac dec 100 1 1G

let vid = v(vin_p)-v(vin_n)
let vod = v(vout_p)-v(vout_n)

let av = vod/vid
let loopgain = -av

let gain_db = db(loopgain)
let phase_deg = 180/pi*cph(loopgain)

meas ac A0 FIND gain_db AT=1
meas ac G_100K FIND gain_db AT=1e5
meas ac G_1M FIND gain_db AT=1e6
meas ac UGF WHEN gain_db=0 CROSS=1
meas ac PHASE_UGF FIND phase_deg WHEN gain_db=0 CROSS=1

echo ===== TAHAP6 {tag} AC RESULTS =====
print A0
print G_100K
print G_1M
print UGF
print PHASE_UGF
echo TB_6_DONE
.endc
"'''

VARIANTS = {
    "6A_MF80_base": dict(tag="6A", sym=SYM80, vbz=None, vbias=None),
    "6B_MF100": dict(tag="6B", sym=SYM100, vbz=None, vbias=None),
    "6C_bias058": dict(tag="6C", sym=SYM80, vbz=None, vbias="0.58"),
    "6D_vbz18": dict(tag="6D", sym=SYM80, vbz="1.8", vbias=None),
}


def sub_once(s, old, new):
    assert s.count(old) == 1, f"pola harus muncul tepat sekali: {old!r} ({s.count(old)}x)"
    return s.replace(old, new)


def build_ota_mf100():
    """Salinan OTA_experiment dengan MF 80 -> 100 pada C1 dan C2 SAJA."""
    s = open(os.path.join(REPO, XS, "OTA_experiment.sch")).read()
    assert s.count("MF=80") == 2, "harus ada tepat 2 kapasitor MF=80"
    out = s.replace("MF=80", "MF=100")
    os.makedirs(os.path.join(ROOT, XS), exist_ok=True)
    open(os.path.join(ROOT, XS, "OTA_experiment_MF100.sch"), "w").write(out)
    open(os.path.join(ROOT, XS, "OTA_experiment_MF100.sym"), "w").write(
        open(os.path.join(REPO, XS, "OTA_experiment.sym")).read())


def build_tb(name, cfg):
    s = open(SRC_TB).read()
    if cfg["sym"] != SYM80:
        s = sub_once(s, "C {" + SYM80 + "}", "C {" + cfg["sym"] + "}")
    if cfg["vbias"]:
        s = sub_once(s, "value=0.507621", "value=" + cfg["vbias"])
    if cfg["vbz"]:
        s = sub_once(s, "name=V3\nvalue=1.5", "name=V3\nvalue=" + cfg["vbz"])
    m = re.search(r'value="\n\.control.*?\.endc\n"', s, flags=re.S)
    assert m, "blok .control tidak ditemukan"
    s = s[:m.start()] + CODE.format(tag=cfg["tag"]) + s[m.end():]
    path = os.path.join(ROOT, SIM, f"tb_{name}.sch")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w").write(s)
    return path


def main():
    build_ota_mf100()
    for n, c in VARIANTS.items():
        print("tulis", build_tb(n, c))


if __name__ == "__main__":
    main()
