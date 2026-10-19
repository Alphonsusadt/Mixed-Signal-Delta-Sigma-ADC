v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {PMOS ONLY: RON | SS | -40 C | VDD=1.62 V} 300 -500 0 0 0.35 0.35 {}
T {W/L=8/0.15 um | probe B-A=5 mV | sweep 0.05...1.55 V} 300 -450 0 0 0.23 0.23 {}
N 450 -360 620 -360 {lab=A}
N 680 -360 850 -360 {lab=B}
N 450 -360 450 -210 {lab=A}
N 450 -210 620 -210 {lab=A}
N 680 -210 850 -210 {lab=B}
N 850 -360 850 -210 {lab=B}
N 450 -210 450 -80 {lab=A}
N 450 -20 450 0 {lab=0}
C {vsource.sym} 650 -360 1 0 {name=VPROBE value=0.005 savecurrent=true}
C {vsource.sym} 450 -50 0 0 {name=VIN_SRC value=0.81}
C {gnd.sym} 450 0 0 0 {name=gVIN lab=0}
C {lab_pin.sym} 500 -210 0 0 {name=lA lab=A}
C {lab_pin.sym} 800 -210 0 1 {name=lB lab=B}
C {vsource.sym} 1080 -290 0 0 {name=VDD_SRC value=1.62}
N 1080 -350 1080 -320 {lab=VDD}
N 1080 -260 1080 -240 {lab=0}
C {lab_pin.sym} 1080 -350 0 1 {name=lVDD lab=VDD}
C {gnd.sym} 1080 -240 0 0 {name=gVDD lab=0}
C {sky130_fd_pr/corner.sym} 1030 -100 0 0 {name=CORNER only_toplevel=false corner=ss}
N 650 -250 650 -270 {lab=0}
C {lab_pin.sym} 650 -270 0 0 {name=lG lab=0}
C {sky130_fd_pr/pfet3_01v8.sym} 650 -230 1 0 {name=MTEST
W=8
L=0.15
body=VDD
nf=1
mult=1
ad=2.32
as=2.32
pd=16.58
ps=16.58
nrd=0.03625
nrs=0.03625
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {code.sym} 300 100 0 0 {name=SIM only_toplevel=true value="
.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp -40
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
dc VIN_SRC 0.05 1.55 0.005
let RON=abs((v(B)-v(A))/i(VPROBE))
meas dc RON_MIN MIN RON
meas dc RON_MAX MAX RON
meas dc RON_060 FIND RON AT=0.6
meas dc RON_081 FIND RON AT=0.81
meas dc RON_089 FIND RON AT=0.89
meas dc RON_090 FIND RON AT=0.9
meas dc RON_120 FIND RON AT=1.2
wrdata ron_pmos_ss_1p62_m40.dat v(A) v(B) i(VPROBE) RON
plot RON
.endc
"}
