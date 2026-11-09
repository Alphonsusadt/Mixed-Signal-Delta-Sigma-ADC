# Block 6 (generator clock NONOV): laporan penutupan

**Status: DITUTUP DENGAN BATAS YANG DIKETAHUI (pemilik proyek memilih opsi A pada 2026-11-09).**
Lingkup: simulasi ngspice pre-layout pada 45 kondisi PVT, ditambah Monte Carlo mismatch lokal di tiga titik. Ini bukan sign-off dan bukan post-layout. Label status: `MEASURED_NOT_FINAL` / `SIMULATED_NOT_FINAL_PASS`.

## 1. Ringkasan

- Block 6 membangkitkan fase non-overlap phi1/phi2 (dan phi1b/phi2b) dari satu clock, mengikuti Spilka et al. (DDECS 2012): XOR, sel tunda current-starved, AND2, XOR (80 MOS, T = 250 ns).
- Dengan bias tetap ideal (VBN 0,70 V / VBP 0,71 V) blok hanya bekerja di titik nominal: **17/45** kondisi PVT lulus kriteria saring, 10 kondisi tidak menghasilkan fase, dan gap menyebar dari 1,94 sampai 91,76 ns.
- Generator bias yang mengikuti PVT (satu resistor, dioda NMOS, cermin, dan dioda replika PMOS) membawanya ke **45/45** dengan gap 9,99 sampai 20,58 ns (sebaran 2,06x) dan lebar fase minimum 104,3 ns.
- Monte Carlo mismatch lokal (100 seed per titik): 99/100 lulus di TT/27 C/1,8 V, 100/100 di SF/125 C/1,98 V, **70/100 di FS/-40 C/1,62 V** (30 kegagalan semuanya berlebar fase di bawah batas saring 100 ns). Ini diterima sebagai batas yang diketahui (bagian 5).
- Closed loop dengan generator dan clock komparator dari phi2b: SNDR 73,62 dB pada OSR 80 (ENOB 11,94), hanya titik nominal, satu run.

## 2. Desain

- Sel tunda dibias oleh VBN/VBP. Gap kira-kira sebanding dengan 1/I arus bias.
- Generator bias: `RB1` dari VDD ke VBN, dioda NMOS `XBN1` (W 0,5 / L 1), cermin NMOS `XBN2` (VBN ke node VBP), dioda PMOS `XBP1` (W 1 / L 1). I = (VDD - VBN) / R. Berjalan sendiri (self-starting).
- R = 1,247933 MOhm, dikalibrasi agar VBN = 0,700 V pada TT/27 C/1,8 V.
- Model SKY130 `xhigh_po`: 2000 ohm/sq, tc1 = -1,47e-3, tc2 = 2,7e-6. ngspice tidak menerapkan tempco model dalam setup ini (arus identik pada -40/27/125 C), sehingga tempco diterapkan manual pada resistor ideal di sweep utama.
- Panjang resistor untuk 1,248 MOhm: sekitar 850 um pada W = 1,41 um (603 persegi). Luas layout belum dievaluasi.

## 3. Kriteria saring yang dipakai

Ini batas rekayasa saya sendiri. Batas ini tidak diturunkan dari anggaran settling saklar atau timing komparator.

| # | Kriteria | Batas |
|---|---|---|
| A1 | Fase terbentuk di semua 45 kondisi (5 corner x -40/27/125 C x 1,62/1,8/1,98 V) | 45/45 |
| A2 | Overlap: maksimum terhadap waktu dari min(phi1, phi2) | < 1 % VDD |
| A3 | Gap non-overlap (yang lebih kecil dari dua gap) | >= 5 ns |
| A4 | Lebar fase (yang lebih kecil dari dua fase), T/2 = 125 ns | >= 100 ns |
| A5 | Clock komparator naik setelah phi2 turun dan sebelum phi1 naik | 45/45 |
| A6 | Start-up: lebar dan gap stabil dalam beberapa siklus, rampa VDD 1 dan 20 us | 4 corner |

Gap + lebar 124,7-125,0 ns pada setiap run PVT deterministik (rata-rata sekitar 123-124 ns pada Monte Carlo, minimum 110,5 ns), sehingga A3 dan A4 saling menukar.

## 4. Hasil

### 4.1 Sweep PVT (A1-A4)

