v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 2800 -1300 4400 -1000 {flags=graph
y1=-0.6
y2=0.2
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=5.12379e-07
x2=1.5405299e-05
divx=9
subdivx=1
node="vin_d
rec"
color="4 7"
dataset=-1
unitx=u
logx=0
logy=0
hilight_wave=2089614176}
B 2 2800 -950 4400 -650 {flags=graph
y1=-1.2
y2=1.2
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=5.12379e-07
x2=1.5405299e-05
divx=9
subdivx=1
node="o1_d
o2_d"
color="4 5"
dataset=-1
unitx=u
logx=0
logy=0
}
B 2 2800 -600 4400 -300 {flags=graph
y1=0.58607232
y2=1.4803897
ypos1=0
ypos2=2
divy=6
subdivy=1
unity=1
x1=5.12379e-07
x2=1.5405299e-05
divx=9
subdivx=1
node="o1_p
o1_n
o2_p
o2_n"
color="4 5 6 7"
dataset=-1
unitx=u
logx=0
logy=0
}
B 2 2800 -250 4400 50 {flags=graph
y1=-0.7
y2=1.9
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=5.12379e-07
x2=1.5405299e-05
divx=9
subdivx=1
node="q
dac_d"
color="4 7"
dataset=-1
unitx=u
logx=0
logy=0
}
B 2 2800 100 4400 400 {flags=graph
y1=-3.8
y2=-1.9
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=5.12379e-07
x2=1.5405299e-05
divx=9
subdivx=1
node="phi1
phi2
clk"
color="4 5 7"
dataset=-1
unitx=u
logx=0
logy=0
}
B 2 2800 450 4400 750 {flags=graph
y1=0
y2=1.9
ypos1=0
ypos2=2
divy=4
subdivy=1
unity=1
x1=5.12379e-07
x2=1.5405299e-05
divx=9
subdivx=1
node="cmp_p
cmp_n"
color="4 5"
dataset=-1
unitx=u
logx=0
logy=0
}
T {tb_SD_TOP: closed-loop testbench of the 2nd-order delta-sigma modulator (Blocks 1-6), conditions of run f6} -700 -1000 0 0 0.9 0.9 {}
T {Block 1 OTA + Block 2 SC-CMFB + Block 5 switches inside SD_STAGE; Block 3 StrongARM + SR latch; Block 4 1-bit DAC; Block 6 NONOV with bias generator.} -700 -940 0 0 0.45 0.45 {}
T {Configuration of run f6_sine300_b6res_n4096: phases from Block 6, comparator clock = phi2b through 2 inverters. Ideal sources: VIN, VCM, VREF, bias.} -700 -905 0 0 0.4 0.4 {}
T {DAC feedback sampler, stage 1 (swapped branch; Block 5 switches)} -230 690 0 0 0.4 0.4 {}
T {DAC feedback sampler, stage 2 (swapped branch)} 570 690 0 0 0.4 0.4 {}
T {comparator clock chain (2 x B6_INV)} 630 -670 0 0 0.35 0.35 {}
T {Ideal sources in the simulation: vdd 1.8 V, vcm 0.9 V, vrefp 1.2 V, vrefn 0.6 V, vbias1/2, vcs1/2, vcms1/2, vbz_l/r, rst/rstb, clkm, vin_p/vin_n.} -700 780 0 0 0.35 0.35 {}
T {Closed-loop deck: top_level/closed_loop/run_closed_loop_f1.py (extracted SPICE netlists in top_level/closed_loop/spice/).} -700 815 0 0 0.35 0.35 {}
T {Integrator 1} -230 -110 0 0 0.55 0.55 {}
T {Block 1 OTA + Block 2 CMFB + Block 5 switches} -230 -75 0 0 0.4 0.4 {}
T {Integrator 2} 570 -110 0 0 0.55 0.55 {}
T {Block 1 OTA + Block 2 CMFB + Block 5 switches} 570 -75 0 0 0.4 0.4 {}
T {Block 3: StrongARM comparator} 1290 100 0 0 0.45 0.45 {}
T {Block 3: output buffers + SR latch} 1580 -300 0 0 0.45 0.45 {}
T {Block 4: 1-bit DAC} 2330 -190 0 0 0.5 0.5 {}
T {Block 6: NONOV clock generator} 120 -820 0 0 0.5 0.5 {}
T {Block 6: bias generator} -330 -820 0 0 0.5 0.5 {}
T {Supplies, references and bias (ideal sources, values of run f6)} -720 -1380 0 0 0.5 0.5 {}
T {Master clock, reset and differential input (300 mV pk diff, 12.695 kHz = bin 13/4096)} 980 -1380 0 0 0.5 0.5 {}
T {Measurement only (ideal, not part of the design): differential probes and 2 x RC 50 kHz reconstruction filter on the DAC output} -720 940 0 0 0.45 0.45 {}
T {OSCILLOSCOPE: run Netlist + Simulate, then Ctrl+Left-Click the launcher to load tb_SD_TOP.raw. Zoom a graph with the mouse wheel, press f to fit.} 2800 -1460 0 0 0.45 0.45 {}
T {CH1: differential input vin_d and reconstructed DAC output rec (V)} 2800 -1330 0 0 0.4 0.4 {}
T {CH2: integrator 1 and 2 differential outputs o1_d, o2_d (V)} 2800 -980 0 0 0.4 0.4 {}
T {CH3: single-ended integrator outputs (common-mode and headroom check, V)} 2800 -630 0 0 0.4 0.4 {}
T {CH4: bitstream q (latch) and DAC differential output dac_d (V)} 2800 -280 0 0 0.4 0.4 {}
T {CH5: clock phases phi1, phi2 (Block 6) and comparator clock clk (V), zoom in} 2800 70 0 0 0.4 0.4 {}
T {CH6: StrongARM outputs cmp_p, cmp_n (V), zoom in} 2800 420 0 0 0.4 0.4 {}
N 250 -40 550 -40 {lab=o1_p}
N 250 40 550 40 {lab=o1_n}
N -310 -40 -250 -40 {lab=vin_p}
N -310 40 -250 40 {lab=vin_n}
N -195 -210 -195 -150 {lab=phi1}
N -165 -210 -165 -150 {lab=phi1b}
N -135 -210 -135 -150 {lab=phi2}
N -105 -210 -105 -150 {lab=phi2b}
N -75 -210 -75 -150 {lab=rst}
N -45 -210 -45 -150 {lab=rstb}
N -15 -210 -15 -150 {lab=vdd}
N 15 -210 15 -150 {lab=vcm}
N 45 -210 45 -150 {lab=vcms1}
N 75 -210 75 -150 {lab=vbias1}
N 105 -210 105 -150 {lab=vcs1}
N 135 -210 135 -150 {lab=vbz_l}
N 165 -210 165 -150 {lab=vbz_r}
N 195 -210 195 -150 {lab=GND}
N 605 -210 605 -150 {lab=phi1}
N 635 -210 635 -150 {lab=phi1b}
N 665 -210 665 -150 {lab=phi2}
N 695 -210 695 -150 {lab=phi2b}
N 725 -210 725 -150 {lab=rst}
N 755 -210 755 -150 {lab=rstb}
N 785 -210 785 -150 {lab=vdd}
N 815 -210 815 -150 {lab=vcm}
N 845 -210 845 -150 {lab=vcms2}
N 875 -210 875 -150 {lab=vbias2}
N 905 -210 905 -150 {lab=vcs2}
N 935 -210 935 -150 {lab=vbz_l}
N 965 -210 965 -150 {lab=vbz_r}
N 995 -210 995 -150 {lab=GND}
N 1050 -40 1060 -40 {lab=o2_p}
N 1060 -40 1060 -10 {lab=o2_p}
N 1060 -10 1200 -10 {lab=o2_p}
N 1050 40 1090 40 {lab=o2_n}
N 1090 10 1090 40 {lab=o2_n}
N 1090 10 1200 10 {lab=o2_n}
N 1160 -30 1200 -30 {lab=clk}
N 1400 -30 1440 -30 {lab=vdd}
N 1400 30 1440 30 {lab=GND}
N 1400 -10 1450 -10 {lab=cmp_p}
N 1450 -160 1450 -10 {lab=cmp_p}
N 1450 -160 1500 -160 {lab=cmp_p}
N 1400 10 1480 10 {lab=cmp_n}
N 1480 10 1480 160 {lab=cmp_n}
N 1480 160 1500 160 {lab=cmp_n}
N 1560 -270 1560 -240 {lab=vdd}
N 1560 -80 1560 -50 {lab=GND}
N 1560 50 1560 80 {lab=vdd}
N 1560 240 1560 270 {lab=GND}
N 1660 -160 1710 -160 {lab=p_buf}
N 1710 -160 1710 -50 {lab=p_buf}
N 1710 -50 1770 -50 {lab=p_buf}
N 1660 160 1740 160 {lab=n_buf}
N 1740 50 1740 160 {lab=n_buf}
N 1740 50 1770 50 {lab=n_buf}
N 1880 100 1880 130 {lab=GND}
N 1920 100 1920 130 {lab=vdd}
N 2030 -50 2070 -50 {lab=q}
N 2070 -50 2070 20 {lab=q}
N 2070 20 2200 20 {lab=q}
N 2030 50 2100 50 {lab=qb}
N 2100 50 2100 60 {lab=qb}
N 2100 60 2200 60 {lab=qb}
N 2160 -80 2200 -80 {lab=vrefp}
N 2160 -40 2200 -40 {lab=vrefn}
N 2310 -180 2310 -150 {lab=vdd}
N 2390 150 2390 180 {lab=GND}
N 2500 -50 2560 -50 {lab=dac_p}
N 2500 50 2560 50 {lab=dac_n}
N -100 150 -100 370 {lab=s1_p}
N 100 150 100 370 {lab=s1_n}
N 700 150 700 370 {lab=s2_p}
N 900 150 900 370 {lab=s2_n}
N -210 430 -150 430 {lab=dac_n}
N -210 470 -150 470 {lab=dac_p}
N 590 430 650 430 {lab=dac_n}
N 590 470 650 470 {lab=dac_p}
N -135 550 -135 610 {lab=phi1}
N -90 550 -90 610 {lab=phi1b}
N -45 550 -45 610 {lab=phi2}
N 0 550 0 610 {lab=phi2b}
N 45 550 45 610 {lab=vcm}
N 90 550 90 610 {lab=vdd}
N 135 550 135 610 {lab=GND}
N 665 550 665 610 {lab=phi1}
N 710 550 710 610 {lab=phi1b}
N 755 550 755 610 {lab=phi2}
N 800 550 800 610 {lab=phi2b}
N 845 550 845 610 {lab=vcm}
N 890 550 890 610 {lab=vdd}
N 935 550 935 610 {lab=GND}
N 70 -600 120 -600 {lab=clkm}
N 160 -780 160 -720 {lab=vdd}
N 160 -480 160 -420 {lab=GND}
N 240 -780 240 -720 {lab=vbp_b6}
N 240 -480 240 -420 {lab=vbn_b6}
N 280 -660 340 -660 {lab=phi1}
N 280 -620 340 -620 {lab=phi1b}
N 280 -580 340 -580 {lab=phi2}
N 280 -540 340 -540 {lab=phi2b}
N -270 -730 -270 -670 {lab=vdd}
N -270 -530 -270 -470 {lab=GND}
N -190 -620 -140 -620 {lab=vbn_b6}
N -190 -580 -140 -580 {lab=vbp_b6}
N 600 -540 640 -540 {lab=phi2b}
N 760 -540 840 -540 {lab=clkc1}
N 960 -540 1010 -540 {lab=clk}
N 700 -640 700 -590 {lab=vdd}
N 700 -490 700 -460 {lab=GND}
N 900 -640 900 -590 {lab=vdd}
N 900 -490 900 -460 {lab=GND}
C {top_level/xschem/SD_STAGE.sym} 0 0 0 0 {name=X1 }
C {top_level/xschem/SD_STAGE.sym} 800 0 0 0 {name=X2 }
C {lab_pin.sym} -310 -40 0 0 {name=l1 lab=vin_p}
C {lab_pin.sym} -310 40 0 0 {name=l2 lab=vin_n}
C {lab_pin.sym} -195 -210 1 0 {name=l3 lab=phi1}
C {lab_pin.sym} -165 -210 1 0 {name=l4 lab=phi1b}
C {lab_pin.sym} -135 -210 1 0 {name=l5 lab=phi2}
C {lab_pin.sym} -105 -210 1 0 {name=l6 lab=phi2b}
C {lab_pin.sym} -75 -210 1 0 {name=l7 lab=rst}
C {lab_pin.sym} -45 -210 1 0 {name=l8 lab=rstb}
C {lab_pin.sym} -15 -210 1 0 {name=l9 lab=vdd}
C {lab_pin.sym} 15 -210 1 0 {name=l10 lab=vcm}
C {lab_pin.sym} 45 -210 1 0 {name=l11 lab=vcms1}
C {lab_pin.sym} 75 -210 1 0 {name=l12 lab=vbias1}
C {lab_pin.sym} 105 -210 1 0 {name=l13 lab=vcs1}
C {lab_pin.sym} 135 -210 1 0 {name=l14 lab=vbz_l}
C {lab_pin.sym} 165 -210 1 0 {name=l15 lab=vbz_r}
C {lab_pin.sym} 195 -210 1 0 {name=l16 lab=GND}
C {lab_pin.sym} 605 -210 1 0 {name=l17 lab=phi1}
C {lab_pin.sym} 635 -210 1 0 {name=l18 lab=phi1b}
C {lab_pin.sym} 665 -210 1 0 {name=l19 lab=phi2}
C {lab_pin.sym} 695 -210 1 0 {name=l20 lab=phi2b}
C {lab_pin.sym} 725 -210 1 0 {name=l21 lab=rst}
C {lab_pin.sym} 755 -210 1 0 {name=l22 lab=rstb}
C {lab_pin.sym} 785 -210 1 0 {name=l23 lab=vdd}
C {lab_pin.sym} 815 -210 1 0 {name=l24 lab=vcm}
C {lab_pin.sym} 845 -210 1 0 {name=l25 lab=vcms2}
C {lab_pin.sym} 875 -210 1 0 {name=l26 lab=vbias2}
C {lab_pin.sym} 905 -210 1 0 {name=l27 lab=vcs2}
C {lab_pin.sym} 935 -210 1 0 {name=l28 lab=vbz_l}
C {lab_pin.sym} 965 -210 1 0 {name=l29 lab=vbz_r}
C {lab_pin.sym} 995 -210 1 0 {name=l30 lab=GND}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 1350 0 0 0 {name=XCMP }
C {lab_pin.sym} 1160 -30 0 0 {name=l31 lab=clk}
C {lab_pin.sym} 1440 -30 2 0 {name=l32 lab=vdd}
C {lab_pin.sym} 1440 30 2 0 {name=l33 lab=GND}
C {blocks/04_1Bit_DAC/xschem/BUF_B01.sym} 1580 -160 0 0 {name=XBP }
C {blocks/04_1Bit_DAC/xschem/BUF_B01.sym} 1580 160 0 0 {name=XBN }
C {lab_pin.sym} 1560 -270 3 0 {name=l34 lab=vdd}
C {lab_pin.sym} 1560 -50 1 0 {name=l35 lab=GND}
C {lab_pin.sym} 1560 50 3 0 {name=l36 lab=vdd}
C {lab_pin.sym} 1560 270 1 0 {name=l37 lab=GND}
C {blocks/03_StrongARM/xschem/SR_Latch.sym} 1900 0 0 0 {name=XSR }
C {lab_pin.sym} 1880 130 1 0 {name=l38 lab=GND}
C {lab_pin.sym} 1920 130 1 0 {name=l39 lab=vdd}
C {blocks/04_1Bit_DAC/xschem/DAC_1bit.sym} 2350 0 0 0 {name=XDAC }
C {lab_pin.sym} 2160 -80 0 0 {name=l40 lab=vrefp}
C {lab_pin.sym} 2160 -40 0 0 {name=l41 lab=vrefn}
C {lab_pin.sym} 2310 -180 1 0 {name=l42 lab=vdd}
C {lab_pin.sym} 2390 180 3 0 {name=l43 lab=GND}
C {lab_pin.sym} 2560 -50 2 0 {name=l44 lab=dac_p}
C {lab_pin.sym} 2560 50 2 0 {name=l45 lab=dac_n}
C {top_level/xschem/FB_SAMP.sym} 0 450 0 0 {name=XFB1 }
C {top_level/xschem/FB_SAMP.sym} 800 450 0 0 {name=XFB2 }
C {lab_pin.sym} -210 430 0 0 {name=l46 lab=dac_n}
C {lab_pin.sym} -210 470 0 0 {name=l47 lab=dac_p}
C {lab_pin.sym} 590 430 0 0 {name=l48 lab=dac_n}
C {lab_pin.sym} 590 470 0 0 {name=l49 lab=dac_p}
C {lab_pin.sym} -135 610 3 0 {name=l50 lab=phi1}
C {lab_pin.sym} -90 610 3 0 {name=l51 lab=phi1b}
C {lab_pin.sym} -45 610 3 0 {name=l52 lab=phi2}
C {lab_pin.sym} 0 610 3 0 {name=l53 lab=phi2b}
C {lab_pin.sym} 45 610 3 0 {name=l54 lab=vcm}
C {lab_pin.sym} 90 610 3 0 {name=l55 lab=vdd}
C {lab_pin.sym} 135 610 3 0 {name=l56 lab=GND}
C {lab_pin.sym} 665 610 3 0 {name=l57 lab=phi1}
C {lab_pin.sym} 710 610 3 0 {name=l58 lab=phi1b}
C {lab_pin.sym} 755 610 3 0 {name=l59 lab=phi2}
C {lab_pin.sym} 800 610 3 0 {name=l60 lab=phi2b}
C {lab_pin.sym} 845 610 3 0 {name=l61 lab=vcm}
C {lab_pin.sym} 890 610 3 0 {name=l62 lab=vdd}
C {lab_pin.sym} 935 610 3 0 {name=l63 lab=GND}
C {blocks/06_Clock_gen/xschem/B6_NONOV.sym} 200 -600 0 0 {name=XNONOV }
C {lab_pin.sym} 70 -600 0 0 {name=l64 lab=clkm}
C {lab_pin.sym} 160 -780 0 0 {name=l65 lab=vdd}
C {lab_pin.sym} 160 -420 0 0 {name=l66 lab=GND}
C {lab_pin.sym} 240 -780 0 0 {name=l67 lab=vbp_b6}
C {lab_pin.sym} 240 -420 0 0 {name=l68 lab=vbn_b6}
C {lab_pin.sym} 340 -660 2 0 {name=l69 lab=phi1}
C {lab_pin.sym} 340 -620 2 0 {name=l70 lab=phi1b}
C {lab_pin.sym} 340 -580 2 0 {name=l71 lab=phi2}
C {lab_pin.sym} 340 -540 2 0 {name=l72 lab=phi2b}
C {blocks/06_Clock_gen/xschem/B6_BIASGEN.sym} -250 -600 0 0 {name=XBIAS }
C {lab_pin.sym} -270 -730 0 0 {name=l73 lab=vdd}
C {lab_pin.sym} -270 -470 0 0 {name=l74 lab=GND}
C {lab_pin.sym} -140 -620 2 0 {name=l75 lab=vbn_b6}
C {lab_pin.sym} -140 -580 2 0 {name=l76 lab=vbp_b6}
C {blocks/06_Clock_gen/xschem/B6_INV.sym} 700 -540 0 0 {name=XCI1 }
C {blocks/06_Clock_gen/xschem/B6_INV.sym} 900 -540 0 0 {name=XCI2 }
C {lab_pin.sym} 600 -540 0 0 {name=l77 lab=phi2b}
C {lab_pin.sym} 1010 -540 2 0 {name=l78 lab=clk}
C {lab_pin.sym} 700 -640 0 0 {name=l79 lab=vdd}
C {lab_pin.sym} 700 -460 0 0 {name=l80 lab=GND}
C {lab_pin.sym} 900 -640 0 0 {name=l81 lab=vdd}
C {lab_pin.sym} 900 -460 0 0 {name=l82 lab=GND}
C {lab_wire.sym} 400 -40 0 0 {name=p1 sig_type=std_logic lab=o1_p}
C {lab_wire.sym} 400 40 0 0 {name=p2 sig_type=std_logic lab=o1_n}
C {lab_wire.sym} 1130 -10 0 0 {name=p3 sig_type=std_logic lab=o2_p}
C {lab_wire.sym} 1150 10 0 0 {name=p4 sig_type=std_logic lab=o2_n}
C {lab_wire.sym} 1480 -160 0 0 {name=p5 sig_type=std_logic lab=cmp_p}
C {lab_wire.sym} 1490 160 0 0 {name=p6 sig_type=std_logic lab=cmp_n}
C {lab_wire.sym} 1690 -160 0 0 {name=p7 sig_type=std_logic lab=p_buf}
C {lab_wire.sym} 1700 160 0 0 {name=p8 sig_type=std_logic lab=n_buf}
C {lab_wire.sym} 2130 20 0 0 {name=p9 sig_type=std_logic lab=q}
C {lab_wire.sym} 2150 60 0 0 {name=p10 sig_type=std_logic lab=qb}
C {lab_wire.sym} -100 260 1 0 {name=p11 sig_type=std_logic lab=s1_p}
C {lab_wire.sym} 100 260 1 0 {name=p12 sig_type=std_logic lab=s1_n}
C {lab_wire.sym} 700 260 1 0 {name=p13 sig_type=std_logic lab=s2_p}
C {lab_wire.sym} 900 260 1 0 {name=p14 sig_type=std_logic lab=s2_n}
C {lab_wire.sym} 800 -540 0 0 {name=p15 sig_type=std_logic lab=clkc1}
C {vsource.sym} -700 -1250 0 0 {name=VVDD value="1.8" savecurrent=false}
C {lab_pin.sym} -700 -1280 0 1 {name=l100 lab=vdd}
C {lab_pin.sym} -700 -1220 0 1 {name=l101 lab=GND}
C {vsource.sym} -570 -1250 0 0 {name=VVCM value="0.9" savecurrent=false}
C {lab_pin.sym} -570 -1280 0 1 {name=l102 lab=vcm}
C {lab_pin.sym} -570 -1220 0 1 {name=l103 lab=GND}
C {vsource.sym} -440 -1250 0 0 {name=VVREFP value="1.2" savecurrent=false}
C {lab_pin.sym} -440 -1280 0 1 {name=l104 lab=vrefp}
C {lab_pin.sym} -440 -1220 0 1 {name=l105 lab=GND}
C {vsource.sym} -310 -1250 0 0 {name=VVREFN value="0.6" savecurrent=false}
C {lab_pin.sym} -310 -1280 0 1 {name=l106 lab=vrefn}
C {lab_pin.sym} -310 -1220 0 1 {name=l107 lab=GND}
C {vsource.sym} -180 -1250 0 0 {name=VVBIAS1 value="0.58" savecurrent=false}
C {lab_pin.sym} -180 -1280 0 1 {name=l108 lab=vbias1}
C {lab_pin.sym} -180 -1220 0 1 {name=l109 lab=GND}
C {vsource.sym} -50 -1250 0 0 {name=VVBIAS2 value="0.58" savecurrent=false}
C {lab_pin.sym} -50 -1280 0 1 {name=l110 lab=vbias2}
C {lab_pin.sym} -50 -1220 0 1 {name=l111 lab=GND}
C {vsource.sym} 80 -1250 0 0 {name=VVCS1 value="0.925908120449107" savecurrent=false}
C {lab_pin.sym} 80 -1280 0 1 {name=l112 lab=vcs1}
C {lab_pin.sym} 80 -1220 0 1 {name=l113 lab=GND}
C {vsource.sym} 210 -1250 0 0 {name=VVCS2 value="0.925908120449107" savecurrent=false}
C {lab_pin.sym} 210 -1280 0 1 {name=l114 lab=vcs2}
C {lab_pin.sym} 210 -1220 0 1 {name=l115 lab=GND}
C {vsource.sym} 340 -1250 0 0 {name=VVCMS1 value="0.60354572" savecurrent=false}
C {lab_pin.sym} 340 -1280 0 1 {name=l116 lab=vcms1}
C {lab_pin.sym} 340 -1220 0 1 {name=l117 lab=GND}
C {vsource.sym} 470 -1250 0 0 {name=VVCMS2 value="0.60354572" savecurrent=false}
C {lab_pin.sym} 470 -1280 0 1 {name=l118 lab=vcms2}
C {lab_pin.sym} 470 -1220 0 1 {name=l119 lab=GND}
C {vsource.sym} 600 -1250 0 0 {name=VVBZL value="1.8" savecurrent=false}
C {lab_pin.sym} 600 -1280 0 1 {name=l120 lab=vbz_l}
C {lab_pin.sym} 600 -1220 0 1 {name=l121 lab=GND}
C {vsource.sym} 730 -1250 0 0 {name=VVBZR value="1.8" savecurrent=false}
C {lab_pin.sym} 730 -1280 0 1 {name=l122 lab=vbz_r}
C {lab_pin.sym} 730 -1220 0 1 {name=l123 lab=GND}
C {vsource.sym} 1000 -1250 0 0 {name=VCLKM value="PULSE(1.8 0 15.6n 1n 1n 124n 250n)" savecurrent=false}
C {lab_pin.sym} 1000 -1280 0 1 {name=l124 lab=clkm}
C {lab_pin.sym} 1000 -1220 0 1 {name=l125 lab=GND}
C {vsource.sym} 1300 -1250 0 0 {name=VRST value="PWL(0 1.8 5u 1.8 5.001u 0)" savecurrent=false}
C {lab_pin.sym} 1300 -1280 0 1 {name=l126 lab=rst}
C {lab_pin.sym} 1300 -1220 0 1 {name=l127 lab=GND}
C {vsource.sym} 1600 -1250 0 0 {name=VRSTB value="PWL(0 0 5u 0 5.001u 1.8)" savecurrent=false}
C {lab_pin.sym} 1600 -1280 0 1 {name=l128 lab=rstb}
C {lab_pin.sym} 1600 -1220 0 1 {name=l129 lab=GND}
C {vsource.sym} 1900 -1250 0 0 {name=VINP value="SIN(0.9 0.15 12.6953125k 9u)" savecurrent=false}
C {lab_pin.sym} 1900 -1280 0 1 {name=l130 lab=vin_p}
C {lab_pin.sym} 1900 -1220 0 1 {name=l131 lab=GND}
C {vsource.sym} 2200 -1250 0 0 {name=VINN value="SIN(0.9 -0.15 12.6953125k 9u)" savecurrent=false}
C {lab_pin.sym} 2200 -1280 0 1 {name=l132 lab=vin_n}
C {lab_pin.sym} 2200 -1220 0 1 {name=l133 lab=GND}
C {vcvs.sym} -600 1100 0 0 {name=E_VIN value=1}
C {lab_pin.sym} -640 1080 0 0 {name=l140 lab=vin_p}
C {lab_pin.sym} -640 1120 0 0 {name=l141 lab=vin_n}
C {lab_pin.sym} -600 1070 3 0 {name=l142 lab=vin_d}
C {lab_pin.sym} -600 1130 1 0 {name=l143 lab=GND}
C {vcvs.sym} -350 1100 0 0 {name=E_O1 value=1}
C {lab_pin.sym} -390 1080 0 0 {name=l144 lab=o1_p}
C {lab_pin.sym} -390 1120 0 0 {name=l145 lab=o1_n}
C {lab_pin.sym} -350 1070 3 0 {name=l146 lab=o1_d}
C {lab_pin.sym} -350 1130 1 0 {name=l147 lab=GND}
C {vcvs.sym} -100 1100 0 0 {name=E_O2 value=1}
C {lab_pin.sym} -140 1080 0 0 {name=l148 lab=o2_p}
C {lab_pin.sym} -140 1120 0 0 {name=l149 lab=o2_n}
C {lab_pin.sym} -100 1070 3 0 {name=l150 lab=o2_d}
C {lab_pin.sym} -100 1130 1 0 {name=l151 lab=GND}
C {vcvs.sym} 150 1100 0 0 {name=E_DAC value=1}
C {lab_pin.sym} 110 1080 0 0 {name=l152 lab=dac_p}
C {lab_pin.sym} 110 1120 0 0 {name=l153 lab=dac_n}
C {lab_pin.sym} 150 1070 3 0 {name=l154 lab=dac_d}
C {lab_pin.sym} 150 1130 1 0 {name=l155 lab=GND}
C {res.sym} 400 1100 0 0 {name=R_F1 value=10k footprint=1206 device=resistor m=1}
C {lab_pin.sym} 400 1070 3 0 {name=l156 lab=dac_d}
C {lab_pin.sym} 400 1130 1 0 {name=l157 lab=rc1}
C {capa.sym} 520 1100 0 0 {name=C_F1
m=1
value=318p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 520 1070 3 0 {name=l158 lab=rc1}
C {lab_pin.sym} 520 1130 1 0 {name=l159 lab=GND}
C {vcvs.sym} 750 1100 0 0 {name=E_BUF value=1}
C {lab_pin.sym} 710 1080 0 0 {name=l160 lab=rc1}
C {lab_pin.sym} 710 1120 0 0 {name=l161 lab=GND}
C {lab_pin.sym} 750 1070 3 0 {name=l162 lab=rc1b}
C {lab_pin.sym} 750 1130 1 0 {name=l163 lab=GND}
C {res.sym} 950 1100 0 0 {name=R_F2 value=10k footprint=1206 device=resistor m=1}
C {lab_pin.sym} 950 1070 3 0 {name=l164 lab=rc1b}
C {lab_pin.sym} 950 1130 1 0 {name=l165 lab=rec}
C {capa.sym} 1070 1100 0 0 {name=C_F2
m=1
value=318p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1070 1070 3 0 {name=l166 lab=rec}
C {lab_pin.sym} 1070 1130 1 0 {name=l167 lab=GND}
C {code.sym} -700 1250 0 0 {name=s1 only_toplevel=true value="
.lib /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice tt
.option scale=1e-6
.option reltol=1e-5 vntol=1e-8 abstol=1e-13
.temp 27
.nodeset v(q)=0 v(qb)=1.8

* Quick look: 90 us = 5 us reset + about one input period (78.8 us).
* Full SNDR run (1.03325 ms, 4096 bits) stays in top_level/closed_loop/run_closed_loop_f1.py.
.control
save v(vin_p) v(vin_n) v(vin_d) v(rec) v(dac_p) v(dac_n) v(dac_d)
save v(o1_p) v(o1_n) v(o1_d) v(o2_p) v(o2_n) v(o2_d) v(s1_p) v(s1_n) v(s2_p) v(s2_n)
save v(cmp_p) v(cmp_n) v(p_buf) v(n_buf) v(q) v(qb)
save v(clkm) v(phi1) v(phi1b) v(phi2) v(phi2b) v(clk) v(rst) v(vbn_b6) v(vbp_b6)
tran 1n 90u 0 100p
linearize
write tb_SD_TOP.raw
.endc
"}
C {launcher.sym} 2860 -1380 0 0 {name=h1
descr="Ctrl+Left-Click: load/unload waveforms"
tclcommand="xschem raw_read $netlist_dir/tb_SD_TOP.raw tran"
}
