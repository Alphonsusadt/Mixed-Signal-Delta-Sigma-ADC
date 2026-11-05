v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 60 -420 0 0 {name=p_CLK lab=CLK}
C {opin.sym} 60 -380 0 0 {name=p_PHI1 lab=PHI1}
C {opin.sym} 60 -340 0 0 {name=p_PHI1B lab=PHI1B}
C {opin.sym} 60 -300 0 0 {name=p_PHI2 lab=PHI2}
C {opin.sym} 60 -260 0 0 {name=p_PHI2B lab=PHI2B}
C {iopin.sym} 60 -220 0 0 {name=p_VDD lab=VDD}
C {ipin.sym} 60 -180 0 0 {name=p_VBP lab=VBP}
C {iopin.sym} 60 -140 0 0 {name=p_GND lab=GND}
C {ipin.sym} 60 -100 0 0 {name=p_VBN lab=VBN}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 300 -300 0 0 {name=x1}
C {lab_pin.sym} 210 -320 0 0 {name=l0 lab=CLK}
C {lab_pin.sym} 210 -280 0 0 {name=l1 lab=VDD}
C {lab_pin.sym} 390 -300 0 1 {name=l2 lab=CLKB}
C {lab_pin.sym} 300 -370 0 1 {name=l3 lab=VDD}
C {lab_pin.sym} 300 -230 0 1 {name=l4 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 300 -100 0 0 {name=x2}
C {lab_pin.sym} 210 -120 0 0 {name=l5 lab=CLK}
C {lab_pin.sym} 210 -80 0 0 {name=l6 lab=GND}
C {lab_pin.sym} 390 -100 0 1 {name=l7 lab=CLKS}
C {lab_pin.sym} 300 -170 0 1 {name=l8 lab=VDD}
C {lab_pin.sym} 300 -30 0 1 {name=l9 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_DELAY_CS.sym} 560 -300 0 0 {name=xd1}
C {lab_pin.sym} 470 -300 0 0 {name=l10 lab=CLKB}
C {lab_pin.sym} 650 -300 0 1 {name=l11 lab=DCLKB}
C {lab_pin.sym} 540 -370 0 1 {name=l12 lab=VBP}
C {lab_pin.sym} 540 -230 0 1 {name=l13 lab=VBN}
C {lab_pin.sym} 580 -370 0 1 {name=l14 lab=VDD}
C {lab_pin.sym} 580 -230 0 1 {name=l15 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_DELAY_CS.sym} 560 -100 0 0 {name=xd2}
C {lab_pin.sym} 470 -100 0 0 {name=l16 lab=CLKS}
C {lab_pin.sym} 650 -100 0 1 {name=l17 lab=DCLKS}
C {lab_pin.sym} 540 -170 0 1 {name=l18 lab=VBP}
C {lab_pin.sym} 540 -30 0 1 {name=l19 lab=VBN}
C {lab_pin.sym} 580 -170 0 1 {name=l20 lab=VDD}
C {lab_pin.sym} 580 -30 0 1 {name=l21 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_AND2.sym} 820 -300 0 0 {name=xa1}
C {lab_pin.sym} 730 -320 0 0 {name=l22 lab=CLKB}
C {lab_pin.sym} 730 -280 0 0 {name=l23 lab=DCLKS}
C {lab_pin.sym} 910 -300 0 1 {name=l24 lab=PHI1S}
C {lab_pin.sym} 820 -370 0 1 {name=l25 lab=VDD}
C {lab_pin.sym} 820 -230 0 1 {name=l26 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_AND2.sym} 820 -100 0 0 {name=xa2}
C {lab_pin.sym} 730 -120 0 0 {name=l27 lab=CLKS}
C {lab_pin.sym} 730 -80 0 0 {name=l28 lab=DCLKB}
C {lab_pin.sym} 910 -100 0 1 {name=l29 lab=PHI2S}
C {lab_pin.sym} 820 -170 0 1 {name=l30 lab=VDD}
C {lab_pin.sym} 820 -30 0 1 {name=l31 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 1100 -400 0 0 {name=x3}
C {lab_pin.sym} 1010 -420 0 0 {name=l32 lab=PHI1S}
C {lab_pin.sym} 1010 -380 0 0 {name=l33 lab=VDD}
C {lab_pin.sym} 1190 -400 0 1 {name=l34 lab=PHI1B}
C {lab_pin.sym} 1100 -470 0 1 {name=l35 lab=VDD}
C {lab_pin.sym} 1100 -330 0 1 {name=l36 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 1100 -250 0 0 {name=x4}
C {lab_pin.sym} 1010 -270 0 0 {name=l37 lab=PHI1S}
C {lab_pin.sym} 1010 -230 0 0 {name=l38 lab=GND}
C {lab_pin.sym} 1190 -250 0 1 {name=l39 lab=PHI1}
C {lab_pin.sym} 1100 -320 0 1 {name=l40 lab=VDD}
C {lab_pin.sym} 1100 -180 0 1 {name=l41 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 1100 -100 0 0 {name=x5}
C {lab_pin.sym} 1010 -120 0 0 {name=l42 lab=PHI2S}
C {lab_pin.sym} 1010 -80 0 0 {name=l43 lab=VDD}
C {lab_pin.sym} 1190 -100 0 1 {name=l44 lab=PHI2B}
C {lab_pin.sym} 1100 -170 0 1 {name=l45 lab=VDD}
C {lab_pin.sym} 1100 -30 0 1 {name=l46 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 1100 50 0 0 {name=x6}
C {lab_pin.sym} 1010 30 0 0 {name=l47 lab=PHI2S}
C {lab_pin.sym} 1010 70 0 0 {name=l48 lab=GND}
C {lab_pin.sym} 1190 50 0 1 {name=l49 lab=PHI2}
C {lab_pin.sym} 1100 -20 0 1 {name=l50 lab=VDD}
C {lab_pin.sym} 1100 120 0 1 {name=l51 lab=GND}
T {NONOV (Spilka et al., DDECS 2012, Fig. 7): XOR -> tunda -> AND -> XOR} 240 -560 0 0 0.4 0.4 {}
N 210 -320 240 -320 {}
N 210 -280 240 -280 {}
N 210 -120 240 -120 {}
N 210 -80 240 -80 {}
N 300 -370 300 -350 {}
N 300 -250 300 -230 {}
N 300 -170 300 -150 {}
N 300 -50 300 -30 {}
N 360 -300 390 -300 {}
N 360 -100 390 -100 {}
N 470 -300 500 -300 {}
N 470 -100 500 -100 {}
N 540 -370 540 -350 {}
N 540 -250 540 -230 {}
N 540 -170 540 -150 {}
N 540 -50 540 -30 {}
N 580 -370 580 -350 {}
N 580 -250 580 -230 {}
N 580 -170 580 -150 {}
N 580 -50 580 -30 {}
N 620 -300 650 -300 {}
N 620 -100 650 -100 {}
N 730 -320 760 -320 {}
N 730 -280 760 -280 {}
N 730 -120 760 -120 {}
N 730 -80 760 -80 {}
N 820 -370 820 -350 {}
N 820 -250 820 -230 {}
N 820 -170 820 -150 {}
N 820 -50 820 -30 {}
N 880 -300 910 -300 {}
N 880 -100 910 -100 {}
N 1010 -420 1040 -420 {}
N 1010 -380 1040 -380 {}
N 1010 -270 1040 -270 {}
N 1010 -230 1040 -230 {}
N 1010 -120 1040 -120 {}
N 1010 -80 1040 -80 {}
N 1010 30 1040 30 {}
N 1010 70 1040 70 {}
N 1100 -470 1100 -450 {}
N 1100 -350 1100 -330 {}
N 1100 -320 1100 -300 {}
N 1100 -200 1100 -180 {}
N 1100 -170 1100 -150 {}
N 1100 -50 1100 -30 {}
N 1100 -20 1100 0 {}
N 1100 100 1100 120 {}
N 1160 -400 1190 -400 {}
N 1160 -250 1190 -250 {}
N 1160 -100 1190 -100 {}
N 1160 50 1190 50 {}
