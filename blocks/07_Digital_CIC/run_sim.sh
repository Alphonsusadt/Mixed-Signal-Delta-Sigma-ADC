#!/usr/bin/env bash
# Block 7: regenerate data, run the Icarus testbench, optional synthesis.
# Usage (from anywhere):  bash blocks/07_Digital_CIC/run_sim.sh [synth]
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
python3 python/cic_ref.py
iverilog -g2012 -o build/tb.vvp rtl/cic3.v tb/tb_cic3.v
vvp -n build/tb.vvp +STIM=f6    +STRIDE=1
vvp -n build/tb.vvp +STIM=f6    +STRIDE=7
vvp -n build/tb.vvp +STIM=f6    +STRIDE=128
vvp -n build/tb.vvp +STIM=ones  +STRIDE=1
vvp -n build/tb.vvp +STIM=zeros +STRIDE=3
if [ "${1:-}" = "synth" ]; then
  yosys -q -p "read_verilog -sv rtl/cic3.v; synth_gowin -top cic3 -json build/cic3_gowin.json; tee -o build/cic3_stat.txt stat"
  cat build/cic3_stat.txt
fi
