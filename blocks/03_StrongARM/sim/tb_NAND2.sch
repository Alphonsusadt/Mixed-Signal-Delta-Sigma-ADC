v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 300 -400 330 -400 {lab=A}
N 300 -320 330 -320 {lab=B}
N 590 -360 700 -360 {lab=Y}
N 470 -260 470 -210 {lab=VCC}
N 430 -260 430 -210 {lab=0}
N 170 -140 170 -110 {lab=VCC}
N 170 -50 170 -30 {lab=0}
N 250 -130 250 -110 {lab=A}
N 250 -50 250 -30 {lab=0}
N 320 -130 320 -110 {lab=B}
N 320 -50 320 -30 {lab=0}
N 700 -360 700 -330 {lab=Y}
N 700 -270 700 -250 {lab=0}
N 700 -360 760 -360 {lab=Y}
C {devices/vsource.sym} 170 -80 0 0 {name=VVDD value=1.8}
C {devices/vsource.sym} 250 -80 0 0 {name=VA value="PWL(0n 0 10n 0 10.1n 1.8 30n 1.8 30.1n 0 40n 0)"}
C {devices/vsource.sym} 320 -80 0 0 {name=VB value="PWL(0n 0 20n 0 20.1n 1.8 40n 1.8)"}
C {devices/capa.sym} 700 -300 0 0 {name=CLOAD value=20f}
C {devices/lab_wire.sym} 170 -140 0 0 {name=lVCCsrc lab=VCC}
C {devices/lab_wire.sym} 250 -130 0 0 {name=lAsrc lab=A}
C {devices/lab_wire.sym} 320 -130 0 0 {name=lBsrc lab=B}
C {devices/lab_wire.sym} 300 -400 0 0 {name=lAin lab=A}
C {devices/lab_wire.sym} 300 -320 0 0 {name=lBin lab=B}
C {devices/lab_wire.sym} 750 -360 0 0 {name=lYout lab=Y}
C {devices/lab_wire.sym} 470 -210 0 0 {name=lVCCnand lab=VCC}
C {devices/code_shown.sym} 950 -240 0 0 {name=SPICE only_toplevel=true value=".lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice tt
.option scale=1e-6
.tran 0.01n 40n 0 0.01n
.meas tran v00 FIND v(Y) AT=5n
.meas tran v10 FIND v(Y) AT=15n
.meas tran v11 FIND v(Y) AT=25n
.meas tran v01 FIND v(Y) AT=35n
.meas tran tphl TRIG v(B) VAL=0.9 RISE=1 TARG v(Y) VAL=0.9 FALL=1
.meas tran tplh TRIG v(A) VAL=0.9 FALL=1 TARG v(Y) VAL=0.9 RISE=1
.save v(A) v(B) v(Y) i(VVDD)"}
C {blocks/03_StrongARM/xschem/NAND2.sym} 450 -360 0 0 {name=x1}
C {gnd.sym} 170 -30 0 0 {name=l1 lab=0}
C {gnd.sym} 250 -30 0 0 {name=l2 lab=0}
C {gnd.sym} 320 -30 0 0 {name=l3 lab=0}
C {gnd.sym} 700 -250 0 0 {name=l4 lab=0}
C {gnd.sym} 430 -210 0 0 {name=l5 lab=0}