| Sweep | Kondisi | Lulus | Gap (ns) | Lebar min (ns) | Overlap maks (% VDD) |
|---|---|---|---|---|---|
| Bias tetap ideal | 45 (35 valid) | 17/45 | 1,94 .. 91,76 | 32,9 | 0,031 |
| Dioda replika, arus referensi ideal | 45 | 45/45 | 12,09 .. 16,47 | 108,4 | 0,031 |
| Generator, R ideal (tanpa tempco) | 45 | 45/45 | 11,21 .. 18,73 | 106,2 | 0,031 |
| Generator, resistor PDK (tempco tidak diterapkan ngspice) | 45 | 45/45 | 11,34 .. 18,85 | 106,0 | 0,031 |
| **Generator, R dengan tc1/tc2 (utama)** | 45 | **45/45** | **9,99 .. 20,58** | **104,3** | 0,031 |
| Generator, R x 0,8 (tanpa tempco) | 12 ekstrem | 12/12 | 9,14 .. 15,35 | 109,5 | 0,012 |
| Generator, R x 1,2 (tanpa tempco) | 12 ekstrem | 12/12 | 13,26 .. 22,06 | 102,8 | 0,012 |

Ekstrem sweep utama: gap terkecil 9,99 ns di SF/125 C/1,98 V; gap terbesar 20,58 ns dan lebar terkecil 104,31 ns di FS/-40 C/1,62 V; overlap terbesar 0,62 mV di FF/125 C/1,98 V. Tabel per kondisi: [pvt_results_block6.md](pvt_results_block6.md).

### 4.2 Monte Carlo, mismatch lokal (100 seed per titik)

Corner library `tt_mm` / `fs_mm` / `sf_mm` dengan `.option seed`; generator sweep utama (R dengan tempco). Hanya mismatch lokal transistor yang acak.

| Titik | Lulus | Gap (ns), rata-rata +- sd (min .. maks) | Lebar (ns), rata-rata +- sd (min .. maks) |
|---|---|---|---|
| TT, 27 C, 1,8 V | 99/100 | 14,0 +- 2,85 (7,78 .. 24,69) | 109,9 +- 3,20 (94,2 .. 115,1) |
| SF, 125 C, 1,98 V (gap terkecil) | 100/100 | 10,0 +- 1,56 (6,31 .. 15,53) | 114,4 +- 1,69 (106,8 .. 117,4) |
| FS, -40 C, 1,62 V (lebar terkecil) | **70/100** | 20,9 +- 5,50 (9,95 .. 43,41) | 102,0 +- 6,50 (67,1 .. 111,5) |

- Rata-rata Monte Carlo cocok dengan nilai deterministik di titik yang sama (10,00 vs 9,99 ns di SF; 20,9 vs 20,58 ns di FS).
- Ke-30 kegagalan di FS/-40 C/1,62 V semuanya berlebar < 100 ns; gap tidak pernah di bawah 5 ns. Interval kepercayaan 95 % untuk 70/100 sekitar 60-78 %.
- Distribusinya miring (Shapiro p < 0,01), jadi rata-rata - 3 sd bukan klaim 3-sigma. Lebar terburuk yang terukur (67,1 ns) jauh di bawah ekstrapolasi Gauss.
- Seed yang sama menjadi yang terburuk di ketiga run (seed 2046: lebar terkecil; seed 2038: gap terkecil) dan gap per seed berkorelasi 0,99 antara FS dan SF. Ini konsisten dengan komponen arus bias bersama, misalnya transistor cermin kecil di generator. Belum diuji.
- Overlap tetap di bawah 0,05 mV pada seluruh 300 sampel. Data mentah per seed: `results/mc/`.

### 4.3 Start-up (A6)

VDD naik dari 0 V; clock mulai setelah rampa (rampa 1 dan 20 us) atau selama rampa (hanya 1 us). 12 run, semuanya stabil (lebar dan gap akhir dalam 1 ns, gap >= 5 ns, lebar >= 100 ns, overlap < 1 % VDD).

| Corner / T / VDD | Gap akhir (ns) | Lebar akhir (ns) | Overlap (mV) | Pulsa hingga stabil (setelah / selama) |
|---|---|---|---|---|
| TT / 27 C / 1,8 V | 13,93 | 110,98 | 0,004 | 2 / 3 |
| SS / -40 C / 1,62 V | 19,70 | 105,11 | 0,004 | 2 / 3 |
| FF / 125 C / 1,98 V | 10,85 | 114,16 | 0,619 | 2 / 4 |
| FS / -40 C / 1,98 V | 15,94 | 108,99 | 0,004 | 2 / 3 |

Nilai akhir sama dengan sweep PVT. Pulsa pertama pada mode "setelah" bukan pulsa clock: phi1 mengikuti VDD dan tetap tinggi selama seluruh rampa (lebar 300 ns sampai 10 us) hingga clock mulai.

### 4.4 Clock komparator dari phi2b (A5)

Dua inverter setelah phi2b, beban placeholder 20 fF, 45 kondisi: clock naik di dalam gap pada 45/45. Phi2 turun sampai clock naik: 0,28 .. 0,73 ns; clock naik sampai phi1 naik: 9,69 .. 19,68 ns; lama clock tinggi 134,6 .. 145,0 ns. Block 3 melaporkan tunda keputusan terintegrasi terburuk 3,189 ns pada kampanyenya sendiri; definisi kedua angka itu belum dicocokkan, jadi ini bukan klaim margin.

