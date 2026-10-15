v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -400 180 -300 {lab=Vin1}
N 180 -400 330 -400 {lab=Vin1}
N 240 -380 330 -380 {lab=Vin2}
N 240 -380 240 -300 {lab=Vin2}
N 780 -320 780 -280 {lab=N_BUF}
N 780 -320 920 -320 {lab=N_BUF}
N 780 -420 920 -420 {lab=P_BUF}
N 780 -520 780 -420 {lab=P_BUF}
N 680 -360 700 -360 {lab=VDD}
N 680 -600 700 -600 {lab=VDD}
N 530 -380 580 -380 {lab=OUT_N}
N 580 -380 580 -280 {lab=OUT_N}
N 580 -280 620 -280 {lab=OUT_N}
N 530 -400 580 -400 {lab=OUT_P}
N 580 -520 580 -400 {lab=OUT_P}
N 580 -520 620 -520 {lab=OUT_P}
N 50 -320 50 -300 {lab=VDD}
N 110 -420 110 -300 {lab=CLK}
N 110 -420 320 -420 {lab=CLK}
N 320 -420 330 -420 {lab=CLK}
N 530 -440 530 -420 {lab=VDD}
N 530 -360 530 -340 {lab=0}
N 50 -240 50 -230 {lab=0}
N 110 -240 110 -230 {lab=0}
N 180 -240 180 -230 {lab=0}
N 240 -240 240 -230 {lab=0}
N 680 -440 680 -430 {lab=0}
N 680 -200 680 -190 {lab=0}
N 1030 -270 1030 -250 {lab=0}
N 1070 -270 1070 -250 {lab=VDD}
N 1180 -420 1320 -420 {lab=Q}
N 1320 -420 1320 -340 {lab=Q}
N 1320 -340 1390 -340 {lab=Q}
N 1180 -320 1320 -320 {lab=QB}
N 1320 -320 1320 -300 {lab=QB}
N 1320 -300 1390 -300 {lab=QB}
N 1580 -210 1580 -190 {lab=0}
N 1500 -520 1500 -510 {lab=VDD}
N 360 -180 360 -140 {lab=VREFP}
N 450 -180 450 -140 {lab=VREFN}
N 450 -80 450 -70 {lab=0}
N 360 -80 360 -70 {lab=0}
N 1330 -450 1350 -450 {lab=VREFN}
N 1350 -450 1350 -400 {lab=VREFN}
N 1350 -400 1390 -400 {lab=VREFN}
N 1330 -470 1360 -470 {lab=VREFP}
N 1360 -470 1360 -440 {lab=VREFP}
N 1360 -440 1390 -440 {lab=VREFP}
N 1810 -230 1810 -210 {lab=0}
N 1740 -230 1740 -210 {lab=0}
N 1740 -310 1740 -290 {lab=DAC_N}
N 1690 -310 1740 -310 {lab=DAC_N}
N 1810 -410 1810 -290 {lab=DAC_P}
N 1690 -410 1810 -410 {lab=DAC_P}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 480 -390 0 0 {name=x1}
C {blocks/04_1Bit_DAC/xschem/BUF_B01.sym} 700 -520 0 0 {name=x2}
C {blocks/04_1Bit_DAC/xschem/BUF_B01.sym} 700 -280 0 0 {name=x3}
C {blocks/03_StrongARM/xschem/SR_Latch.sym} 1050 -370 0 0 {name=x4}
C {blocks/04_1Bit_DAC/xschem/DAC_1bit.sym} 1540 -360 0 0 {name=X5}
C {vsource.sym} 50 -270 0 0 {name=V1 value=1.8 savecurrent=false}
C {vsource.sym} 180 -270 0 0 {name=VVin1 value="PULSE(0.8995 0.9005 330n 1n 1n 249n 500n)" savecurrent=false}
C {vsource.sym} 240 -270 0 0 {name=VVin2 value="PULSE(0.9005 0.8995 330n 1n 1n 249n 500n)" savecurrent=false}
C {vdd.sym} 50 -320 0 0 {name=l1 lab=VDD}
C {vdd.sym} 530 -440 0 0 {name=l2 lab=VDD}
C {vdd.sym} 700 -600 0 0 {name=l3 lab=VDD}
C {vdd.sym} 700 -360 0 0 {name=l4 lab=VDD}
C {vdd.sym} 1070 -250 2 0 {name=l5 lab=VDD}
C {vdd.sym} 1500 -520 0 0 {name=l6 lab=VDD}
C {vsource.sym} 110 -270 0 0 {name=VCLK value="PULSE(0 1.8 100n 1n 1n 124n 250n)" savecurrent=false}
C {gnd.sym} 50 -230 0 0 {name=l7 lab=0}
C {gnd.sym} 110 -230 0 0 {name=l8 lab=0}
C {gnd.sym} 180 -230 0 0 {name=l9 lab=0}
C {gnd.sym} 240 -230 0 0 {name=l10 lab=0}
C {gnd.sym} 530 -340 0 0 {name=l11 lab=0}
C {gnd.sym} 680 -430 0 0 {name=l12 lab=0}
C {gnd.sym} 680 -190 0 0 {name=l13 lab=0}
C {gnd.sym} 1030 -250 0 0 {name=l14 lab=0}
C {gnd.sym} 1580 -190 0 0 {name=l15 lab=0}
C {vsource.sym} 360 -110 0 0 {name=VVREFP value=1.2 savecurrent=false}
C {vsource.sym} 450 -110 0 0 {name=VVREFN value=0.6 savecurrent=false}
C {lab_pin.sym} 360 -180 0 0 {name=p1 sig_type=std_logic lab=VREFP}
C {lab_pin.sym} 450 -180 0 0 {name=p2 sig_type=std_logic lab=VREFN}
C {gnd.sym} 360 -70 0 0 {name=l16 lab=0}
C {gnd.sym} 450 -70 0 0 {name=l17 lab=0}
C {lab_pin.sym} 1330 -470 0 0 {name=p3 sig_type=std_logic lab=VREFP}
C {lab_pin.sym} 1330 -450 0 0 {name=p4 sig_type=std_logic lab=VREFN}
C {capa.sym} 1740 -260 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 1810 -260 0 0 {name=C2
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 1740 -210 0 0 {name=l18 lab=0}
C {gnd.sym} 1810 -210 0 0 {name=l19 lab=0}
C {lab_wire.sym} 1730 -310 0 0 {name=p5 sig_type=std_logic lab=DAC_N}
C {lab_wire.sym} 1740 -410 0 0 {name=p6 sig_type=std_logic lab=DAC_P}
C {lab_wire.sym} 280 -400 0 0 {name=p7 sig_type=std_logic lab=Vin1}
C {lab_wire.sym} 280 -380 0 0 {name=p8 sig_type=std_logic lab=Vin2}
C {lab_wire.sym} 210 -420 0 0 {name=p9 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 550 -400 0 0 {name=p10 sig_type=std_logic lab=OUT_P}
C {lab_wire.sym} 550 -380 0 0 {name=p11 sig_type=std_logic lab=OUT_N}
C {lab_wire.sym} 850 -420 0 0 {name=p12 sig_type=std_logic lab=P_BUF}
C {lab_wire.sym} 850 -320 0 0 {name=p13 sig_type=std_logic lab=N_BUF}
C {lab_wire.sym} 1230 -420 0 0 {name=p14 sig_type=std_logic lab=Q}
C {lab_wire.sym} 1230 -320 0 0 {name=p15 sig_type=std_logic lab=QB}
C {code.sym} 840 -150 0 0 {name=s1 only_toplevel=true value="
.lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice tt
.option scale=1e-6
.option reltol=1e-5 vntol=1e-8 abstol=1e-13
.temp 27

.tran 0.05n 3.1u 0 0.05n

.save v(Vin1) v(Vin2) v(CLK)
.save v(OUT_P) v(OUT_N) v(P_BUF) v(N_BUF)
.save v(Q) v(QB) v(DAC_P) v(DAC_N)

* Negative differential input: Vin1 < Vin2, expected Q=0, QB=1.8
.meas tran q_neg_200 FIND v(Q) AT=200n
.meas tran qb_neg_200 FIND v(QB) AT=200n
.meas tran dacp_neg_200 FIND v(DAC_P) AT=200n
.meas tran dacn_neg_200 FIND v(DAC_N) AT=200n

* Positive differential input: Vin1 > Vin2, expected Q=1.8, QB=0
.meas tran q_pos_450 FIND v(Q) AT=450n
.meas tran qb_pos_450 FIND v(QB) AT=450n
.meas tran dacp_pos_450 FIND v(DAC_P) AT=450n
.meas tran dacn_pos_450 FIND v(DAC_N) AT=450n

* Hold during comparator reset; these are spot checks, not full timing verification
.meas tran q_hold_neg_300 FIND v(Q) AT=300n
.meas tran q_hold_pos_550 FIND v(Q) AT=550n
"}
