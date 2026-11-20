"""DC check (run from an empty scratch directory: writes lvt.spice/out.dat): Vsg needed for 1.55 uA in the OTA input PMOS (W240 L0.6), regular vs LVT, per corner."""
import subprocess
import numpy as np

CORNERS = [("tt", 27, 1.8), ("fs", -40, 1.62), ("ss", -40, 1.62), ("sf", 125, 1.98), ("ff", 125, 1.98)]
DEV = ["sky130_fd_pr__pfet_01v8", "sky130_fd_pr__pfet_01v8_lvt"]
I_TGT = 1.546e-6

def run(dev, corner, temp, vdd):
    deck = f"""* vsg sweep
.option scale=1e-6
.lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice {corner}
.temp {temp}
VS s 0 {vdd}
VG g 0 0
VD d 0 0.4
XM1 d g s s {dev} W=240 L=0.6 nf=1 mult=1
.control
dc VG {vdd} 0 -0.002
wrdata out.dat i(VD)
.endc
.end
"""
    open("lvt.spice", "w").write(deck)
    subprocess.run(["ngspice", "-b", "lvt.spice"], capture_output=True)
    d = np.loadtxt("out.dat")
    vg, i = d[:, 0], np.abs(d[:, 1])
    vsg = vdd - vg
    k = np.argmax(i >= I_TGT)
    need = vsg[k] if i[k] >= I_TGT else float("nan")
    i_at = np.interp(0.9, vg[::-1], i[::-1])           # gate at VCM 0.9 V
    return need, i_at

print(f"{'corner':16s} {'device':30s} {'Vsg@1.55uA':>11s} {'I@VCM0.9':>10s} {'max in-CM':>10s}")
for c, t, v in CORNERS:
    for dev in DEV:
        need, i_at = run(dev, c, t, v)
        print(f"{c}/{t}/{v:<9} {dev:30s} {need:11.3f} {i_at*1e6:9.3f}u {v-need:10.3f}")
