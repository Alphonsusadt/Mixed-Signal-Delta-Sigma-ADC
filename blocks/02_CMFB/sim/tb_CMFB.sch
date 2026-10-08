v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 40 -150 40 -130 {lab=VDD}
N 40 -70 40 -50 {lab=0}
N 100 -150 100 -130 {lab=Vcs}
N 100 -70 100 -50 {lab=0}
N 160 -150 160 -130 {lab=PHI1B}
N 160 -70 160 -50 {lab=0}
N 220 -150 220 -130 {lab=PHI1}
N 220 -70 220 -50 {lab=0}
N 280 -150 280 -130 {lab=PHI2B}
N 280 -70 280 -50 {lab=0}
N 340 -150 340 -130 {lab=PHI2}
N 340 -70 340 -50 {lab=0}
N 400 -150 400 -130 {lab=Vcmo}
N 400 -70 400 -50 {lab=0}
N 460 -150 460 -130 {lab=Vo1_N}
N 460 -70 460 -50 {lab=0}
N 520 -150 520 -130 {lab=Vo1_P}
N 520 -70 520 -50 {lab=0}
N 100 -370 100 -150 {lab=Vcs}
N 100 -370 650 -370 {lab=Vcs}
N 160 -350 160 -150 {lab=PHI1B}
N 160 -350 650 -350 {lab=PHI1B}
N 220 -330 220 -150 {lab=PHI1}
N 220 -330 650 -330 {lab=PHI1}
N 280 -310 280 -150 {lab=PHI2B}
N 280 -310 650 -310 {lab=PHI2B}
N 340 -290 340 -150 {lab=PHI2}
N 340 -290 650 -290 {lab=PHI2}
N 400 -270 400 -150 {lab=Vcmo}
N 400 -270 650 -270 {lab=Vcmo}
N 460 -250 460 -150 {lab=Vo1_N}
N 460 -250 650 -250 {lab=Vo1_N}
N 520 -230 520 -150 {lab=Vo1_P}
N 520 -230 650 -230 {lab=Vo1_P}
N 870 -390 870 -370 {lab=VDD}
N 870 -330 870 -310 {lab=0}
N 870 -350 930 -350 {lab=Vcmfb1}
C {blocks/02_CMFB/xschem/CMFB.sym} 760 -290 0 0 {
name=x1
}
C {vsource.sym} 40 -100 0 0 {
name=VDD_SRC
value=1.8
savecurrent=false
}
C {vdd.sym} 40 -150 0 0 {
name=l1
lab=VDD
}
C {gnd.sym} 40 -50 0 0 {
name=l2
lab=0
}
C {vsource.sym} 100 -100 0 0 {
name=V_VCS
value=0.9
savecurrent=false
}
C {gnd.sym} 100 -50 0 0 {
name=l3
lab=0
}
C {vsource.sym} 160 -100 0 0 {
name=VPHI1B
value="PULSE(1.8 0 100n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 160 -50 0 0 {
name=l4
lab=0
}
C {vsource.sym} 220 -100 0 0 {
name=VPHI1
value="PULSE(0 1.8 100n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 220 -50 0 0 {
name=l5
lab=0
}
C {vsource.sym} 280 -100 0 0 {
name=VPHI2B
value="PULSE(1.8 0 600n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 280 -50 0 0 {
name=l6
lab=0
}
C {vsource.sym} 340 -100 0 0 {
name=VPHI2
value="PULSE(0 1.8 600n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 340 -50 0 0 {
name=l7
lab=0
}
C {vsource.sym} 400 -100 0 0 {
name=VVCMO
value=0.91844
savecurrent=false
}
C {gnd.sym} 400 -50 0 0 {
name=l8
lab=0
}
C {vsource.sym} 460 -100 0 0 {
name=VVO1N
value=0.81844
savecurrent=false
}
C {gnd.sym} 460 -50 0 0 {
name=l9
lab=0
}
C {vsource.sym} 520 -100 0 0 {
name=VVO1P
value=1.01844
savecurrent=false
}
C {gnd.sym} 520 -50 0 0 {
name=l10
lab=0
}
C {vdd.sym} 870 -390 0 0 {
name=l11
lab=VDD
}
C {gnd.sym} 870 -310 0 0 {
name=l12
lab=0
}
C {opin.sym} 930 -350 0 0 {
name=p1
lab=Vcmfb1
}
C {lab_wire.sym} 120 -370 0 0 {
name=nvcs
sig_type=std_logic
lab=Vcs
}
C {lab_wire.sym} 180 -350 0 0 {
name=nphi1b
sig_type=std_logic
lab=PHI1B
}
C {lab_wire.sym} 240 -330 0 0 {
name=nphi1
sig_type=std_logic
lab=PHI1
}
C {lab_wire.sym} 300 -310 0 0 {
name=nphi2b
sig_type=std_logic
lab=PHI2B
}
C {lab_wire.sym} 360 -290 0 0 {
name=nphi2
sig_type=std_logic
lab=PHI2
}
C {lab_wire.sym} 420 -270 0 0 {
name=nvcmo
sig_type=std_logic
lab=Vcmo
}
C {lab_wire.sym} 480 -250 0 0 {
name=nvo1n
sig_type=std_logic
lab=Vo1_N
}
C {lab_wire.sym} 540 -230 0 0 {
name=nvo1p
sig_type=std_logic
lab=Vo1_P
}
C {lab_wire.sym} 900 -350 0 0 {
name=nvcmfb
sig_type=std_logic
lab=Vcmfb1
}
C {code_shown.sym} 40 -2590 0 0 {
name=s1
only_toplevel=true
value="
* ============================================================
* SC-CMFB STANDALONE CHARACTERIZATION
* Differential-only test
*
* Expected source condition:
*   Vo1_P = 1.01844 V
*   Vo1_N = 0.81844 V
*
* Therefore:
*   V_OCM = (Vo1_P + Vo1_N)/2 = 0.91844 V
*   V_OD  = Vo1_P - Vo1_N     = 0.20000 V
*
* Expected:
*   Vcmfb1 average remains close to nominal ~0.9 V
* ============================================================

* Weak numerical DC path only
RLEAK Vcmfb1 0 1G

.control
save all

* ------------------------------------------------------------
* TRANSIENT
* ------------------------------------------------------------

tran 1n 10u uic


* ============================================================
* CLOCK CHECKS
* ============================================================

meas tran PHI1_MAX MAX v(phi1)
meas tran PHI1_MIN MIN v(phi1)

meas tran PHI1B_MAX MAX v(phi1b)
meas tran PHI1B_MIN MIN v(phi1b)

meas tran PHI2_MAX MAX v(phi2)
meas tran PHI2_MIN MIN v(phi2)

meas tran PHI2B_MAX MAX v(phi2b)
meas tran PHI2B_MIN MIN v(phi2b)


* ============================================================
* INPUT OUTPUT-COMMON-MODE CHECK
* Use final 2 us after settling
* ============================================================

meas tran VO1P_AVG AVG v(vo1_p) FROM=8u TO=10u
meas tran VO1N_AVG AVG v(vo1_n) FROM=8u TO=10u

let VOCM_INPUT = (VO1P_AVG + VO1N_AVG)/2
let VOD_INPUT  = VO1P_AVG - VO1N_AVG


* ============================================================
* VCMFB STEADY-STATE CHARACTERIZATION
* ============================================================

meas tran VCMFB_AVG AVG v(vcmfb1) FROM=8u TO=10u
meas tran VCMFB_MIN MIN v(vcmfb1) FROM=8u TO=10u
meas tran VCMFB_MAX MAX v(vcmfb1) FROM=8u TO=10u

let VCMFB_RIPPLE = VCMFB_MAX - VCMFB_MIN

* Reference control voltage used in testbench
let VCMFB_TARGET = 0.9

let VCMFB_DC_ERROR = VCMFB_AVG - VCMFB_TARGET
let VCMFB_DC_ERROR_ABS = abs(VCMFB_DC_ERROR)


* ============================================================
* PRINT RESULTS
* ============================================================

print PHI1_MAX
print PHI1_MIN
print PHI1B_MAX
print PHI1B_MIN

print PHI2_MAX
print PHI2_MIN
print PHI2B_MAX
print PHI2B_MIN

print VO1P_AVG
print VO1N_AVG
print VOCM_INPUT
print VOD_INPUT

print VCMFB_AVG
print VCMFB_MIN
print VCMFB_MAX
print VCMFB_RIPPLE

print VCMFB_TARGET
print VCMFB_DC_ERROR
print VCMFB_DC_ERROR_ABS


* ============================================================
* PLOTS
* ============================================================

plot v(phi1) v(phi2)
plot v(phi1b) v(phi2b)

plot v(vo1_p) v(vo1_n)

plot v(vcmfb1)

.endc
"
}
C {sky130_fd_pr/corner.sym} 950 -530 0 0 {
name=CORNER
only_toplevel=false
corner=tt
}
