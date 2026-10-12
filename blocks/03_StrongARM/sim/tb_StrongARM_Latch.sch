v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {TB 9D - StrongARM + SR Latch / 4 MHz / clock tr=tf=5ns} 40 -810 0 0 0.4 0.4 {}
T {Vin1/Vin2 swap ONLY during reset: +10mV -> -10mV -> +10mV -> -10mV} 40 -770 0 0 0.3 0.3 {}
N 460 -590 500 -590 {lab=Vin1}
N 460 -550 500 -550 {lab=Vin2}
N 460 -490 500 -490 {lab=CLK}
N 760 -380 760 -340 {lab=VDD}
N 700 -380 700 -340 {lab=0}
N 960 -600 1000 -600 {lab=Q}
N 960 -560 1000 -560 {lab=QB}
N 960 -500 1000 -500 {lab=Vout_P}
N 960 -460 1000 -460 {lab=Vout_N}
N 150 -170 150 -130 {lab=VDD}
N 150 -70 150 -50 {lab=0}
N 270 -170 270 -130 {lab=Vin1}
N 270 -70 270 -50 {lab=0}
N 390 -170 390 -130 {lab=Vin2}
N 390 -70 390 -50 {lab=0}
N 510 -170 510 -130 {lab=CLK}
N 510 -70 510 -50 {lab=0}
N 1140 -310 1140 -290 {lab=Vout_P}
N 1140 -230 1140 -210 {lab=0}
N 1280 -310 1280 -290 {lab=Vout_N}
N 1280 -230 1280 -210 {lab=0}
N 1420 -310 1420 -290 {lab=Q}
N 1420 -230 1420 -210 {lab=0}
N 1560 -310 1560 -290 {lab=QB}
N 1560 -230 1560 -210 {lab=0}
C {blocks/03_StrongARM/xschem/StrongARM_Latch.sym} 730 -530 0 0 {name=x1}
C {devices/lab_wire.sym} 460 -590 0 0 {name=tbP0 lab=Vin1}
C {devices/lab_wire.sym} 460 -550 0 0 {name=tbP1 lab=Vin2}
C {devices/lab_wire.sym} 460 -490 0 0 {name=tbP2 lab=CLK}
C {devices/lab_wire.sym} 760 -340 0 0 {name=tbP3 lab=VDD}
C {gnd.sym} 700 -340 0 0 {name=gwrap lab=0}
C {devices/lab_wire.sym} 1000 -600 0 0 {name=tbP5 lab=Q}
C {devices/lab_wire.sym} 1000 -560 0 0 {name=tbP6 lab=QB}
C {devices/lab_wire.sym} 1000 -500 0 0 {name=tbP7 lab=Vout_P}
C {devices/lab_wire.sym} 1000 -460 0 0 {name=tbP8 lab=Vout_N}
C {devices/vsource.sym} 150 -100 0 0 {name=VVDD value="1.8"}
C {devices/lab_wire.sym} 150 -170 0 0 {name=src0 lab=VDD}
C {gnd.sym} 150 -50 0 0 {name=g0 lab=0}
C {devices/vsource.sym} 270 -100 0 0 {name=VVin1 value="PWL(0n 0.905 200n 0.905 201n 0.895 450n 0.895 451n 0.905 700n 0.905 701n 0.895 1000n 0.895)"}
C {devices/lab_wire.sym} 270 -170 0 0 {name=src1 lab=Vin1}
C {gnd.sym} 270 -50 0 0 {name=g1 lab=0}
C {devices/vsource.sym} 390 -100 0 0 {name=VVin2 value="PWL(0n 0.895 200n 0.895 201n 0.905 450n 0.905 451n 0.895 700n 0.895 701n 0.905 1000n 0.905)"}
C {devices/lab_wire.sym} 390 -170 0 0 {name=src2 lab=Vin2}
C {gnd.sym} 390 -50 0 0 {name=g2 lab=0}
C {devices/vsource.sym} 510 -100 0 0 {name=VPulse value="PULSE(0 1.8 0 5n 5n 125n 250n)"}
C {devices/lab_wire.sym} 510 -170 0 0 {name=src3 lab=CLK}
C {gnd.sym} 510 -50 0 0 {name=g3 lab=0}
C {devices/capa.sym} 1140 -260 0 0 {name=COUTP value=20f}
C {devices/lab_wire.sym} 1140 -310 0 0 {name=load0 lab=Vout_P}
C {gnd.sym} 1140 -210 0 0 {name=gc0 lab=0}
C {devices/capa.sym} 1280 -260 0 0 {name=COUTN value=20f}
C {devices/lab_wire.sym} 1280 -310 0 0 {name=load1 lab=Vout_N}
C {gnd.sym} 1280 -210 0 0 {name=gc1 lab=0}
C {devices/capa.sym} 1420 -260 0 0 {name=CQ value=20f}
C {devices/lab_wire.sym} 1420 -310 0 0 {name=load2 lab=Q}
C {gnd.sym} 1420 -210 0 0 {name=gc2 lab=0}
C {devices/capa.sym} 1560 -260 0 0 {name=CQB value=20f}
C {devices/lab_wire.sym} 1560 -310 0 0 {name=load3 lab=QB}
C {gnd.sym} 1560 -210 0 0 {name=gc3 lab=0}
C {devices/code_shown.sym} 60 20 0 0 {name=SPICE only_toplevel=true value=".lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice tt
.option scale=1e-6
.tran 0.02n 1u 0 0.02n
.meas tran eval1_q FIND v(q) AT=40n
.meas tran eval1_qb FIND v(qb) AT=40n
.meas tran eval1_vout_p FIND v(vout_p) AT=40n
.meas tran eval1_vout_n FIND v(vout_n) AT=40n
.meas tran hold1_q FIND v(q) AT=180n
.meas tran hold1_qb FIND v(qb) AT=180n
.meas tran hold1_vout_p FIND v(vout_p) AT=180n
.meas tran hold1_vout_n FIND v(vout_n) AT=180n
.meas tran input_hold1_q FIND v(q) AT=225n
.meas tran input_hold1_qb FIND v(qb) AT=225n
.meas tran input_hold1_vout_p FIND v(vout_p) AT=225n
.meas tran input_hold1_vout_n FIND v(vout_n) AT=225n
.meas tran eval2_q FIND v(q) AT=290n
.meas tran eval2_qb FIND v(qb) AT=290n
.meas tran eval2_vout_p FIND v(vout_p) AT=290n
.meas tran eval2_vout_n FIND v(vout_n) AT=290n
.meas tran hold2_q FIND v(q) AT=430n
.meas tran hold2_qb FIND v(qb) AT=430n
.meas tran hold2_vout_p FIND v(vout_p) AT=430n
.meas tran hold2_vout_n FIND v(vout_n) AT=430n
.meas tran input_hold2_q FIND v(q) AT=475n
.meas tran input_hold2_qb FIND v(qb) AT=475n
.meas tran input_hold2_vout_p FIND v(vout_p) AT=475n
.meas tran input_hold2_vout_n FIND v(vout_n) AT=475n
.meas tran eval3_q FIND v(q) AT=540n
.meas tran eval3_qb FIND v(qb) AT=540n
.meas tran eval3_vout_p FIND v(vout_p) AT=540n
.meas tran eval3_vout_n FIND v(vout_n) AT=540n
.meas tran hold3_q FIND v(q) AT=680n
.meas tran hold3_qb FIND v(qb) AT=680n
.meas tran hold3_vout_p FIND v(vout_p) AT=680n
.meas tran hold3_vout_n FIND v(vout_n) AT=680n
.meas tran input_hold3_q FIND v(q) AT=725n
.meas tran input_hold3_qb FIND v(qb) AT=725n
.meas tran input_hold3_vout_p FIND v(vout_p) AT=725n
.meas tran input_hold3_vout_n FIND v(vout_n) AT=725n
.meas tran eval4_q FIND v(q) AT=790n
.meas tran eval4_qb FIND v(qb) AT=790n
.meas tran eval4_vout_p FIND v(vout_p) AT=790n
.meas tran eval4_vout_n FIND v(vout_n) AT=790n
.meas tran hold4_q FIND v(q) AT=930n
.meas tran hold4_qb FIND v(qb) AT=930n
.meas tran hold4_vout_p FIND v(vout_p) AT=930n
.meas tran hold4_vout_n FIND v(vout_n) AT=930n
.meas tran iavg AVG i(VVDD) FROM=250n TO=1000n
.meas tran t_c2 TRIG v(CLK) VAL=0.9 RISE=2 TARG v(Q) VAL=0.9 FALL=1 TD=240n
.meas tran t_c3 TRIG v(CLK) VAL=0.9 RISE=3 TARG v(Q) VAL=0.9 RISE=1 TD=490n
.meas tran t_c4 TRIG v(CLK) VAL=0.9 RISE=4 TARG v(Q) VAL=0.9 FALL=1 TD=740n
.save v(CLK) v(Vin1) v(Vin2) v(Vout_P) v(Vout_N) v(Q) v(QB) v(VDD) i(VVDD)"}
