v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Blok 6: sel tunda current-starved, td vs bias} 40 -700 0 0 0.4 0.4 {}
C {vsource.sym} 120 -100 0 0 {name=VVDD value="1.8"}
C {lab_pin.sym} 120 -130 0 1 {name=l0 lab=VDD}
C {lab_pin.sym} 120 -70 0 1 {name=l1 lab=0}
C {vsource.sym} 280 -100 0 0 {name=VIN value="PULSE(0 1.8 50n 1n 1n 600n 1.5u)"}
C {lab_pin.sym} 280 -130 0 1 {name=l2 lab=IN}
C {lab_pin.sym} 280 -70 0 1 {name=l3 lab=0}
C {vsource.sym} 440 -100 0 0 {name=VBNSRC value="0.55"}
C {lab_pin.sym} 440 -130 0 1 {name=l4 lab=VBN}
C {lab_pin.sym} 440 -70 0 1 {name=l5 lab=0}
C {vsource.sym} 600 -100 0 0 {name=VBPSRC value="0.9"}
C {lab_pin.sym} 600 -130 0 1 {name=l6 lab=VBP}
C {lab_pin.sym} 600 -70 0 1 {name=l7 lab=0}
C {capa.sym} 760 -100 0 0 {name=CL value=10f}
C {lab_pin.sym} 760 -130 0 1 {name=l8 lab=OUT}
C {lab_pin.sym} 760 -70 0 1 {name=l9 lab=0}
C {blocks/06_Clock_gen/xschem/B6_DELAY_CS.sym} 1500 -300 0 0 {name=X1}
C {lab_pin.sym} 1440 -300 0 0 {name=l10 lab=IN}
C {lab_pin.sym} 1560 -300 0 1 {name=l11 lab=OUT}
C {lab_pin.sym} 1480 -350 0 0 {name=l12 lab=VBP}
C {lab_pin.sym} 1520 -350 0 1 {name=l13 lab=VDD}
C {lab_pin.sym} 1480 -250 0 0 {name=l14 lab=VBN}
C {lab_pin.sym} 1520 -250 0 1 {name=l15 lab=0}
C {sky130_fd_pr/corner.sym} 100 -600 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 40 -500 0 0 {name=SIM only_toplevel=true value="* tb_6B_dly_vbn0p55: sel tunda current-starved standalone, beban 10 fF = PLACEHOLDER. Variabel = bias VBN; VBP dari tabel VBP_MATCH (arus pull-up ~ pull-down, perkiraan).
.option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 0.1n 1.5u 0 0.1n
wrdata tb_6B_dly_vbn0p55.dat v(IN) v(OUT)
echo ===== TB6_MEAS =====
meas tran TD_R TRIG v(IN) VAL=0.9 RISE=1 TARG v(OUT) VAL=0.9 FALL=1
meas tran TD_F TRIG v(IN) VAL=0.9 FALL=1 TARG v(OUT) VAL=0.9 RISE=1
meas tran IVDD_AVG AVG i(VVDD) FROM=100n TO=600n
echo TB6_DONE
.endc
"}
