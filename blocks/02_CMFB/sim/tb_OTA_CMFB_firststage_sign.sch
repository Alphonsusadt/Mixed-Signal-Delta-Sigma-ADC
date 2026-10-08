v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 40 -200 40 -180 {lab=VDD}
N 40 -120 40 -100 {lab=0}
N 110 -350 110 -180 {lab=Vcmfb1}
N 110 -350 500 -350 {lab=Vcmfb1}
N 110 -120 110 -100 {lab=0}
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
N 730 -290 830 -290 {lab=Vout_p}
N 730 -270 830 -270 {lab=Vout_n}
N 730 -330 830 -330 {lab=Vo1_A}
N 730 -310 830 -310 {lab=Vo1_B}
C {vsource.sym} 40 -150 0 0 {
name=VDD_SRC
value=1.8
savecurrent=false
}
C {vdd.sym} 40 -200 0 0 {
name=l1
lab=VDD
}
C {gnd.sym} 40 -100 0 0 {
name=l2
lab=0
}
C {vsource.sym} 110 -150 0 0 {
name=VCMFB_SRC
value=0.9
savecurrent=false
}
C {gnd.sym} 110 -100 0 0 {
name=l3
lab=0
}
C {lab_wire.sym} 150 -350 0 0 {
name=n_vcmfb
sig_type=std_logic
lab=Vcmfb1
}
C {vsource.sym} 180 -150 0 0 {
name=VVBZR
value=1.5
savecurrent=false
}
C {gnd.sym} 180 -100 0 0 {
name=l4
lab=0
}
C {lab_wire.sym} 210 -330 0 0 {
name=n_vbzr
sig_type=std_logic
lab=Vbz_R
}
C {vsource.sym} 250 -150 0 0 {
name=VVBZL
value=1.5
savecurrent=false
}
C {gnd.sym} 250 -100 0 0 {
name=l5
lab=0
}
C {lab_wire.sym} 280 -310 0 0 {
name=n_vbzl
sig_type=std_logic
lab=Vbz_L
}
C {vsource.sym} 320 -150 0 0 {
name=V_INP
value=0.4
savecurrent=false
}
C {gnd.sym} 320 -100 0 0 {
name=l6
lab=0
}
C {lab_wire.sym} 350 -290 0 0 {
name=n_inp
sig_type=std_logic
lab=Vin_p
}
C {vsource.sym} 390 -150 0 0 {
name=V_INN
value=0.4
savecurrent=false
}
C {gnd.sym} 390 -100 0 0 {
name=l7
lab=0
}
C {lab_wire.sym} 420 -270 0 0 {
name=n_inn
sig_type=std_logic
lab=Vin_n
}
C {vsource.sym} 460 -150 0 0 {
name=V_BIAS
value=0.507621
savecurrent=false
}
C {gnd.sym} 460 -100 0 0 {
name=l8
lab=0
}
C {lab_wire.sym} 480 -250 0 0 {
name=n_bias
sig_type=std_logic
lab=Vbias
}
C {blocks/01_OTA/xschem/OTA_CMFB.sym} 650 -300 0 0 {
name=x1
}
C {vdd.sym} 730 -370 0 0 {
name=l9
lab=VDD
}
C {gnd.sym} 730 -230 0 0 {
name=l10
lab=0
}
C {lab_wire.sym} 790 -290 0 0 {
name=n_voutp
sig_type=std_logic
lab=Vout_p
}
C {lab_wire.sym} 790 -270 0 0 {
name=n_voutn
sig_type=std_logic
lab=Vout_n
}
C {lab_wire.sym} 780 -330 0 0 {
name=n_vo1a
sig_type=std_logic
lab=Vo1_A
}
C {lab_wire.sym} 780 -310 0 0 {
name=n_vo1b
sig_type=std_logic
lab=Vo1_B
}
C {sky130_fd_pr/corner.sym} 1030 -490 0 0 {
name=CORNER
only_toplevel=false
corner=tt
}
C {code_shown.sym} 20 -3800 0 0 {
name=s1
only_toplevel=true
value="
.options rshunt=1e12

.control
save all

* ==========================================================
* IMPORTANT:
*
* No standalone OP command.
*
* Previous OP calculation encountered an internal singular
* node. The DC sweep itself converges correctly.
* ==========================================================


* ==========================================================
* VCMFB1 LOCAL SWEEP
*
* 0.8998 V
* 0.9000 V
* 0.9002 V
* ==========================================================

dc VCMFB_SRC 0.8998 0.9002 0.0002


* ==========================================================
* MEASURE RAW FIRST-STAGE NODES
*
* Measure real circuit nodes first.
* Common-mode values are calculated afterwards.
* This is more robust than MEAS on LET vectors.
* ==========================================================

meas dc VO1A_8998 FIND v(vo1_a) AT=0.8998
meas dc VO1A_9000 FIND v(vo1_a) AT=0.9000
meas dc VO1A_9002 FIND v(vo1_a) AT=0.9002

meas dc VO1B_8998 FIND v(vo1_b) AT=0.8998
meas dc VO1B_9000 FIND v(vo1_b) AT=0.9000
meas dc VO1B_9002 FIND v(vo1_b) AT=0.9002


* ==========================================================
* MEASURE FINAL OUTPUT NODES
* ==========================================================

meas dc VOUTP_8998 FIND v(vout_p) AT=0.8998
meas dc VOUTP_9000 FIND v(vout_p) AT=0.9000
meas dc VOUTP_9002 FIND v(vout_p) AT=0.9002

meas dc VOUTN_8998 FIND v(vout_n) AT=0.8998
meas dc VOUTN_9000 FIND v(vout_n) AT=0.9000
meas dc VOUTN_9002 FIND v(vout_n) AT=0.9002


* ==========================================================
* CALCULATE FIRST-STAGE COMMON MODE
* ==========================================================

let VO1CM_8998 = (VO1A_8998 + VO1B_8998)/2
let VO1CM_9000 = (VO1A_9000 + VO1B_9000)/2
let VO1CM_9002 = (VO1A_9002 + VO1B_9002)/2

let VO1D_8998 = VO1A_8998 - VO1B_8998
let VO1D_9000 = VO1A_9000 - VO1B_9000
let VO1D_9002 = VO1A_9002 - VO1B_9002


* ==========================================================
* CALCULATE FINAL OUTPUT COMMON MODE
* ==========================================================

let VOCM_8998 = (VOUTP_8998 + VOUTN_8998)/2
let VOCM_9000 = (VOUTP_9000 + VOUTN_9000)/2
let VOCM_9002 = (VOUTP_9002 + VOUTN_9002)/2

let VOD_8998 = VOUTP_8998 - VOUTN_8998
let VOD_9000 = VOUTP_9000 - VOUTN_9000
let VOD_9002 = VOUTP_9002 - VOUTN_9002


* ==========================================================
* CONTROL SLOPES
* ==========================================================

let DELTA_VCMFB = 0.0004

let DELTA_VO1CM = VO1CM_9002 - VO1CM_8998
let VO1_CM_SLOPE = DELTA_VO1CM / DELTA_VCMFB

let DELTA_VOCM = VOCM_9002 - VOCM_8998
let FINAL_CM_SLOPE = DELTA_VOCM / DELTA_VCMFB


* ==========================================================
* FIRST-STAGE VCMO TARGET
*
* At nominal:
*
* Vcmfb1 = 0.9000 V
*
* This is the value to use later as Vcmo for SC-CMFB.
* ==========================================================

let VCMO_FIRST_STAGE = VO1CM_9000


* ==========================================================
* PRINT FIRST-STAGE RESULTS
* ==========================================================

echo
echo ================================================
echo ===== OTA FIRST-STAGE CMFB RESULTS =============
echo ================================================

print VO1A_8998
print VO1A_9000
print VO1A_9002

print VO1B_8998
print VO1B_9000
print VO1B_9002

print VO1CM_8998
print VO1CM_9000
print VO1CM_9002

print VO1D_8998
print VO1D_9000
print VO1D_9002

print DELTA_VO1CM
print VO1_CM_SLOPE

print VCMO_FIRST_STAGE


* ==========================================================
* PRINT FINAL OUTPUT RESULTS
* ==========================================================

echo
echo ================================================
echo ===== FINAL OTA OUTPUT RESULTS =================
echo ================================================

print VOUTP_8998
print VOUTP_9000
print VOUTP_9002

print VOUTN_8998
print VOUTN_9000
print VOUTN_9002

print VOCM_8998
print VOCM_9000
print VOCM_9002

print VOD_8998
print VOD_9000
print VOD_9002

print DELTA_VOCM
print FINAL_CM_SLOPE


* ==========================================================
* WAVEFORM VECTORS
* ==========================================================

let VO1CM_TRACE = (v(vo1_a)+v(vo1_b))/2
let VOCM_TRACE  = (v(vout_p)+v(vout_n))/2


* ==========================================================
* PLOTS
* ==========================================================

plot VO1CM_TRACE
plot v(vo1_a) v(vo1_b)

plot VOCM_TRACE
plot v(vout_p) v(vout_n)

.endc
"
}
