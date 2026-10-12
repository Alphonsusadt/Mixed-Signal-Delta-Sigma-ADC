v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {BLOCK 4 - 1-BIT DIFFERENTIAL REFERENCE DAC (4 CMOS TG)} 140 -730 0 0 0.5 0.5 {}
T {Block 4 is reference MUX only; switched-capacitor feedback is Block 5} 140 -690 0 0 0.28 0.28 {}
T {Q=1: DAC_P=VREFP, DAC_N=VREFN} 150 -650 0 0 0.29 0.29 {}
T {Q=0: DAC_P=VREFN, DAC_N=VREFP} 150 -620 0 0 0.29 0.29 {}
T {TG1: VREFP -> DAC_P  [Q=1]} 310 -580 0 0 0.3 0.3 {}
T {TG3: VREFN -> DAC_N  [Q=1]} 690 -580 0 0 0.3 0.3 {}
T {TG2: VREFN -> DAC_P  [Q=0]} 310 -280 0 0 0.3 0.3 {}
T {TG4: VREFP -> DAC_N  [Q=0]} 690 -280 0 0 0.3 0.3 {}
T {Body tie: PMOS=VDD; NMOS=GND (in TG_cell.sch)} 170 -90 0 0 0.28 0.28 {}
N 320 -470 370 -470 {lab=VREFP}
N 570 -470 620 -470 {lab=DAC_P}
N 470 -610 470 -570 {lab=QB}
N 470 -370 470 -330 {lab=Q}
N 550 -540 550 -500 {lab=VDD}
N 550 -440 550 -400 {lab=GND}
N 320 -170 370 -170 {lab=VREFN}
N 570 -170 620 -170 {lab=DAC_P}
N 470 -310 470 -270 {lab=Q}
N 470 -70 470 -30 {lab=QB}
N 550 -240 550 -200 {lab=VDD}
N 550 -140 550 -100 {lab=GND}
N 700 -470 750 -470 {lab=VREFN}
N 950 -470 1000 -470 {lab=DAC_N}
N 850 -610 850 -570 {lab=QB}
N 850 -370 850 -330 {lab=Q}
N 930 -540 930 -500 {lab=VDD}
N 930 -440 930 -400 {lab=GND}
N 700 -170 750 -170 {lab=VREFP}
N 950 -170 1000 -170 {lab=DAC_N}
N 850 -310 850 -270 {lab=Q}
N 850 -70 850 -30 {lab=QB}
N 930 -240 930 -200 {lab=VDD}
N 930 -140 930 -100 {lab=GND}
C {devices/lab_wire.sym} 320 -470 0 0 {name=l_TG1_VREFP_320_-470 sig_type=std_logic lab=VREFP}
C {devices/lab_wire.sym} 570 -470 0 0 {name=l_TG1_DAC_P_570_-470 sig_type=std_logic lab=DAC_P}
C {devices/lab_wire.sym} 470 -610 0 0 {name=l_TG1_QB_470_-610 sig_type=std_logic lab=QB}
C {devices/lab_wire.sym} 470 -370 0 0 {name=l_TG1_Q_470_-370 sig_type=std_logic lab=Q}
C {devices/lab_wire.sym} 550 -540 0 0 {name=l_TG1_VDD_550_-540 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 550 -440 0 0 {name=l_TG1_GND_550_-440 sig_type=std_logic lab=GND}
C {devices/lab_wire.sym} 320 -170 0 0 {name=l_TG2_VREFN_320_-170 sig_type=std_logic lab=VREFN}
C {devices/lab_wire.sym} 570 -170 0 0 {name=l_TG2_DAC_P_570_-170 sig_type=std_logic lab=DAC_P}
C {devices/lab_wire.sym} 470 -310 0 0 {name=l_TG2_Q_470_-310 sig_type=std_logic lab=Q}
C {devices/lab_wire.sym} 470 -70 0 0 {name=l_TG2_QB_470_-70 sig_type=std_logic lab=QB}
C {devices/lab_wire.sym} 550 -240 0 0 {name=l_TG2_VDD_550_-240 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 550 -140 0 0 {name=l_TG2_GND_550_-140 sig_type=std_logic lab=GND}
C {devices/lab_wire.sym} 700 -470 0 0 {name=l_TG3_VREFN_700_-470 sig_type=std_logic lab=VREFN}
C {devices/lab_wire.sym} 950 -470 0 0 {name=l_TG3_DAC_N_950_-470 sig_type=std_logic lab=DAC_N}
C {devices/lab_wire.sym} 850 -610 0 0 {name=l_TG3_QB_850_-610 sig_type=std_logic lab=QB}
C {devices/lab_wire.sym} 850 -370 0 0 {name=l_TG3_Q_850_-370 sig_type=std_logic lab=Q}
C {devices/lab_wire.sym} 930 -540 0 0 {name=l_TG3_VDD_930_-540 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 930 -440 0 0 {name=l_TG3_GND_930_-440 sig_type=std_logic lab=GND}
C {devices/lab_wire.sym} 700 -170 0 0 {name=l_TG4_VREFP_700_-170 sig_type=std_logic lab=VREFP}
C {devices/lab_wire.sym} 950 -170 0 0 {name=l_TG4_DAC_N_950_-170 sig_type=std_logic lab=DAC_N}
C {devices/lab_wire.sym} 850 -310 0 0 {name=l_TG4_Q_850_-310 sig_type=std_logic lab=Q}
C {devices/lab_wire.sym} 850 -70 0 0 {name=l_TG4_QB_850_-70 sig_type=std_logic lab=QB}
C {devices/lab_wire.sym} 930 -240 0 0 {name=l_TG4_VDD_930_-240 sig_type=std_logic lab=VDD}
C {devices/lab_wire.sym} 930 -140 0 0 {name=l_TG4_GND_930_-140 sig_type=std_logic lab=GND}
C {devices/iopin.sym} 100 -520 0 0 {name=p1 lab=VREFP}
C {devices/iopin.sym} 100 -490 0 0 {name=p2 lab=VREFN}
C {devices/ipin.sym} 100 -420 0 0 {name=p3 lab=Q}
C {devices/ipin.sym} 100 -390 0 0 {name=p4 lab=QB}
C {devices/iopin.sym} 100 -320 0 0 {name=p5 lab=VDD}
C {devices/iopin.sym} 100 -290 0 0 {name=p6 lab=GND}
C {devices/opin.sym} 1110 -520 0 0 {name=p7 lab=DAC_P}
C {devices/opin.sym} 1110 -490 0 0 {name=p8 lab=DAC_N}
C {blocks/04_1Bit_DAC/xschem/TG_cell.sym} 470 -470 0 0 {name=x1}
C {blocks/04_1Bit_DAC/xschem/TG_cell.sym} 850 -470 0 0 {name=x2}
C {blocks/04_1Bit_DAC/xschem/TG_cell.sym} 470 -170 0 0 {name=x3}
C {blocks/04_1Bit_DAC/xschem/TG_cell.sym} 850 -170 0 0 {name=x4}
