v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {5D LVT: DIFFERENTIAL TRACK-AND-HOLD | SS / -40 C / 1.62 V} 0 -300 0 0 0.35 0.35 {}
T {NMOS 4/0.15 um | PMOS 8/0.35 um | CH=1pF | Rs=100 ohm | fs=4MHz} 0 -255 0 0 0.24 0.24 {}
C {vsource.sym} 0 0 0 0 {name=VINP_SRC value="PWL(0 0.5832 1.72e-07 0.5832 1.73e-07 1.0368 2.55e-07 1.0368 2.56e-07 0.729 4.22e-07 0.729 4.23e-07 0.891 5.05e-07 0.891 5.06e-07 0.891 6.72e-07 0.891 6.73e-07 0.729 7.55e-07 0.729 7.56e-07 1.0368 9.22e-07 1.0368 9.23e-07 0.5832 1.005e-06 0.5832 1.006e-06 0.81 1.172e-06 0.81 1.173e-06 0.81 1.25e-06 0.81)"}
C {lab_pin.sym} 0 -30 0 0 {name=l606 lab=src_p}
C {lab_pin.sym} 0 30 0 0 {name=l654 lab=0}
C {vsource.sym} 0 300 0 0 {name=VINN_SRC value="PWL(0 1.0368 1.72e-07 1.0368 1.73e-07 0.5832 2.55e-07 0.5832 2.56e-07 0.891 4.22e-07 0.891 4.23e-07 0.729 5.05e-07 0.729 5.06e-07 0.729 6.72e-07 0.729 6.73e-07 0.891 7.55e-07 0.891 7.56e-07 0.5832 9.22e-07 0.5832 9.23e-07 1.0368 1.005e-06 1.0368 1.006e-06 0.81 1.172e-06 0.81 1.173e-06 0.81 1.25e-06 0.81)"}
C {lab_pin.sym} 0 270 0 0 {name=l1053 lab=src_n}
C {lab_pin.sym} 0 330 0 0 {name=l1102 lab=0}
C {vsource.sym} 0 600 0 0 {name=VDD_SRC value="1.62"}
C {lab_pin.sym} 0 570 0 0 {name=l1201 lab=vdd}
C {lab_pin.sym} 0 630 0 0 {name=l1248 lab=0}
C {vsource.sym} 220 600 0 0 {name=VCM_SRC value="0.81"}
C {lab_pin.sym} 220 570 0 0 {name=l1349 lab=vcm}
C {lab_pin.sym} 220 630 0 0 {name=l1398 lab=0}
C {vsource.sym} 440 600 0 0 {name=VPHI_SRC value="PULSE(0 1.62 3e-08 1e-09 1e-09 1.1e-07 2.5e-07)"}
C {lab_pin.sym} 440 570 0 0 {name=l1545 lab=phi}
C {lab_pin.sym} 440 630 0 0 {name=l1594 lab=0}
C {vsource.sym} 660 600 0 0 {name=VPHIB_SRC value="PULSE(1.62 0 3e-08 1e-09 1e-09 1.1e-07 2.5e-07)"}
C {lab_pin.sym} 660 570 0 0 {name=l1742 lab=phib}
C {lab_pin.sym} 660 630 0 0 {name=l1792 lab=0}
C {res.sym} 220 0 0 0 {name=RSP value="100"}
C {lab_pin.sym} 220 -30 0 0 {name=l1884 lab=src_p}
C {lab_pin.sym} 220 30 0 0 {name=l1935 lab=vin_p}
C {lab_pin.sym} 450 0 0 0 {name=l2024 lab=vin_p}
C {lab_pin.sym} 650 0 2 0 {name=l2073 lab=hp}
C {lab_pin.sym} 550 -100 0 0 {name=l2119 lab=phib}
C {lab_pin.sym} 550 100 0 0 {name=l2170 lab=phi}
C {lab_pin.sym} 630 -30 2 0 {name=l2219 lab=vdd}
C {lab_pin.sym} 630 30 2 0 {name=l2268 lab=0}
C {capa.sym} 820 0 0 0 {name=CHP value="1p"}
C {lab_pin.sym} 820 -30 0 0 {name=l2359 lab=hp}
C {lab_pin.sym} 820 30 0 0 {name=l2407 lab=vcm}
C {res.sym} 220 300 0 0 {name=RSN value="100"}
C {lab_pin.sym} 220 270 0 0 {name=l2502 lab=src_n}
C {lab_pin.sym} 220 330 0 0 {name=l2553 lab=vin_n}
C {lab_pin.sym} 450 300 0 0 {name=l2645 lab=vin_n}
C {lab_pin.sym} 650 300 2 0 {name=l2696 lab=hn}
C {lab_pin.sym} 550 200 0 0 {name=l2744 lab=phib}
C {lab_pin.sym} 550 400 0 0 {name=l2794 lab=phi}
C {lab_pin.sym} 630 270 2 0 {name=l2843 lab=vdd}
C {lab_pin.sym} 630 330 2 0 {name=l2892 lab=0}
C {capa.sym} 820 300 0 0 {name=CHN value="1p"}
C {lab_pin.sym} 820 270 0 0 {name=l2986 lab=hn}
C {lab_pin.sym} 820 330 0 0 {name=l3034 lab=vcm}
C {sky130_fd_pr/corner.sym} 1000 600 0 0 {name=CORNER only_toplevel=false corner=ss}
C {code.sym} 1050 0 0 0 {name=SIM only_toplevel=true value="
.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp -40
.ic V(hp)=0.81 V(hn)=0.81
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 100p 1.25u 0 100p
let err_p=abs(v(hp)-v(src_p))
let err_n=abs(v(hn)-v(src_n))
meas tran ERR_P1 FIND err_p AT=140n
meas tran ERR_N1 FIND err_n AT=140n
meas tran ERR_P2 FIND err_p AT=390n
meas tran ERR_N2 FIND err_n AT=390n
meas tran ERR_P3 FIND err_p AT=640n
meas tran ERR_N3 FIND err_n AT=640n
meas tran ERR_P4 FIND err_p AT=890n
meas tran ERR_N4 FIND err_n AT=890n
meas tran ERR_P5 FIND err_p AT=1140n
meas tran ERR_N5 FIND err_n AT=1140n
wrdata waveform_5D_lvt.dat v(src_p) v(src_n) v(vin_p) v(vin_n) v(hp) v(hn) v(phi) v(phib)
plot v(src_p) v(hp) v(src_n) v(hn)
.endc
"}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 550 300 0 0 {name=x1}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 550 0 0 0 {name=x2}
