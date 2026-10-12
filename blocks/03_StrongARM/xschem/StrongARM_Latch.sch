v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {TAHAP 9D - comparator 11T + SR latch 8T} 120 -880 0 0 0.4 0.4 {}
T {Vin1 > Vin2 -> Vout_P LOW -> latch Q HIGH} 120 -835 0 0 0.3 0.3 {}
N 470 -530 500 -530 {lab=VDD}
N 240 -530 270 -530 {lab=CLK}
N 470 -510 500 -510 {lab=Vout_P}
N 470 -490 500 -490 {lab=Vout_N}
N 240 -510 270 -510 {lab=Vin1}
N 240 -490 270 -490 {lab=Vin2}
N 470 -470 500 -470 {lab=GND}
N 880 -550 910 -550 {lab=Vout_P}
N 880 -450 910 -450 {lab=Vout_N}
N 1170 -550 1200 -550 {lab=Q}
N 1170 -450 1200 -450 {lab=QB}
N 1020 -400 1020 -370 {lab=GND}
N 1060 -400 1060 -370 {lab=VDD}
N 80 -720 110 -720 {lab=Vin1}
N 80 -670 110 -670 {lab=Vin2}
N 80 -620 110 -620 {lab=CLK}
N 80 -570 110 -570 {lab=VDD}
N 80 -520 110 -520 {lab=GND}
N 1390 -720 1420 -720 {lab=Q}
N 1390 -670 1420 -670 {lab=QB}
N 1390 -620 1420 -620 {lab=Vout_P}
N 1390 -570 1420 -570 {lab=Vout_N}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 420 -500 0 0 {name=xSA}
C {blocks/03_StrongARM/xschem/SR_Latch.sym} 1040 -500 0 0 {name=xSR}
C {devices/lab_wire.sym} 500 -530 0 0 {name=wSA_0 lab=VDD}
C {devices/lab_wire.sym} 240 -530 0 0 {name=wSA_1 lab=CLK}
C {devices/lab_wire.sym} 500 -510 0 0 {name=wSA_2 lab=Vout_P}
C {devices/lab_wire.sym} 500 -490 0 0 {name=wSA_3 lab=Vout_N}
C {devices/lab_wire.sym} 240 -510 0 0 {name=wSA_4 lab=Vin1}
C {devices/lab_wire.sym} 240 -490 0 0 {name=wSA_5 lab=Vin2}
C {devices/lab_wire.sym} 500 -470 0 0 {name=wSA_6 lab=GND}
C {devices/lab_wire.sym} 880 -550 0 0 {name=wSR_0 lab=Vout_P}
C {devices/lab_wire.sym} 880 -450 0 0 {name=wSR_1 lab=Vout_N}
C {devices/lab_wire.sym} 1200 -550 0 0 {name=wSR_2 lab=Q}
C {devices/lab_wire.sym} 1200 -450 0 0 {name=wSR_3 lab=QB}
C {devices/lab_wire.sym} 1020 -370 0 0 {name=wSR_4 lab=GND}
C {devices/lab_wire.sym} 1060 -370 0 0 {name=wSR_5 lab=VDD}
C {devices/ipin.sym} 80 -720 0 0 {name=p0 lab=Vin1}
C {devices/lab_wire.sym} 110 -720 0 0 {name=port0 lab=Vin1}
C {devices/ipin.sym} 80 -670 0 0 {name=p1 lab=Vin2}
C {devices/lab_wire.sym} 110 -670 0 0 {name=port1 lab=Vin2}
C {devices/ipin.sym} 80 -620 0 0 {name=p2 lab=CLK}
C {devices/lab_wire.sym} 110 -620 0 0 {name=port2 lab=CLK}
C {devices/iopin.sym} 80 -570 2 0 {name=p3 lab=VDD}
C {devices/lab_wire.sym} 110 -570 0 0 {name=port3 lab=VDD}
C {devices/iopin.sym} 80 -520 2 0 {name=p4 lab=GND}
C {devices/lab_wire.sym} 110 -520 0 0 {name=port4 lab=GND}
C {devices/opin.sym} 1420 -720 0 0 {name=p5 lab=Q}
C {devices/lab_wire.sym} 1390 -720 0 0 {name=port5 lab=Q}
C {devices/opin.sym} 1420 -670 0 0 {name=p6 lab=QB}
C {devices/lab_wire.sym} 1390 -670 0 0 {name=port6 lab=QB}
C {devices/opin.sym} 1420 -620 0 0 {name=p7 lab=Vout_P}
C {devices/lab_wire.sym} 1390 -620 0 0 {name=port7 lab=Vout_P}
C {devices/opin.sym} 1420 -570 0 0 {name=p8 lab=Vout_N}
C {devices/lab_wire.sym} 1390 -570 0 0 {name=port8 lab=Vout_N}
