v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {INTEGRATOR I1_startup | TRIAL BIAS - CHECK I1 BEFORE I2/I3} 20 -270 0 0 0.35 0.35 {}
T {CS=1pF CF=2pF CL=200fF | LVT WN/LN=4/0.15 WP/LP=8/0.35 | fs=4MHz} 20 -220 0 0 0.25 0.25 {}
T {OTA polarity and SC-CMFB startup must be verified; trial bias is not validated} 20 -180 0 0 0.22 0.22 {}
T {CF and reset stay connected between SUM and corresponding output} 1000 -170 0 0 0.2 0.2 {}
T {CMFB senses first-stage nodes Vo1_A/B; final output CM is measured, not assumed} 1230 1060 0 0 0.2 0.2 {}
C {lab_pin.sym} 0 0 0 0 {name=L11 lab=vin_p}
C {lab_pin.sym} 200 0 2 0 {name=L12 lab=a_p}
C {lab_pin.sym} 100 -100 0 0 {name=L13 lab=phi1b}
C {lab_pin.sym} 100 100 0 0 {name=L14 lab=phi1}
C {lab_pin.sym} 180 -30 2 0 {name=L15 lab=vdd}
C {lab_pin.sym} 180 30 2 0 {name=L16 lab=0}
C {lab_pin.sym} 0 230 0 0 {name=L18 lab=b_p}
C {lab_pin.sym} 200 230 2 0 {name=L19 lab=vcm}
C {lab_pin.sym} 100 130 0 0 {name=L20 lab=phi1b}
C {lab_pin.sym} 100 330 0 0 {name=L21 lab=phi1}
C {lab_pin.sym} 180 200 2 0 {name=L22 lab=vdd}
C {lab_pin.sym} 180 260 2 0 {name=L23 lab=0}
C {lab_pin.sym} 340 230 0 0 {name=L25 lab=a_p}
C {lab_pin.sym} 540 230 2 0 {name=L26 lab=vcm}
C {lab_pin.sym} 440 130 0 0 {name=L27 lab=phi2b}
C {lab_pin.sym} 440 330 0 0 {name=L28 lab=phi2}
C {lab_pin.sym} 520 200 2 0 {name=L29 lab=vdd}
C {lab_pin.sym} 520 260 2 0 {name=L30 lab=0}
C {lab_pin.sym} 680 0 0 0 {name=L32 lab=b_p}
C {lab_pin.sym} 880 0 2 0 {name=L33 lab=sum_p}
C {lab_pin.sym} 780 -100 0 0 {name=L34 lab=phi2b}
C {lab_pin.sym} 780 100 0 0 {name=L35 lab=phi2}
C {lab_pin.sym} 860 -30 2 0 {name=L36 lab=vdd}
C {lab_pin.sym} 860 30 2 0 {name=L37 lab=0}
C {capa.sym} 440 0 0 0 {name=CSp value=1p}
C {lab_pin.sym} 440 -30 0 0 {name=L39 lab=a_p}
C {lab_pin.sym} 440 30 0 0 {name=L40 lab=b_p}
C {capa.sym} 1120 0 0 0 {name=CFp value=2p}
C {lab_pin.sym} 1120 -30 0 0 {name=L42 lab=sum_p}
C {lab_pin.sym} 1120 30 0 0 {name=L43 lab=out_p}
C {lab_pin.sym} 1020 230 0 0 {name=L45 lab=sum_p}
C {lab_pin.sym} 1220 230 2 0 {name=L46 lab=out_p}
C {lab_pin.sym} 1120 130 0 0 {name=L47 lab=rstb}
C {lab_pin.sym} 1120 330 0 0 {name=L48 lab=rst}
C {lab_pin.sym} 1200 200 2 0 {name=L49 lab=vdd}
C {lab_pin.sym} 1200 260 2 0 {name=L50 lab=0}
C {capa.sym} 1900 0 0 0 {name=CLp value=200f}
C {lab_pin.sym} 1900 -30 0 0 {name=L52 lab=out_p}
C {lab_pin.sym} 1900 30 0 0 {name=L53 lab=0}
C {lab_pin.sym} 0 520 0 0 {name=L55 lab=vin_n}
C {lab_pin.sym} 200 520 2 0 {name=L56 lab=a_n}
C {lab_pin.sym} 100 420 0 0 {name=L57 lab=phi1b}
C {lab_pin.sym} 100 620 0 0 {name=L58 lab=phi1}
C {lab_pin.sym} 180 490 2 0 {name=L59 lab=vdd}
C {lab_pin.sym} 180 550 2 0 {name=L60 lab=0}
C {lab_pin.sym} 0 750 0 0 {name=L62 lab=b_n}
C {lab_pin.sym} 200 750 2 0 {name=L63 lab=vcm}
C {lab_pin.sym} 100 650 0 0 {name=L64 lab=phi1b}
C {lab_pin.sym} 100 850 0 0 {name=L65 lab=phi1}
C {lab_pin.sym} 180 720 2 0 {name=L66 lab=vdd}
C {lab_pin.sym} 180 780 2 0 {name=L67 lab=0}
C {lab_pin.sym} 340 750 0 0 {name=L69 lab=a_n}
C {lab_pin.sym} 540 750 2 0 {name=L70 lab=vcm}
C {lab_pin.sym} 440 650 0 0 {name=L71 lab=phi2b}
C {lab_pin.sym} 440 850 0 0 {name=L72 lab=phi2}
C {lab_pin.sym} 520 720 2 0 {name=L73 lab=vdd}
C {lab_pin.sym} 520 780 2 0 {name=L74 lab=0}
C {lab_pin.sym} 680 520 0 0 {name=L76 lab=b_n}
C {lab_pin.sym} 880 520 2 0 {name=L77 lab=sum_n}
C {lab_pin.sym} 780 420 0 0 {name=L78 lab=phi2b}
C {lab_pin.sym} 780 620 0 0 {name=L79 lab=phi2}
C {lab_pin.sym} 860 490 2 0 {name=L80 lab=vdd}
C {lab_pin.sym} 860 550 2 0 {name=L81 lab=0}
C {capa.sym} 440 520 0 0 {name=CSn value=1p}
C {lab_pin.sym} 440 490 0 0 {name=L83 lab=a_n}
C {lab_pin.sym} 440 550 0 0 {name=L84 lab=b_n}
C {capa.sym} 1120 520 0 0 {name=CFn value=2p}
C {lab_pin.sym} 1120 490 0 0 {name=L86 lab=sum_n}
C {lab_pin.sym} 1120 550 0 0 {name=L87 lab=out_n}
C {lab_pin.sym} 1020 750 0 0 {name=L89 lab=sum_n}
C {lab_pin.sym} 1220 750 2 0 {name=L90 lab=out_n}
C {lab_pin.sym} 1120 650 0 0 {name=L91 lab=rstb}
C {lab_pin.sym} 1120 850 0 0 {name=L92 lab=rst}
C {lab_pin.sym} 1200 720 2 0 {name=L93 lab=vdd}
C {lab_pin.sym} 1200 780 2 0 {name=L94 lab=0}
C {capa.sym} 1340 510 0 0 {name=CLn value=200f}
C {lab_pin.sym} 1340 480 0 0 {name=L96 lab=out_n}
C {lab_pin.sym} 1340 540 0 0 {name=L97 lab=0}
C {lab_pin.sym} 1390 170 0 0 {name=L101 lab=vbz_r}
C {lab_pin.sym} 1390 190 0 0 {name=L102 lab=vbz_l}
C {lab_pin.sym} 1390 210 0 0 {name=L103 lab=sum_p}
C {lab_pin.sym} 1390 230 0 0 {name=L104 lab=sum_n}
C {lab_pin.sym} 1390 250 0 0 {name=L105 lab=vbias}
C {lab_pin.sym} 1620 150 0 1 {name=L106 lab=vdd}
C {lab_pin.sym} 1620 170 0 1 {name=L107 lab=vo1_b}
C {lab_pin.sym} 1620 190 0 1 {name=L108 lab=vo1_a}
C {lab_pin.sym} 1620 210 0 1 {name=L109 lab=out_p}
C {lab_pin.sym} 1620 230 0 1 {name=L110 lab=out_n}
C {lab_pin.sym} 1620 250 0 1 {name=L111 lab=0}
C {lab_pin.sym} 1430 870 0 0 {name=L113 lab=vcs}
C {lab_pin.sym} 1430 890 0 0 {name=L114 lab=phi1b}
C {lab_pin.sym} 1430 910 0 0 {name=L115 lab=phi1}
C {lab_pin.sym} 1430 930 0 0 {name=L116 lab=phi2b}
C {lab_pin.sym} 1430 950 0 0 {name=L117 lab=phi2}
C {lab_pin.sym} 1430 970 0 0 {name=L118 lab=vcm_stage1}
C {lab_pin.sym} 1430 990 0 0 {name=L119 lab=vo1_b}
C {lab_pin.sym} 1430 1010 0 0 {name=L120 lab=vo1_a}
C {lab_pin.sym} 1650 870 0 1 {name=L121 lab=vdd}
C {lab_pin.sym} 1650 890 0 1 {name=L122 lab=vcmfb}
C {lab_pin.sym} 1650 910 0 1 {name=L123 lab=0}
C {vsource.sym} -10 1150 0 0 {name=VDD_SRC value=1.8}
C {lab_pin.sym} -10 1120 0 0 {name=L126 lab=vdd}
C {lab_pin.sym} -10 1180 0 0 {name=L127 lab=0}
C {vsource.sym} 320 1150 0 0 {name=VCM_SRC value=0.9}
C {lab_pin.sym} 320 1120 0 0 {name=L129 lab=vcm}
C {lab_pin.sym} 320 1180 0 0 {name=L130 lab=0}
C {vsource.sym} 650 1150 0 0 {name=VBIAS_SRC value=0.6}
C {lab_pin.sym} 650 1120 0 0 {name=L132 lab=vbias}
C {lab_pin.sym} 650 1180 0 0 {name=L133 lab=0}
C {vsource.sym} 980 1150 0 0 {name=VBZL_SRC value=1.8}
C {lab_pin.sym} 980 1120 0 0 {name=L135 lab=vbz_l}
C {lab_pin.sym} 980 1180 0 0 {name=L136 lab=0}
C {vsource.sym} 1310 1150 0 0 {name=VBZR_SRC value=1.8}
C {lab_pin.sym} 1310 1120 0 0 {name=L138 lab=vbz_r}
C {lab_pin.sym} 1310 1180 0 0 {name=L139 lab=0}
C {vsource.sym} 1640 1150 0 0 {name=VCS_SRC value=0.9}
C {lab_pin.sym} 1640 1120 0 0 {name=L141 lab=vcs}
C {lab_pin.sym} 1640 1180 0 0 {name=L142 lab=0}
C {vsource.sym} -10 1350 0 0 {name=VCM1_SRC value=0.9}
C {lab_pin.sym} -10 1320 0 0 {name=L144 lab=vcm_stage1}
C {lab_pin.sym} -10 1380 0 0 {name=L145 lab=0}
C {vsource.sym} 320 1350 0 0 {name=VPHI1_SRC value="PULSE(0 1.8 30n 1n 1n 110n 250n)"}
C {lab_pin.sym} 320 1320 0 0 {name=L147 lab=phi1}
C {lab_pin.sym} 320 1380 0 0 {name=L148 lab=0}
C {vsource.sym} 650 1350 0 0 {name=VPHI1B_SRC value="PULSE(1.8 0 30n 1n 1n 110n 250n)"}
C {lab_pin.sym} 650 1320 0 0 {name=L150 lab=phi1b}
C {lab_pin.sym} 650 1380 0 0 {name=L151 lab=0}
C {vsource.sym} 980 1350 0 0 {name=VPHI2_SRC value="PULSE(0 1.8 155n 1n 1n 110n 250n)"}
C {lab_pin.sym} 980 1320 0 0 {name=L153 lab=phi2}
C {lab_pin.sym} 980 1380 0 0 {name=L154 lab=0}
C {vsource.sym} 1310 1350 0 0 {name=VPHI2B_SRC value="PULSE(1.8 0 155n 1n 1n 110n 250n)"}
C {lab_pin.sym} 1310 1320 0 0 {name=L156 lab=phi2b}
C {lab_pin.sym} 1310 1380 0 0 {name=L157 lab=0}
C {vsource.sym} 1640 1350 0 0 {name=VRST_SRC value=1.8}
C {lab_pin.sym} 1640 1320 0 0 {name=L159 lab=rst}
C {lab_pin.sym} 1640 1380 0 0 {name=L160 lab=0}
C {vsource.sym} -10 1550 0 0 {name=VRSTB_SRC value=0}
C {lab_pin.sym} -10 1520 0 0 {name=L162 lab=rstb}
C {lab_pin.sym} -10 1580 0 0 {name=L163 lab=0}
C {vsource.sym} 320 1550 0 0 {name=VINP_SRC value="PWL(0 0.9 2.005u 0.9 2.006u 0.9 5u 0.9)"}
C {lab_pin.sym} 320 1520 0 0 {name=L165 lab=vin_p}
C {lab_pin.sym} 320 1580 0 0 {name=L166 lab=0}
C {vsource.sym} 650 1550 0 0 {name=VINN_SRC value="PWL(0 0.9 2.005u 0.9 2.006u 0.9 5u 0.9)"}
C {lab_pin.sym} 650 1520 0 0 {name=L168 lab=vin_n}
C {lab_pin.sym} 650 1580 0 0 {name=L169 lab=0}
C {sky130_fd_pr/corner.sym} 2150 950 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 2150 0 0 0 {name=SIM only_toplevel=true value="
* I1 startup: reset remains ON throughout simulation.
* Bias values are literal source properties, not validated final biases.
* CS=1p, CF=2p, CL=200f per channel.

.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp 27

.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15

tran 200p 5u 0 200p

let vdiff=v(out_p)-v(out_n)
let vcmout=(v(out_p)+v(out_n))/2
let vcmfirst=(v(vo1_a)+v(vo1_b))/2

meas tran CM_END FIND vcmout AT=4.99u
meas tran CM1_END FIND vcmfirst AT=4.99u
meas tran DIFF_END FIND vdiff AT=4.99u
meas tran CMFB_END FIND v(vcmfb) AT=4.99u

wrdata waveform_I1_startup.dat v(vin_p) v(vin_n) v(sum_p) v(sum_n) v(out_p) v(out_n) v(vo1_a) v(vo1_b) v(vcmfb) v(phi1) v(phi2) v(rst) i(VDD_SRC)

plot v(out_p) v(out_n) vcmout
.endc
"}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 100 0 0 0 {name=x1}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 100 230 0 0 {name=x2}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 100 520 0 0 {name=x3}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 100 750 0 0 {name=x4}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 440 750 0 0 {name=x5}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 440 230 0 0 {name=x6}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 780 0 0 0 {name=x7}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 1120 230 0 0 {name=x8}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 780 520 0 0 {name=x9}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 1120 750 0 0 {name=x10}
C {blocks/01_OTA/xschem/OTA_CMFB.sym} 1540 200 0 0 {name=x11}
C {blocks/02_CMFB/xschem/CMFB.sym} 1540 950 0 0 {name=x12}
C {vsource.sym} 980 1550 0 0 {name=VCM1 value=0.6
}
C {lab_pin.sym} 980 1520 0 0 {name=L1 lab=vcmfb1
}
C {lab_pin.sym} 980 1580 0 0 {name=L2 lab=0}
C {lab_pin.sym} 1390 150 0 0 {name=L3 lab=vcmfb1
}
