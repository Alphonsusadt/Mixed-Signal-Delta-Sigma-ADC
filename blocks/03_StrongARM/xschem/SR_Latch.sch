v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 250 -440 320 -440 {lab=SN}
N 250 -360 320 -360 {lab=QB}
N 590 -400 700 -400 {lab=Q}
N 430 -300 430 -240 {lab=GND}
N 470 -300 470 -240 {lab=VCC}
N 250 -140 320 -140 {lab=RN}
N 250 -60 320 -60 {lab=Q}
N 590 -100 700 -100 {lab=QB}
N 430 0 430 60 {lab=GND}
N 470 0 470 60 {lab=VCC}
C {blocks/03_StrongARM/xschem/NAND2.sym} 450 -400 0 0 {name=x1}
C {blocks/03_StrongARM/xschem/NAND2.sym} 450 -100 0 0 {name=x2}
C {devices/ipin.sym} 250 -440 0 0 {name=pSN lab=SN}
C {devices/ipin.sym} 250 -140 0 0 {name=pRN lab=RN}
C {devices/opin.sym} 700 -400 0 0 {name=pQ lab=Q}
C {devices/opin.sym} 700 -100 0 0 {name=pQB lab=QB}
C {devices/iopin.sym} 470 -240 0 0 {name=pVCC lab=VCC}
C {devices/iopin.sym} 430 60 2 0 {name=pGND lab=GND}
C {devices/lab_wire.sym} 250 -360 0 0 {name=lQBin lab=QB}
C {devices/lab_wire.sym} 250 -60 0 0 {name=lQin lab=Q}
C {devices/lab_wire.sym} 430 -240 0 0 {name=lGNDtop lab=GND}
C {devices/lab_wire.sym} 470 60 0 0 {name=lVCCbot lab=VCC}
