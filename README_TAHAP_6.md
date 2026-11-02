# Tahap 6 - AC OTA: Cc (MF) 80 vs 100, dan bias loop vs bias Block 1

Status: NOT_RUN sampai dijalankan. Hasil terukur = MEASURED_NOT_FINAL. Tidak ada kriteria PASS.

Pertanyaan: loop memakai OTA dengan Cc 264,5 fF (MF=100), sedangkan Block 1 dikarakterisasi dengan
Cc 211,6 fF (MF=80). Apakah selisih Cc (atau bias loop) mengubah gain/UGF/PM secara berarti?

Satu variabel per eksperimen, dasar: tb_OTA_AC_experiment.sch milik repo (CMFB ideal, beban 20 pF/sisi, TT/27C).

| Exp | Perubahan terhadap baseline | Berkas |
|---|---|---|
| 6A | tidak ada (MF=80, Vbias 0.507621, Vbz 1.5) - harus mereproduksi laporan Block 1: 69.34 dB, 3.153 MHz, 61.37 deg | tb_6A_MF80_base.sch |
| 6B | hanya Cc: MF=100 (OTA_experiment_MF100.sch = salinan dengan 2 baris MF) | tb_6B_MF100.sch |
| 6C | hanya Vbias = 0.58 (nilai loop) | tb_6C_bias058.sch |
| 6D | hanya Vbz = 1.8 (nilai loop) | tb_6D_vbz18.sch |

Tidak ada transistor yang diubah. Selisih terhadap berkas repo dapat diperiksa dengan `diff`.

## Menjalankan (dari root repo)
    python3 tools/run_tahap6.py selftest
    python3 tools/run_tahap6.py netlist --xschem /foss/tools/bin/xschem
    python3 tools/run_tahap6.py sim
    python3 tools/run_tahap6.py analyze | tee results/tahap6/summary.txt
Kirim: summary.txt dan results/tahap6/tb_6*.log (+ netlist/*.spice bila ada masalah).

## Cara membaca
1. 6A harus cocok dengan laporan Block 1; kalau tidak, 6B-6D belum boleh dibaca.
2. 6B menjawab pengaruh Cc saja; 6C/6D menjawab pengaruh bias saja.
3. Lingkup: OTA berdiri sendiri, bukan SC-CMFB loop dan bukan beban sampling cap sebenarnya; belum PVT.
