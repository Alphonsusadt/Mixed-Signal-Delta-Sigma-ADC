v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 340 -350 370 -350 {lab=SN}
N 340 -250 370 -250 {lab=RN}
N 630 -350 760 -350 {lab=Q}
N 630 -250 880 -250 {lab=QB}
N 520 -200 520 -160 {lab=VCC}
N 480 -200 480 -160 {lab=0}
N 160 -110 160 -100 {lab=VCC}
N 160 -40 160 -20 {lab=0}
N 250 -110 250 -100 {lab=SN}
N 250 -40 250 -20 {lab=0}
N 320 -110 320 -100 {lab=RN}
N 320 -40 320 -20 {lab=0}
N 760 -350 760 -340 {lab=Q}
N 760 -150 760 -130 {lab=0}
N 880 -250 880 -240 {lab=QB}
N 880 -180 880 -160 {lab=#net1}
N 760 -340 760 -210 {lab=Q}
C {blocks/03_StrongARM/xschem/SR_Latch.sym} 500 -300 0 0 {name=x1}
C {devices/vsource.sym} 160 -70 0 0 {name=VVDD value=1.8}
C {devices/vsource.sym} 250 -70 0 0 {name=VSN value="PWL(0n 0 10n 0 10.1n 1.8 40n 1.8 40.1n 0 50n 0 50.1n 1.8 80n 1.8)"}
C {devices/vsource.sym} 320 -70 0 0 {name=VRN value="PWL(0n 1.8 20n 1.8 20.1n 0 30n 0 30.1n 1.8 60n 1.8 60.1n 0 70n 0 70.1n 1.8 80n 1.8)"}
C {devices/capa.sym} 760 -180 0 0 {name=CQ value=20f}
C {devices/capa.sym} 880 -210 0 0 {name=CQB value=20f}
C {devices/lab_wire.sym} 160 -110 0 0 {name=lVCCsrc lab=VCC}
C {devices/lab_wire.sym} 250 -110 0 0 {name=lSNsrc lab=SN}
C {devices/lab_wire.sym} 320 -110 0 0 {name=lRNsrc lab=RN}
C {devices/lab_wire.sym} 340 -350 0 0 {name=lSNin lab=SN}
C {devices/lab_wire.sym} 340 -250 0 0 {name=lRNin lab=RN}
C {devices/lab_wire.sym} 760 -350 0 0 {name=lQ lab=Q}
C {devices/lab_wire.sym} 880 -250 0 0 {name=lQB lab=QB}
C {devices/lab_wire.sym} 520 -160 0 0 {name=lVCCport lab=VCC}
C {devices/code_shown.sym} 1050 -270 0 0 {name=SPICE only_toplevel=true value=".lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice tt
.option scale=1e-6
.tran 0.01n 80n 0 0.01n
.meas tran set1_q FIND v(Q) AT=5n
.meas tran set1_qb FIND v(QB) AT=5n
.meas tran hold1_q FIND v(Q) AT=15n
.meas tran hold1_qb FIND v(QB) AT=15n
.meas tran reset1_q FIND v(Q) AT=25n
.meas tran reset1_qb FIND v(QB) AT=25n
.meas tran hold2_q FIND v(Q) AT=35n
.meas tran hold2_qb FIND v(QB) AT=35n
.meas tran set2_q FIND v(Q) AT=45n
.meas tran set2_qb FIND v(QB) AT=45n
.meas tran hold3_q FIND v(Q) AT=55n
.meas tran hold3_qb FIND v(QB) AT=55n
.meas tran reset2_q FIND v(Q) AT=65n
.meas tran reset2_qb FIND v(QB) AT=65n
.meas tran hold4_q FIND v(Q) AT=75n
.meas tran hold4_qb FIND v(QB) AT=75n
.meas tran iavg AVG i(VVDD) FROM=5n TO=80n
.save v(SN) v(RN) v(Q) v(QB) i(VVDD)"}
C {gnd.sym} 160 -20 0 0 {name=l1 lab=0}
C {gnd.sym} 250 -20 0 0 {name=l2 lab=0}
C {gnd.sym} 320 -20 0 0 {name=l3 lab=0}
C {gnd.sym} 480 -160 0 0 {name=l4 lab=0}
C {gnd.sym} 760 -130 0 0 {name=l5 lab=0}
C {gnd.sym} 880 -160 0 0 {name=l6 lab=0}
