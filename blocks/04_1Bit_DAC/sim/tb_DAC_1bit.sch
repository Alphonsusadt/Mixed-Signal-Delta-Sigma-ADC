v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {BLOCK 4: DIFFERENTIAL 1-BIT DAC - FUNCTIONAL TESTBENCH} 40 -700 0 0 0.44 0.44 {}
T {VDD=1.8 V; VREFP=1.2 V; VREFN=0.6 V; control clock 4 MHz} 40 -665 0 0 0.26 0.26 {}
T {Load = 200 fF on DAC_P, DAC_N; independent ideal Q/QB sources} 40 -640 0 0 0.26 0.26 {}
N 690 -500 740 -500 {lab=VREFP}
N 690 -460 740 -460 {lab=VREFN}
N 690 -400 740 -400 {lab=Q}
N 690 -360 740 -360 {lab=QB}
N 850 -610 850 -570 {lab=VDD}
N 930 -270 930 -240 {lab=0}
N 1040 -470 1160 -470 {lab=DAC_P}
N 1160 -280 1160 -260 {lab=0}
N 1040 -370 1310 -370 {lab=DAC_N}
N 1310 -370 1310 -350 {lab=DAC_N}
N 1310 -290 1310 -270 {lab=0}
N 120 -160 120 -130 {lab=VDD}
N 120 -70 120 -50 {lab=0}
N 280 -160 280 -130 {lab=VREFP}
N 280 -70 280 -50 {lab=0}
N 440 -160 440 -130 {lab=VREFN}
N 440 -70 440 -50 {lab=0}
N 600 -160 600 -130 {lab=Q}
N 600 -70 600 -50 {lab=0}
N 760 -160 760 -130 {lab=QB}
N 760 -70 760 -50 {lab=0}
N 1160 -470 1160 -340 {lab=DAC_P}
C {devices/lab_wire.sym} 690 -500 0 0 {name=l_tb_VREFP lab=VREFP}
C {devices/lab_wire.sym} 690 -460 0 0 {name=l_tb_VREFN lab=VREFN}
C {devices/lab_wire.sym} 690 -400 0 0 {name=l_tb_Q lab=Q}
C {devices/lab_wire.sym} 690 -360 0 0 {name=l_tb_QB lab=QB}
C {devices/lab_wire.sym} 850 -610 0 0 {name=l_tb_VDD lab=VDD}
C {devices/gnd.sym} 930 -240 0 0 {name=l_tb_gnd lab=0}
C {devices/capa.sym} 1160 -310 0 0 {name=CLOAD_P value=200f}
C {devices/gnd.sym} 1160 -260 0 0 {name=l_gp lab=0}
C {devices/capa.sym} 1310 -320 0 0 {name=CLOAD_N value=200f}
C {devices/gnd.sym} 1310 -270 0 0 {name=l_gn lab=0}
C {devices/lab_wire.sym} 1160 -470 0 0 {name=l_outp lab=DAC_P}
C {devices/lab_wire.sym} 1310 -370 0 0 {name=l_outn lab=DAC_N}
C {devices/vsource.sym} 120 -100 0 0 {name=VVDD value=1.8}
C {devices/lab_wire.sym} 120 -160 0 0 {name=l_src_VDD lab=VDD}
C {devices/gnd.sym} 120 -50 0 0 {name=g_src_VDD lab=0}
C {devices/vsource.sym} 280 -100 0 0 {name=VREFP_SRC value=1.2}
C {devices/lab_wire.sym} 280 -160 0 0 {name=l_src_VREFP lab=VREFP}
C {devices/gnd.sym} 280 -50 0 0 {name=g_src_VREFP lab=0}
C {devices/vsource.sym} 440 -100 0 0 {name=VREFN_SRC value=0.6}
C {devices/lab_wire.sym} 440 -160 0 0 {name=l_src_VREFN lab=VREFN}
C {devices/gnd.sym} 440 -50 0 0 {name=g_src_VREFN lab=0}
C {devices/vsource.sym} 600 -100 0 0 {name=VQ_SRC value="PULSE(0 1.8 100n 2n 2n 100n 250n)"}
C {devices/lab_wire.sym} 600 -160 0 0 {name=l_src_Q lab=Q}
C {devices/gnd.sym} 600 -50 0 0 {name=g_src_Q lab=0}
C {devices/vsource.sym} 760 -100 0 0 {name=VQB_SRC value="PULSE(1.8 0 100n 2n 2n 100n 250n)"}
C {devices/lab_wire.sym} 760 -160 0 0 {name=l_src_QB lab=QB}
C {devices/gnd.sym} 760 -50 0 0 {name=g_src_QB lab=0}
C {devices/code_shown.sym} 40 -570 0 0 {name=SPICE only_toplevel=true value=".lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice tt
.option scale=1e-6
.temp 27
.tran 0.2n 1u 0 0.2n
* Q=0 before 100ns; Q=1 100-200ns; Q=0 200-350ns; Q=1 350-450ns
.meas tran dacp_q0_50 FIND v(DAC_P) AT=50n
.meas tran dacn_q0_50 FIND v(DAC_N) AT=50n
.meas tran dacp_q1_150 FIND v(DAC_P) AT=150n
.meas tran dacn_q1_150 FIND v(DAC_N) AT=150n
.meas tran dacp_q0_275 FIND v(DAC_P) AT=275n
.meas tran dacn_q0_275 FIND v(DAC_N) AT=275n
.meas tran dacp_q1_400 FIND v(DAC_P) AT=400n
.meas tran dacn_q1_400 FIND v(DAC_N) AT=400n
.meas tran dacp_q0_525 FIND v(DAC_P) AT=525n
.meas tran dacn_q0_525 FIND v(DAC_N) AT=525n
.meas tran dacp_max MAX v(DAC_P) FROM=0n TO=1u
.meas tran dacp_min MIN v(DAC_P) FROM=0n TO=1u
.meas tran dacn_max MAX v(DAC_N) FROM=0n TO=1u
.meas tran dacn_min MIN v(DAC_N) FROM=0n TO=1u
.save v(Q) v(QB) v(VREFP) v(VREFN) v(DAC_P) v(DAC_N) i(VVDD) i(VREFP_SRC) i(VREFN_SRC)"}
C {blocks/04_1Bit_DAC/xschem/DAC_1bit.sym} 890 -420 0 0 {name=X1}
