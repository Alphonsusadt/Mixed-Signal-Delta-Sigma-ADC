# Closed-loop Sigma-Delta orde-2 (SKY130) — paket uji Python + ngspice

**STATUS: SIMULATED_NOT_FINAL_PASS pada level model perilaku; level transistor = NOT_RUN.**
Sandbox pembuat tidak punya ngspice/PDK. Yang sudah dijalankan: `sd_behavioral.py`, studi perilaku,
`run_closed_loop.py --check` (CHECK_OK, jumlah pin semua instance cocok) dan `--selftest`
(jalur parser→bit→SNDR cocok dengan model). Deck transistor-level BELUM pernah dieksekusi.

## Arsitektur
- STAGE1 + STAGE2 (file Anda, tidak diubah) → StrongARM → 2×BUF_B01 → SR_Latch → DAC_1bit (blok 4E apa adanya).
- Cabang sampling DAC baru `spice/fb_sampler.spice` ditempel di node `sum_p/sum_n` tiap stage (Cd=1p, TG LVT sama dengan Block 5).
- Komparator: Vin1=out2_p, Vin2=out2_n. DAC: VREFP 1.2 V / VREFN 0.6 V, tengah 0.9 V = VCM.
- Polaritas (KOREKSI setelah run smoke2, transistor-level): stage di netlist ini NON-inverting (input P→sum_P menaikkan output). Terukur: stage 1 + SWAP → Δy1 = −b1·V (0,300 V/siklus untuk V=±0,6); I1→I2: Δy2 = +0,47·y1 (fit, 4 titik, residu 7e-4). Maka stage 2 harus memakai `FB_SAMP_SWAP` juga (−b2·V). `FB_SAMP_STRAIGHT` di stage 2 (smoke2) = umpan balik positif: I2 menempel di rail. Default `--fb2 swap`. Model perilaku setara dengan y1_rangkaian = −y1_model.
- Model: y1[n+1]=y1[n]−a1·u+b1·v ; y2[n+1]=y2[n]−a2·y1[n]−b2·v ; a=Cs/Cf=0.5, b=Cd/Cf=0.5.

## Urutan pakai (satu variabel per eksperimen)
```
python3 run_closed_loop.py --check
python3 run_closed_loop.py --run --name smoke --cycles 24 --reset-us 2 --dc-mv 0
python3 run_closed_loop.py --run --name dc100 --cycles 512 --dc-mv 100
python3 run_closed_loop.py --run --name sin --cycles 4096 --amp-mv 300 --bin 13 --osr 16 --model
python3 run_closed_loop.py --analyze results/closed_loop/sin/waveform.dat --amp-mv 300 --cycles 4096 --osr 16
```
Cek tes DC: rata-rata v_d ≈ (a1/b1)·u_d = u_d. Periksa `ngspice.log` pada error pertama, bukan baris terakhir.

## Yang belum diverifikasi (jujur)
1. Bias default = nilai testbench I2; stage-1 mungkin butuh set bias lain (hipotesis: CM collapse I1).
2. `wrdata` + `linearize` belum diuji; fallback `--no-linearize`.
3. OTA dalam loop ≠ OTA Block 1 yang dikarakterisasi.
4. Kapasitor MIM: netlist memuat MF=100 dan m=100 (kemungkinan multiplisitas ganda) — uji dengan pengukuran kapasitansi AC.
5. Hold error Block 5 asimetris (penyebab belum ditentukan).
6. Durasi reset 20 µs adalah default, bukan syarat desain tervalidasi.
7. Spesifikasi: SNDR/DR 99 dB pada OSR 80 tidak tercapai orde-2 1-bit (ideal ≈75 dB); butuh OSR≈256 atau orde/bit lebih tinggi, atau revisi spesifikasi.
