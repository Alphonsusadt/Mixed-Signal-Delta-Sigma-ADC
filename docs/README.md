# Documentation index

Technical reports per block (English / Bahasa Indonesia). All results: nominal, pre-layout, simulation unless stated in the report.
System target (revised 2026-11-02): ~75 dB SNDR at OSR 80, 25 kHz bandwidth.

## Analog modulator (transistor level, SPICE)

| Block | Report EN | Report ID | Closure / notes |
|---|---|---|---|
| 1 OTA (Rev 2) | [EN](../blocks/01_OTA/docs/Block1_OTA_Report_EN.pdf) | [ID](../blocks/01_OTA/docs/Block1_OTA_Report_ID.pdf) | |
| 2 SC-CMFB | [EN](../blocks/02_CMFB/docs/Block2_SC_CMFB_Report_EN.pdf) | [ID](../blocks/02_CMFB/docs/Block2_SC_CMFB_Report_ID.pdf) | |
| 3 StrongARM + SR latch | [EN](../blocks/03_StrongARM/docs/Block3_StrongARM_Report_EN.pdf) | [ID](../blocks/03_StrongARM/docs/Block3_StrongARM_Report_ID.pdf) | |
| 4 1-bit DAC (Rev 1.1) | [EN](../blocks/04_1Bit_DAC/docs/Block4_DAC_Report_EN.pdf) | [ID](../blocks/04_1Bit_DAC/docs/Block4_DAC_Report_ID.pdf) | |
| 5 Switch network | [EN](../blocks/05_Switch_Network/docs/Block5_SwitchNetwork_Report_EN.pdf) | [ID](../blocks/05_Switch_Network/docs/Block5_SwitchNetwork_Report_ID.pdf) | closure report [EN](../blocks/05_Switch_Network/docs/block5_closure_report.md) / [ID](../blocks/05_Switch_Network/docs/block5_closure_report_ID.md) |
| 6 Clock generator (NONOV) | [EN](../blocks/06_Clock_gen/docs/Block6_ClockGen_Report_EN.pdf) | [ID](../blocks/06_Clock_gen/docs/Block6_ClockGen_Report_ID.pdf) | [README](../blocks/06_Clock_gen/README.md); closure report [EN](../blocks/06_Clock_gen/docs/block6_closure_report.md) / [ID](../blocks/06_Clock_gen/docs/block6_closure_report_ID.md); [PVT tables](../blocks/06_Clock_gen/docs/pvt_results_block6.md) |

## Top level (Blocks 1-6 together)

| Item | Where |
|---|---|
| Closed-loop runs driven from Python (SNDR from the bitstream) | [top_level/closed_loop/README.md](../top_level/closed_loop/README.md) |
| Xschem top level and system testbench (sources, probes, oscilloscope graphs) | `top_level/xschem/SD_TOP.sch`, `top_level/xschem/tb_SD_TOP.sch`, result figure `top_level/xschem/tb_SD_TOP_scope.png` |
| Raw-file viewer with A/B cursors | `top_level/closed_loop/tools/view_raw.py` |

## Digital back end (RTL)

| Block | Documentation |
|---|---|
| 7 sinc^3 CIC decimator | [blocks/07_Digital_CIC/README.md](../blocks/07_Digital_CIC/README.md) |
| 8 CIC droop-compensation FIR | [blocks/08_Digital_FIR/README.md](../blocks/08_Digital_FIR/README.md) |

What the FPGA demonstration does and does not show (replayed transistor-level bitstream versus an ideal behavioral model): see the root [README](../README.md#fpga-demonstration-what-it-shows-and-what-it-does-not).
