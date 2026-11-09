# Block 6 (NONOV clock generator): closure report

**Status: CLOSED WITH KNOWN LIMITS (project owner chose option A on 2026-11-09).**
Scope: pre-layout ngspice simulation over 45 PVT conditions, plus a local-mismatch Monte Carlo at three points. This is not a sign-off and not post-layout. Status labels: `MEASURED_NOT_FINAL` / `SIMULATED_NOT_FINAL_PASS`.

## 1. Summary

- Block 6 produces the non-overlapping phases phi1/phi2 (and phi1b/phi2b) from one clock, following Spilka et al. (DDECS 2012): XOR, current-starved delay cells, AND2, XOR (80 MOS, T = 250 ns).
- With ideal fixed bias (VBN 0.70 V / VBP 0.71 V) the block works only at the nominal point: **17/45** PVT conditions pass the screening criteria, 10 produce no phases, and the gap spreads from 1.94 to 91.76 ns.
- A PVT-tracking bias generator (one resistor, an NMOS diode, a mirror and a PMOS replica diode) brings this to **45/45** with the gap between 9.99 and 20.58 ns (2.06x spread) and a minimum phase width of 104.3 ns.
- Local-mismatch Monte Carlo (100 seeds per point): 99/100 pass at TT/27 C/1.8 V, 100/100 at SF/125 C/1.98 V, **70/100 at FS/-40 C/1.62 V** (all 30 failures have a phase width below the 100 ns screening limit). This is accepted as a known limit (section 5).
- Closed loop with the generator and the comparator clock from phi2b: SNDR 73.62 dB at OSR 80 (ENOB 11.94), nominal point only, single run.

## 2. Design

- Delay cells are biased by VBN/VBP. Gap is roughly proportional to 1/I of the bias current.
- Bias generator: `RB1` from VDD to VBN, NMOS diode `XBN1` (W 0.5 / L 1), NMOS mirror `XBN2` (VBN to the VBP node), PMOS diode `XBP1` (W 1 / L 1). I = (VDD - VBN) / R. It starts by itself.
- R = 1.247933 MOhm, calibrated so that VBN = 0.700 V at TT/27 C/1.8 V.
- The SKY130 `xhigh_po` model gives 2000 ohm/sq, tc1 = -1.47e-3, tc2 = 2.7e-6. ngspice does not apply the model tempco in this setup (identical current at -40/27/125 C), so the tempco is applied manually to an ideal resistor in the main sweep.
- Resistor length for 1.248 MOhm: about 850 um at W = 1.41 um (603 squares). Layout area is not evaluated.

## 3. Screening criteria used

These are my own engineering thresholds. They are not derived from a switch-settling or comparator-timing budget.

| # | Criterion | Threshold |
|---|---|---|
| A1 | Phases produced in all 45 conditions (5 corners x -40/27/125 C x 1.62/1.8/1.98 V) | 45/45 |
| A2 | Overlap: max over time of min(phi1, phi2) | < 1 % of VDD |
| A3 | Non-overlap gap (smaller of the two) | >= 5 ns |
| A4 | Phase width (smaller of the two), T/2 = 125 ns | >= 100 ns |
| A5 | Comparator clock rises after phi2 falls and before phi1 rises | 45/45 |
| A6 | Start-up: width and gap settle within a few cycles, VDD ramp 1 and 20 us | 4 corners |

Gap + width is 124.7-125.0 ns in every deterministic PVT run (about 123-124 ns on average in Monte Carlo, minimum 110.5 ns), so A3 and A4 trade against each other.

## 4. Results

### 4.1 PVT sweeps (A1-A4)