### 4.5 Closed loop (sinus 300 mV, OSR 80, 4112 siklus, FFT 4096 titik, bin 13, TT/27 C/1,8 V)

| Run | Konfigurasi | SNDR (dB) | ENOB |
|---|---|---|---|
| `sine300_n4096` | fase ideal, clock komparator ideal | 75,37 | 12,23 |
| `f1_sine300_b6_n4096` | fase Block 6 (bias ideal), clock komparator ideal | 73,87 | 11,98 |
| `f5_sine300_n2_n4096` | fase Block 6 (bias ideal), clock komparator dari phi2b | 72,44 | 11,74 |
| `f6_sine300_b6res_n4096` | fase Block 6 dengan generator resistor-referensi, clock komparator dari phi2b | 73,62 | 11,94 |

Sebaran SNDR satu run sekitar +-1 dB pada OSR 80, jadi selisih antar baris tidak dinyatakan sebagai degradasi atau perbaikan. Target sistem sekitar 75 dB pada OSR 80.

## 5. Batas yang diketahui (belum dicakup)

- Hanya pre-layout: tanpa ekstraksi atau parasitik; beban node clock adalah placeholder (20 fF).
- Batas di bagian 3 adalah batas saring, tidak diturunkan dari settling Block 5. "Lulus" berarti lulus terhadap batas itu.
- Monte Carlo: hanya mismatch lokal, resistor ideal, tanpa sebaran proses global, hanya tiga titik (tidak digabung dengan 42 kondisi PVT lainnya), masing-masing 100 seed. Di FS/-40 C/1,62 V hasilnya 70/100 terhadap batas lebar (lebar terburuk 67,1 ns); di SF/125 C/1,98 V gap terkecil 6,31 ns (1,3 ns di atas batas).
- Resistor: ngspice tidak menerapkan tempco maupun ketergantungan corner model; tc1/tc2 diterapkan manual. Sebaran R hanya dicakup oleh x0,8 / x1,2 di kondisi ekstrem, tanpa tempco.
- Closed loop hanya di titik nominal (satu amplitudo, satu bin, satu run per konfigurasi).
- Selama rampa suplai phi1 mengikuti VDD dan phi2 bisa naik sampai sebagian VDD (sekitar 0,27 V pada uji awal); efeknya pada saklar Block 5 belum dievaluasi. Beberapa siklus pertama setelah start tidak nominal dan diasumsikan jatuh di dalam reset 5 us, yang merupakan nilai bawaan, bukan syarat tervalidasi. Overlap start-up hanya diukur setelah rampa.
- Arus suplai generator hanya diperkirakan (sekitar 2 x I) dan tidak dilaporkan terpisah.
- Tunda keputusan Block 3 dan angka F5 memakai definisi yang berbeda.

## 6. Keputusan dan iterasi berikutnya

| Tanggal | Keputusan |
|---|---|
| 2026-11-09 | Tutup Block 6 dengan opsi A: yield 70/100 di FS/-40 C/1,62 V terhadap batas saring lebar diterima sebagai batas yang diketahui. |

Belum dikerjakan, berurutan menurut perkiraan dampak: (1) menggeser R ke x0,75-0,8 (x0,8 deterministik memberi lebar >= 109,5 ns di 12 titik ekstrem, tanpa tempco); (2) memperbesar transistor cermin generator untuk mengurangi sebaran; (3) menurunkan syarat lebar dari settling Block 5, bukan dari nilai saring 100 ns. Perubahan R apa pun membatalkan hasil PVT, Monte Carlo, start-up, clock komparator, dan closed loop di atas.

## 7. Berkas dan reproduksi

- Alat (akar repo): `tools/pvt_block6.py`, `tools/bias_gen_block6.py`, `tools/bias_gen_rpdk.py`, `tools/startup_block6.py`, `tools/startup_report_block6.py`, `tools/mc_block6.py`, `tools/summarize_block6.py`; `top_level/closed_loop/tools/f5_clkcmp_pvt.py`; penggerak closed loop `top_level/closed_loop/run_closed_loop_f1.py` (`--b6-bias res`).
- `--repo` pada alat-alat ini menunjuk ke pohon simulasi yang memuat `blocks/06_Clock_gen/sim/out/netlist/`.
- Hasil: `blocks/06_Clock_gen/results/pvt/*.csv`, `results/mc/`, `results/startup/startup_summary.csv`, run closed loop di `top_level/closed_loop/results/closed_loop/` (argumen di `manifest.json`).

## 8. Persetujuan pemilik

- [ ] Bukti di bagian 4 cukup untuk menyatakan Block 6 selesai pada lingkup ini.
- [ ] Batas di bagian 5 diterima sebagai batas yang diketahui.
