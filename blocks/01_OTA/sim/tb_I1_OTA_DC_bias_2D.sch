v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {I1 DIAGNOSTIC: OTA TWO-BIAS DC SWEEP} 0 -170 0 0 0.4 0.4 {}
T {TT | 1.8 V | 27 C | Vin_p = Vin_n = 0.9 V | Vbias sweep = 0.2 to 1.0 V} 0 -120 0 0 0.25 0.25 {}
T {Vcmfb1: 0 to 1.8 V / 10 mV | Vbias: 0.2 to 1.0 V / 20 mV | 7421 points} 0 -80 0 0 0.22 0.22 {}
C {lab_pin.sym} 350 50 0 0 {name=L_IN0 lab=vcmfb_ctrl}
C {lab_pin.sym} 350 70 0 0 {name=L_IN1 lab=vbz_r}
C {lab_pin.sym} 350 90 0 0 {name=L_IN2 lab=vbz_l}
C {lab_pin.sym} 350 110 0 0 {name=L_IN3 lab=vin_p}
C {lab_pin.sym} 350 130 0 0 {name=L_IN4 lab=vin_n}
C {lab_pin.sym} 350 150 0 0 {name=L_IN5 lab=vbias}
C {lab_pin.sym} 580 50 0 1 {name=L_OUT0 lab=vdd}
C {lab_pin.sym} 580 70 0 1 {name=L_OUT1 lab=vo1_b}
C {lab_pin.sym} 580 90 0 1 {name=L_OUT2 lab=vo1_a}
C {lab_pin.sym} 580 110 0 1 {name=L_OUT3 lab=out_p}
C {lab_pin.sym} 580 130 0 1 {name=L_OUT4 lab=out_n}
C {lab_pin.sym} 580 150 0 1 {name=L_OUT5 lab=0}
C {vsource.sym} 0 350 0 0 {name=VDD_SRC value=1.8 savecurrent=true}
C {lab_pin.sym} 0 320 0 0 {name=LS0 lab=vdd}
C {gnd.sym} 0 380 0 0 {name=GS0 lab=0}
C {vsource.sym} 260 350 0 0 {name=VCMFB_TEST value=0.6 savecurrent=true}
C {lab_pin.sym} 260 320 0 0 {name=LS1 lab=vcmfb_ctrl}
C {gnd.sym} 260 380 0 0 {name=GS1 lab=0}
C {vsource.sym} 520 350 0 0 {name=VBIAS_SRC value=0.46 savecurrent=true}
C {lab_pin.sym} 520 320 0 0 {name=LS2 lab=vbias}
C {gnd.sym} 520 380 0 0 {name=GS2 lab=0}
C {vsource.sym} 780 350 0 0 {name=VBZR_SRC value=1.8 savecurrent=true}
C {lab_pin.sym} 780 320 0 0 {name=LS3 lab=vbz_r}
C {gnd.sym} 780 380 0 0 {name=GS3 lab=0}
C {vsource.sym} 0 530 0 0 {name=VBZL_SRC value=1.8 savecurrent=true}
C {lab_pin.sym} 0 500 0 0 {name=LS4 lab=vbz_l}
C {gnd.sym} 0 560 0 0 {name=GS4 lab=0}
C {vsource.sym} 260 530 0 0 {name=VINP_SRC value=0.9 savecurrent=true}
C {lab_pin.sym} 260 500 0 0 {name=LS5 lab=vin_p}
C {gnd.sym} 260 560 0 0 {name=GS5 lab=0}
C {vsource.sym} 520 530 0 0 {name=VINN_SRC value=0.9 savecurrent=true}
C {lab_pin.sym} 520 500 0 0 {name=LS6 lab=vin_n}
C {gnd.sym} 520 560 0 0 {name=GS6 lab=0}
C {capa.sym} 800 120 0 0 {name=CL0 value=200f}
C {lab_pin.sym} 800 90 0 0 {name=LC0 lab=out_p}
C {gnd.sym} 800 150 0 0 {name=GC0 lab=0}
C {capa.sym} 1000 120 0 0 {name=CL1 value=200f}
C {lab_pin.sym} 1000 90 0 0 {name=LC1 lab=out_n}
C {gnd.sym} 1000 150 0 0 {name=GC1 lab=0}
C {sky130_fd_pr/corner.sym} 1100 400 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 1100 0 0 0 {name=SIM only_toplevel=true value="
* Diagnostic only: these trial bias values are not validated.
* 181 Vcmfb points x 41 Vbias values = 7421 DC operating points.
* Both OTA inputs remain fixed at 0.9 V; no external CMFB or reset loop.
* DC capacitors are open circuits; this does not test transient stability.
.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp 27
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
dc VCMFB_TEST 0.95 0.97 0.0001 VBIAS_SRC 0.2 1.0 0.02
let vcmout=(v(out_p)+v(out_n))/2
let vcmfirst=(v(vo1_a)+v(vo1_b))/2
let vdiff=v(out_p)-v(out_n)
let idd=-i(VDD_SRC)
wrdata ota_dc_bias_fine.dat v(vbias) v(vcmfb_ctrl) v(out_p) v(out_n) v(vo1_a) v(vo1_b) vcmout vcmfirst vdiff idd
write ota_dc_bias_fine.raw
* Export data for analysis; avoid plotting all 41 sweeps together.
.endc
"}
C {01_OTA/xschem/OTA_CMFB.sym} 500 100 0 0 {name=x2}
