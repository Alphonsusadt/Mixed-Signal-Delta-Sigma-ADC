v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Blok 6: logic XOR + AND2} 40 -700 0 0 0.4 0.4 {}
C {vsource.sym} 120 -100 0 0 {name=VVDD value="1.8"}
C {lab_pin.sym} 120 -130 0 1 {name=l0 lab=VDD}
C {lab_pin.sym} 120 -70 0 1 {name=l1 lab=0}
C {vsource.sym} 280 -100 0 0 {name=VA value="PULSE(0 1.8 100n 1n 1n 99n 200n)"}
C {lab_pin.sym} 280 -130 0 1 {name=l2 lab=A}
C {lab_pin.sym} 280 -70 0 1 {name=l3 lab=0}
C {vsource.sym} 440 -100 0 0 {name=VB value="PULSE(0 1.8 200n 1n 1n 199n 400n)"}
C {lab_pin.sym} 440 -130 0 1 {name=l4 lab=B}
C {lab_pin.sym} 440 -70 0 1 {name=l5 lab=0}
C {capa.sym} 600 -100 0 0 {name=CX value=20f}
C {lab_pin.sym} 600 -130 0 1 {name=l6 lab=XOUT}
C {lab_pin.sym} 600 -70 0 1 {name=l7 lab=0}
C {capa.sym} 760 -100 0 0 {name=CA value=20f}
C {lab_pin.sym} 760 -130 0 1 {name=l8 lab=AOUT}
C {lab_pin.sym} 760 -70 0 1 {name=l9 lab=0}
C {blocks/06_Clock_gen/xschem/B6_XOR.sym} 1500 -300 0 0 {name=X1}
C {lab_pin.sym} 1440 -320 0 0 {name=l10 lab=A}
C {lab_pin.sym} 1440 -280 0 0 {name=l11 lab=B}
C {lab_pin.sym} 1560 -300 0 1 {name=l12 lab=XOUT}
C {lab_pin.sym} 1500 -350 0 1 {name=l13 lab=VDD}
C {lab_pin.sym} 1500 -250 0 1 {name=l14 lab=0}
C {sky130_fd_pr/corner.sym} 100 -600 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 40 -500 0 0 {name=SIM only_toplevel=true value="* tb_6C_logic: tabel kebenaran XOR dan AND2 (sel Blok 6) di ngspice. Beban 20 fF.
.option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 0.1n 450n 0 0.1n
wrdata tb_6C_logic.dat v(A) v(B) v(XOUT) v(AOUT)
echo ===== TB6_MEAS =====
meas tran XOR_00 FIND v(XOUT) AT=80n
meas tran AND_00 FIND v(AOUT) AT=80n
meas tran XOR_10 FIND v(XOUT) AT=180n
meas tran AND_10 FIND v(AOUT) AT=180n
meas tran XOR_01 FIND v(XOUT) AT=280n
meas tran AND_01 FIND v(AOUT) AT=280n
meas tran XOR_11 FIND v(XOUT) AT=380n
meas tran AND_11 FIND v(AOUT) AT=380n
echo TB6_DONE
.endc
"}
C {blocks/06_Clock_gen/xschem/B6_AND2.sym} 1500 100 0 0 {name=X2}
C {lab_pin.sym} 1440 80 0 0 {name=l900 lab=A}
C {lab_pin.sym} 1440 120 0 0 {name=l901 lab=B}
C {lab_pin.sym} 1560 100 0 1 {name=l902 lab=AOUT}
C {lab_pin.sym} 1500 50 0 1 {name=l903 lab=VDD}
C {lab_pin.sym} 1500 150 0 1 {name=l904 lab=0}
