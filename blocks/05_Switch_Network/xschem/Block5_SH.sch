v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {BLOCK 5: differential passive track-and-hold; adapted from Xu & Friedman (2005), Fig. 3.} 100 -540 0 0 0.3 0.3 {}
T {CH = 1p per side. No OTA or buffer. Keep PHI_SHB complementary to PHI_SH.} 100 -500 0 0 0.25 0.25 {}
N 160 -200 300 -200 {lab=VIN_P}
N 500 -200 680 -200 {lab=HOLD_P}
N 400 -300 420 -300 {lab=PHI_SHB}
N 400 -100 420 -100 {lab=PHI_SH}
N 480 -230 500 -230 {lab=VDD}
N 480 -170 500 -170 {lab=GND}
N 620 -140 640 -140 {lab=VCM}
N 160 200 300 200 {lab=VIN_N}
N 500 200 680 200 {lab=HOLD_N}
N 400 100 420 100 {lab=PHI_SHB}
N 400 300 420 300 {lab=PHI_SH}
N 480 170 500 170 {lab=VDD}
N 480 230 500 230 {lab=GND}
N 620 260 640 260 {lab=VCM}
C {ipin.sym} 160 -200 0 0 {name=p1 lab=VIN_P}
C {ipin.sym} 160 200 0 0 {name=p2 lab=VIN_N}
C {ipin.sym} 160 -420 0 0 {name=p3 lab=PHI_SH}
C {ipin.sym} 160 -380 0 0 {name=p4 lab=PHI_SHB}
C {iopin.sym} 800 -420 0 0 {name=p5 lab=VDD}
C {iopin.sym} 800 -380 0 0 {name=p6 lab=GND}
C {ipin.sym} 160 -340 0 0 {name=p7 lab=VCM}
C {opin.sym} 680 -200 0 0 {name=p8 lab=HOLD_P}
C {opin.sym} 680 200 0 0 {name=p9 lab=HOLD_N}
C {lab_pin.sym} 420 -300 0 1 {name=lP0 lab=PHI_SHB}
C {lab_pin.sym} 420 -100 0 1 {name=lP1 lab=PHI_SH}
C {lab_pin.sym} 500 -230 0 1 {name=lP2 lab=VDD}
C {lab_pin.sym} 500 -170 0 1 {name=lP3 lab=GND}
C {capa.sym} 620 -170 0 0 {name=CH_P m=1 value=1p}
C {lab_pin.sym} 640 -140 0 1 {name=lVCM_P lab=VCM}
C {lab_pin.sym} 420 100 0 1 {name=lN0 lab=PHI_SHB}
C {lab_pin.sym} 420 300 0 1 {name=lN1 lab=PHI_SH}
C {lab_pin.sym} 500 170 0 1 {name=lN2 lab=VDD}
C {lab_pin.sym} 500 230 0 1 {name=lN3 lab=GND}
C {capa.sym} 620 230 0 0 {name=CH_N m=1 value=1p}
C {lab_pin.sym} 640 260 0 1 {name=lVCM_N lab=VCM}
C {blocks/05_Switch_Network/xschem/TG_SC.sym} 400 -200 0 0 {name=x3}
C {blocks/05_Switch_Network/xschem/TG_SC.sym} 400 200 0 0 {name=x1}
