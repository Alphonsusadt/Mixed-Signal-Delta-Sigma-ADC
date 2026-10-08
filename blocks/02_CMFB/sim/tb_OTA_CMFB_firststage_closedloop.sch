v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 40 -200 40 -180 {lab=VDD}
N 40 -120 40 -100 {lab=0}
N 180 -330 180 -180 {lab=Vbz_R}
N 180 -330 500 -330 {lab=Vbz_R}
N 180 -120 180 -100 {lab=0}
N 250 -310 250 -180 {lab=Vbz_L}
N 250 -310 500 -310 {lab=Vbz_L}
N 250 -120 250 -100 {lab=0}
N 320 -290 320 -180 {lab=Vin_p}
N 320 -290 500 -290 {lab=Vin_p}
N 320 -120 320 -100 {lab=0}
N 390 -270 390 -180 {lab=Vin_n}
N 390 -270 500 -270 {lab=Vin_n}
N 390 -120 390 -100 {lab=0}
N 460 -250 460 -180 {lab=Vbias}
N 460 -250 500 -250 {lab=Vbias}
N 460 -120 460 -100 {lab=0}
N 730 -370 730 -350 {lab=VDD}
N 730 -250 730 -230 {lab=0}
N 730 -290 790 -290 {lab=Vout_p}
N 790 -290 790 -260 {lab=Vout_p}
N 790 -180 790 -160 {lab=0}
N 730 -270 870 -270 {lab=Vout_n}
N 870 -270 870 -240 {lab=Vout_n}
N 870 -180 870 -160 {lab=0}
N 730 -330 780 -330 {lab=Vo1_B}
N 730 -310 780 -310 {lab=Vo1_A}
N 990 -340 1030 -340 {lab=Vcs}
N 990 -320 1030 -320 {lab=PHI1B}
N 990 -300 1030 -300 {lab=PHI1}
N 990 -280 1030 -280 {lab=PHI2B}
N 990 -260 1030 -260 {lab=PHI2}
N 990 -240 1030 -240 {lab=Vcmo}
N 990 -220 1030 -220 {lab=Vo1_A}
N 990 -200 1030 -200 {lab=Vo1_B}
N 1250 -360 1250 -340 {lab=VDD}
N 1250 -300 1250 -280 {lab=0}
N 1250 -320 1310 -320 {lab=Vcmfb_out}
N 920 -140 920 -120 {lab=Vcs}
N 920 -60 920 -40 {lab=0}
N 990 -140 990 -120 {lab=PHI1B}
N 990 -60 990 -40 {lab=0}
N 1060 -140 1060 -120 {lab=PHI1}
N 1060 -60 1060 -40 {lab=0}
N 1130 -140 1130 -120 {lab=PHI2B}
N 1130 -60 1130 -40 {lab=0}
N 1200 -140 1200 -120 {lab=PHI2}
N 1200 -60 1200 -40 {lab=0}
N 1270 -140 1270 -120 {lab=Vcmo}
N 1270 -60 1270 -40 {lab=0}
N 790 -260 790 -240 {lab=Vout_p}
N 160 -350 500 -350 {lab=Vcmfb_out}
C {blocks/01_OTA/xschem/OTA_CMFB.sym} 650 -300 0 0 {name=x1}
C {blocks/02_CMFB/xschem/CMFB.sym} 1140 -260 0 0 {name=x2}
C {vsource.sym} 40 -150 0 0 {name=VDD_SRC value=1.8 savecurrent=false}
C {vdd.sym} 40 -200 0 0 {name=l1 lab=VDD}
C {gnd.sym} 40 -100 0 0 {name=l2 lab=0}
C {vsource.sym} 180 -150 0 0 {name=VVBZR value=1.5 savecurrent=false}
C {gnd.sym} 180 -100 0 0 {name=l4 lab=0}
C {vsource.sym} 250 -150 0 0 {name=VVBZL value=1.5 savecurrent=false}
C {gnd.sym} 250 -100 0 0 {name=l5 lab=0}
C {vsource.sym} 320 -150 0 0 {name=V_INP value=0.4 savecurrent=false}
C {gnd.sym} 320 -100 0 0 {name=l6 lab=0}
C {vsource.sym} 390 -150 0 0 {name=V_INN value=0.4 savecurrent=false}
C {gnd.sym} 390 -100 0 0 {name=l7 lab=0}
C {vsource.sym} 460 -150 0 0 {name=V_BIAS value=0.507621 savecurrent=false}
C {gnd.sym} 460 -100 0 0 {name=l8 lab=0}
C {vdd.sym} 730 -370 0 0 {name=l9 lab=VDD}
C {gnd.sym} 730 -230 0 0 {name=l10 lab=0}
C {capa-2.sym} 790 -210 0 0 {
name=CLP
m=1
value=20p
footprint=1206
device=polarized_capacitor
}
C {gnd.sym} 790 -160 0 0 {name=l11 lab=0}
C {capa-2.sym} 870 -210 0 0 {
name=CLN
m=1
value=20p
footprint=1206
device=polarized_capacitor
}
C {gnd.sym} 870 -160 0 0 {name=l12 lab=0}
C {lab_wire.sym} 210 -330 0 0 {name=n2 sig_type=std_logic lab=Vbz_R}
C {lab_wire.sym} 280 -310 0 0 {name=n3 sig_type=std_logic lab=Vbz_L}
C {lab_wire.sym} 350 -290 0 0 {name=n4 sig_type=std_logic lab=Vin_p}
C {lab_wire.sym} 420 -270 0 0 {name=n5 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 480 -250 0 0 {name=n6 sig_type=std_logic lab=Vbias}
C {lab_wire.sym} 780 -290 0 0 {name=n7 sig_type=std_logic lab=Vout_p}
C {lab_wire.sym} 780 -270 0 0 {name=n8 sig_type=std_logic lab=Vout_n}
C {lab_wire.sym} 770 -330 0 0 {name=n9 sig_type=std_logic lab=Vo1_B}
C {lab_wire.sym} 770 -310 0 0 {name=n10 sig_type=std_logic lab=Vo1_A}
C {lab_wire.sym} 1000 -340 0 0 {name=n11 sig_type=std_logic lab=Vcs}
C {lab_wire.sym} 1000 -320 0 0 {name=n12 sig_type=std_logic lab=PHI1B}
C {lab_wire.sym} 1000 -300 0 0 {name=n13 sig_type=std_logic lab=PHI1}
C {lab_wire.sym} 1000 -280 0 0 {name=n14 sig_type=std_logic lab=PHI2B}
C {lab_wire.sym} 1000 -260 0 0 {name=n15 sig_type=std_logic lab=PHI2}
C {lab_wire.sym} 1000 -240 0 0 {name=n16 sig_type=std_logic lab=Vcmo}
C {lab_wire.sym} 1000 -220 0 0 {name=n17 sig_type=std_logic lab=Vo1_A}
C {lab_wire.sym} 1000 -200 0 0 {name=n18 sig_type=std_logic lab=Vo1_B}
C {vdd.sym} 1250 -360 0 0 {name=l13 lab=VDD}
C {gnd.sym} 1250 -280 0 0 {name=l14 lab=0}
C {lab_wire.sym} 1300 -320 0 0 {name=n19 sig_type=std_logic lab=Vcmfb_out}
C {vsource.sym} 920 -90 0 0 {name=V_VCS value=0.9 savecurrent=false}
C {gnd.sym} 920 -40 0 0 {name=l15 lab=0}
C {lab_wire.sym} 920 -140 1 0 {name=n20 sig_type=std_logic lab=Vcs}
C {vsource.sym} 990 -90 0 0 {
name=VPHI1B
value="PULSE(1.8 0 100n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 990 -40 0 0 {name=l16 lab=0}
C {lab_wire.sym} 990 -140 1 0 {name=n21 sig_type=std_logic lab=PHI1B}
C {vsource.sym} 1060 -90 0 0 {
name=VPHI1
value="PULSE(0 1.8 100n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1060 -40 0 0 {name=l17 lab=0}
C {lab_wire.sym} 1060 -140 1 0 {name=n22 sig_type=std_logic lab=PHI1}
C {vsource.sym} 1130 -90 0 0 {
name=VPHI2B
value="PULSE(1.8 0 600n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1130 -40 0 0 {name=l18 lab=0}
C {lab_wire.sym} 1130 -140 1 0 {name=n23 sig_type=std_logic lab=PHI2B}
C {vsource.sym} 1200 -90 0 0 {
name=VPHI2
value="PULSE(0 1.8 600n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1200 -40 0 0 {name=l19 lab=0}
C {lab_wire.sym} 1200 -140 1 0 {name=n24 sig_type=std_logic lab=PHI2}
C {vsource.sym} 1270 -90 0 0 {
name=V_VCMO
value=0.9292742
savecurrent=false
}
C {gnd.sym} 1270 -40 0 0 {name=l20 lab=0}
C {lab_wire.sym} 1270 -140 1 0 {name=n25 sig_type=std_logic lab=Vcmo}
C {sky130_fd_pr/corner.sym} 1370 -360 0 0 {
name=CORNER
only_toplevel=false
corner=tt
}
C {code.sym} 300 -500 0 0 {
name=s1
only_toplevel=true
value="
* ==========================================================
* OTA + SC-CMFB CLOSED-LOOP VERIFICATION
* SKY130 TT | VDD = 1.8 V | TEMP = 27 C
*
* Simulation: 100 us
* Clock period: 1 us
* First-stage VCMO target: 0.9292742 V
*
* Closed-loop feedback:
* CMFB output = Vcmfb_out = OTA Vcmfb1 input
*
* No UIC
* ==========================================================

.options rshunt=1e12

RLEAK_CMFB Vcmfb_out 0 1e12

.control
save all

* ==========================================================
* 1. TRANSIENT SIMULATION
* ==========================================================

tran 1n 100u

* ==========================================================
* 2. COMMON-MODE AND DIFFERENTIAL VECTORS
* ==========================================================

let VO1CM_TRACE = (v(vo1_a)+v(vo1_b))/2
let VO1D_TRACE  = v(vo1_a)-v(vo1_b)

let VOCM_TRACE  = (v(vout_p)+v(vout_n))/2
let VOD_TRACE   = v(vout_p)-v(vout_n)

* ==========================================================
* 3. FIRST-STAGE STEADY STATE
* Measurement interval: 90-100 us
* ==========================================================

meas tran VO1A_AVG AVG v(vo1_a) FROM=90u TO=100u
meas tran VO1B_AVG AVG v(vo1_b) FROM=90u TO=100u

meas tran VO1CM_AVG AVG VO1CM_TRACE FROM=90u TO=100u
meas tran VO1CM_MIN MIN VO1CM_TRACE FROM=90u TO=100u
meas tran VO1CM_MAX MAX VO1CM_TRACE FROM=90u TO=100u

meas tran VO1D_AVG AVG VO1D_TRACE FROM=90u TO=100u

let VCMO_TARGET = 0.9292742

let VO1CM_ERROR = VO1CM_AVG-VCMO_TARGET
let VO1CM_ERROR_ABS = abs(VO1CM_ERROR)

let VO1CM_RIPPLE = VO1CM_MAX-VO1CM_MIN

* ==========================================================
* 4. FINAL OTA OUTPUT
* ==========================================================

meas tran VOUTP_AVG AVG v(vout_p) FROM=90u TO=100u
meas tran VOUTN_AVG AVG v(vout_n) FROM=90u TO=100u

meas tran VOCM_AVG AVG VOCM_TRACE FROM=90u TO=100u
meas tran VOCM_MIN MIN VOCM_TRACE FROM=90u TO=100u
meas tran VOCM_MAX MAX VOCM_TRACE FROM=90u TO=100u

meas tran VOD_AVG AVG VOD_TRACE FROM=90u TO=100u

let VOCM_RIPPLE = VOCM_MAX-VOCM_MIN

* ==========================================================
* 5. CLOSED-LOOP CMFB CONTROL
* Actual feedback node: Vcmfb_out
* ==========================================================

meas tran VCMFB_AVG AVG v(vcmfb_out) FROM=90u TO=100u
meas tran VCMFB_MIN MIN v(vcmfb_out) FROM=90u TO=100u
meas tran VCMFB_MAX MAX v(vcmfb_out) FROM=90u TO=100u

let VCMFB_RIPPLE = VCMFB_MAX-VCMFB_MIN

let VCMFB_NOMINAL = 0.9
let VCMFB_OFFSET = VCMFB_AVG-VCMFB_NOMINAL

* ==========================================================
* 6. LONG-TERM SETTLING CHECK
*
* Compare two consecutive 10-us windows
* ==========================================================

meas tran VO1CM_80_90 AVG VO1CM_TRACE FROM=80u TO=90u
meas tran VO1CM_90_100 AVG VO1CM_TRACE FROM=90u TO=100u

meas tran VCMFB_80_90 AVG v(vcmfb_out) FROM=80u TO=90u
meas tran VCMFB_90_100 AVG v(vcmfb_out) FROM=90u TO=100u

meas tran VOCM_80_90 AVG VOCM_TRACE FROM=80u TO=90u
meas tran VOCM_90_100 AVG VOCM_TRACE FROM=90u TO=100u

let CM_DRIFT = VO1CM_90_100-VO1CM_80_90
let CTRL_DRIFT = VCMFB_90_100-VCMFB_80_90
let OUT_DRIFT = VOCM_90_100-VOCM_80_90

let CM_DRIFT_ABS = abs(CM_DRIFT)
let CTRL_DRIFT_ABS = abs(CTRL_DRIFT)
let OUT_DRIFT_ABS = abs(OUT_DRIFT)

* ==========================================================
* 7. CLOCK VALIDATION
* ==========================================================

meas tran PHI1_MAX MAX v(phi1)
meas tran PHI1_MIN MIN v(phi1)

meas tran PHI1B_MAX MAX v(phi1b)
meas tran PHI1B_MIN MIN v(phi1b)

meas tran PHI2_MAX MAX v(phi2)
meas tran PHI2_MIN MIN v(phi2)

meas tran PHI2B_MAX MAX v(phi2b)
meas tran PHI2B_MIN MIN v(phi2b)

* ==========================================================
* 8. FIRST-STAGE RESULTS
* ==========================================================

echo ============================================
echo FIRST-STAGE CLOSED-LOOP RESULTS
echo ============================================

print VO1A_AVG
print VO1B_AVG

print VO1CM_AVG
print VO1CM_MIN
print VO1CM_MAX
print VO1CM_RIPPLE

print VO1D_AVG

print VCMO_TARGET
print VO1CM_ERROR
print VO1CM_ERROR_ABS

* ==========================================================
* 9. FINAL OUTPUT RESULTS
* ==========================================================

echo ============================================
echo FINAL OTA OUTPUT RESULTS
echo ============================================

print VOUTP_AVG
print VOUTN_AVG

print VOCM_AVG
print VOCM_MIN
print VOCM_MAX
print VOCM_RIPPLE

print VOD_AVG

* ==========================================================
* 10. CMFB CONTROL RESULTS
* ==========================================================

echo ============================================
echo CLOSED-LOOP CMFB RESULTS
echo ============================================

print VCMFB_AVG
print VCMFB_MIN
print VCMFB_MAX
print VCMFB_RIPPLE

print VCMFB_NOMINAL
print VCMFB_OFFSET

* ==========================================================
* 11. SETTLING AND LONG-TERM DRIFT
* ==========================================================

echo ============================================
echo LONG-TERM SETTLING RESULTS
echo ============================================

print VO1CM_80_90
print VO1CM_90_100

print VCMFB_80_90
print VCMFB_90_100

print VOCM_80_90
print VOCM_90_100

print CM_DRIFT
print CTRL_DRIFT
print OUT_DRIFT

print CM_DRIFT_ABS
print CTRL_DRIFT_ABS
print OUT_DRIFT_ABS

* ==========================================================
* 12. CLOCK RESULTS
* ==========================================================

echo ============================================
echo CLOCK VALIDATION
echo ============================================

print PHI1_MAX
print PHI1_MIN

print PHI1B_MAX
print PHI1B_MIN

print PHI2_MAX
print PHI2_MIN

print PHI2B_MAX
print PHI2B_MIN

* ==========================================================
* 13. WAVEFORMS
* ==========================================================

plot VO1CM_TRACE
plot v(vcmfb_out)

plot VOCM_TRACE

plot v(vo1_a) v(vo1_b)
plot v(vout_p) v(vout_n)

plot v(phi1) v(phi2)

.endc
"
}
C {lab_wire.sym} 250 -350 0 0 {name=n1 sig_type=std_logic lab=Vcmfb_out}
