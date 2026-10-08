v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 870 -600 930 -600 {lab=#net1}
N 870 -220 920 -220 {lab=#net2}
N 1480 -600 1530 -600 {lab=#net3}
N 1480 -220 1530 -220 {lab=#net4}
N 1120 -600 1120 -450 {lab=CMFB}
N 1120 -390 1120 -220 {lab=Vo1_P}
N 900 -600 900 -450 {lab=#net1}
N 900 -390 900 -220 {lab=#net2}
N 1120 -600 1280 -600 {lab=CMFB}
N 1510 -600 1510 -450 {lab=#net3}
N 1510 -390 1510 -220 {lab=#net4}
N 1280 -600 1280 -450 {lab=CMFB}
N 1280 -390 1280 -220 {lab=Vo1_N}
N 850 -670 850 -630 {lab=VDD}
N 1100 -670 1100 -630 {lab=VDD}
N 1460 -670 1460 -630 {lab=VDD}
N 1710 -670 1710 -630 {lab=VDD}
N 850 -290 850 -250 {lab=VDD}
N 1100 -290 1100 -250 {lab=VDD}
N 1460 -290 1460 -250 {lab=VDD}
N 1710 -290 1710 -250 {lab=VDD}
N 850 -570 850 -530 {lab=GND}
N 1100 -570 1100 -530 {lab=GND}
N 1460 -570 1460 -530 {lab=GND}
N 1710 -570 1710 -530 {lab=GND}
N 850 -190 850 -150 {lab=GND}
N 1100 -190 1100 -150 {lab=GND}
N 1460 -190 1460 -150 {lab=GND}
N 1710 -190 1710 -150 {lab=GND}
N 1120 -220 1120 -200 {lab=Vo1_P}
N 1280 -220 1280 -200 {lab=Vo1_N}
N 1200 -630 1200 -600 {lab=CMFB}
C {blocks/02_CMFB/xschem/TG_cell.sym} 770 -600 0 0 {name=x1}
C {blocks/02_CMFB/xschem/TG_cell.sym} 1020 -600 0 0 {name=x2}
C {blocks/02_CMFB/xschem/TG_cell.sym} 770 -220 0 0 {name=x3}
C {blocks/02_CMFB/xschem/TG_cell.sym} 1020 -220 0 0 {name=x4}
C {blocks/02_CMFB/xschem/TG_cell.sym} 1380 -600 0 0 {name=x5}
C {blocks/02_CMFB/xschem/TG_cell.sym} 1630 -600 0 0 {name=x6}
C {blocks/02_CMFB/xschem/TG_cell.sym} 1380 -220 0 0 {name=x7}
C {blocks/02_CMFB/xschem/TG_cell.sym} 1630 -220 0 0 {name=x8}
C {capa.sym} 900 -420 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 1120 -420 0 0 {name=C2
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 1280 -420 0 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 1510 -420 0 0 {name=C4
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 850 -670 2 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1100 -670 2 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1460 -670 2 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1710 -670 2 0 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 850 -290 1 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1100 -290 1 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1460 -290 1 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1710 -290 1 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 850 -530 0 0 {name=p9 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1100 -530 0 0 {name=p10 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1460 -530 0 0 {name=p11 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1710 -530 0 0 {name=p12 sig_type=std_logic lab=GND}
C {lab_pin.sym} 850 -150 0 0 {name=p13 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1100 -150 0 0 {name=p14 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1460 -150 0 0 {name=p15 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1710 -150 0 0 {name=p16 sig_type=std_logic lab=GND}
C {iopin.sym} 1690 -420 0 0 {name=p17 lab=GND}
C {iopin.sym} 1690 -450 0 0 {name=p18 lab=VDD}
C {ipin.sym} 1120 -200 2 0 {name=p19 lab=Vo1_P}
C {ipin.sym} 1280 -200 0 0 {name=p20 lab=Vo1_N}
C {opin.sym} 1200 -630 0 0 {name=p21 lab=CMFB}
C {lab_pin.sym} 770 -700 0 0 {name=p22 sig_type=std_logic lab=PHI1B}
C {lab_pin.sym} 770 -320 0 0 {name=p23 sig_type=std_logic lab=PHI1B}
C {lab_pin.sym} 1630 -320 2 0 {name=p24 sig_type=std_logic lab=PHI1B}
C {lab_pin.sym} 1630 -700 2 0 {name=p25 sig_type=std_logic lab=PHI1B}
C {lab_pin.sym} 1020 -700 0 0 {name=p26 sig_type=std_logic lab=PHI2B}
C {lab_pin.sym} 1020 -320 0 0 {name=p27 sig_type=std_logic lab=PHI2B}
C {lab_pin.sym} 1380 -700 2 0 {name=p28 sig_type=std_logic lab=PHI2B}
C {lab_pin.sym} 1380 -320 2 0 {name=p29 sig_type=std_logic lab=PHI2B}
C {lab_pin.sym} 770 -500 0 0 {name=p30 sig_type=std_logic lab=PHI1
}
C {lab_pin.sym} 770 -120 0 0 {name=p31 sig_type=std_logic lab=PHI1
}
C {lab_pin.sym} 1630 -500 2 0 {name=p32 sig_type=std_logic lab=PHI1
}
C {lab_pin.sym} 1630 -120 2 0 {name=p33 sig_type=std_logic lab=PHI1
}
C {lab_pin.sym} 1020 -500 0 0 {name=p34 sig_type=std_logic lab=PHI2}
C {lab_pin.sym} 1020 -120 0 0 {name=p35 sig_type=std_logic lab=PHI2}
C {lab_pin.sym} 1380 -500 2 0 {name=p36 sig_type=std_logic lab=PHI2}
C {lab_pin.sym} 1380 -120 2 0 {name=p37 sig_type=std_logic lab=PHI2}
C {ipin.sym} 680 -480 0 0 {name=p38 lab=PHI1B}
C {ipin.sym} 680 -460 0 0 {name=p39 lab=PHI1}
C {ipin.sym} 680 -440 0 0 {name=p40 lab=PHI2B}
C {ipin.sym} 680 -420 0 0 {name=p41 lab=PHI2}
C {lab_pin.sym} 670 -600 0 0 {name=p42 sig_type=std_logic lab=Vcs}
C {lab_pin.sym} 1730 -600 2 0 {name=p43 sig_type=std_logic lab=Vcs}
C {lab_pin.sym} 670 -220 0 0 {name=p44 sig_type=std_logic lab=Vcmo}
C {lab_pin.sym} 1730 -220 2 0 {name=p45 sig_type=std_logic lab=Vcmo}
C {ipin.sym} 680 -400 0 0 {name=p46 lab=Vcmo
}
C {ipin.sym} 680 -500 0 0 {name=p47 lab=Vcs
}
