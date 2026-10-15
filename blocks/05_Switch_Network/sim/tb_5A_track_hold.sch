v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {5A FIRST TESTBENCH: TRACK / HOLD, NO OTA} 100 -480 0 0 0.4 0.4 {}
T {TT, 1.8 V, 27 C; CH=1p per side inside Block5_SH; WN/WP=2/4 um; L=0.15 um.} 100 -430 0 0 0.25 0.25 {}
T {Verify this schematic and its exported netlist before running the Python sweeps.} 100 -390 0 0 0.25 0.25 {}
T {SOURCES: input P/N, VDD, clock/complement, common-mode. Both inputs change while HOLD is active.} 100 0 0 0 0.22 0.22 {}
T {Plots and .dat come from ngspice after simulation. Expected reference values are in START_HERE_XSCHEM_ID.md.} 100 450 0 0 0.22 0.22 {}
N 220 -260 250 -260 {lab=SRC_P}
N 470 -260 640 -260 {lab=vin_p}
N 380 -240 410 -240 {lab=SRC_N}
N 470 -240 640 -240 {lab=vin_n}
N 580 -320 640 -320 {lab=PHI_SH}
N 580 -300 640 -300 {lab=PHI_SHB}
N 580 -280 640 -280 {lab=VCM}
N 860 -400 910 -400 {lab=VDD}
N 860 -140 910 -140 {lab=0}
N 940 -280 1100 -280 {lab=HOLD_P}
N 940 -260 1100 -260 {lab=HOLD_N}
N 120 40 120 70 {lab=SRC_P}
N 120 130 120 150 {lab=0}
N 320 40 320 70 {lab=SRC_N}
N 320 130 320 150 {lab=0}
N 520 40 520 70 {lab=VDD}
N 520 130 520 150 {lab=0}
N 120 270 120 300 {lab=PHI_SH}
N 120 360 120 380 {lab=0}
N 320 270 320 300 {lab=PHI_SHB}
N 320 360 320 380 {lab=0}
N 520 270 520 300 {lab=VCM}
N 520 360 520 380 {lab=0}
N 310 -260 470 -260 {lab=vin_p}
C {lab_pin.sym} 220 -260 2 1 {name=lSRCP lab=SRC_P}
C {res.sym} 280 -260 1 0 {name=RSP value=100 m=1}
C {lab_pin.sym} 380 -240 2 1 {name=lSRCN lab=SRC_N}
C {res.sym} 440 -240 1 0 {name=RSN value=100 m=1}
C {lab_pin.sym} 580 -320 2 1 {name=lPHI_SH lab=PHI_SH}
C {lab_pin.sym} 580 -300 2 1 {name=lPHI_SHB lab=PHI_SHB}
C {lab_pin.sym} 580 -280 2 1 {name=lVCM lab=VCM}
C {lab_pin.sym} 910 -400 0 1 {name=lVDD lab=VDD}
C {gnd.sym} 910 -140 0 0 {name=gDUT lab=0}
C {lab_pin.sym} 1100 -280 0 1 {name=lHOLD_P lab=HOLD_P}
C {lab_pin.sym} 1100 -260 0 1 {name=lHOLD_N lab=HOLD_N}
C {vsource.sym} 120 100 0 0 {name=VINP_SRC value="PULSE(0.95 0.85 180n 1n 1n 249n 500n)" savecurrent=false}
C {lab_pin.sym} 120 40 0 1 {name=ls0 lab=SRC_P}
C {gnd.sym} 120 150 0 0 {name=gs0 lab=0}
C {vsource.sym} 320 100 0 0 {name=VINN_SRC value="PULSE(0.85 0.95 180n 1n 1n 249n 500n)" savecurrent=false}
C {lab_pin.sym} 320 40 0 1 {name=ls1 lab=SRC_N}
C {gnd.sym} 320 150 0 0 {name=gs1 lab=0}
C {vsource.sym} 520 100 0 0 {name=VDD_SRC value="1.8" savecurrent=false}
C {lab_pin.sym} 520 40 0 1 {name=ls2 lab=VDD}
C {gnd.sym} 520 150 0 0 {name=gs2 lab=0}
C {vsource.sym} 120 330 0 0 {name=VPHI_SRC value="PULSE(0 1.8 30n 1n 1n 110n 250n)" savecurrent=false}
C {lab_pin.sym} 120 270 0 1 {name=ls3 lab=PHI_SH}
C {gnd.sym} 120 380 0 0 {name=gs3 lab=0}
C {vsource.sym} 320 330 0 0 {name=VPHIB_SRC value="PULSE(1.8 0 30n 1n 1n 110n 250n)" savecurrent=false}
C {lab_pin.sym} 320 270 0 1 {name=ls4 lab=PHI_SHB}
C {gnd.sym} 320 380 0 0 {name=gs4 lab=0}
C {vsource.sym} 520 330 0 0 {name=VCM_SRC value="0.9" savecurrent=false}
C {lab_pin.sym} 520 270 0 1 {name=ls5 lab=VCM}
C {gnd.sym} 520 380 0 0 {name=gs5 lab=0}
C {sky130_fd_pr/corner.sym} 940 100 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 740 100 0 0 {name=SIM only_toplevel=true value="
* Native Xschem first check: standalone TG sampler, CH=1p, RS=100 ohm.
* Uses the existing Xschem SKY130 PDK setup via corner.sym.
.option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
* Numerical initial condition, not a silicon reset circuit.
.ic V(HOLD_P)=0.9 V(HOLD_N)=0.9
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 0.1n 1u 0 0.1n
let VIN_D = v(VIN_P)-v(VIN_N)
let HOLD_D = v(HOLD_P)-v(HOLD_N)
let HOLD_CM = (v(HOLD_P)+v(HOLD_N))/2
meas tran HOLDP_TRACK1 FIND v(HOLD_P) AT=125n
meas tran HOLDN_TRACK1 FIND v(HOLD_N) AT=125n
meas tran HOLDP_HOLD1 FIND v(HOLD_P) AT=240n
meas tran HOLDN_HOLD1 FIND v(HOLD_N) AT=240n
meas tran HOLDP_TRACK2 FIND v(HOLD_P) AT=375n
meas tran HOLDN_TRACK2 FIND v(HOLD_N) AT=375n
wrdata tb_5A_track_hold.dat v(SRC_P) v(SRC_N) v(VIN_P) v(VIN_N) v(HOLD_P) v(HOLD_N) v(PHI_SH) v(PHI_SHB) VIN_D HOLD_D HOLD_CM
plot v(PHI_SH) v(PHI_SHB)
plot v(VIN_P) v(HOLD_P)
plot v(VIN_N) v(HOLD_N)
plot VIN_D HOLD_D
plot HOLD_CM
.endc
"}
C {blocks/05_Switch_Network/xschem/Block5_SH.sym} 790 -280 0 0 {name=x1}
C {lab_wire.sym} 490 -260 0 0 {name=p1 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} 520 -240 0 0 {name=p2 sig_type=std_logic lab=vin_n}