| Sweep | Conditions | Pass | Gap (ns) | Min width (ns) | Max overlap (% VDD) |
|---|---|---|---|---|---|
| Fixed ideal bias | 45 (35 valid) | 17/45 | 1.94 .. 91.76 | 32.9 | 0.031 |
| Replica diodes, ideal reference current | 45 | 45/45 | 12.09 .. 16.47 | 108.4 | 0.031 |
| Generator, ideal R (no tempco) | 45 | 45/45 | 11.21 .. 18.73 | 106.2 | 0.031 |
| Generator, PDK resistor (tempco not applied by ngspice) | 45 | 45/45 | 11.34 .. 18.85 | 106.0 | 0.031 |
| **Generator, R with tc1/tc2 (main)** | 45 | **45/45** | **9.99 .. 20.58** | **104.3** | 0.031 |
| Generator, R x 0.8 (no tempco) | 12 extremes | 12/12 | 9.14 .. 15.35 | 109.5 | 0.012 |
| Generator, R x 1.2 (no tempco) | 12 extremes | 12/12 | 13.26 .. 22.06 | 102.8 | 0.012 |

Main sweep extremes: smallest gap 9.99 ns at SF/125 C/1.98 V; largest gap 20.58 ns and smallest width 104.31 ns at FS/-40 C/1.62 V; largest overlap 0.62 mV at FF/125 C/1.98 V. Per-condition tables: [pvt_results_block6.md](pvt_results_block6.md).

### 4.2 Monte Carlo, local mismatch (100 seeds per point)

`tt_mm` / `fs_mm` / `sf_mm` library corners with `.option seed`; main-sweep generator (R with tempco). Only local transistor mismatch is random.

| Point | Pass | Gap (ns), mean +- sd (min .. max) | Width (ns), mean +- sd (min .. max) |
|---|---|---|---|
| TT, 27 C, 1.8 V | 99/100 | 14.0 +- 2.85 (7.78 .. 24.69) | 109.9 +- 3.20 (94.2 .. 115.1) |
| SF, 125 C, 1.98 V (smallest gap) | 100/100 | 10.0 +- 1.56 (6.31 .. 15.53) | 114.4 +- 1.69 (106.8 .. 117.4) |
| FS, -40 C, 1.62 V (smallest width) | **70/100** | 20.9 +- 5.50 (9.95 .. 43.41) | 102.0 +- 6.50 (67.1 .. 111.5) |

- Monte Carlo means match the deterministic values at the same points (10.00 vs 9.99 ns at SF; 20.9 vs 20.58 ns at FS).
- The 30 failures at FS/-40 C/1.62 V all have width < 100 ns; the gap never falls below 5 ns. The 95 % interval for 70/100 is about 60-78 %.
- The distributions are skewed (Shapiro p < 0.01), so mean - 3 sd is not a 3-sigma claim. The worst measured width (67.1 ns) is far below the Gaussian extrapolation.
- The same seeds are worst in all three runs (seed 2046: smallest width; seed 2038: smallest gap) and the per-seed gap correlates 0.99 between FS and SF. This is consistent with a common bias-current component, for example the small generator mirror devices. It was not tested.
- Overlap stays below 0.05 mV in all 300 samples. Raw per-seed data: `results/mc/`.

### 4.3 Start-up (A6)

VDD ramps from 0 V; the clock starts after the ramp (ramp 1 and 20 us) or during it (ramp 1 us only). 12 runs, all settle (final width and gap within 1 ns, gap >= 5 ns, width >= 100 ns, overlap < 1 % VDD).

| Corner / T / VDD | Final gap (ns) | Final width (ns) | Overlap (mV) | Pulses to settle (after / during) |
|---|---|---|---|---|
| TT / 27 C / 1.8 V | 13.93 | 110.98 | 0.004 | 2 / 3 |
| SS / -40 C / 1.62 V | 19.70 | 105.11 | 0.004 | 2 / 3 |
| FF / 125 C / 1.98 V | 10.85 | 114.16 | 0.619 | 2 / 4 |
| FS / -40 C / 1.98 V | 15.94 | 108.99 | 0.004 | 2 / 3 |

The final values equal the PVT sweep values. The first pulse in mode "after" is not a clock pulse: phi1 follows VDD and stays high during the whole ramp (300 ns to 10 us wide) until the clock starts.

### 4.4 Comparator clock from phi2b (A5)

