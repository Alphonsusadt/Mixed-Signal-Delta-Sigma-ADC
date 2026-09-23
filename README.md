# Mixed-Signal-Delta-Sigma-ADC
An ASIC-ready 1.8V 2nd-Order Switched-Capacitor Delta-Sigma ADC. End-to-end design from transistor-level (Xschem/ngspice) to RTL Decimation (Verilog) &amp; FPGA prototyping (Tang Nano 20K).

Salin teks di bawah ini dan tempelkan ke dalam file README.md di folder utama proyek Anda. Notion/Markdown akan otomatis merendernya dengan cantik.

🌊 Mixed-Signal Delta-Sigma ADC (ASIC-Ready IP)
StatusToolchain

📖 Project Overview
This repository documents the end-to-end design of a 1.8V 2nd-Order Switched-Capacitor Delta-Sigma Modulator. Designed as an ASIC-ready IP block, the project covers the complete silicon lifecycle: from mathematical noise modeling and transistor-level schematic design to digital decimation and FPGA prototyping.

This portfolio piece demonstrates a T-shaped engineering skillset, bridging the gap between analog physics (kT/C noise, OTA design) and digital system integration (RTL, CIC filters, FPGA timing closure).

🎯 Target Specifications
Parameter	Target Value
Architecture	2nd-Order Switched-Capacitor
Supply Voltage	1.8 V
Sampling Rate	4 MHz
Oversampling Ratio (OSR)	80
Dynamic Range (DR)	~99 dB
Technology (PDK)	Open-Source 130nm / 180nm
🏗️ Architecture & Block Diagram
(TODO: Insert Block Diagram Image Here)

The system is divided into 6 modular IP blocks:

OTA: Two-Stage Class A/AB Fully Differential Amplifier (Ref: Rabii & Wooley, IEEE 1997).
CMFB: Switched-Capacitor Common-Mode Feedback Network.
Quantizer: 1-Bit Dynamic Regenerative Latch.
1-Bit DAC: Rail-to-Rail Feedback Multiplexer.
Switch Network: CMOS Transmission Gates & NMOS switches.
Clock Gen: Two-Phase Non-Overlapping Clock with Delayed Edges.
🛠️ Toolchain Flow
Analog Design: Schematic capture in Xschem.
Analog Simulation: SPICE simulations (AC, Transient) in ngspice (Bitstream extraction).
Digital RTL: Verilog CIC Decimation Filter (No multipliers).
Digital Verification: Icarus Verilog & GTKWave (Self-checking testbench reading the analog bitstream).
Prototyping: Synthesis and Place & Route on Gowin EDA (Tang Nano 20K FPGA).
Validation: Analog reconstruction via R-2R Ladder DAC & Oscilloscope.
📂 Repository Structure
blocks/ - Modular transistor-level schematics, symbols, and SPICE testbenches.
rtl/ - Synthesizable Verilog for CIC decimation and testbenches.
top_level/ - Top-level interconnect of all modular symbols.
fpga/ - Constraints and synthesis reports for Tang Nano 20K.
docs/ - Design rationale, mathematical proofs, and simulation plots.
