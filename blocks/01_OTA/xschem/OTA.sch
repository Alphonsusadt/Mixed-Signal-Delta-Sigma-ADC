v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 350 -270 350 -140 {lab=#net1}
N 480 -270 480 -140 {lab=#net2}
N 390 -110 440 -110 {lab=Vbias}
N 560 -220 560 -110 {lab=#net1}
N 380 -220 560 -220 {lab=#net1}
N 380 -240 380 -220 {lab=#net1}
N 350 -240 380 -240 {lab=#net1}
N 290 -200 290 -110 {lab=#net2}
N 290 -200 450 -200 {lab=#net2}
N 450 -240 450 -200 {lab=#net2}
N 450 -240 480 -240 {lab=#net2}
N 60 -470 210 -470 {lab=#net3}
N 640 -470 780 -470 {lab=#net4}
N 20 -540 20 -500 {lab=VCC}
N 20 -540 820 -540 {lab=VCC}
N 820 -540 820 -500 {lab=VCC}
N 600 -540 600 -500 {lab=VCC}
N 250 -540 250 -500 {lab=VCC}
N 350 -350 350 -330 {lab=#net5}
N 350 -350 470 -350 {lab=#net5}
N 470 -350 480 -350 {lab=#net5}
N 480 -350 480 -330 {lab=#net5}
N 190 -260 190 -110 {lab=#net1}
N 60 -110 190 -110 {lab=#net1}
N 190 -240 350 -240 {lab=#net1}
N 250 -440 250 -140 {lab=#net6}
N 20 -440 20 -140 {lab=Vout(+)}
N 20 -260 50 -260 {lab=Vout(+)}
N 650 -260 650 -110 {lab=#net2}
N 650 -110 780 -110 {lab=#net2}
N 710 -260 730 -260 {lab=#net7}
N 820 -440 820 -140 {lab=Vout(-)}
N 790 -260 820 -260 {lab=Vout(-)}
N 480 -240 650 -240 {lab=#net2}
N 20 -80 20 -50 {lab=GND}
N 20 -50 820 -50 {lab=GND}
N 820 -80 820 -50 {lab=GND}
N 250 -80 250 -50 {lab=GND}
N 350 -80 350 -50 {lab=GND}
N 480 -80 480 -50 {lab=GND}
N 600 -80 600 -50 {lab=GND}
N 110 -260 130 -260 {lab=#net8}
N 600 -440 600 -140 {lab=#net9}
N 20 -500 20 -470 {lab=VCC}
N 250 -500 250 -470 {lab=VCC}
N 600 -500 600 -470 {lab=VCC}
N 820 -500 820 -470 {lab=VCC}
N 250 -140 250 -110 {lab=#net6}
N 350 -110 350 -80 {lab=GND}
N 480 -110 480 -80 {lab=GND}
N 600 -140 600 -110 {lab=#net9}
N 820 -140 820 -110 {lab=Vout(-)}
N 20 -110 20 -80 {lab=GND}
N 410 -370 410 -350 {lab=#net5}
N 410 -540 410 -430 {lab=VCC}
N 410 -430 410 -400 {lab=VCC}
N 460 -300 480 -300 {lab=VCC}
N 460 -540 460 -300 {lab=VCC}
N 350 -300 360 -300 {lab=VCC}
N 360 -540 360 -300 {lab=VCC}
N 410 -570 410 -540 {lab=VCC}
N 420 -50 420 -40 {lab=GND}
N 420 -40 420 -30 {lab=GND}
N 160 -260 160 -50 {lab=GND}
N 680 -260 680 -50 {lab=GND}
N -0 -260 20 -260 {lab=Vout(+)}
N 820 -260 840 -260 {lab=Vout(-)}
N 370 -460 370 -400 {lab=Vcmfb1}
N 420 -150 420 -110 {lab=Vbias}
N 150 -320 160 -320 {lab=Vbz}
N 160 -320 160 -300 {lab=Vbz}
N 680 -320 680 -300 {lab=Vbz}
N 680 -320 690 -320 {lab=Vbz}
C {pmos4.sym} 330 -300 0 0 {name=M1 model=pmos w=120u l=1u del=0 m=1}
C {pmos4.sym} 500 -300 0 1 {name=M2 model=pmos w=120u l=1u del=0 m=1}
C {nmos4.sym} 370 -110 0 1 {name=M3 model=nmos w=8u l=2u del=0 m=1}
C {nmos4.sym} 460 -110 0 0 {name=M4 model=nmos w=8u l=2u del=0 m=1}
C {pmos4.sym} 270 -110 0 1 {name=M5 model=pmos w=60u l=1u del=0 m=1}
C {pmos4.sym} 580 -110 0 0 {name=M6 model=pmos w=30u l=1u del=0 m=1}
C {pmos4.sym} 230 -470 0 0 {name=M7 model=pmos w=300u l=1u del=0 m=1}
C {pmos4.sym} 620 -470 0 1 {name=M8 model=pmos w=200u l=1u del=0 m=1}
C {pmos4.sym} 40 -470 0 1 {name=M9 model=pmos w=200u l=1u del=0 m=1}
C {pmos4.sym} 800 -470 0 0 {name=M10 model=pmos w=30u l=2u del=0 m=1}
C {nmos4.sym} 40 -110 0 1 {name=M11 model=nmos w=30u l=2u del=0 m=1}
C {nmos4.sym} 800 -110 0 0 {name=M12 model=nmos w=20u l=2u del=0 m=1}
C {pmos4.sym} 390 -400 0 0 {name=M13 model=pmos w=20u l=2u del=0 m=1}
C {nmos4.sym} 160 -280 1 0 {name=Mz1 model=nmos w=5u l=5u del=0 m=1}
C {nmos4.sym} 680 -280 1 0 {name=Mz2 model=nmos w=5u l=5u del=0 m=1}
C {capa.sym} 760 -260 3 0 {name=C1
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 80 -260 3 0 {name=C2
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {iopin.sym} 410 -570 0 0 {name=p1 lab=VCC
}
C {iopin.sym} 420 -30 0 0 {name=p2 lab=GND
}
C {opin.sym} 0 -260 2 0 {name=p3 lab=Vout(+)}
C {opin.sym} 840 -260 0 0 {name=p4 lab=Vout(-)}
C {ipin.sym} 310 -300 0 0 {name=p5 lab=Vin(+)
}
C {ipin.sym} 520 -300 2 0 {name=p6 lab=Vin(-)}
C {ipin.sym} 370 -460 0 0 {name=p7 lab=Vcmfb1}
C {ipin.sym} 420 -150 0 0 {name=p8 lab=Vbias}
C {ipin.sym} 150 -320 0 0 {name=p9 lab=Vbz}
C {ipin.sym} 690 -320 2 0 {name=p10 lab=Vbz}
