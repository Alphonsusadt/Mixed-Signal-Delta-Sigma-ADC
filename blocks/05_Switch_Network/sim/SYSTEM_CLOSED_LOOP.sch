v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {SYSTEM CLOSED LOOP - ARCHITECTURE WORKSHEET (TBD ITEMS ARE NOT DESIGN VALUES)} 120 -820 0 0 0.42 0.42 {}
T {Conceptual top-level: wire topology/polarity is a review scaffold. Integrator cell pinout and summing implementation are not yet verified.} 120 -780 0 0 0.24 0.24 {}
T {VIN differential} 130 -320 0 0 0.28 0.28 {}
T {STAGE1 / INTEGRATOR 1} 390 -330 0 0 0.32 0.32 {}
T {STAGE2 / INTEGRATOR 2} 690 -330 0 0 0.32 0.32 {}
T {COMPARATOR} 1010 -370 0 0 0.30 0.30 {}
T {SR LATCH} 1230 -370 0 0 0.30 0.30 {}
T {1-bit DAC} 1450 -370 0 0 0.30 0.30 {}
T {Block 5 switch / receiver TBD} 1690 -350 0 0 0.26 0.26 {}
T {CMP_IN_P/N source stage: TBD} 970 -430 0 0 0.22 0.22 {}
T {DAC reference/polarity: TBD} 1420 -430 0 0 0.22 0.22 {}
T {Summing element, C ratios and sign: TBD} 360 70 0 0 0.24 0.24 {}
T {DO NOT connect DAC to VIN_P/N until the integrator summing node and polarity are verified.} 360 110 0 0 0.22 0.22 {}
T {Feedback return to stage 1 summing network (conceptual only)} 1240 50 0 0 0.22 0.22 {}
T {Clock source: TBD   |   non-overlap phases: TBD   |   comparator decision phase: TBD} 120 300 0 0 0.23 0.23 {}
T {Reset/precharge polarity and release order: TBD   |   VDD/GND/VCM/bias/CMFB/DAC refs: TBD} 120 340 0 0 0.23 0.23 {}
T {fs: TBD (4 MHz exploratory only) | OSR: TBD (80 target mentioned) | topology/order: TBD | gain ratios: TBD} 120 400 0 0 0.22 0.22 {}
T {Differential input limit: TBD | supply/PVT: TBD | VCM: TBD | decision timing: TBD} 120 440 0 0 0.22 0.22 {}
T {Sources: stage1_core.spice/STAGE1 and stage2_core.spice/STAGE2 exploratory candidates; tb_4E_integration.spice comparator/latch/DAC; Block5_SH.sch.} 120 520 0 0 0.20 0.20 {}
T {Not a simulation-ready netlist: resolve cell interfaces, actual summing network, receiver load, supplies/biases and timing before export.} 120 560 0 0 0.20 0.20 {}
N 240 -300 360 -300 {lab=VIN_P}
N 240 -260 360 -260 {lab=VIN_N}
N 570 -300 660 -300 {lab=I1_OUT_P}
N 570 -260 660 -260 {lab=I1_OUT_N}
N 870 -300 960 -300 {lab=I2_OUT_P}
N 870 -260 960 -260 {lab=I2_OUT_N}
N 1120 -300 1190 -300 {lab=DECISION}
N 1340 -300 1410 -300 {lab=Q}
N 1560 -300 1650 -300 {lab=DAC_P}
N 1560 -260 1650 -260 {lab=DAC_N}
N 1770 -300 1770 -160 {lab=DAC_P}
N 1770 -260 1810 -260 {lab=DAC_N}
N 1810 -260 1810 -160 {lab=DAC_N}
N 1810 -160 480 -160 {lab=DAC_N}
N 480 -160 480 -60 {lab=DAC_N}
N 1770 -160 520 -160 {lab=DAC_P}
N 520 -160 520 -60 {lab=DAC_P}
C {devices/ipin.sym} 150 -300 0 0 {name=pVINP lab=VIN_P}
C {devices/ipin.sym} 150 -260 0 0 {name=pVINN lab=VIN_N}
C {devices/lab_pin.sym} 360 -300 0 1 {name=lVINP lab=VIN_P}
C {devices/lab_pin.sym} 360 -260 0 1 {name=lVINN lab=VIN_N}
C {devices/lab_pin.sym} 570 -300 0 0 {name=lI1OP lab=I1_OUT_P}
C {devices/lab_pin.sym} 570 -260 0 0 {name=lI1ON lab=I1_OUT_N}
C {devices/lab_pin.sym} 660 -300 0 1 {name=lI1OP2 lab=I1_OUT_P}
C {devices/lab_pin.sym} 660 -260 0 1 {name=lI1ON2 lab=I1_OUT_N}
C {devices/lab_pin.sym} 870 -300 0 0 {name=lI2OP lab=I2_OUT_P}
C {devices/lab_pin.sym} 870 -260 0 0 {name=lI2ON lab=I2_OUT_N}
C {devices/lab_pin.sym} 960 -300 0 1 {name=lI2OP2 lab=I2_OUT_P}
C {devices/lab_pin.sym} 960 -260 0 1 {name=lI2ON2 lab=I2_OUT_N}
C {devices/lab_pin.sym} 1120 -300 0 0 {name=lDEC lab=DECISION}
C {devices/lab_pin.sym} 1190 -300 0 1 {name=lDEC2 lab=DECISION}
C {devices/lab_pin.sym} 1340 -300 0 0 {name=lQ lab=Q}
C {devices/lab_pin.sym} 1410 -300 0 1 {name=lQ2 lab=Q}
C {devices/lab_pin.sym} 1560 -300 0 0 {name=lDACP lab=DAC_P}
C {devices/lab_pin.sym} 1560 -260 0 0 {name=lDACN lab=DAC_N}
C {devices/lab_pin.sym} 1650 -300 0 1 {name=lDACP2 lab=DAC_P}
C {devices/lab_pin.sym} 1650 -260 0 1 {name=lDACN2 lab=DAC_N}
C {devices/lab_pin.sym} 480 -60 0 1 {name=lDACP3 lab=DAC_P}
C {devices/lab_pin.sym} 520 -60 0 1 {name=lDACN3 lab=DAC_N}
C {devices/lab_pin.sym} 480 0 0 1 {name=lSUMN lab=SUM_N_TBD}
C {devices/lab_pin.sym} 520 0 0 1 {name=lSUMP lab=SUM_P_TBD}
