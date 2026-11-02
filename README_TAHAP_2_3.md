# Tahap 2 dan 3: hold error Block 5 dan kapasitansi MIM

**STATUS: NOT_RUN.** Semua berkas di sini dibuat tanpa Xschem dan tanpa ngspice (sandbox pembuat tidak punya keduanya).
Yang sudah diperiksa secara statis: konektivitas 7 testbench (`tools/check_sch.py`), jalur analisis dengan data sintetis
(`tools/run_tahap2_3.py selftest`). Netlist Xschem dan simulasi ngspice belum pernah dijalankan. Tidak ada klaim hasil.

## Penempatan berkas (jalankan `pwd` dan `ls` dulu)
Folder `blocks/` di zip ini mengikuti struktur repo Anda. Salin **ke root repo** (folder yang berisi `blocks/`),
dengan menggabung, bukan mengganti folder. Semua berkas **baru**; tidak ada berkas repo yang ditimpa.

| Berkas baru | Tujuan |
|---|---|
| `blocks/05_Switch_Network/xschem/Block5_SH_LVT.sch` dan `.sym` | Salinan Block5_SH dengan `TG_SC_LVT.sym` (nama terpisah; `Block5_SH.sch` standard-Vt tidak disentuh) |
| `blocks/05_Switch_Network/sim/tb_5F_E1_baseline.sch` … `E6_standardVt.sch` | Tahap 2 |
| `blocks/01_OTA/sim/tb_MIM_C_AC.sch` | Tahap 3 |
| `tools/` (folder baru di root repo) | `make_tb.py`, `check_sch.py`, `run_tahap2_3.py` |

Hasil simulasi masuk `results/tahap2_3/` (jangan di-commit; `.gitignore` repo hanya mengecualikan `*.raw` dan sejenisnya).
Pastikan `TG_SC_LVT.sym` ada di `blocks/05_Switch_Network/xschem/` (ada di repo Anda).

## Cara menjalankan
```bash
cd <root repo>
python3 tools/check_sch.py blocks/05_Switch_Network/sim/tb_5F_*.sch blocks/01_OTA/sim/tb_MIM_C_AC.sch
python3 tools/run_tahap2_3.py netlist --xschem /foss/tools/bin/xschem     # path xschem sama seperti di Readiness Anda
python3 tools/run_tahap2_3.py sim
python3 tools/run_tahap2_3.py analyze-hold
python3 tools/run_tahap2_3.py analyze-mim
```
Catatan dari Readiness Anda: Xschem mode text-only dapat mengembalikan exit status 10 walau netlist terbentuk. Skrip menilai
dari ada/tidaknya berkas netlist, tetapi **cek log Xschem** bila ada yang janggal. Kerjakan satu testbench dulu (E1) sebelum semuanya.

## Tahap 2: apa yang diuji
Stimulus E1 adalah rekonstruksi. Stimulus asli smoke dinamis Anda tidak ada di berkas yang saya terima. `analyze-hold` mencetak
selisih E1 terhadap angka Readiness (1.10330/0.69817 V pada 200 ns dan 0.724952/1.08579 V pada 450 ns). Selisih besar berarti
stimulus berbeda, bukan rangkaian berbeda; kirim stimulus asli bila itu terjadi.

Definisi (eksplisit, per siklus; turn-off PHI_SH sekitar t0+141 ns):
- `trk` = HOLD pada t0+139 ns (akhir track), `ped` = HOLD(t0+155) − HOLD(t0+139),
- `step_imm` = respons 6 ns setelah langkah input di HOLD, `step_drift` = perubahan dari situ sampai t0+270.

| Eksperimen | Hanya satu hal berbeda dari E1 | Pertanyaan yang dijawab |
|---|---|---|
| E1 | (baseline) langkah input +18 ns setelah switch mati | Rekonstruksi smoke dinamis |
| E2 | input diam selama HOLD | Berapa pedestal turn-off murni? |
| E3 | langkah input +98 ns, bukan +18 ns | Respons tetap sama (feedthrough kapasitif) atau membesar menurut waktu (kebocoran)? |
| E4 | CH efektif 2p | Apakah error ~1/CH? |
| E5 | tepi clock 5 ns | Apakah pedestal bergantung pada laju tepi? |
| E6 | DUT standard-Vt `Block5_SH` | Efek flavor device. **Bukan satu variabel murni**: `TG_SC.sch` standard-Vt memakai PMOS L=0.15 sedangkan LVT 0.35. |

