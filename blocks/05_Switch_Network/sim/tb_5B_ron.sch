v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {5B: TRANSMISSION-GATE ON-RESISTANCE} 300 -540 0 0 0.4 0.4 {}
T {SS | VDD=1.62 V | -40 C | NMOS 4/0.15 um | PMOS 8/0.15 um} 300 -490 0 0 0.25 0.25 {}
T {TG stays ON: CLK_N=VDD, CLK_P=0. Probe imposes V(B)-V(A)=5 mV.} 300 -450 0 0 0.22 0.22 {}
T {VPROBE: positive terminal at B, negative terminal at A} 450 -410 0 0 0.2 0.2 {}
T {DC sweep: A=0.05...1.55 V, step=5 mV (301 points). RON is in ohms.} 300 40 0 0 0.22 0.22 {}
T {Inspect A=0.6...1.2 V, including 0.81 and 0.89 V. No hold capacitors or OTA.} 300 80 0 0 0.2 0.2 {}
N 450 -180 550 -180 {lab=A}
N 750 -180 850 -180 {lab=B}
N 450 -360 620 -360 {lab=A}
N 450 -360 450 -180 {lab=A}
N 680 -360 850 -360 {lab=B}
N 850 -360 850 -180 {lab=B}
N 450 -180 450 -80 {lab=A}
N 450 -20 450 0 {lab=0}
N 650 -310 650 -280 {lab=0}
N 650 -80 650 -40 {lab=VDD}
N 730 -210 790 -210 {lab=VDD}
N 730 -150 790 -150 {lab=0}
N 1080 -350 1080 -320 {lab=VDD}
N 1080 -260 1080 -240 {lab=0}
C {lab_pin.sym} 500 -180 0 0 {name=lA lab=A}
C {lab_pin.sym} 800 -180 0 1 {name=lB lab=B}
C {vsource.sym} 650 -360 1 0 {name=VPROBE value=0.005 savecurrent=true}
C {vsource.sym} 450 -50 0 0 {name=VIN_SRC value=0.81 savecurrent=false}
C {gnd.sym} 450 0 0 0 {name=gVIN lab=0}
C {lab_pin.sym} 650 -310 0 0 {name=lGP lab=0}
C {lab_pin.sym} 650 -40 0 1 {name=lGN lab=VDD}
C {lab_pin.sym} 790 -210 0 1 {name=lBULKP lab=VDD}
C {lab_pin.sym} 790 -150 0 1 {name=lBULKN lab=0}
C {vsource.sym} 1080 -290 0 0 {name=VDD_SRC value=1.62 savecurrent=false}
C {lab_pin.sym} 1080 -350 0 1 {name=lSUPPLY lab=VDD}
C {gnd.sym} 1080 -240 0 0 {name=gSUPPLY lab=0}
C {sky130_fd_pr/corner.sym} 1040 -100 0 0 {name=CORNER only_toplevel=false corner=ss}
C {code.sym} 300 150 0 0 {name=SIM only_toplevel=true value="
* DUT pin order: A B CLK_P CLK_N VDD GND.
* TG_SC.sch must contain WN=4 um, WP=8 um, L=0.15 um.
* Supply and NMOS gate: 1.62 V. PMOS gate: 0 V.
* Probe: VPROBE B A 0.005.
.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp -40
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15

dc VIN_SRC 0.05 1.55 0.005

let RON = abs((v(B)-v(A))/i(VPROBE))

meas dc RON_MIN MIN RON
meas dc RON_MAX MAX RON
meas dc RON_060 FIND RON AT=0.6
meas dc RON_081 FIND RON AT=0.81
meas dc RON_089 FIND RON AT=0.89
meas dc RON_090 FIND RON AT=0.9
meas dc RON_120 FIND RON AT=1.2

wrdata tb_5B_ron_ss_1p62_m40.dat v(A) v(B) i(VPROBE) RON
plot RON
.endc
"}
C {blocks/05_Switch_Network/xschem/TG_SC.sym} 650 -180 0 0 {name=x1}