Two inverters after phi2b, 20 fF placeholder load, 45 conditions: the clock rises inside the gap in 45/45. phi2 fall to clock rise: 0.28 .. 0.73 ns; clock rise to phi1 rise: 9.69 .. 19.68 ns; clock high time 134.6 .. 145.0 ns. Block 3 reports a worst-case integrated decision delay of 3.189 ns in its own campaign; the definitions of the two numbers were not matched, so this is not a margin claim.

### 4.5 Closed loop (300 mV sine, OSR 80, 4112 cycles, 4096-point FFT, bin 13, TT/27 C/1.8 V)

| Run | Configuration | SNDR (dB) | ENOB |
|---|---|---|---|
| `sine300_n4096` | ideal phases, ideal comparator clock | 75.37 | 12.23 |
| `f1_sine300_b6_n4096` | Block 6 phases (ideal bias), ideal comparator clock | 73.87 | 11.98 |
| `f5_sine300_n2_n4096` | Block 6 phases (ideal bias), comparator clock from phi2b | 72.44 | 11.74 |
| `f6_sine300_b6res_n4096` | Block 6 phases with the resistor-reference generator, comparator clock from phi2b | 73.62 | 11.94 |

Single-run SNDR scatter is about +-1 dB at OSR 80, so differences between rows are not claimed as degradation or improvement. The system target is about 75 dB at OSR 80.

## 5. Known limits (not covered)

- Pre-layout only: no extraction or parasitics; the clock-node load is a placeholder (20 fF).
- The thresholds in section 3 are screening limits, not derived from Block 5 settling. "Pass" means pass against them.
- Monte Carlo: local mismatch only, resistor ideal, no global process spread, three points only (not combined with the other 42 PVT conditions), 100 seeds each. At FS/-40 C/1.62 V the yield is 70/100 against the width limit (worst width 67.1 ns); at SF/125 C/1.98 V the smallest gap is 6.31 ns (1.3 ns above the limit).
- Resistor: ngspice does not apply the model tempco or corner dependence; tc1/tc2 were applied manually. Resistor spread is covered only by x0.8 / x1.2 at the extreme conditions, without tempco.
- Closed loop only at the nominal point (one amplitude, one bin, one run per configuration).
- During the supply ramp phi1 follows VDD and phi2 can rise to a fraction of VDD (about 0.27 V in an earlier test); the effect on the Block 5 switches is not evaluated. The first cycles after start are not nominal and are assumed to fall inside the 5 us reset, which is a default, not a validated requirement. Start-up overlap is measured only after the ramp.
- Generator supply current is estimated (about 2 x I) and not separately reported.
- Block 3 decision delay and the F5 numbers use different definitions.

## 6. Decision and next iteration

| Date | Decision |
|---|---|
| 2026-11-09 | Close Block 6 with option A: accept the 70/100 yield at FS/-40 C/1.62 V against the width screening limit as a known limit. |

Not done, in order of expected effect: (1) re-centre R to x0.75-0.8 (deterministic x0.8 gives width >= 109.5 ns at the 12 extremes, without tempco); (2) enlarge the generator mirror devices to reduce the spread; (3) derive the width requirement from Block 5 settling instead of the 100 ns screening value. Any change of R invalidates the PVT, Monte Carlo, start-up, comparator-clock and closed-loop results above.

## 7. Files and reproduction

- Tools (repo root): `tools/pvt_block6.py`, `tools/bias_gen_block6.py`, `tools/bias_gen_rpdk.py`, `tools/startup_block6.py`, `tools/startup_report_block6.py`, `tools/mc_block6.py`, `tools/summarize_block6.py`; `top_level/closed_loop/tools/f5_clkcmp_pvt.py`; closed-loop driver `top_level/closed_loop/run_closed_loop_f1.py` (`--b6-bias res`).
- `--repo` of these tools points to the simulation tree that holds `blocks/06_Clock_gen/sim/out/netlist/`.
- Results: `blocks/06_Clock_gen/results/pvt/*.csv`, `results/mc/`, `results/startup/startup_summary.csv`, closed-loop runs under `top_level/closed_loop/results/closed_loop/` (arguments in `manifest.json`).

## 8. Owner approval

- [ ] Evidence in section 4 is enough to call Block 6 closed at this scope.
- [ ] Limits in section 5 are accepted as known limits.