Panduan membaca (hipotesis yang diuji, bukan kesimpulan):
- Pedestal E2 kecil dan berkurang menurut 1/CH di E4 → injeksi muatan turn-off.
- `step_imm` besar dan sama di E1 dan E3, tanpa drift → feedthrough kapasitif lewat TG yang mati.
- `step_drift` membesar menurut waktu (E3 vs E1) dan turun jauh di E6 → kebocoran subthreshold.
- Tanda error (P naik, N turun) dibandingkan dengan arah langkah input: kopling input searah langkah, injeksi tidak.

## Tahap 3: kapasitansi MIM
Fakta dari berkas Anda: kapasitor `XC1/XC2 ... cap_mim_m3_1 W=1 L=1 MF=100 m=100` berada **di dalam OTA** (kompensasi), bukan di
jalur Cs/Cf (itu kapasitor ideal 1p/2p). Fakta dari repo: `OTA.sch` dan `OTA_CMFB.sch` memakai `MF=1000`, sedangkan netlist
`stage*_core.spice` memakai `MF=100 m=100`. Jadi OTA di loop belum tentu sama dengan OTA yang dikarakterisasi di Block 1.

Hipotesis (belum diverifikasi): simbol sky130 mungkin mengemisi `m=@MF` selain `MF=@MF`. Cek: `find /foss -name cap_mim_m3_1.sym`
lalu `grep -n format <hasil>`. `tb_MIM_C_AC` mengukur C untuk MF/m = (100,100), (100,1), (1,100), (1000,1), (1,1), plus dua instans
dari simbol itu sendiri, plus kapasitor 1p ideal sebagai kalibrasi metode. `N_eff = C / C(1,1)` menunjukkan aturan multiplisitas
yang benar-benar berlaku (≈10000 berarti MF dan m berlipat ganda), tanpa mengandalkan nilai kerapatan MIM.
Setelah ini, jalankan ulang karakterisasi OTA hanya bila hasilnya menunjukkan perbedaan; ukuran transistor tidak diubah.

## Batasan
- Koordinat pin simbol Block5_SH(_LVT) dan `cap_mim_m3_1` (rot 3) diturunkan dari `tb_5A_track_hold.sch`, `Block5_SH.sym`, dan `OTA.sch`; belum dilihat di Xschem.
- `meas`/hasil dibaca dari `wrdata` di Python, bukan dari `.meas` ngspice.
- Tidak ada batas penerimaan numerik; hasil berstatus MEASURED_NOT_FINAL, bukan PASS/FAIL.


## Tambahan jalur B: E7 (aperture) dan E8 (pedestal vs level)

| Exp | Pertanyaan | Stimulus | Analisis |
|---|---|---|---|
| E7_aperture | Apakah anomali 450 ns pada smoke lama = input melangkah dekat saat switch mati? | 10 siklus, langkah input pada t_fall + delta, delta = -20,-8,-5,-3,-1,0,1,3,6,12 ns, input bergantian 1.1/0.7 V | `analyze-aperture` |
| E8_level_sweep | Seberapa linear pedestal terhadap level sinyal? | 9 level P = 0.2..1.6 V (N = 1.8 - P), input beku selama HOLD | `analyze-level` |

Langkah (dari root repo, setelah menyalin berkas pack ke sana; cadangkan dulu berkas yang akan tertimpa):

    python3 tools/check_sch.py blocks/05_Switch_Network/sim/tb_5F_E7_aperture.sch blocks/05_Switch_Network/sim/tb_5F_E8_level_sweep.sch
    python3 tools/run_tahap2_3.py netlist --which hold --only E7 --xschem /foss/tools/bin/xschem
    python3 tools/run_tahap2_3.py netlist --which hold --only E8 --xschem /foss/tools/bin/xschem
    python3 tools/run_tahap2_3.py sim --which hold --only E7
    python3 tools/run_tahap2_3.py sim --which hold --only E8
    python3 tools/run_tahap2_3.py analyze-aperture | tee results/tahap2_3/aperture_summary.txt
    python3 tools/run_tahap2_3.py analyze-level    | tee results/tahap2_3/level_summary.txt

Status semua hasil: NOT_RUN sampai Anda menjalankannya; setelah itu MEASURED_NOT_FINAL.
Referensi E7 (Readiness @450 ns): dP = +24.95 mV, dN = -14.21 mV. Referensi E8: +3.302 mV @1.1 V, -1.833 mV @0.7 V.
