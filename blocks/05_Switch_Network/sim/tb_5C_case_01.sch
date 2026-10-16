v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {5C: SWITCHING ERROR AND HOLD DROOP; INPUTS STAY DC} 100 -480 0 0 0.35 0.35 {}
T {TT, 1.8 V, 27 C; CH=1p/side; RS=100 ohm; WN/WP=2/4 um; L=0.15 um.} 100 -430 0 0 0.24 0.24 {}
T {VIN_P=0.6 V; VIN_N=1.2 V; edge=0.2 ns; PMOS-clock delay relative to NMOS=-0.5 ns.} 100 -390 0 0 0.22 0.22 {}
T {Single track then long hold. Both gate transitions complete at 140.4 ns.} 100 0 0 0 0.22 0.22 {}
T {Pedestal combines turn-off effects. Long hold is a stress test, not normal 4 MHz operation.} 100 450 0 0 0.22 0.22 {}
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
N 190 -180 220 -180 {lab=SRC_P}
N 440 -180 610 -180 {lab=vin_p}
N 350 -160 380 -160 {lab=SRC_N}
N 440 -160 610 -160 {lab=vin_n}
N 550 -240 610 -240 {lab=PHI_SH}
N 550 -220 610 -220 {lab=PHI_SHB}
N 550 -200 610 -200 {lab=VCM}
N 830 -320 880 -320 {lab=VDD}
N 830 -60 880 -60 {lab=0}
N 910 -200 1070 -200 {lab=HOLD_P}
N 910 -180 1070 -180 {lab=HOLD_N}
N 280 -180 440 -180 {lab=vin_p}
C {vsource.sym} 120 100 0 0 {name=VINP_SRC value="0.6" savecurrent=false}
C {lab_pin.sym} 120 40 0 1 {name=ls0 lab=SRC_P}
C {gnd.sym} 120 150 0 0 {name=gs0 lab=0}
C {vsource.sym} 320 100 0 0 {name=VINN_SRC value="1.2" savecurrent=false}
C {lab_pin.sym} 320 40 0 1 {name=ls1 lab=SRC_N}
C {gnd.sym} 320 150 0 0 {name=gs1 lab=0}
C {vsource.sym} 520 100 0 0 {name=VDD_SRC value="1.8" savecurrent=false}
C {lab_pin.sym} 520 40 0 1 {name=ls2 lab=VDD}
C {gnd.sym} 520 150 0 0 {name=gs2 lab=0}
C {vsource.sym} 120 330 0 0 {name=VPHI_SRC value="PULSE(0 1.8 30n 2e-10 2e-10 110n 2.2808e-06)" savecurrent=false}
C {lab_pin.sym} 120 270 0 1 {name=ls3 lab=PHI_SH}
C {gnd.sym} 120 380 0 0 {name=gs3 lab=0}
C {vsource.sym} 320 330 0 0 {name=VPHIB_SRC value="PULSE(1.8 0 2.95e-08 2e-10 2e-10 110n 2.2808e-06)" savecurrent=false}
C {lab_pin.sym} 320 270 0 1 {name=ls4 lab=PHI_SHB}
C {gnd.sym} 320 380 0 0 {name=gs4 lab=0}
C {vsource.sym} 520 330 0 0 {name=VCM_SRC value="0.9" savecurrent=false}
C {lab_pin.sym} 520 270 0 1 {name=ls5 lab=VCM}
C {gnd.sym} 520 380 0 0 {name=gs5 lab=0}
C {sky130_fd_pr/corner.sym} 940 100 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 740 100 0 0 {name=SIM only_toplevel=true value="
.option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
.ic V(HOLD_P)=0.9 V(HOLD_N)=0.9
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 2.5e-11 1.1404e-06 0 2.5e-11
let HOLD_D = v(HOLD_P)-v(HOLD_N)
let HOLD_CM = (v(HOLD_P)+v(HOLD_N))/2
let ERR_P = v(HOLD_P)-v(SRC_P)
let ERR_N = v(HOLD_N)-v(SRC_N)
meas tran HP_PRE FIND v(HOLD_P) AT=1.387e-07
meas tran HP_POST FIND v(HOLD_P) AT=1.454e-07
meas tran HP_D0 FIND v(HOLD_P) AT=1.604e-07
meas tran HP_D1 FIND v(HOLD_P) AT=2.604e-07
let PEDESTAL_HP = HP_POST-HP_PRE
let DROOP100_HP = HP_D1-HP_D0
meas tran HN_PRE FIND v(HOLD_N) AT=1.387e-07
meas tran HN_POST FIND v(HOLD_N) AT=1.454e-07
meas tran HN_D0 FIND v(HOLD_N) AT=1.604e-07
meas tran HN_D1 FIND v(HOLD_N) AT=2.604e-07
let PEDESTAL_HN = HN_POST-HN_PRE
let DROOP100_HN = HN_D1-HN_D0
let PEDESTAL_DIFF = PEDESTAL_HP-PEDESTAL_HN
let PEDESTAL_CM = (PEDESTAL_HP+PEDESTAL_HN)/2
print PEDESTAL_HP PEDESTAL_HN PEDESTAL_DIFF PEDESTAL_CM DROOP100_HP DROOP100_HN
wrdata tb_5C_case_01.dat v(SRC_P) v(SRC_N) v(VIN_P) v(VIN_N) v(HOLD_P) v(HOLD_N) v(PHI_SH) v(PHI_SHB) HOLD_D HOLD_CM ERR_P ERR_N
plot v(PHI_SH) v(PHI_SHB)
plot v(SRC_P) v(HOLD_P)
plot v(SRC_N) v(HOLD_N)
plot ERR_P ERR_N xlimit 1.347e-07 1.604e-07
plot HOLD_CM
plot HOLD_D
.endc
"}
C {lab_pin.sym} 190 -180 2 1 {name=lSRCP1 lab=SRC_P}
C {res.sym} 250 -180 1 0 {name=RSP1 value=100 m=1}
C {lab_pin.sym} 350 -160 2 1 {name=lSRCN1 lab=SRC_N}
C {res.sym} 410 -160 1 0 {name=RSN1 value=100 m=1}
C {lab_pin.sym} 550 -240 2 1 {name=lPHI_SH1 lab=PHI_SH}
C {lab_pin.sym} 550 -220 2 1 {name=lPHI_SHB1 lab=PHI_SHB}
C {lab_pin.sym} 550 -200 2 1 {name=lVCM1 lab=VCM}
C {lab_pin.sym} 880 -320 0 1 {name=lVDD1 lab=VDD}
C {gnd.sym} 880 -60 0 0 {name=gDUT1 lab=0}
C {lab_pin.sym} 1070 -200 0 1 {name=lHOLD_P1 lab=HOLD_P}
C {lab_pin.sym} 1070 -180 0 1 {name=lHOLD_N1 lab=HOLD_N}
C {blocks/05_Switch_Network/xschem/Block5_SH.sym} 760 -200 0 0 {name=x1}
C {lab_wire.sym} 460 -180 0 0 {name=p1 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} 490 -160 0 0 {name=p2 sig_type=std_logic lab=vin_n}
