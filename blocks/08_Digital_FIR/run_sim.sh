#!/usr/bin/env bash
# Block 8: design the FIR, regenerate data, run the Icarus testbench, optional synthesis.
# Usage (from anywhere):  bash blocks/08_Digital_FIR/run_sim.sh [synth]
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
python3 python/fir_ref.py
iverilog -g2012 -I rtl -o build/tb.vvp rtl/fir_comp.v tb/tb_fir_comp.v
vvp -n build/tb.vvp +STRIDE=23
vvp -n build/tb.vvp +STRIDE=24
vvp -n build/tb.vvp +STRIDE=540
vvp -n build/tb.vvp +OVR=1
if [ "${1:-}" = "synth" ]; then
  yosys -q -p "read_verilog -sv -I rtl rtl/fir_comp.v; synth_gowin -top fir_comp -json build/fir_gowin.json; tee -o build/fir_stat.txt stat"
  cat build/fir_stat.txt
fi
