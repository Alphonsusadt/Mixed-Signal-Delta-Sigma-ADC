v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {5E DIAGNOSTIC: LVT SAMPLER + IDEAL TRANSFER | TT 1.8V 27C} 0 -320 0 0 0.32 0.32 {}
T {CH=CL=1pF | input P/N=1.08/0.72V | receiver initial=0.9V | no OTA} 0 -275 0 0 0.23 0.23 {}
C {vsource.sym} 0 0 0 0 {name=VINP_SRC value="1.08"}
C {lab_pin.sym} 0 -30 0 0 {name=L307 lab=src_p}
C {lab_pin.sym} 0 30 0 0 {name=L355 lab=0}
C {res.sym} 210 0 0 0 {name=RSP value="100"}
C {lab_pin.sym} 210 -30 0 0 {name=L443 lab=src_p}
C {lab_pin.sym} 210 30 0 0 {name=L493 lab=vin_p}
C {lab_pin.sym} 400 0 0 0 {name=L581 lab=vin_p}
C {lab_pin.sym} 600 0 2 0 {name=L629 lab=hp}
C {lab_pin.sym} 500 -100 0 0 {name=L674 lab=phib}
C {lab_pin.sym} 500 100 0 0 {name=L724 lab=phi}
C {lab_pin.sym} 580 -30 2 0 {name=L772 lab=vdd}
C {lab_pin.sym} 580 30 2 0 {name=L820 lab=0}
C {capa.sym} 710 0 0 0 {name=CHP value="1p"}
C {lab_pin.sym} 710 -30 0 0 {name=L910 lab=hp}
C {lab_pin.sym} 710 30 0 0 {name=L957 lab=vcm}
C {lab_pin.sym} 890 0 0 0 {name=L1048 lab=hp}
C {lab_pin.sym} 1010 0 2 0 {name=L1094 lab=rp}
C {lab_pin.sym} 950 -60 0 0 {name=L1141 lab=phi2}
C {lab_pin.sym} 950 60 0 0 {name=L1191 lab=0}
C {capa.sym} 1150 0 0 0 {name=CLP value="1p"}
C {lab_pin.sym} 1150 -30 0 0 {name=L1283 lab=rp}
C {lab_pin.sym} 1150 30 0 0 {name=L1332 lab=vcm}
C {vsource.sym} 0 300 0 0 {name=VINN_SRC value="0.72"}
C {lab_pin.sym} 0 270 0 0 {name=L1436 lab=src_n}
C {lab_pin.sym} 0 330 0 0 {name=L1485 lab=0}
C {res.sym} 210 300 0 0 {name=RSN value="100"}
C {lab_pin.sym} 210 270 0 0 {name=L1577 lab=src_n}
C {lab_pin.sym} 210 330 0 0 {name=L1628 lab=vin_n}
C {lab_pin.sym} 400 300 0 0 {name=L1720 lab=vin_n}
C {lab_pin.sym} 600 300 2 0 {name=L1771 lab=hn}
C {lab_pin.sym} 500 200 0 0 {name=L1819 lab=phib}
C {lab_pin.sym} 500 400 0 0 {name=L1869 lab=phi}
C {lab_pin.sym} 580 270 2 0 {name=L1918 lab=vdd}
C {lab_pin.sym} 580 330 2 0 {name=L1967 lab=0}
C {capa.sym} 710 300 0 0 {name=CHN value="1p"}
C {lab_pin.sym} 710 270 0 0 {name=L2061 lab=hn}
C {lab_pin.sym} 710 330 0 0 {name=L2109 lab=vcm}
C {lab_pin.sym} 890 300 0 0 {name=L2204 lab=hn}
C {lab_pin.sym} 1010 300 2 0 {name=L2252 lab=rn}
C {lab_pin.sym} 950 240 0 0 {name=L2301 lab=phi2}
C {lab_pin.sym} 950 360 0 0 {name=L2351 lab=0}
C {capa.sym} 1150 300 0 0 {name=CLN value="1p"}
C {lab_pin.sym} 1150 270 0 0 {name=L2446 lab=rn}
C {lab_pin.sym} 1150 330 0 0 {name=L2495 lab=vcm}
C {vsource.sym} 0 650 0 0 {name=VDD_SRC value="1.8"}
C {lab_pin.sym} 0 620 0 0 {name=L2598 lab=vdd}
C {lab_pin.sym} 0 680 0 0 {name=L2645 lab=0}
C {vsource.sym} 200 650 0 0 {name=VCM_SRC value="0.9"}
C {lab_pin.sym} 200 620 0 0 {name=L2745 lab=vcm}
C {lab_pin.sym} 200 680 0 0 {name=L2794 lab=0}
C {vsource.sym} 400 650 0 0 {name=VPHI_SRC value="PULSE(0 1.8 30n 1n 1n 110n 490n)"}
C {lab_pin.sym} 400 620 0 0 {name=L2926 lab=phi}
C {lab_pin.sym} 400 680 0 0 {name=L2975 lab=0}
C {vsource.sym} 600 650 0 0 {name=VPHIB_SRC value="PULSE(1.8 0 30n 1n 1n 110n 490n)"}
C {lab_pin.sym} 600 620 0 0 {name=L3108 lab=phib}
C {lab_pin.sym} 600 680 0 0 {name=L3158 lab=0}
C {vsource.sym} 800 650 0 0 {name=VPHI2_SRC value="PULSE(0 1.8 180n 1n 1n 40n 490n)"}
C {lab_pin.sym} 800 620 0 0 {name=L3291 lab=phi2}
C {lab_pin.sym} 800 680 0 0 {name=L3341 lab=0}
C {vsource.sym} 1000 650 0 0 {name=VPHI2B_SRC value="PULSE(1.8 0 180n 1n 1n 40n 490n)"}
C {lab_pin.sym} 1000 620 0 0 {name=L3476 lab=phi2b}
C {lab_pin.sym} 1000 680 0 0 {name=L3528 lab=0}
C {sky130_fd_pr/corner.sym} 1350 650 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 1400 0 0 0 {name=SIM only_toplevel=true value="
.subckt TRANSFER_IDEAL A B CTRL GND
S1 A B CTRL GND SW_TRANSFER
.model SW_TRANSFER SW(RON=10 ROFF=1e15 VT=0.9 VH=0)
.ends TRANSFER_IDEAL
.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp 27
.ic V(hp)=0.9 V(hn)=0.9 V(rp)=0.9 V(rn)=0.9
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 100p 245n 0 100p
meas tran hp_178 FIND v(hp) AT=178n
meas tran hp_219 FIND v(hp) AT=219n
meas tran hp_220 FIND v(hp) AT=220n
meas tran hp_227 FIND v(hp) AT=227n
meas tran hn_178 FIND v(hn) AT=178n
meas tran hn_219 FIND v(hn) AT=219n
meas tran hn_220 FIND v(hn) AT=220n
meas tran hn_227 FIND v(hn) AT=227n
meas tran rp_178 FIND v(rp) AT=178n
meas tran rp_219 FIND v(rp) AT=219n
meas tran rp_220 FIND v(rp) AT=220n
meas tran rp_227 FIND v(rp) AT=227n
meas tran rn_178 FIND v(rn) AT=178n
meas tran rn_219 FIND v(rn) AT=219n
meas tran rn_220 FIND v(rn) AT=220n
meas tran rn_227 FIND v(rn) AT=227n
wrdata waveform_5E_ideal.dat v(src_p) v(src_n) v(vin_p) v(vin_n) v(hp) v(hn) v(phi) v(phib) v(rp) v(rn) v(phi2) v(phi2b)
plot v(hp) v(rp) v(hn) v(rn)
.endc
"}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 500 0 0 0 {name=x1}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 500 300 0 0 {name=x2}
C {blocks/05_Switch_Network/sim/TRANSFER_IDEAL.sym} 950 0 0 0 {name=XTR}
C {blocks/05_Switch_Network/sim/TRANSFER_IDEAL.sym} 950 300 0 0 {name=XTR1}
