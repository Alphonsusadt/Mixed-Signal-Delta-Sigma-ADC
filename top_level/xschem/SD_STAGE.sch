v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
E {}
T {SD_STAGE: SC integrator (Block 5 switches + Block 1 OTA + Block 2 CMFB)} 0 -250 0 0 0.6 0.6 {}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 0 0 0 {name=x1 }
N -100 0 -130 0 {}
C {lab_pin.sym} -130 0 0 0 {name=l1 lab=vin_p}
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
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 700 0 0 0 {name=x7 }
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
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 300 0 0 {name=x6 }
N -100 300 -130 300 {}
C {lab_pin.sym} -130 300 0 0 {name=l13 lab=a_p}
N 100 300 130 300 {}
C {lab_pin.sym} 130 300 2 0 {name=l14 lab=vcm}
N 0 200 0 170 {}
C {lab_pin.sym} 0 170 3 0 {name=l15 lab=phi2b}
N 0 400 0 430 {}
C {lab_pin.sym} 0 430 1 0 {name=l16 lab=phi2}
N 80 270 110 270 {}
C {lab_pin.sym} 110 270 2 0 {name=l17 lab=vdd}
N 80 330 110 330 {}
C {lab_pin.sym} 110 330 2 0 {name=l18 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 450 300 0 0 {name=x2 }
N 350 300 320 300 {}
C {lab_pin.sym} 320 300 0 0 {name=l19 lab=b_p}
N 550 300 580 300 {}
C {lab_pin.sym} 580 300 2 0 {name=l20 lab=vcm}
N 450 200 450 170 {}
C {lab_pin.sym} 450 170 3 0 {name=l21 lab=phi1b}
N 450 400 450 430 {}
C {lab_pin.sym} 450 430 1 0 {name=l22 lab=phi1}
N 530 270 560 270 {}
C {lab_pin.sym} 560 270 2 0 {name=l23 lab=vdd}
N 530 330 560 330 {}
C {lab_pin.sym} 560 330 2 0 {name=l24 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 700 0 0 {name=x3 }
N -100 700 -130 700 {}
C {lab_pin.sym} -130 700 0 0 {name=l25 lab=vin_n}
N 100 700 130 700 {}
C {lab_pin.sym} 130 700 2 0 {name=l26 lab=a_n}
N 0 600 0 570 {}
C {lab_pin.sym} 0 570 3 0 {name=l27 lab=phi1b}
N 0 800 0 830 {}
C {lab_pin.sym} 0 830 1 0 {name=l28 lab=phi1}
N 80 670 110 670 {}
C {lab_pin.sym} 110 670 2 0 {name=l29 lab=vdd}
N 80 730 110 730 {}
C {lab_pin.sym} 110 730 2 0 {name=l30 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 700 700 0 0 {name=x9 }
N 600 700 570 700 {}
C {lab_pin.sym} 570 700 0 0 {name=l31 lab=b_n}
N 800 700 830 700 {}
C {lab_pin.sym} 830 700 2 0 {name=l32 lab=sum_n}
N 700 600 700 570 {}
C {lab_pin.sym} 700 570 3 0 {name=l33 lab=phi2b}
N 700 800 700 830 {}
C {lab_pin.sym} 700 830 1 0 {name=l34 lab=phi2}
N 780 670 810 670 {}
C {lab_pin.sym} 810 670 2 0 {name=l35 lab=vdd}
N 780 730 810 730 {}
C {lab_pin.sym} 810 730 2 0 {name=l36 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 1000 0 0 {name=x5 }
N -100 1000 -130 1000 {}
C {lab_pin.sym} -130 1000 0 0 {name=l37 lab=a_n}
N 100 1000 130 1000 {}
C {lab_pin.sym} 130 1000 2 0 {name=l38 lab=vcm}
N 0 900 0 870 {}
C {lab_pin.sym} 0 870 3 0 {name=l39 lab=phi2b}
N 0 1100 0 1130 {}
C {lab_pin.sym} 0 1130 1 0 {name=l40 lab=phi2}
N 80 970 110 970 {}
C {lab_pin.sym} 110 970 2 0 {name=l41 lab=vdd}
N 80 1030 110 1030 {}
C {lab_pin.sym} 110 1030 2 0 {name=l42 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 450 1000 0 0 {name=x4 }
N 350 1000 320 1000 {}
C {lab_pin.sym} 320 1000 0 0 {name=l43 lab=b_n}
N 550 1000 580 1000 {}
C {lab_pin.sym} 580 1000 2 0 {name=l44 lab=vcm}
N 450 900 450 870 {}
C {lab_pin.sym} 450 870 3 0 {name=l45 lab=phi1b}
N 450 1100 450 1130 {}
C {lab_pin.sym} 450 1130 1 0 {name=l46 lab=phi1}
N 530 970 560 970 {}
C {lab_pin.sym} 560 970 2 0 {name=l47 lab=vdd}
N 530 1030 560 1030 {}
C {lab_pin.sym} 560 1030 2 0 {name=l48 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 0 1400 0 0 {name=XPRE_SP }
N -100 1400 -130 1400 {}
C {lab_pin.sym} -130 1400 0 0 {name=l49 lab=sum_p}
N 100 1400 130 1400 {}
C {lab_pin.sym} 130 1400 2 0 {name=l50 lab=vcm}
N 0 1300 0 1270 {}
C {lab_pin.sym} 0 1270 3 0 {name=l51 lab=rstb}
N 0 1500 0 1530 {}
C {lab_pin.sym} 0 1530 1 0 {name=l52 lab=rst}
N 80 1370 110 1370 {}
C {lab_pin.sym} 110 1370 2 0 {name=l53 lab=vdd}
N 80 1430 110 1430 {}
C {lab_pin.sym} 110 1430 2 0 {name=l54 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 450 1400 0 0 {name=XPRE_SN }
N 350 1400 320 1400 {}
C {lab_pin.sym} 320 1400 0 0 {name=l55 lab=sum_n}
N 550 1400 580 1400 {}
C {lab_pin.sym} 580 1400 2 0 {name=l56 lab=vcm}
N 450 1300 450 1270 {}
C {lab_pin.sym} 450 1270 3 0 {name=l57 lab=rstb}
N 450 1500 450 1530 {}
C {lab_pin.sym} 450 1530 1 0 {name=l58 lab=rst}
N 530 1370 560 1370 {}
C {lab_pin.sym} 560 1370 2 0 {name=l59 lab=vdd}
N 530 1430 560 1430 {}
C {lab_pin.sym} 560 1430 2 0 {name=l60 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 900 1400 0 0 {name=XPRE_OP }
N 800 1400 770 1400 {}
C {lab_pin.sym} 770 1400 0 0 {name=l61 lab=out_p}
N 1000 1400 1030 1400 {}
C {lab_pin.sym} 1030 1400 2 0 {name=l62 lab=vcm}
N 900 1300 900 1270 {}
C {lab_pin.sym} 900 1270 3 0 {name=l63 lab=rstb}
N 900 1500 900 1530 {}
C {lab_pin.sym} 900 1530 1 0 {name=l64 lab=rst}
N 980 1370 1010 1370 {}
C {lab_pin.sym} 1010 1370 2 0 {name=l65 lab=vdd}
N 980 1430 1010 1430 {}
C {lab_pin.sym} 1010 1430 2 0 {name=l66 lab=GND}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 1350 1400 0 0 {name=XPRE_ON }
N 1250 1400 1220 1400 {}
C {lab_pin.sym} 1220 1400 0 0 {name=l67 lab=out_n}
N 1450 1400 1480 1400 {}
C {lab_pin.sym} 1480 1400 2 0 {name=l68 lab=vcm}
N 1350 1300 1350 1270 {}
C {lab_pin.sym} 1350 1270 3 0 {name=l69 lab=rstb}
N 1350 1500 1350 1530 {}
C {lab_pin.sym} 1350 1530 1 0 {name=l70 lab=rst}
N 1430 1370 1460 1370 {}
C {lab_pin.sym} 1460 1370 2 0 {name=l71 lab=vdd}
N 1430 1430 1460 1430 {}
C {lab_pin.sym} 1460 1430 2 0 {name=l72 lab=GND}
C {capa.sym} 450 0 0 0 {name=CSp value=1p m=1}
N 450 -30 450 -50 {}
C {lab_pin.sym} 450 -50 3 0 {name=l73 lab=a_p}
N 450 30 450 50 {}
C {lab_pin.sym} 450 50 1 0 {name=l74 lab=b_p}
C {capa.sym} 450 700 0 0 {name=CSn value=1p m=1}
N 450 670 450 650 {}
C {lab_pin.sym} 450 650 3 0 {name=l75 lab=a_n}
N 450 730 450 750 {}
C {lab_pin.sym} 450 750 1 0 {name=l76 lab=b_n}
C {capa.sym} 1150 0 0 0 {name=CFp value=2p m=1}
N 1150 -30 1150 -50 {}
C {lab_pin.sym} 1150 -50 3 0 {name=l77 lab=sum_p}
N 1150 30 1150 50 {}
C {lab_pin.sym} 1150 50 1 0 {name=l78 lab=out_p}
C {capa.sym} 1300 0 0 0 {name=CLp value=200f m=1}
N 1300 -30 1300 -50 {}
C {lab_pin.sym} 1300 -50 3 0 {name=l79 lab=out_p}
N 1300 30 1300 50 {}
C {lab_pin.sym} 1300 50 1 0 {name=l80 lab=GND}
C {capa.sym} 1150 700 0 0 {name=CFn value=2p m=1}
N 1150 670 1150 650 {}
C {lab_pin.sym} 1150 650 3 0 {name=l81 lab=sum_n}
N 1150 730 1150 750 {}
C {lab_pin.sym} 1150 750 1 0 {name=l82 lab=out_n}
C {capa.sym} 1300 700 0 0 {name=CLn value=200f m=1}
N 1300 670 1300 650 {}
C {lab_pin.sym} 1300 650 3 0 {name=l83 lab=out_n}
N 1300 730 1300 750 {}
C {lab_pin.sym} 1300 750 1 0 {name=l84 lab=GND}
C {blocks/01_OTA/xschem/OTA_CMFB.sym} 1750 250 0 0 {name=x11 }
N 1830 200 1870 200 {}
C {lab_pin.sym} 1870 200 2 0 {name=l85 lab=vdd}
N 1600 200 1560 200 {}
C {lab_pin.sym} 1560 200 0 0 {name=l86 lab=vcmfb}
N 1600 220 1560 220 {}
C {lab_pin.sym} 1560 220 0 0 {name=l87 lab=vbz_r}
N 1600 240 1560 240 {}
C {lab_pin.sym} 1560 240 0 0 {name=l88 lab=vbz_l}
N 1600 260 1560 260 {}
C {lab_pin.sym} 1560 260 0 0 {name=l89 lab=sum_p}
N 1600 280 1560 280 {}
C {lab_pin.sym} 1560 280 0 0 {name=l90 lab=sum_n}
N 1830 220 1870 220 {}
C {lab_pin.sym} 1870 220 2 0 {name=l91 lab=vo1_b}
N 1830 240 1870 240 {}
C {lab_pin.sym} 1870 240 2 0 {name=l92 lab=vo1_a}
N 1830 260 1870 260 {}
C {lab_pin.sym} 1870 260 2 0 {name=l93 lab=out_p}
N 1830 280 1870 280 {}
C {lab_pin.sym} 1870 280 2 0 {name=l94 lab=out_n}
N 1600 300 1560 300 {}
C {lab_pin.sym} 1560 300 0 0 {name=l95 lab=vbias}
N 1830 300 1870 300 {}
C {lab_pin.sym} 1870 300 2 0 {name=l96 lab=GND}
C {blocks/02_CMFB/xschem/CMFB.sym} 1750 750 0 0 {name=x12 }
N 1860 690 1900 690 {}
C {lab_pin.sym} 1900 690 2 0 {name=l97 lab=vcmfb}
N 1640 670 1600 670 {}
C {lab_pin.sym} 1600 670 0 0 {name=l98 lab=vcs}
N 1640 690 1600 690 {}
C {lab_pin.sym} 1600 690 0 0 {name=l99 lab=phi1b}
N 1640 710 1600 710 {}
C {lab_pin.sym} 1600 710 0 0 {name=l100 lab=phi1}
N 1860 670 1900 670 {}
C {lab_pin.sym} 1900 670 2 0 {name=l101 lab=vdd}
N 1640 730 1600 730 {}
C {lab_pin.sym} 1600 730 0 0 {name=l102 lab=phi2b}
N 1860 710 1900 710 {}
C {lab_pin.sym} 1900 710 2 0 {name=l103 lab=GND}
N 1640 750 1600 750 {}
C {lab_pin.sym} 1600 750 0 0 {name=l104 lab=phi2}
N 1640 770 1600 770 {}
C {lab_pin.sym} 1600 770 0 0 {name=l105 lab=vcm_stage1}
N 1640 790 1600 790 {}
C {lab_pin.sym} 1600 790 0 0 {name=l106 lab=vo1_b}
N 1640 810 1600 810 {}
C {lab_pin.sym} 1600 810 0 0 {name=l107 lab=vo1_a}
C {blocks/02_CMFB/xschem/CMFB_OUT_I2_Wired.sym} 1750 1250 0 0 {name=XCMOUT }
N 1750 1110 1750 1070 {}
C {lab_pin.sym} 1750 1070 3 0 {name=l108 lab=vdd}
N 1750 1390 1750 1430 {}
C {lab_pin.sym} 1750 1430 1 0 {name=l109 lab=GND}
N 1690 1110 1690 1070 {}
C {lab_pin.sym} 1690 1070 3 0 {name=l110 lab=out_p}
N 1810 1110 1810 1070 {}
C {lab_pin.sym} 1810 1070 3 0 {name=l111 lab=out_n}
N 1600 1310 1560 1310 {}
C {lab_pin.sym} 1560 1310 0 0 {name=l112 lab=vcm}
C {ipin.sym} -450 -200 0 0 {name=P0 lab=vin_p}
C {ipin.sym} -450 -160 0 0 {name=P1 lab=vin_n}
C {ipin.sym} -450 -120 0 0 {name=P2 lab=phi1}
C {ipin.sym} -450 -80 0 0 {name=P3 lab=phi1b}
C {ipin.sym} -450 -40 0 0 {name=P4 lab=phi2}
C {ipin.sym} -450 0 0 0 {name=P5 lab=phi2b}
C {ipin.sym} -450 40 0 0 {name=P6 lab=rst}
C {ipin.sym} -450 80 0 0 {name=P7 lab=rstb}
C {ipin.sym} -450 120 0 0 {name=P8 lab=vcm}
C {ipin.sym} -450 160 0 0 {name=P9 lab=vcm_stage1}
C {ipin.sym} -450 200 0 0 {name=P10 lab=vbias}
C {ipin.sym} -450 240 0 0 {name=P11 lab=vcs}
C {ipin.sym} -450 280 0 0 {name=P12 lab=vbz_l}
C {ipin.sym} -450 320 0 0 {name=P13 lab=vbz_r}
C {opin.sym} -450 360 0 0 {name=P14 lab=out_p}
C {opin.sym} -450 400 0 0 {name=P15 lab=out_n}
C {opin.sym} -450 440 0 0 {name=P16 lab=sum_p}
C {opin.sym} -450 480 0 0 {name=P17 lab=sum_n}
C {iopin.sym} -450 520 0 0 {name=P18 lab=vdd}
C {iopin.sym} -450 560 0 0 {name=P19 lab=GND}
