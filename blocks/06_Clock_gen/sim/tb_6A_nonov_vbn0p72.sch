v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Blok 6: generator non-overlap NONOV, standalone nominal} 40 -700 0 0 0.4 0.4 {}
C {vsource.sym} 120 -100 0 0 {name=VVDD value="1.8"}
C {lab_pin.sym} 120 -130 0 1 {name=l0 lab=VDD}
C {lab_pin.sym} 120 -70 0 1 {name=l1 lab=0}
C {vsource.sym} 280 -100 0 0 {name=VCLK value="PULSE(0 1.8 20n 1n 1n 124n 250n)"}
C {lab_pin.sym} 280 -130 0 1 {name=l2 lab=CLK}
C {lab_pin.sym} 280 -70 0 1 {name=l3 lab=0}
C {vsource.sym} 440 -100 0 0 {name=VBNSRC value="0.72"}
C {lab_pin.sym} 440 -130 0 1 {name=l4 lab=VBN}
C {lab_pin.sym} 440 -70 0 1 {name=l5 lab=0}
C {vsource.sym} 600 -100 0 0 {name=VBPSRC value="0.686"}
C {lab_pin.sym} 600 -130 0 1 {name=l6 lab=VBP}
C {lab_pin.sym} 600 -70 0 1 {name=l7 lab=0}
C {capa.sym} 760 -100 0 0 {name=C1 value=200f}
C {lab_pin.sym} 760 -130 0 1 {name=l8 lab=PHI1}
C {lab_pin.sym} 760 -70 0 1 {name=l9 lab=0}
C {capa.sym} 920 -100 0 0 {name=C1B value=200f}
C {lab_pin.sym} 920 -130 0 1 {name=l10 lab=PHI1B}
C {lab_pin.sym} 920 -70 0 1 {name=l11 lab=0}
C {capa.sym} 1080 -100 0 0 {name=C2 value=200f}
C {lab_pin.sym} 1080 -130 0 1 {name=l12 lab=PHI2}
C {lab_pin.sym} 1080 -70 0 1 {name=l13 lab=0}
C {capa.sym} 1240 -100 0 0 {name=C2B value=200f}
C {lab_pin.sym} 1240 -130 0 1 {name=l14 lab=PHI2B}
C {lab_pin.sym} 1240 -70 0 1 {name=l15 lab=0}
C {blocks/06_Clock_gen/xschem/B6_NONOV.sym} 1500 -300 0 0 {name=X1}
C {lab_pin.sym} 1420 -300 0 0 {name=l16 lab=CLK}
C {lab_pin.sym} 1580 -360 0 1 {name=l17 lab=PHI1}
C {lab_pin.sym} 1580 -320 0 1 {name=l18 lab=PHI1B}
C {lab_pin.sym} 1580 -280 0 1 {name=l19 lab=PHI2}
C {lab_pin.sym} 1580 -240 0 1 {name=l20 lab=PHI2B}
C {lab_pin.sym} 1460 -420 0 0 {name=l21 lab=VDD}
C {lab_pin.sym} 1540 -420 0 1 {name=l22 lab=VBP}
C {lab_pin.sym} 1460 -180 0 0 {name=l23 lab=0}
C {lab_pin.sym} 1540 -180 0 1 {name=l24 lab=VBN}
C {sky130_fd_pr/corner.sym} 100 -600 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 40 -500 0 0 {name=SIM only_toplevel=true value="* tb_6A_nonov_vbn0p72: Blok 6 NONOV standalone, TT 1.8 V 27 C. Ukuran sel = nilai awal (TBD). Beban 200 fF/keluaran = PLACEHOLDER.
.option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 0.1n 2u 0 0.1n
wrdata tb_6A_nonov_vbn0p72.dat v(CLK) v(PHI1) v(PHI1B) v(PHI2) v(PHI2B)
echo ===== TB6_MEAS =====
meas tran DT_1F2R TRIG v(PHI1) VAL=0.9 FALL=2 TARG v(PHI2) VAL=0.9 RISE=2
meas tran DT_2F1R TRIG v(PHI2) VAL=0.9 FALL=2 TARG v(PHI1) VAL=0.9 RISE=2
meas tran W_PHI1 TRIG v(PHI1) VAL=0.9 RISE=2 TARG v(PHI1) VAL=0.9 FALL=3
meas tran W_PHI2 TRIG v(PHI2) VAL=0.9 RISE=2 TARG v(PHI2) VAL=0.9 FALL=2
meas tran SKEW_P1R TRIG v(PHI1) VAL=0.9 RISE=2 TARG v(PHI1B) VAL=0.9 FALL=2
meas tran SKEW_P1F TRIG v(PHI1) VAL=0.9 FALL=2 TARG v(PHI1B) VAL=0.9 RISE=2
meas tran SKEW_P2R TRIG v(PHI2) VAL=0.9 RISE=2 TARG v(PHI2B) VAL=0.9 FALL=2
meas tran SKEW_P2F TRIG v(PHI2) VAL=0.9 FALL=2 TARG v(PHI2B) VAL=0.9 RISE=2
meas tran TR_PHI1 TRIG v(PHI1) VAL=0.18 RISE=2 TARG v(PHI1) VAL=1.62 RISE=2
meas tran TF_PHI1 TRIG v(PHI1) VAL=1.62 FALL=2 TARG v(PHI1) VAL=0.18 FALL=2
meas tran TR_PHI2 TRIG v(PHI2) VAL=0.18 RISE=2 TARG v(PHI2) VAL=1.62 RISE=2
meas tran TF_PHI2 TRIG v(PHI2) VAL=1.62 FALL=2 TARG v(PHI2) VAL=0.18 FALL=2
meas tran TR_PHI1B TRIG v(PHI1B) VAL=0.18 RISE=2 TARG v(PHI1B) VAL=1.62 RISE=2
meas tran TF_PHI1B TRIG v(PHI1B) VAL=1.62 FALL=2 TARG v(PHI1B) VAL=0.18 FALL=2
meas tran TR_PHI2B TRIG v(PHI2B) VAL=0.18 RISE=2 TARG v(PHI2B) VAL=1.62 RISE=2
meas tran TF_PHI2B TRIG v(PHI2B) VAL=1.62 FALL=2 TARG v(PHI2B) VAL=0.18 FALL=2
let ovl = v(PHI1)*v(PHI2)
meas tran OVL_PROD MAX ovl FROM=500n TO=1.5u
meas tran PHI1_MAX MAX v(PHI1) FROM=500n TO=1.5u
meas tran PHI1_MIN MIN v(PHI1) FROM=500n TO=1.5u
meas tran PHI2_MAX MAX v(PHI2) FROM=500n TO=1.5u
meas tran PHI2_MIN MIN v(PHI2) FROM=500n TO=1.5u
meas tran IVDD_AVG AVG i(VVDD) FROM=500n TO=1.5u
echo TB6_DONE
.endc
"}
