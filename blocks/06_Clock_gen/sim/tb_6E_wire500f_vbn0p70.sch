v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Blok 6: NONOV + beban gerbang nyata + kabel 500f/net} 40 -700 0 0 0.4 0.4 {}
C {vsource.sym} 120 -100 0 0 {name=VVDD value="1.8"}
C {lab_pin.sym} 120 -130 0 1 {name=l0 lab=VDD}
C {lab_pin.sym} 120 -70 0 1 {name=l1 lab=0}
C {vsource.sym} 280 -100 0 0 {name=VCLK value="PULSE(0 1.8 20n 1n 1n 124n 250n)"}
C {lab_pin.sym} 280 -130 0 1 {name=l2 lab=CLK}
C {lab_pin.sym} 280 -70 0 1 {name=l3 lab=0}
C {vsource.sym} 440 -100 0 0 {name=VBNSRC value="0.7"}
C {lab_pin.sym} 440 -130 0 1 {name=l4 lab=VBN}
C {lab_pin.sym} 440 -70 0 1 {name=l5 lab=0}
C {vsource.sym} 600 -100 0 0 {name=VBPSRC value="0.71"}
C {lab_pin.sym} 600 -130 0 1 {name=l6 lab=VBP}
C {lab_pin.sym} 600 -70 0 1 {name=l7 lab=0}
C {blocks/06_Clock_gen/xschem/B6_NONOV.sym} 1500 -300 0 0 {name=X1}
C {lab_pin.sym} 1420 -300 0 0 {name=l8 lab=CLK}
C {lab_pin.sym} 1580 -360 0 1 {name=l9 lab=PHI1}
C {lab_pin.sym} 1580 -320 0 1 {name=l10 lab=PHI1B}
C {lab_pin.sym} 1580 -280 0 1 {name=l11 lab=PHI2}
C {lab_pin.sym} 1580 -240 0 1 {name=l12 lab=PHI2B}
C {lab_pin.sym} 1460 -420 0 0 {name=l13 lab=VDD}
C {lab_pin.sym} 1540 -420 0 1 {name=l14 lab=VBP}
C {lab_pin.sym} 1460 -180 0 0 {name=l15 lab=0}
C {lab_pin.sym} 1540 -180 0 1 {name=l16 lab=VBN}
C {sky130_fd_pr/corner.sym} 100 -600 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 40 -500 0 0 {name=SIM only_toplevel=true value="* tb_6E_wire500f_vbn0p70: Blok 6 NONOV standalone, TT 1.8 V 27 C. Ukuran sel = nilai awal (TBD). Beban = transistor gerbang sakelar nyata (24 gate/net sesuai loop, S=D=0.9 V), TANPA kapasitansi kabel. Ditambah kapasitansi kabel 500f per net (PERKIRAAN pra-layout, bukan hasil ekstraksi).
.option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8
.temp 27
Vm vm 0 0.9
XLN1A vm PHI1 vm 0 sky130_fd_pr__nfet_01v8_lvt W=4 L=0.15 nf=1 mult=1 m=16
XLN1B vm PHI1 vm 0 sky130_fd_pr__nfet_01v8 W=2 L=0.15 nf=1 mult=1 m=8
XLP1A vm PHI1B vm vdd sky130_fd_pr__pfet_01v8_lvt W=8 L=0.35 nf=1 mult=1 m=16
XLP1B vm PHI1B vm vdd sky130_fd_pr__pfet_01v8 W=4 L=0.15 nf=1 mult=1 m=8
XLN2A vm PHI2 vm 0 sky130_fd_pr__nfet_01v8_lvt W=4 L=0.15 nf=1 mult=1 m=16
XLN2B vm PHI2 vm 0 sky130_fd_pr__nfet_01v8 W=2 L=0.15 nf=1 mult=1 m=8
XLP2A vm PHI2B vm vdd sky130_fd_pr__pfet_01v8_lvt W=8 L=0.35 nf=1 mult=1 m=16
XLP2B vm PHI2B vm vdd sky130_fd_pr__pfet_01v8 W=4 L=0.15 nf=1 mult=1 m=8
CWPHI1 PHI1 0 500f
CWPHI1B PHI1B 0 500f
CWPHI2 PHI2 0 500f
CWPHI2B PHI2B 0 500f
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 0.1n 2u 0 0.1n
wrdata tb_6E_wire500f_vbn0p70.dat v(CLK) v(PHI1) v(PHI1B) v(PHI2) v(PHI2B)
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
