v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
E {}
T {FB_SAMP: DAC feedback sampling branch (same LVT switches as Block 5, Cd = 1 pF)} 0 -250 0 0 0.6 0.6 {}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 0 0 0 {name=XS1_P }
N -100 0 -130 0 {}
C {lab_pin.sym} -130 0 0 0 {name=l1 lab=din_p}
N 100 0 130 0 {}
C {lab_pin.sym} 130 0 2 0 {name=l2 lab=a_p}
N 0 -100 0 -130 {}
C {lab_pin.sym} 0 -130 3 0 {name=l3 lab=phi1b}
N 0 100 0 130 {}
C {lab_pin.sym} 0 130 1 0 {name=l4 lab=phi1}
N 80 -30 110 -30 {}
C {lab_pin.sym} 110 -30 2 0 {name=l5 lab=vdd}
N 80 30 110 30 {}
C {lab_pin.sym} 110 30 2 0 {name=l6 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 700 0 0 0 {name=XT2_P }
N 600 0 570 0 {}
C {lab_pin.sym} 570 0 0 0 {name=l7 lab=b_p}
N 800 0 830 0 {}
C {lab_pin.sym} 830 0 2 0 {name=l8 lab=sum_p}
N 700 -100 700 -130 {}
C {lab_pin.sym} 700 -130 3 0 {name=l9 lab=phi2b}
N 700 100 700 130 {}
C {lab_pin.sym} 700 130 1 0 {name=l10 lab=phi2}
N 780 -30 810 -30 {}
C {lab_pin.sym} 810 -30 2 0 {name=l11 lab=vdd}
N 780 30 810 30 {}
C {lab_pin.sym} 810 30 2 0 {name=l12 lab=GND}
C {capa.sym} 380 0 0 0 {name=CD_P value=1p m=1}
N 380 -30 380 -50 {}
C {lab_pin.sym} 380 -50 3 0 {name=l13 lab=a_p}
N 380 30 380 50 {}
C {lab_pin.sym} 380 50 1 0 {name=l14 lab=b_p}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 300 0 0 {name=XT1_P }
N -100 300 -130 300 {}
C {lab_pin.sym} -130 300 0 0 {name=l15 lab=a_p}
N 100 300 130 300 {}
C {lab_pin.sym} 130 300 2 0 {name=l16 lab=vcm}
N 0 200 0 170 {}
C {lab_pin.sym} 0 170 3 0 {name=l17 lab=phi2b}
N 0 400 0 430 {}
C {lab_pin.sym} 0 430 1 0 {name=l18 lab=phi2}
N 80 270 110 270 {}
C {lab_pin.sym} 110 270 2 0 {name=l19 lab=vdd}
N 80 330 110 330 {}
C {lab_pin.sym} 110 330 2 0 {name=l20 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 450 300 0 0 {name=XS2_P }
N 350 300 320 300 {}
C {lab_pin.sym} 320 300 0 0 {name=l21 lab=b_p}
N 550 300 580 300 {}
C {lab_pin.sym} 580 300 2 0 {name=l22 lab=vcm}
N 450 200 450 170 {}
C {lab_pin.sym} 450 170 3 0 {name=l23 lab=phi1b}
N 450 400 450 430 {}
C {lab_pin.sym} 450 430 1 0 {name=l24 lab=phi1}
N 530 270 560 270 {}
C {lab_pin.sym} 560 270 2 0 {name=l25 lab=vdd}
N 530 330 560 330 {}
C {lab_pin.sym} 560 330 2 0 {name=l26 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 700 0 0 {name=XS1_N }
N -100 700 -130 700 {}
C {lab_pin.sym} -130 700 0 0 {name=l27 lab=din_n}
N 100 700 130 700 {}
C {lab_pin.sym} 130 700 2 0 {name=l28 lab=a_n}
N 0 600 0 570 {}
C {lab_pin.sym} 0 570 3 0 {name=l29 lab=phi1b}
N 0 800 0 830 {}
C {lab_pin.sym} 0 830 1 0 {name=l30 lab=phi1}
N 80 670 110 670 {}
C {lab_pin.sym} 110 670 2 0 {name=l31 lab=vdd}
N 80 730 110 730 {}
C {lab_pin.sym} 110 730 2 0 {name=l32 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 700 700 0 0 {name=XT2_N }
N 600 700 570 700 {}
C {lab_pin.sym} 570 700 0 0 {name=l33 lab=b_n}
N 800 700 830 700 {}
C {lab_pin.sym} 830 700 2 0 {name=l34 lab=sum_n}
N 700 600 700 570 {}
C {lab_pin.sym} 700 570 3 0 {name=l35 lab=phi2b}
N 700 800 700 830 {}
C {lab_pin.sym} 700 830 1 0 {name=l36 lab=phi2}
N 780 670 810 670 {}
C {lab_pin.sym} 810 670 2 0 {name=l37 lab=vdd}
N 780 730 810 730 {}
C {lab_pin.sym} 810 730 2 0 {name=l38 lab=GND}
C {capa.sym} 380 700 0 0 {name=CD_N value=1p m=1}
N 380 670 380 650 {}
C {lab_pin.sym} 380 650 3 0 {name=l39 lab=a_n}
N 380 730 380 750 {}
C {lab_pin.sym} 380 750 1 0 {name=l40 lab=b_n}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 1000 0 0 {name=XT1_N }
N -100 1000 -130 1000 {}
C {lab_pin.sym} -130 1000 0 0 {name=l41 lab=a_n}
N 100 1000 130 1000 {}
C {lab_pin.sym} 130 1000 2 0 {name=l42 lab=vcm}
N 0 900 0 870 {}
C {lab_pin.sym} 0 870 3 0 {name=l43 lab=phi2b}
N 0 1100 0 1130 {}
C {lab_pin.sym} 0 1130 1 0 {name=l44 lab=phi2}
N 80 970 110 970 {}
C {lab_pin.sym} 110 970 2 0 {name=l45 lab=vdd}
N 80 1030 110 1030 {}
C {lab_pin.sym} 110 1030 2 0 {name=l46 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 450 1000 0 0 {name=XS2_N }
N 350 1000 320 1000 {}
C {lab_pin.sym} 320 1000 0 0 {name=l47 lab=b_n}
N 550 1000 580 1000 {}
C {lab_pin.sym} 580 1000 2 0 {name=l48 lab=vcm}
N 450 900 450 870 {}
C {lab_pin.sym} 450 870 3 0 {name=l49 lab=phi1b}
N 450 1100 450 1130 {}
C {lab_pin.sym} 450 1130 1 0 {name=l50 lab=phi1}
N 530 970 560 970 {}
C {lab_pin.sym} 560 970 2 0 {name=l51 lab=vdd}
N 530 1030 560 1030 {}
C {lab_pin.sym} 560 1030 2 0 {name=l52 lab=GND}
C {ipin.sym} -450 -200 0 0 {name=P0 lab=din_p}
C {ipin.sym} -450 -160 0 0 {name=P1 lab=din_n}
C {ipin.sym} -450 -120 0 0 {name=P2 lab=phi1}
C {ipin.sym} -450 -80 0 0 {name=P3 lab=phi1b}
C {ipin.sym} -450 -40 0 0 {name=P4 lab=phi2}
C {ipin.sym} -450 0 0 0 {name=P5 lab=phi2b}
C {ipin.sym} -450 40 0 0 {name=P6 lab=vcm}
C {opin.sym} -450 80 0 0 {name=P7 lab=sum_p}
C {opin.sym} -450 120 0 0 {name=P8 lab=sum_n}
C {iopin.sym} -450 160 0 0 {name=P9 lab=vdd}
C {iopin.sym} -450 200 0 0 {name=P10 lab=GND}
