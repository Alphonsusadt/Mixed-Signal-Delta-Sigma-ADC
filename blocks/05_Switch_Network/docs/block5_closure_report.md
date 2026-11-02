# Block 5 (Switch Network) - Laporan Penutupan (final)

**Status dokumen: DISETUJUI pemilik proyek pada 2026-11-02 (tahap 8), untuk lingkup nominal pre-layout. Ini bukan sign-off PVT/post-layout.**
Lingkup klaim: nominal TT / 1,8 V / 27 C, pre-layout, simulasi. Label status: MEASURED_NOT_FINAL / SIMULATED_NOT_FINAL_PASS.

## 1. Keputusan yang sudah diambil
| Tahap | Keputusan | Tanggal |
|---|---|---|
| 4 | Pedestal Block 5 diterima sebagai MEASURED_NOT_FINAL (tanpa batas angka) | 2026-11-02 |
| 6 | Ditutup dengan Opsi A: OTA pada bias loop dengan CMFB tertutup dicatat sebagai batas yang diketahui | 2026-11-02 |
| 7 | Spek direvisi: SNDR ~75 dB pada OSR 80, BW 25 kHz (fs 4 MHz), bukan 99 dB | 2026-11-02 |

## 2. Bukti terukur
| Uji | Hasil | Status | Berkas |
|---|---|---|---|
| Closed-loop DC (100 mV) | rata-rata V = +0,1002 V (harapan 0,1 V), tanpa rail | SIMULATED_NOT_FINAL_PASS | dc100b |
| Closed-loop sinus, 4096 titik, bin 13, -6 dBFS | SNDR 75,37 dB @ OSR 80 (ENOB 12,23); model 77,16 dB (rentang model terhadap fase 75,3-78,8) | SIMULATED_NOT_FINAL_PASS | sine300_n4096 |
| Bentuk noise (orde-2) | kenaikan 14-17 dB per penggandaan pita; HD2 -77,8 dBc, HD3 -72,0 dBc (model -76,9 / -68,3) | MEASURED_NOT_FINAL | dihitung dari bitstream |
| Hold error E1-E6 (Block5_SH LVT) | pedestal +3,302 mV / -1,834 mV (1,1 V / 0,7 V), simetris P/N; CH 2 pF -> x0,52/x0,50; edge 5 ns -> x0,76/x1,02; Vt standar -> x0,16/x0,79; tanpa feedthrough/leakage | MEASURED_NOT_FINAL | tb_5F_E1..E6 |
| E7 aperture | jendela tangkap langkah input ~3 ns (delta -3..0 ns); delta >= +1 ns: langkah diabaikan | MEASURED_NOT_FINAL | tb_5F_E7 |
| E8 pedestal vs level | -3,19 mV (0,2 V) ... +9,28 mV (1,6 V); gain error diferensial +0,964%; INL puncak 1,36 mV (0,0485% dari +-1,4 V); P=N di level sama | MEASURED_NOT_FINAL | tb_5F_E8 |
| MIM (tahap 3) | MF diabaikan model, hanya m mengalikan; unit 2,645 fF | MEASURED_NOT_FINAL | tb_MIM_C_AC |
| OTA AC (tahap 6), OTA_experiment (Block 1) saja | MF=80: 69,34 dB / 3,153 MHz / PM 61,37; MF=100: 69,34 dB / 2,711 MHz / PM 66,61; Vbz tanpa efek. BUKAN OTA yang dipakai di loop (lihat bagian 3) | MEASURED_NOT_FINAL | tb_6A..6D |

## 3. Batas yang diketahui (BELUM diverifikasi)
- Tanpa transient noise di deck dan model: 75,4 dB adalah batas kuantisasi + non-idealitas deterministik; kT/C, thermal OTA, noise komparator belum masuk.
- Satu amplitudo (-6 dBFS), satu bin (13/4096), satu corner; belum sweep amplitudo, belum PVT, belum post-layout.
- Block5_SH standalone tidak ada di dalam loop (loop memakai TG_SC_LVT di stage core): hasil E1-E8 tidak otomatis berlaku di loop.
- Anomali 450 ns lama: konsisten dengan langkah input yang jatuh di jendela aperture ~3 ns (hipotesis, belum terbukti karena stimulus asli tidak dimiliki).
- OTA pada bias loop (Vbias 0,58) dengan CMFB tertutup: belum terkarakterisasi (6C gagal di harness CMFB-ideal).
- **Koreksi 2026-11-02:** OTA di netlist loop (S1_OTA_CMFB / S2_OTA_CMFB, setara OTA_CMFB.sch) BUKAN OTA_experiment yang dikarakterisasi di laporan Block 1. Sizing berbeda (M1/M2 240/0,6 vs 120/1,2; M5/M6 40/2 vs 20/2; M7/M8 60/2 vs 30/2; M9/M10 60/1 vs 300/1; M11/M12 80/1 vs 200/1; M13 480/1,2 vs 60/1,2), cabang Vbz (nulling) masih ada, dan Cc = 264,5 fF (MF=100). Hasil tahap 6 (MF=80 vs 100) dan metrik Block 1 karenanya tidak boleh diatribusikan ke OTA loop. AC OTA loop (OTA_CMFB + SC-CMFB, bias 0,58 V) belum terkarakterisasi; keputusan penanganannya ada pada pemilik proyek.
- Vbz tidak berpengaruh pada harness AC; penyebab belum ditelusuri.
- Offset DC: hanya diukur lewat DC 100 mV (error 0,2 mV), belum pada DC 0.
- Sizing I1/I2/CMFB tidak diubah (aturan dossier).

## 4. Daftar persetujuan (diisi pemilik proyek)
- [x] Bukti pada bagian 2 cukup untuk menyatakan Block 5 selesai pada lingkup nominal pre-layout.
- [x] Batas pada bagian 3 diterima sebagai batas yang diketahui.
- [x] Spek ~75 dB @ OSR 80 (BW 25 kHz) dipakai untuk dokumentasi dan portofolio.
- [ ] Berkas hasil yang dimasukkan ke git: ditentukan pemilik saat commit (belum diputuskan; hindari *.bak, backup_pre_v2/, .dat besar).

Persetujuan diberikan: Block 6 boleh mulai. Penomoran Block 6 (Clock Gen atau CIC) belum ditetapkan dan harus diputuskan pemilik proyek.
