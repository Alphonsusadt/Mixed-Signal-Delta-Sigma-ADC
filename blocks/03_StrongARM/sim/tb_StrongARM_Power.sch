v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 -240 540 -220 {lab=VDD}
N 80 -160 80 -140 {lab=VDD}
N 80 -80 80 -70 {lab=0}
N 150 -80 150 -70 {lab=0}
N 230 -80 230 -70 {lab=0}
N 300 -80 300 -70 {lab=0}
N 540 -160 540 -150 {lab=0}
N 300 -180 300 -140 {lab=Vin2}
N 300 -180 340 -180 {lab=Vin2}
N 230 -200 340 -200 {lab=Vin1}
N 230 -200 230 -140 {lab=Vin1}
N 150 -220 340 -220 {lab=CLK}
N 150 -220 150 -140 {lab=CLK}
N 540 -200 590 -200 {lab=Vout_P}
N 540 -180 590 -180 {lab=Vout_N}
N 590 -180 600 -180 {lab=Vout_N}
N 590 -200 660 -200 {lab=Vout_P}
N 660 -200 710 -200 {lab=Vout_P}
N 600 -180 710 -180 {lab=Vout_N}
N 600 -80 600 -70 {lab=0}
N 660 -80 660 -70 {lab=0}
N 660 -200 660 -140 {lab=Vout_P}
N 600 -180 600 -140 {lab=Vout_N}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 490 -190 0 0 {name=x1}
C {vsource.sym} 80 -110 0 0 {name=VVDD value=1.8 savecurrent=false}
C {vdd.sym} 80 -160 0 0 {name=l1 lab=VDD}
C {vdd.sym} 540 -240 0 0 {name=l2 lab=VDD}
C {vsource.sym} 230 -110 0 0 {name=VVin1 value=0.895 savecurrent=false}
C {gnd.sym} 80 -70 0 0 {name=l3 lab=0}
C {gnd.sym} 230 -70 0 0 {name=l4 lab=0}
C {vsource.sym} 300 -110 0 0 {name=VVin2 value=0.905 savecurrent=false}
C {gnd.sym} 300 -70 0 0 {name=l5 lab=0}
C {vsource.sym} 150 -110 0 0 {name=VPulse value="PULSE(0 1.8 0 1n 1n 125n 250n)" savecurrent=false}
C {gnd.sym} 150 -70 0 0 {name=l6 lab=0}
C {gnd.sym} 540 -150 0 0 {name=l7 lab=0}
C {opin.sym} 710 -200 0 0 {name=p1 lab=Vout_P}
C {opin.sym} 710 -180 0 0 {name=p2 lab=Vout_N}
C {code.sym} 80 -370 0 0 {name=s1 only_toplevel=false 
value="

.control
save all

* ============================================
* BLOCK 3 - STRONGARM COMPARATOR
* TEST 7C - FINAL OUTPUT LOADING
* SKY130 TT / VDD 1.8V / CLK 4MHz
* BOTH INPUT POLARITIES
* ============================================

echo ============================================
echo TEST 7C - FINAL CHARACTERIZATION
echo ============================================

* ============================================
* CASE A: Vin1 < Vin2
* Vout_N should FALL
* Vout_P should remain HIGH
* ============================================

alter VVin1 0.895
alter VVin2 0.905

echo CASE A - NEGATIVE DIFFERENTIAL INPUT

tran 0.05n 2.5u

meas tran delay_A TRIG v(clk) VAL=0.9 RISE=9 TARG v(vout_n) VAL=0.9 FALL=9

meas tran vp_eval_A FIND v(vout_p) AT=2.01u
meas tran vn_eval_A FIND v(vout_n) AT=2.01u

meas tran vp_reset_A FIND v(vout_p) AT=2.20u
meas tran vn_reset_A FIND v(vout_n) AT=2.20u

meas tran vp_droop_A MIN v(vout_p) FROM=2u TO=2.01u

meas tran vp_max_A MAX v(vout_p) FROM=500n TO=2.5u
meas tran vn_max_A MAX v(vout_n) FROM=500n TO=2.5u

meas tran vp_min_A MIN v(vout_p) FROM=500n TO=2.5u
meas tran vn_min_A MIN v(vout_n) FROM=500n TO=2.5u

meas tran ivdd_A AVG i(VVDD) FROM=500n TO=2.5u

let power_A_uW = -1.8 * ivdd_A * 1e6
let energy_A_pJ = power_A_uW / 4
let delay_A_ns = delay_A * 1e9

echo CASE A SUMMARY
print power_A_uW
print energy_A_pJ
print delay_A_ns

* ============================================
* CASE B: Vin1 > Vin2
* Vout_P should FALL
* Vout_N should remain HIGH
* ============================================

alter VVin1 0.905
alter VVin2 0.895

echo CASE B - POSITIVE DIFFERENTIAL INPUT

tran 0.05n 2.5u

meas tran delay_B TRIG v(clk) VAL=0.9 RISE=9 TARG v(vout_p) VAL=0.9 FALL=9

meas tran vp_eval_B FIND v(vout_p) AT=2.01u
meas tran vn_eval_B FIND v(vout_n) AT=2.01u

meas tran vp_reset_B FIND v(vout_p) AT=2.20u
meas tran vn_reset_B FIND v(vout_n) AT=2.20u

meas tran vn_droop_B MIN v(vout_n) FROM=2u TO=2.01u

meas tran vp_max_B MAX v(vout_p) FROM=500n TO=2.5u
meas tran vn_max_B MAX v(vout_n) FROM=500n TO=2.5u

meas tran vp_min_B MIN v(vout_p) FROM=500n TO=2.5u
meas tran vn_min_B MIN v(vout_n) FROM=500n TO=2.5u

meas tran ivdd_B AVG i(VVDD) FROM=500n TO=2.5u

let power_B_uW = -1.8 * ivdd_B * 1e6
let energy_B_pJ = power_B_uW / 4
let delay_B_ns = delay_B * 1e9

echo CASE B SUMMARY
print power_B_uW
print energy_B_pJ
print delay_B_ns

echo ============================================
echo BOTH POLARITIES COMPLETED
echo ============================================

.endc"}
C {sky130_fd_pr/corner.sym} 580 -380 0 0 {name=CORNER only_toplevel=false corner=tt}
C {lab_wire.sym} 240 -200 0 0 {name=p3 sig_type=std_logic lab=Vin1}
C {lab_wire.sym} 310 -180 0 0 {name=p4 sig_type=std_logic lab=Vin2}
C {lab_wire.sym} 170 -220 0 0 {name=p5 sig_type=std_logic lab=CLK}
C {capa.sym} 600 -110 0 0 {name=C1
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 600 -70 0 0 {name=l8 lab=0}
C {capa.sym} 660 -110 0 0 {name=C2
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 660 -70 0 0 {name=l9 lab=0}
