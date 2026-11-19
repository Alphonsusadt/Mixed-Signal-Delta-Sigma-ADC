# Block 5 (Switch Network) - Closure Report (final)

Bahasa Indonesia: [block5_closure_report_ID.md](block5_closure_report_ID.md)

**Document status: APPROVED by the project owner on 2026-11-02 (stage 8), for the nominal pre-layout scope. This is not a PVT or post-layout sign-off.**
Scope of the claims: nominal TT / 1.8 V / 27 C, pre-layout, simulation. Status labels: MEASURED_NOT_FINAL / SIMULATED_NOT_FINAL_PASS.

## 1. Decisions taken
| Stage | Decision | Date |
|---|---|---|
| 4 | Block 5 pedestal accepted as MEASURED_NOT_FINAL (no numeric acceptance limit) | 2026-11-02 |
| 6 | Closed with option A: the OTA at the loop bias with closed CMFB is recorded as a known limit | 2026-11-02 |
| 7 | Specification revised: SNDR ~75 dB at OSR 80, BW 25 kHz (fs 4 MHz), not 99 dB | 2026-11-02 |

## 2. Measured evidence
| Test | Result | Status | Files |
|---|---|---|---|
| Closed-loop DC (100 mV) | mean V = +0.1002 V (expected 0.1 V), no rail | SIMULATED_NOT_FINAL_PASS | dc100b |
| Closed-loop sine, 4096 points, bin 13, -6 dBFS | SNDR 75.37 dB @ OSR 80 (ENOB 12.23); model 77.16 dB (model range over phase 75.3-78.8) | SIMULATED_NOT_FINAL_PASS | sine300_n4096 |
| Noise shape (2nd order) | rise of 14-17 dB per doubling of the band; HD2 -77.8 dBc, HD3 -72.0 dBc (model -76.9 / -68.3) | MEASURED_NOT_FINAL | computed from the bitstream |
| Hold error E1-E6 (Block5_SH LVT) | pedestal +3.302 mV / -1.834 mV (1.1 V / 0.7 V), P/N symmetric; CH 2 pF -> x0.52/x0.50; 5 ns edge -> x0.76/x1.02; standard Vt -> x0.16/x0.79; no feedthrough/leakage | MEASURED_NOT_FINAL | tb_5F_E1..E6 |
| E7 aperture | input-step capture window ~3 ns (delta -3..0 ns); delta >= +1 ns: step ignored | MEASURED_NOT_FINAL | tb_5F_E7 |
| E8 pedestal vs level | -3.19 mV (0.2 V) ... +9.28 mV (1.6 V); differential gain error +0.964 %; peak INL 1.36 mV (0.0485 % of +-1.4 V); P = N at the same level | MEASURED_NOT_FINAL | tb_5F_E8 |
| MIM (stage 3) | the model ignores MF, only m multiplies; unit 2.645 fF | MEASURED_NOT_FINAL | tb_MIM_C_AC |
| OTA AC (stage 6), OTA_experiment (Block 1) only | MF=80: 69.34 dB / 3.153 MHz / PM 61.37; MF=100: 69.34 dB / 2.711 MHz / PM 66.61; Vbz has no effect. NOT the OTA used in the loop (see section 3) | MEASURED_NOT_FINAL | tb_6A..6D |

## 3. Known limits (NOT yet verified)
- No transient noise in the decks or the model: 75.4 dB is the quantisation limit plus deterministic non-idealities; kT/C, OTA thermal noise and comparator noise are not included.
- One amplitude (-6 dBFS), one bin (13/4096), one corner; no amplitude sweep, no PVT, no post-layout yet.
- The standalone Block5_SH is not inside the loop (the loop uses TG_SC_LVT in the stage core): the E1-E8 results do not automatically apply to the loop.
- Old 450 ns anomaly: consistent with an input step that falls inside the ~3 ns aperture window (hypothesis, not proven because the original stimulus is not available).
- OTA at the loop bias (Vbias 0.58) with closed CMFB: not characterized (6C failed in the ideal-CMFB harness).
- **Correction 2026-11-02:** the OTA in the loop netlist (S1_OTA_CMFB / S2_OTA_CMFB, equivalent to OTA_CMFB.sch) is NOT the OTA_experiment characterized in the Block 1 report. Sizing differs (M1/M2 240/0.6 vs 120/1.2; M5/M6 40/2 vs 20/2; M7/M8 60/2 vs 30/2; M9/M10 60/1 vs 300/1; M11/M12 80/1 vs 200/1; M13 480/1.2 vs 60/1.2), the Vbz (nulling) branch is still present, and Cc = 264.5 fF (MF=100). The stage 6 results (MF=80 vs 100) and the Block 1 metrics therefore must not be attributed to the loop OTA. The AC response of the loop OTA (OTA_CMFB + SC-CMFB, bias 0.58 V) is not characterized; how to handle it is the project owner's decision.
- Vbz has no influence in the AC harness; the cause has not been traced.
- DC offset: only measured through DC 100 mV (error 0.2 mV), not at DC 0.
- I1/I2/CMFB sizing not changed (dossier rule).

## 4. Approval list (filled in by the project owner)
- [x] The evidence in section 2 is sufficient to declare Block 5 done for the nominal pre-layout scope.
- [x] The limits in section 3 are accepted as known limits.
- [x] The ~75 dB @ OSR 80 (BW 25 kHz) specification is used for documentation and the portfolio.
- [ ] Result files committed to git: decided by the owner at commit time (not decided; avoid *.bak, backup_pre_v2/, large .dat).

Approval given: Block 6 may start. The numbering of Block 6 (clock generator or CIC) was not fixed at the time and was left to the project owner (it became the clock generator; the CIC is Block 7).

## 5. Later updates (after closure)
- 2026-11-19: in the Xschem hierarchy the loop OTA now takes its compensation capacitors from parameter `CC_MF` (default 1000 for the Block 1/2/5 testbenches; `SD_STAGE` uses 100, as the closed-loop decks). Before this change `SD_TOP.sch` did not match the closed-loop decks. See the commit "Fix Xschem hierarchy so SD_TOP matches the f6 closed-loop deck".
