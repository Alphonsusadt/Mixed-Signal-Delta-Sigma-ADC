v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 60 -420 0 0 {name=p_A lab=A}
C {ipin.sym} 60 -380 0 0 {name=p_B lab=B}
C {opin.sym} 60 -340 0 0 {name=p_OUT lab=OUT}
C {iopin.sym} 60 -300 0 0 {name=p_VDD lab=VDD}
C {iopin.sym} 60 -260 0 0 {name=p_GND lab=GND}
C {blocks/06_Clock_gen/xschem/B6_NAND2.sym} 300 0 0 0 {name=xnand}
C {blocks/06_Clock_gen/xschem/B6_INV.sym} 500 0 0 0 {name=xinv}
C {lab_pin.sym} 210 -20 0 0 {name=l0 lab=A}
C {lab_pin.sym} 210 20 0 0 {name=l1 lab=B}
C {lab_pin.sym} 600 0 0 1 {name=l2 lab=OUT}
C {lab_pin.sym} 240 -100 0 0 {name=l3 lab=VDD}
C {lab_pin.sym} 240 100 0 0 {name=l4 lab=GND}
N 210 -20 240 -20 {}
N 210 20 240 20 {}
N 240 -100 300 -100 {}
N 240 100 300 100 {}
N 300 -100 300 -50 {}
N 300 -100 500 -100 {}
N 300 50 300 100 {}
N 300 100 500 100 {}
N 360 0 440 0 {}
N 500 -100 500 -50 {}
N 500 50 500 100 {}
N 560 0 600 0 {}
