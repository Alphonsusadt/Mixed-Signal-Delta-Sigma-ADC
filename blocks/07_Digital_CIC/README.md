# Block 7 - sinc^3 CIC decimator

Status of every number here: `SIMULATED_NOT_FINAL_PASS` (RTL simulation and a model; not yet run on the FPGA).

## Place in the chain

```
modulator bitstream (1 bit, 4 MHz) -> cic3, sinc^3 R=80 (this block) -> fir_comp (Block 8) -> 21-bit samples, 50 kHz
```

The 1-bit bitstream of the 2nd-order modulator carries the signal in its density of ones; its quantisation noise is pushed to high frequencies. The CIC (Hogenauer cascaded integrator-comb) removes most of that noise and lowers the rate by R = 80, from 4 MHz to 50 kHz, turning the 1-bit stream into 20-bit numbers.

## Design

| Item | Value |
|---|---|
| Structure | 3 integrators at 4 MHz -> decimation by 80 -> 3 combs at 50 kHz (no multipliers) |
| Input mapping | bit 1 -> +1, bit 0 -> -1 |
| Word width | 20-bit two's complement with wrap-around (modular arithmetic, as in a standard Hogenauer CIC). DC gain R^3 = 512000 needs 20 signed bits |
| Response | sinc^3; droop 0.7224 (-2.8 dB) at the 12.7 kHz test tone, -11.8 dB at 25 kHz; compensated by Block 8 |
| Timing | the three integrators are chained in one clock; the combs are registered and need decimated samples at least 4 clocks apart |
| Interface | `din_valid`/`din` (one pulse per modulator bit) -> `dout_valid`/`dout` (one pulse per decimated sample); synchronous active-high reset |

## Results

| Check | Result |
|---|---|
| W-bit wrap-around model == exact integer model | equal |
| Model == sinc^3 FIR (boxcar of 80 convolved 3 times) | equal |
| Full scale +-512000 fits in 20 bits | yes |
| RTL vs model (Icarus): f6 bitstream at input spacing 1, 7 and 128 clocks, all ones, all zeros | 5/5 scenarios, 51/51 outputs each, 0 mismatches (re-run on 2026-11-19) |
| Mutation: W = 18 | fails as expected |
| f6 tone after the CIC | amplitude 0.3613 FS, expected 0.5 x 0.7224 = 0.3612 (sine fit on 47 points, illustrative only, NOT an SNDR) |
| Yosys `synth_gowin` estimate (not P&R) | about 138 LUT, 127 ALU, 211 FF |

## Run

```
bash blocks/07_Digital_CIC/run_sim.sh          # data from the f6 bitstream, 5 testbench runs
bash blocks/07_Digital_CIC/run_sim.sh synth    # plus yosys synth_gowin statistics
```

Input bitstream: `top_level/closed_loop/results/closed_loop/f6_sine300_b6res_n4096/bitstream.txt` (transistor-level closed-loop run f6). `data/` and `build/` are generated and not tracked.

## Limits

- Only RTL simulation so far. The FPGA test (replayed f6 bitstream on the Tang Nano 20K, on-chip comparison with golden data) is the next step; see "FPGA demonstration" in the root README.
- 4096 input bits give 51 output samples: enough for bit-exact checks, not for an SNDR measurement at the decimated rate.
