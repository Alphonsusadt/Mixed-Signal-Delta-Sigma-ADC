v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 680 -250 680 -230 {lab=0}
N 680 -310 700 -310 {lab=VCC}
N 30 -180 30 -170 {lab=VCC}
N 30 -110 30 -100 {lab=0}
N 90 -110 90 -100 {lab=0}
N 180 -110 180 -100 {lab=0}
N 230 -110 230 -100 {lab=0}
N 280 -110 280 -100 {lab=0}
N 370 -230 380 -230 {lab=Vin(+)}
N 370 -210 380 -210 {lab=Vbias}
N 90 -190 90 -170 {lab=Vin(+)}
N 180 -190 180 -170 {lab=Vin(-)}
N 230 -190 230 -170 {lab=Vbias}
N 370 -250 380 -250 {lab=Vin(-)}
N 280 -190 280 -170 {lab=Vcm}
N 370 -270 380 -270 {lab=Vcm}
N 370 -290 380 -290 {lab=Vcm}
N 370 -310 380 -310 {lab=Vcm}
N 740 -190 740 -180 {lab=0}
N 800 -190 800 -180 {lab=0}
N 740 -270 740 -250 {lab=#net1}
N 680 -270 740 -270 {lab=#net1}
N 680 -290 800 -290 {lab=#net2}
N 800 -290 800 -250 {lab=#net2}
C {blocks/01_OTA/xschem/OTA.sym} 530 -260 0 0 {name=x1}
C {gnd.sym} 680 -230 0 0 {name=l1 lab=0}
C {vdd.sym} 700 -310 0 0 {name=l2 lab=VCC}
C {vsource.sym} 30 -140 0 0 {name=V1 value=1.8V savecurrent=false}
C {vdd.sym} 30 -180 0 0 {name=l3 lab=VCC}
C {vsource.sym} 90 -140 0 0 {name=V2 value="0.4V AC 1" savecurrent=false}
C {vsource.sym} 180 -140 0 0 {name=V3 value=0.4 savecurrent=false}
C {vsource.sym} 230 -140 0 0 {name=V4 value=1 savecurrent=false}
C {lab_pin.sym} 370 -230 0 0 {name=p1 sig_type=std_logic lab=Vin(+)}
C {vsource.sym} 280 -140 0 0 {name=V5 value=0.9 savecurrent=false}
C {gnd.sym} 30 -100 0 0 {name=l4 lab=0}
C {gnd.sym} 90 -100 0 0 {name=l5 lab=0}
C {gnd.sym} 180 -100 0 0 {name=l6 lab=0}
C {gnd.sym} 230 -100 0 0 {name=l7 lab=0}
C {gnd.sym} 280 -100 0 0 {name=l8 lab=0}
C {lab_pin.sym} 370 -250 0 0 {name=p2 sig_type=std_logic lab=Vin(-)}
C {lab_pin.sym} 370 -210 0 0 {name=p3 sig_type=std_logic lab=Vbias
}
C {lab_pin.sym} 180 -190 1 0 {name=p4 sig_type=std_logic lab=Vin(-)}
C {lab_pin.sym} 90 -190 1 0 {name=p5 sig_type=std_logic lab=Vin(+)}
C {lab_pin.sym} 230 -190 1 0 {name=p6 sig_type=std_logic lab=Vbias
}
C {lab_pin.sym} 370 -270 0 0 {name=p7 sig_type=std_logic lab=Vcm}
C {lab_pin.sym} 370 -290 0 0 {name=p8 sig_type=std_logic lab=Vcm}
C {lab_pin.sym} 370 -310 0 0 {name=p9 sig_type=std_logic lab=Vcm}
C {lab_pin.sym} 280 -190 1 0 {name=p10 sig_type=std_logic lab=Vcm}
C {capa.sym} 740 -220 0 0 {name=C1
m=1
value=20p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 800 -220 0 0 {name=C2
m=1
value=20p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 800 -180 0 0 {name=l9 lab=0}
C {gnd.sym} 740 -180 0 0 {name=l10 lab=0}
C {code_shown.sym} 40 -350 0 0 {name=s1 only_toplevel=false 
value="
.ac dec 10 10 100Meg
.meas ac dc_gain find vdb(Vout_pos) at=10
.meas ac ugf when vdb(Vout_pos)=0
" }
