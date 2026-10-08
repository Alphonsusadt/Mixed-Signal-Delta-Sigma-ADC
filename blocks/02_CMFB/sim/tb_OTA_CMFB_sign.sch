v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 50 -200 50 -180 {lab=VDD}
N 50 -120 50 -100 {lab=0}
N 110 -350 110 -180 {lab=Vcmfb1}
N 110 -350 480 -350 {lab=Vcmfb1}
N 110 -120 110 -100 {lab=0}
N 160 -330 160 -180 {lab=Vbz_R}
N 160 -330 480 -330 {lab=Vbz_R}
N 160 -120 160 -100 {lab=0}
N 230 -310 230 -180 {lab=Vbz_L}
N 230 -310 480 -310 {lab=Vbz_L}
N 230 -120 230 -100 {lab=0}
N 300 -290 300 -180 {lab=Vin_p}
N 300 -290 480 -290 {lab=Vin_p}
N 300 -120 300 -100 {lab=0}
N 360 -270 360 -180 {lab=Vin_n}
N 360 -270 480 -270 {lab=Vin_n}
N 360 -120 360 -100 {lab=0}
N 430 -250 430 -180 {lab=Vbias}
N 430 -250 480 -250 {lab=Vbias}
N 430 -120 430 -100 {lab=0}
N 710 -360 710 -350 {lab=VDD}
N 710 -290 710 -270 {lab=0}
N 710 -330 820 -330 {lab=Vout_p}
N 820 -330 820 -290 {lab=Vout_p}
N 820 -330 970 -330 {lab=Vout_p}
N 970 -330 970 -220 {lab=Vout_p}
N 970 -220 1450 -220 {lab=Vout_p}
N 820 -230 820 -210 {lab=0}
N 710 -310 750 -310 {lab=Vout_n}
N 750 -310 750 -290 {lab=Vout_n}
N 750 -310 930 -310 {lab=Vout_n}
N 930 -310 930 -240 {lab=Vout_n}
N 930 -240 1450 -240 {lab=Vout_n}
N 750 -230 750 -210 {lab=0}
N 1000 -360 1000 -170 {lab=Vcs}
N 1000 -360 1450 -360 {lab=Vcs}
N 1000 -110 1000 -90 {lab=0}
N 1090 -340 1090 -170 {lab=PHI1B}
N 1090 -340 1450 -340 {lab=PHI1B}
N 1090 -110 1090 -90 {lab=0}
N 1170 -320 1170 -170 {lab=PHI1}
N 1170 -320 1450 -320 {lab=PHI1}
N 1170 -110 1170 -90 {lab=0}
N 1240 -300 1240 -170 {lab=PHI2B}
N 1240 -300 1450 -300 {lab=PHI2B}
N 1240 -110 1240 -90 {lab=0}
N 1320 -280 1320 -170 {lab=PHI2}
N 1320 -280 1450 -280 {lab=PHI2}
N 1320 -110 1320 -90 {lab=0}
N 1390 -260 1390 -170 {lab=Vcmo}
N 1390 -260 1450 -260 {lab=Vcmo}
N 1390 -110 1390 -90 {lab=0}
N 1670 -380 1670 -360 {lab=VDD}
N 1670 -320 1670 -300 {lab=0}
N 1670 -340 1730 -340 {lab=Vcmfb_out}
C {vsource.sym} 50 -150 0 0 {
name=VDD_SRC
value=1.8
savecurrent=false
}
C {vdd.sym} 50 -200 0 0 {
name=l1
lab=VDD
}
C {gnd.sym} 50 -100 0 0 {
name=l2
lab=0
}
C {vsource.sym} 110 -150 0 0 {
name=VCMFB_SRC
value=0.9002 
savecurrent=false
}
C {gnd.sym} 110 -100 0 0 {
name=l3
lab=0
}
C {lab_wire.sym} 130 -350 0 0 {
name=n_vcmfb1
sig_type=std_logic
lab=Vcmfb1
}
C {vsource.sym} 160 -150 0 0 {
name=VVBZR
value=1.5
savecurrent=false
}
C {gnd.sym} 160 -100 0 0 {
name=l4
lab=0
}
C {lab_wire.sym} 180 -330 0 0 {
name=n_vbzr
sig_type=std_logic
lab=Vbz_R
}
C {vsource.sym} 230 -150 0 0 {
name=VVBZL
value=1.5
savecurrent=false
}
C {gnd.sym} 230 -100 0 0 {
name=l5
lab=0
}
C {lab_wire.sym} 250 -310 0 0 {
name=n_vbzl
sig_type=std_logic
lab=Vbz_L
}
C {vsource.sym} 300 -150 0 0 {
name=V_INP
value=0.4
savecurrent=false
}
C {gnd.sym} 300 -100 0 0 {
name=l6
lab=0
}
C {lab_wire.sym} 320 -290 0 0 {
name=n_inp
sig_type=std_logic
lab=Vin_p
}
C {vsource.sym} 360 -150 0 0 {
name=V_INN
value=0.4
savecurrent=false
}
C {gnd.sym} 360 -100 0 0 {
name=l7
lab=0
}
C {lab_wire.sym} 380 -270 0 0 {
name=n_inn
sig_type=std_logic
lab=Vin_n
}
C {vsource.sym} 430 -150 0 0 {
name=V_BIAS
value=0.507621
savecurrent=false
}
C {gnd.sym} 430 -100 0 0 {
name=l8
lab=0
}
C {lab_wire.sym} 450 -250 0 0 {
name=n_bias
sig_type=std_logic
lab=Vbias
}
C {blocks/01_OTA/xschem/OTA_experiment.sym} 630 -300 0 0 {
name=x1
}
C {vdd.sym} 710 -360 0 0 {
name=l9
lab=VDD
}
C {gnd.sym} 710 -270 0 0 {
name=l10
lab=0
}
C {lab_wire.sym} 780 -330 0 0 {
name=n_voutp
sig_type=std_logic
lab=Vout_p
}
C {capa-2.sym} 820 -260 0 0 {
name=CLP
m=1
value=20p
footprint=1206
device=polarized_capacitor
}
C {gnd.sym} 820 -210 0 0 {
name=l11
lab=0
}
C {lab_wire.sym} 730 -310 0 0 {
name=n_voutn
sig_type=std_logic
lab=Vout_n
}
C {capa-2.sym} 750 -260 0 0 {
name=CLN
m=1
value=20p
footprint=1206
device=polarized_capacitor
}
C {gnd.sym} 750 -210 0 0 {
name=l12
lab=0
}
C {vsource.sym} 1000 -140 0 0 {
name=V_VCS
value=0.9
savecurrent=false
}
C {gnd.sym} 1000 -90 0 0 {
name=l13
lab=0
}
C {lab_wire.sym} 1020 -360 0 0 {
name=n_vcs
sig_type=std_logic
lab=Vcs
}
C {vsource.sym} 1090 -140 0 0 {
name=VPHI1B
value="PULSE(1.8 0 100n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1090 -90 0 0 {
name=l14
lab=0
}
C {lab_wire.sym} 1110 -340 0 0 {
name=n_phi1b
sig_type=std_logic
lab=PHI1B
}
C {vsource.sym} 1170 -140 0 0 {
name=VPHI1
value="PULSE(0 1.8 100n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1170 -90 0 0 {
name=l15
lab=0
}
C {lab_wire.sym} 1190 -320 0 0 {
name=n_phi1
sig_type=std_logic
lab=PHI1
}
C {vsource.sym} 1240 -140 0 0 {
name=VPHI2B
value="PULSE(1.8 0 600n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1240 -90 0 0 {
name=l16
lab=0
}
C {lab_wire.sym} 1260 -300 0 0 {
name=n_phi2b
sig_type=std_logic
lab=PHI2B
}
C {vsource.sym} 1320 -140 0 0 {
name=VPHI2
value="PULSE(0 1.8 600n 2n 2n 300n 1u)"
savecurrent=false
}
C {gnd.sym} 1320 -90 0 0 {
name=l17
lab=0
}
C {lab_wire.sym} 1340 -280 0 0 {
name=n_phi2
sig_type=std_logic
lab=PHI2
}
C {vsource.sym} 1390 -140 0 0 {
name=V_VCMO
value=0.91844
savecurrent=false
}
C {gnd.sym} 1390 -90 0 0 {
name=l18
lab=0
}
C {lab_wire.sym} 1410 -260 0 0 {
name=n_vcmo
sig_type=std_logic
lab=Vcmo
}
C {blocks/02_CMFB/xschem/CMFB.sym} 1560 -280 0 0 {
name=x2
}
C {vdd.sym} 1670 -380 0 0 {
name=l19
lab=VDD
}
C {gnd.sym} 1670 -300 0 0 {
name=l20
lab=0
}
C {lab_wire.sym} 1700 -340 0 0 {
name=n_vcmfbout
sig_type=std_logic
lab=Vcmfb_out
}
C {opin.sym} 1730 -340 0 0 {
name=pout
lab=Vcmfb_out
}
C {sky130_fd_pr/corner.sym} 1480 -550 0 0 {
name=CORNER
only_toplevel=false
corner=tt
}
C {code_shown.sym} 150 -2960 0 0 {
name=s1
only_toplevel=true
value="
.options rshunt=1e12

RLEAK_OUT Vcmfb_out 0 1e12

.control
save all

* ==========================================================
* STEP 1: TRUE DC OPERATING POINT
* ==========================================================

op

let VOCM_OP = (v(vout_p)+v(vout_n))/2
let VOD_OP  = v(vout_p)-v(vout_n)

print v(vcmfb1)
print v(vout_p)
print v(vout_n)
print VOCM_OP
print VOD_OP


* ==========================================================
* STEP 2: TRANSIENT
*
* IMPORTANT:
* THERE IS NO UIC HERE.
* ==========================================================

tran 1n 10u

let VOCM = (v(vout_p)+v(vout_n))/2
let VOD  = v(vout_p)-v(vout_n)


* ==========================================================
* OTA STEADY-STATE CHARACTERIZATION
* ==========================================================

meas tran VOUTP_AVG AVG v(vout_p) FROM=8u TO=10u
meas tran VOUTN_AVG AVG v(vout_n) FROM=8u TO=10u

meas tran VOCM_AVG AVG VOCM FROM=8u TO=10u
meas tran VOCM_MIN MIN VOCM FROM=8u TO=10u
meas tran VOCM_MAX MAX VOCM FROM=8u TO=10u

meas tran VOD_AVG AVG VOD FROM=8u TO=10u


* ==========================================================
* EXTERNAL OTA CMFB CONTROL
* ==========================================================

meas tran VCMFB_IN_AVG AVG v(vcmfb1) FROM=8u TO=10u


* ==========================================================
* SC-CMFB OUTPUT CHARACTERIZATION
* ==========================================================

meas tran VCMFB_OUT_AVG AVG v(vcmfb_out) FROM=8u TO=10u
meas tran VCMFB_OUT_MIN MIN v(vcmfb_out) FROM=8u TO=10u
meas tran VCMFB_OUT_MAX MAX v(vcmfb_out) FROM=8u TO=10u

let VCMFB_OUT_RIPPLE = VCMFB_OUT_MAX-VCMFB_OUT_MIN

let VCMFB_OUT_ERROR = VCMFB_OUT_AVG-0.9


* ==========================================================
* CLOCK VALIDATION
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
* RESULTS
* ==========================================================

print VOUTP_AVG
print VOUTN_AVG

print VOCM_AVG
print VOCM_MIN
print VOCM_MAX
print VOD_AVG

print VCMFB_IN_AVG

print VCMFB_OUT_AVG
print VCMFB_OUT_MIN
print VCMFB_OUT_MAX
print VCMFB_OUT_RIPPLE
print VCMFB_OUT_ERROR

print PHI1_MAX
print PHI1_MIN

print PHI1B_MAX
print PHI1B_MIN

print PHI2_MAX
print PHI2_MIN

print PHI2B_MAX
print PHI2B_MIN


* ==========================================================
* PLOTS
* ==========================================================

plot v(phi1) v(phi2)
plot v(phi1b) v(phi2b)

plot v(vout_p) v(vout_n)

plot VOCM

plot v(vcmfb1) v(vcmfb_out)

.endc
"
}
