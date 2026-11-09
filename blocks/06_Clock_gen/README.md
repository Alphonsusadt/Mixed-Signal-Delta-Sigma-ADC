# Block 6: two-phase non-overlapping clock generator (NONOV)

Generates phi1/phi2 and their complements from one 4 MHz clock (T = 250 ns) with a PVT-tracking bias generator. SKY130, xschem + ngspice, pre-layout.

- Status: closed with known limits (`MEASURED_NOT_FINAL`). Details: [block6_closure_report.md](docs/block6_closure_report.md) (English), [block6_closure_report_ID.md](docs/block6_closure_report_ID.md) (Bahasa Indonesia).
- Headline: 45/45 PVT conditions pass the screening criteria (gap 9.99 .. 20.58 ns, width >= 104.3 ns); fixed ideal bias passes 17/45. Local-mismatch Monte Carlo: 99/100 (TT), 100/100 (SF/125 C/1.98 V), 70/100 (FS/-40 C/1.62 V, width screening limit).
- Per-condition tables: [docs/pvt_results_block6.md](docs/pvt_results_block6.md). Raw data: `results/pvt/`, `results/mc/`, `results/startup/`.
- Schematics: `xschem/B6_*.sch`; testbenches: `sim/`.

Tools live in the repository `tools/` folder (`pvt_block6.py`, `bias_gen_block6.py`, `mc_block6.py`, `startup_block6.py`, `startup_report_block6.py`, `summarize_block6.py`) and `top_level/closed_loop/tools/f5_clkcmp_pvt.py`. Their `--repo` option points to the simulation tree that contains `blocks/06_Clock_gen/sim/out/netlist/`.
