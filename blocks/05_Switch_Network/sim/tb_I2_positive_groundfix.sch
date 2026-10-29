v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {I2 ZERO | GROUND FIX | DIFFERENTIAL SWITCHED-CAPACITOR INTEGRATOR} 20 -400 0 0 0.5 0.5 {}
T {4 MHz | GitHub 720a907; OTA compensation follows local cell | Cs=1pF, Cf=2pF, CL=200fF per side (trial)} 20 -350 0 0 0.3 0.3 {}
T {Input -> sampling capacitors -> transfer switches -> OTA -> output} 20 -310 0 0 0.28 0.28 {}
T {PRECHARGE: sum/output -> VCM; ON 0..20.020 us, OFF after 20.021 us} 20 1120 0 0 0.3 0.3 {}
T {SUPPLIES / BIAS | CLOCK / RESET | INPUT STIMULUS} 20 1590 0 0 0.35 0.35 {}
T {VDD_SRC} 110 1730 0 0 0.22 0.22 {}
T {1.8} 110 1760 0 0 0.22 0.22 {}
T {VCM_SRC} 500 1730 0 0 0.22 0.22 {}
T {0.9} 500 1760 0 0 0.22 0.22 {}
T {VBIAS_SRC} 890 1730 0 0 0.22 0.22 {}
T {0.58} 890 1760 0 0 0.22 0.22 {}
T {VBZL_SRC} 1280 1730 0 0 0.22 0.22 {}
T {1.8} 1280 1760 0 0 0.22 0.22 {}
T {VBZR_SRC} 1670 1730 0 0 0.22 0.22 {}
T {1.8} 1670 1760 0 0 0.22 0.22 {}
T {VCS_SRC} 110 1990 0 0 0.22 0.22 {}
T {0.925908120449107} 110 2020 0 0 0.22 0.22 {}
T {VCM1_SRC} 500 1990 0 0 0.22 0.22 {}
T {0.60354572} 500 2020 0 0 0.22 0.22 {}
T {VPHI1_SRC} 890 1990 0 0 0.22 0.22 {}
T {PULSE / 4 MHz} 890 2020 0 0 0.22 0.22 {}
T {VPHI1B_SRC} 1280 1990 0 0 0.22 0.22 {}
T {PULSE / 4 MHz} 1280 2020 0 0 0.22 0.22 {}
T {VPHI2_SRC} 1670 1990 0 0 0.22 0.22 {}
T {PULSE / 4 MHz} 1670 2020 0 0 0.22 0.22 {}
T {VPHI2B_SRC} 110 2250 0 0 0.22 0.22 {}
T {PULSE / 4 MHz} 110 2280 0 0 0.22 0.22 {}
T {VRST_SRC} 500 2250 0 0 0.22 0.22 {}
T {PWL (see README)} 500 2280 0 0 0.22 0.22 {}
T {VRSTB_SRC} 890 2250 0 0 0.22 0.22 {}
T {PWL (see README)} 890 2280 0 0 0.22 0.22 {}
T {VINP_SRC} 1280 2250 0 0 0.22 0.22 {}
T {DC 0.9 V} 1280 2280 0 0 0.22 0.22 {}
T {VINN_SRC} 1670 2250 0 0 0.22 0.22 {}
T {DC 0.9 V} 1670 2280 0 0 0.22 0.22 {}
T {Open this sheet first. Select OTA / CMFB / TG and press e to inspect its real schematic.} 20 2470 0 0 0.28 0.28 {}
T {Trial standalone I2. Architecture coefficient, real quantizer loading, and PVT remain to be verified.} 20 2520 0 0 0.25 0.25 {}
N 200 -130 200 -100 {lab=phi1b}
N 200 100 200 130 {lab=phi1}
N 280 -30 310 -30 {lab=vdd}
N 280 30 310 30 {lab=0}
N 20 0 100 0 {lab=vin2_p}
N 300 0 470 0 {lab=a2_p}
N 530 0 700 0 {lab=b2_p}
N 800 -130 800 -100 {lab=phi2b}
N 800 100 800 130 {lab=phi2}
N 880 -30 910 -30 {lab=vdd}
N 880 30 910 30 {lab=0}
N 900 0 1000 0 {lab=sum2_p}
N 200 170 200 200 {lab=phi2b}
N 200 400 200 430 {lab=phi2}
N 90 270 120 270 {lab=vdd}
N 90 330 120 330 {lab=0}
N 360 0 360 300 {lab=a2_p}
N 300 300 360 300 {lab=a2_p}
N 60 300 100 300 {lab=vcm}
N 800 170 800 200 {lab=phi1b}
N 800 400 800 430 {lab=phi1}
N 880 270 910 270 {lab=vdd}
N 880 330 910 330 {lab=0}
N 620 0 620 300 {lab=b2_p}
N 620 300 700 300 {lab=b2_p}
N 900 300 940 300 {lab=vcm}
N 200 470 200 500 {lab=phi1b}
N 200 700 200 730 {lab=phi1}
N 280 570 310 570 {lab=vdd}
N 280 630 310 630 {lab=0}
N 20 600 100 600 {lab=vin2_n}
N 300 600 470 600 {lab=a2_n}
N 530 600 700 600 {lab=b2_n}
N 800 470 800 500 {lab=phi2b}
N 800 700 800 730 {lab=phi2}
N 880 570 910 570 {lab=vdd}
N 880 630 910 630 {lab=0}
N 900 600 1000 600 {lab=sum2_n}
N 200 770 200 800 {lab=phi2b}
N 200 1000 200 1030 {lab=phi2}
N 90 870 120 870 {lab=vdd}
N 90 930 120 930 {lab=0}
N 360 600 360 900 {lab=a2_n}
N 300 900 360 900 {lab=a2_n}
N 60 900 100 900 {lab=vcm}
N 800 770 800 800 {lab=phi1b}
N 800 1000 800 1030 {lab=phi1}
N 880 870 910 870 {lab=vdd}
N 880 930 910 930 {lab=0}
N 620 600 620 900 {lab=b2_n}
N 620 900 700 900 {lab=b2_n}
N 900 900 940 900 {lab=vcm}
N 1000 0 1000 300 {lab=sum2_p}
N 1000 300 1100 300 {lab=sum2_p}
N 1000 320 1000 600 {lab=sum2_n}
N 1000 320 1100 320 {lab=sum2_n}
N 1330 300 1630 300 {lab=out2_p}
N 1630 0 1630 300 {lab=out2_p}
N 1630 0 1910 0 {lab=out2_p}
N 1330 320 1690 320 {lab=out2_n}
N 1690 320 1690 600 {lab=out2_n}
N 1690 600 1910 600 {lab=out2_n}
N 1000 -200 1000 0 {lab=sum2_p}
N 1000 -200 1280 -200 {lab=sum2_p}
N 1340 -200 1630 -200 {lab=out2_p}
N 1630 -200 1630 0 {lab=out2_p}
N 1000 600 1000 1040 {lab=sum2_n}
N 1000 1040 1280 1040 {lab=sum2_n}
N 1340 1040 1690 1040 {lab=out2_n}
N 1690 600 1690 1040 {lab=out2_n}
N 1910 0 1910 70 {lab=out2_p}
N 1910 130 1910 150 {lab=0}
N 1910 600 1910 670 {lab=out2_n}
N 1910 730 1910 750 {lab=0}
N 1040 260 1100 260 {lab=vbz_r}
N 1040 280 1100 280 {lab=vbz_l}
N 1060 340 1100 340 {lab=vbias}
N 1330 240 1360 240 {lab=vdd}
N 1330 340 1360 340 {lab=0}
N 1360 -20 1410 -20 {lab=vcmfb2}
N 1410 -20 1410 200 {lab=vcmfb2}
N 1080 200 1410 200 {lab=vcmfb2}
N 1080 200 1080 240 {lab=vcmfb2}
N 1080 240 1100 240 {lab=vcmfb2}
N 1330 260 1470 260 {lab=vo1_2b}
N 1470 140 1470 260 {lab=vo1_2b}
N 1110 140 1470 140 {lab=vo1_2b}
N 1110 80 1110 140 {lab=vo1_2b}
N 1110 80 1140 80 {lab=vo1_2b}
N 1330 280 1500 280 {lab=vo1_2a}
N 1500 160 1500 280 {lab=vo1_2a}
N 1090 160 1500 160 {lab=vo1_2a}
N 1090 100 1090 160 {lab=vo1_2a}
N 1090 100 1140 100 {lab=vo1_2a}
N 1110 -40 1140 -40 {lab=vcs}
N 1110 -20 1140 -20 {lab=phi1b}
N 1110 0 1140 0 {lab=phi1}
N 1110 20 1140 20 {lab=phi2b}
N 1110 40 1140 40 {lab=phi2}
N 1110 60 1140 60 {lab=vcm_stage1}
N 1360 -40 1390 -40 {lab=vdd}
N 1360 0 1390 0 {lab=0}
N 1630 300 1630 650 {lab=out2_p}
N 1390 650 1630 650 {lab=out2_p}
N 1390 650 1390 680 {lab=out2_p}
N 1690 600 1690 670 {lab=out2_n}
N 1510 670 1690 670 {lab=out2_n}
N 1510 670 1510 680 {lab=out2_n}
N 1450 610 1450 680 {lab=vdd}
N 1450 960 1450 990 {lab=0}
N 1260 880 1300 880 {lab=vcm}
N 200 1200 200 1230 {lab=rstb}
N 200 1430 200 1460 {lab=rst}
N 280 1300 310 1300 {lab=vdd}
N 280 1360 310 1360 {lab=0}
N 60 1330 100 1330 {lab=sum2_p}
N 300 1330 340 1330 {lab=vcm}
N 340 1330 340 1500 {lab=vcm}
N 670 1200 670 1230 {lab=rstb}
N 670 1430 670 1460 {lab=rst}
N 750 1300 780 1300 {lab=vdd}
N 750 1360 780 1360 {lab=0}
N 530 1330 570 1330 {lab=sum2_n}
N 770 1330 810 1330 {lab=vcm}
N 810 1330 810 1500 {lab=vcm}
N 1140 1200 1140 1230 {lab=rstb}
N 1140 1430 1140 1460 {lab=rst}
N 1220 1300 1250 1300 {lab=vdd}
N 1220 1360 1250 1360 {lab=0}
N 1000 1330 1040 1330 {lab=out2_p}
N 1240 1330 1280 1330 {lab=vcm}
N 1280 1330 1280 1500 {lab=vcm}
N 1610 1200 1610 1230 {lab=rstb}
N 1610 1430 1610 1460 {lab=rst}
N 1690 1300 1720 1300 {lab=vdd}
N 1690 1360 1720 1360 {lab=0}
N 1470 1330 1510 1330 {lab=out2_n}
N 1710 1330 1750 1330 {lab=vcm}
N 1750 1330 1750 1500 {lab=vcm}
N 340 1500 1750 1500 {lab=vcm}
N 80 1680 80 1710 {lab=vdd}
N 80 1770 80 1790 {lab=0}
N 470 1680 470 1710 {lab=vcm}
N 470 1770 470 1790 {lab=0}
N 860 1680 860 1710 {lab=vbias}
N 860 1770 860 1790 {lab=0}
N 1250 1680 1250 1710 {lab=vbz_l}
N 1250 1770 1250 1790 {lab=0}
N 1640 1680 1640 1710 {lab=vbz_r}
N 1640 1770 1640 1790 {lab=0}
N 80 1940 80 1970 {lab=vcs}
N 80 2030 80 2050 {lab=0}
N 470 1940 470 1970 {lab=vcm_stage1}
N 470 2030 470 2050 {lab=0}
N 860 1940 860 1970 {lab=phi1}
N 860 2030 860 2050 {lab=0}
N 1250 1940 1250 1970 {lab=phi1b}
N 1250 2030 1250 2050 {lab=0}
N 1640 1940 1640 1970 {lab=phi2}
N 1640 2030 1640 2050 {lab=0}
N 80 2200 80 2230 {lab=phi2b}
N 80 2290 80 2310 {lab=0}
N 470 2200 470 2230 {lab=rst}
N 470 2290 470 2310 {lab=0}
N 860 2200 860 2230 {lab=rstb}
N 860 2290 860 2310 {lab=0}
N 1250 2200 1250 2230 {lab=vin2_p}
N 1250 2290 1250 2310 {lab=0}
N 1640 2200 1640 2230 {lab=vin2_n}
N 1640 2290 1640 2310 {lab=0}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 200 0 0 0 {name=XSAMP_P }
C {lab_wire.sym} 200 -130 0 0 {name=L1 lab=phi1b}
C {lab_wire.sym} 200 130 0 0 {name=L2 lab=phi1}
C {lab_wire.sym} 310 -30 0 0 {name=L3 lab=vdd}
C {lab_wire.sym} 310 30 0 0 {name=L4 lab=0}
C {lab_wire.sym} 20 0 0 0 {name=L5 lab=vin2_p}
C {lab_wire.sym} 360 0 0 0 {name=L6 lab=a2_p}
C {capa.sym} 500 0 3 0 {name=CSP value=1p}
C {lab_wire.sym} 620 0 0 0 {name=L7 lab=b2_p}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 800 0 0 0 {name=XTRANSFER_P }
C {lab_wire.sym} 800 -130 0 0 {name=L8 lab=phi2b}
C {lab_wire.sym} 800 130 0 0 {name=L9 lab=phi2}
C {lab_wire.sym} 910 -30 0 0 {name=L10 lab=vdd}
C {lab_wire.sym} 910 30 0 0 {name=L11 lab=0}
C {lab_wire.sym} 970 0 0 0 {name=L12 lab=sum2_p}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 200 300 0 1 {name=XREFT_P }
C {lab_wire.sym} 200 170 0 0 {name=L13 lab=phi2b}
C {lab_wire.sym} 200 430 0 0 {name=L14 lab=phi2}
C {lab_wire.sym} 90 270 0 0 {name=L15 lab=vdd}
C {lab_wire.sym} 90 330 0 0 {name=L16 lab=0}
C {lab_wire.sym} 60 300 0 0 {name=L17 lab=vcm}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 800 300 0 0 {name=XREFS_P }
C {lab_wire.sym} 800 170 0 0 {name=L18 lab=phi1b}
C {lab_wire.sym} 800 430 0 0 {name=L19 lab=phi1}
C {lab_wire.sym} 910 270 0 0 {name=L20 lab=vdd}
C {lab_wire.sym} 910 330 0 0 {name=L21 lab=0}
C {lab_wire.sym} 940 300 0 0 {name=L22 lab=vcm}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 200 600 0 0 {name=XSAMP_N }
C {lab_wire.sym} 200 470 0 0 {name=L23 lab=phi1b}
C {lab_wire.sym} 200 730 0 0 {name=L24 lab=phi1}
C {lab_wire.sym} 310 570 0 0 {name=L25 lab=vdd}
C {lab_wire.sym} 310 630 0 0 {name=L26 lab=0}
C {lab_wire.sym} 20 600 0 0 {name=L27 lab=vin2_n}
C {lab_wire.sym} 360 600 0 0 {name=L28 lab=a2_n}
C {capa.sym} 500 600 3 0 {name=CSN value=1p}
C {lab_wire.sym} 620 600 0 0 {name=L29 lab=b2_n}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 800 600 0 0 {name=XTRANSFER_N }
C {lab_wire.sym} 800 470 0 0 {name=L30 lab=phi2b}
C {lab_wire.sym} 800 730 0 0 {name=L31 lab=phi2}
C {lab_wire.sym} 910 570 0 0 {name=L32 lab=vdd}
C {lab_wire.sym} 910 630 0 0 {name=L33 lab=0}
C {lab_wire.sym} 970 600 0 0 {name=L34 lab=sum2_n}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 200 900 0 1 {name=XREFT_N }
C {lab_wire.sym} 200 770 0 0 {name=L35 lab=phi2b}
C {lab_wire.sym} 200 1030 0 0 {name=L36 lab=phi2}
C {lab_wire.sym} 90 870 0 0 {name=L37 lab=vdd}
C {lab_wire.sym} 90 930 0 0 {name=L38 lab=0}
C {lab_wire.sym} 60 900 0 0 {name=L39 lab=vcm}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 800 900 0 0 {name=XREFS_N }
C {lab_wire.sym} 800 770 0 0 {name=L40 lab=phi1b}
C {lab_wire.sym} 800 1030 0 0 {name=L41 lab=phi1}
C {lab_wire.sym} 910 870 0 0 {name=L42 lab=vdd}
C {lab_wire.sym} 910 930 0 0 {name=L43 lab=0}
C {lab_wire.sym} 940 900 0 0 {name=L44 lab=vcm}
C {blocks/01_OTA/xschem/OTA_CMFB.sym} 1250 290 0 0 {name=XOTA2 }
C {lab_wire.sym} 1870 0 0 0 {name=L45 lab=out2_p}
C {lab_wire.sym} 1870 600 0 0 {name=L46 lab=out2_n}
C {capa.sym} 1310 -200 3 0 {name=CFP value=2p}
C {capa.sym} 1310 1040 3 0 {name=CFN value=2p}
C {capa.sym} 1910 100 0 0 {name=CLP value=200f}
C {gnd.sym} 1910 150 0 0 {name=GCLP lab=0}
C {capa.sym} 1910 700 0 0 {name=CLN value=200f}
C {gnd.sym} 1910 750 0 0 {name=GCLN lab=0}
C {lab_wire.sym} 1040 260 0 0 {name=L47 lab=vbz_r}
C {lab_wire.sym} 1040 280 0 0 {name=L48 lab=vbz_l}
C {lab_wire.sym} 1060 340 0 0 {name=L49 lab=vbias}
C {lab_wire.sym} 1360 240 0 0 {name=L50 lab=vdd}
C {lab_wire.sym} 1360 340 0 0 {name=L51 lab=0}
C {blocks/02_CMFB/xschem/CMFB.sym} 1250 40 0 0 {name=XSCM2 }
C {lab_wire.sym} 1410 180 0 0 {name=L52 lab=vcmfb2}
C {lab_wire.sym} 1440 140 0 0 {name=L53 lab=vo1_2b}
C {lab_wire.sym} 1440 160 0 0 {name=L54 lab=vo1_2a}
C {lab_wire.sym} 1110 -40 0 0 {name=L55 lab=vcs}
C {lab_wire.sym} 1110 -20 0 0 {name=L56 lab=phi1b}
C {lab_wire.sym} 1110 0 0 0 {name=L57 lab=phi1}
C {lab_wire.sym} 1110 20 0 0 {name=L58 lab=phi2b}
C {lab_wire.sym} 1110 40 0 0 {name=L59 lab=phi2}
C {lab_wire.sym} 1110 60 0 0 {name=L60 lab=vcm_stage1}
C {lab_wire.sym} 1390 -40 0 0 {name=L61 lab=vdd}
C {lab_wire.sym} 1390 0 0 0 {name=L62 lab=0}
C {blocks/02_CMFB/xschem/CMFB_OUT_I2_Wired.sym} 1450 820 0 0 {name=XOCM2 }
C {lab_wire.sym} 1450 610 0 0 {name=L63 lab=vdd}
C {lab_wire.sym} 1450 990 0 0 {name=L64 lab=0}
C {lab_wire.sym} 1260 880 0 0 {name=L65 lab=vcm}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 200 1330 0 0 {name=XPRE_SUM2_P }
C {lab_wire.sym} 200 1200 0 0 {name=L66 lab=rstb}
C {lab_wire.sym} 200 1460 0 0 {name=L67 lab=rst}
C {lab_wire.sym} 310 1300 0 0 {name=L68 lab=vdd}
C {lab_wire.sym} 310 1360 0 0 {name=L69 lab=0}
C {lab_wire.sym} 60 1330 0 0 {name=L70 lab=sum2_p}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 670 1330 0 0 {name=XPRE_SUM2_N }
C {lab_wire.sym} 670 1200 0 0 {name=L71 lab=rstb}
C {lab_wire.sym} 670 1460 0 0 {name=L72 lab=rst}
C {lab_wire.sym} 780 1300 0 0 {name=L73 lab=vdd}
C {lab_wire.sym} 780 1360 0 0 {name=L74 lab=0}
C {lab_wire.sym} 530 1330 0 0 {name=L75 lab=sum2_n}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 1140 1330 0 0 {name=XPRE_OUT2_P }
C {lab_wire.sym} 1140 1200 0 0 {name=L76 lab=rstb}
C {lab_wire.sym} 1140 1460 0 0 {name=L77 lab=rst}
C {lab_wire.sym} 1250 1300 0 0 {name=L78 lab=vdd}
C {lab_wire.sym} 1250 1360 0 0 {name=L79 lab=0}
C {lab_wire.sym} 1000 1330 0 0 {name=L80 lab=out2_p}
C {blocks/05_Switch_Network/xschem/TG_SC_LVT.sym} 1610 1330 0 0 {name=XPRE_OUT2_N }
C {lab_wire.sym} 1610 1200 0 0 {name=L81 lab=rstb}
C {lab_wire.sym} 1610 1460 0 0 {name=L82 lab=rst}
C {lab_wire.sym} 1720 1300 0 0 {name=L83 lab=vdd}
C {lab_wire.sym} 1720 1360 0 0 {name=L84 lab=0}
C {lab_wire.sym} 1470 1330 0 0 {name=L85 lab=out2_n}
C {lab_wire.sym} 340 1500 0 0 {name=L86 lab=vcm}
C {vsource.sym} 80 1740 0 0 {name=VDD_SRC value="1.8" hide_texts=true}
C {lab_wire.sym} 80 1680 0 0 {name=L87 lab=vdd}
C {gnd.sym} 80 1790 0 0 {name=gVDD_SRC lab=0}
C {vsource.sym} 470 1740 0 0 {name=VCM_SRC value="0.9" hide_texts=true}
C {lab_wire.sym} 470 1680 0 0 {name=L88 lab=vcm}
C {gnd.sym} 470 1790 0 0 {name=gVCM_SRC lab=0}
C {vsource.sym} 860 1740 0 0 {name=VBIAS_SRC value="0.58" hide_texts=true}
C {lab_wire.sym} 860 1680 0 0 {name=L89 lab=vbias}
C {gnd.sym} 860 1790 0 0 {name=gVBIAS_SRC lab=0}
C {vsource.sym} 1250 1740 0 0 {name=VBZL_SRC value="1.8" hide_texts=true}
C {lab_wire.sym} 1250 1680 0 0 {name=L90 lab=vbz_l}
C {gnd.sym} 1250 1790 0 0 {name=gVBZL_SRC lab=0}
C {vsource.sym} 1640 1740 0 0 {name=VBZR_SRC value="1.8" hide_texts=true}
C {lab_wire.sym} 1640 1680 0 0 {name=L91 lab=vbz_r}
C {gnd.sym} 1640 1790 0 0 {name=gVBZR_SRC lab=0}
C {vsource.sym} 80 2000 0 0 {name=VCS_SRC value="0.925908120449107" hide_texts=true}
C {lab_wire.sym} 80 1940 0 0 {name=L92 lab=vcs}
C {gnd.sym} 80 2050 0 0 {name=gVCS_SRC lab=0}
C {vsource.sym} 470 2000 0 0 {name=VCM1_SRC value="0.60354572" hide_texts=true}
C {lab_wire.sym} 470 1940 0 0 {name=L93 lab=vcm_stage1}
C {gnd.sym} 470 2050 0 0 {name=gVCM1_SRC lab=0}
C {vsource.sym} 860 2000 0 0 {name=VPHI1_SRC value="PULSE(0 1.8 30n 1n 1n 110n 250n)" hide_texts=true}
C {lab_wire.sym} 860 1940 0 0 {name=L94 lab=phi1}
C {gnd.sym} 860 2050 0 0 {name=gVPHI1_SRC lab=0}
C {vsource.sym} 1250 2000 0 0 {name=VPHI1B_SRC value="PULSE(1.8 0 30n 1n 1n 110n 250n)" hide_texts=true}
C {lab_wire.sym} 1250 1940 0 0 {name=L95 lab=phi1b}
C {gnd.sym} 1250 2050 0 0 {name=gVPHI1B_SRC lab=0}
C {vsource.sym} 1640 2000 0 0 {name=VPHI2_SRC value="PULSE(0 1.8 155n 1n 1n 110n 250n)" hide_texts=true}
C {lab_wire.sym} 1640 1940 0 0 {name=L96 lab=phi2}
C {gnd.sym} 1640 2050 0 0 {name=gVPHI2_SRC lab=0}
C {vsource.sym} 80 2260 0 0 {name=VPHI2B_SRC value="PULSE(1.8 0 155n 1n 1n 110n 250n)" hide_texts=true}
C {lab_wire.sym} 80 2200 0 0 {name=L97 lab=phi2b}
C {gnd.sym} 80 2310 0 0 {name=gVPHI2B_SRC lab=0}
C {vsource.sym} 470 2260 0 0 {name=VRST_SRC value="PWL(0 1.8 20.020u 1.8 20.021u 0 30u 0)" hide_texts=true}
C {lab_wire.sym} 470 2200 0 0 {name=L98 lab=rst}
C {gnd.sym} 470 2310 0 0 {name=gVRST_SRC lab=0}
C {vsource.sym} 860 2260 0 0 {name=VRSTB_SRC value="PWL(0 0 20.020u 0 20.021u 1.8 30u 1.8)" hide_texts=true}
C {lab_wire.sym} 860 2200 0 0 {name=L99 lab=rstb}
C {gnd.sym} 860 2310 0 0 {name=gVRSTB_SRC lab=0}
C {vsource.sym} 1250 2260 0 0 {name=VINP_SRC value="PWL(0 0.9 22.005u 0.9 22.006u 0.905 24.005u 0.905 24.006u 0.9 30u 0.9)" hide_texts=true}
C {lab_wire.sym} 1250 2200 0 0 {name=L100 lab=vin2_p}
C {gnd.sym} 1250 2310 0 0 {name=gVINP_SRC lab=0}
C {vsource.sym} 1640 2260 0 0 {name=VINN_SRC value="PWL(0 0.9 22.005u 0.9 22.006u 0.895 24.005u 0.895 24.006u 0.9 30u 0.9)" hide_texts=true}
C {lab_wire.sym} 1640 2200 0 0 {name=L101 lab=vin2_n}
C {gnd.sym} 1640 2310 0 0 {name=gVINN_SRC lab=0}
C {code.sym} 2070 1690 0 0 {name=SIM only_toplevel=true value="
* GitHub 720a907: OTA C1/C2 MF=1000; no device sizes modified.
* Trial characterization values only. Set from architecture before I2 signoff.
.param CS2_TEST=1p CF2_TEST=2p CL2_TEST=200f I2_ARCH_CONFIRMED=0
.option scale=1e-6 reltol=1e-5 abstol=1e-14 vntol=1e-8
.temp 27
.control
save all
set wr_singlescale
set wr_vecnames
set numdgt=15
tran 200p 30u 0 100p
let vd2=v(OUT2_P)-v(OUT2_N)
let cm2=(v(OUT2_P)+v(OUT2_N))/2
let cmfirst2=(v(VO1_2A)+v(VO1_2B))/2
meas tran VDD_END FIND v(vdd) AT=29.99u
meas tran VINP_END FIND v(vin2_p) AT=29.99u
meas tran VINN_END FIND v(vin2_n) AT=29.99u
meas tran RST_END FIND v(rst) AT=29.99u
meas tran PHI1_MIN MIN v(phi1) FROM=29u TO=30u
meas tran PHI1_MAX MAX v(phi1) FROM=29u TO=30u
meas tran VD_BEFORE FIND vd2 AT=22.014u
meas tran VD_CYCLE8 FIND vd2 AT=24.014u
meas tran VD_CYCLE24 FIND vd2 AT=28.014u
meas tran CM_END AVG cm2 FROM=29u TO=30u
meas tran CM_FIRST_END AVG cmfirst2 FROM=29u TO=30u
meas tran CM_MIN MIN cm2 FROM=21u TO=30u
meas tran CM_MAX MAX cm2 FROM=21u TO=30u
meas tran DIFF_MIN MIN vd2 FROM=21u TO=30u
meas tran DIFF_MAX MAX vd2 FROM=21u TO=30u
let burst_delta=VD_CYCLE8-VD_BEFORE
let hold_drift=VD_CYCLE24-VD_CYCLE8
print burst_delta hold_drift
wrdata waveform_I2_zero_groundfix.dat v(VIN2_P) v(VIN2_N) v(SUM2_P) v(SUM2_N) v(OUT2_P) v(OUT2_N) v(VO1_2A) v(VO1_2B) v(VCMFB2) v(PHI1) v(PHI2) v(RST) i(VDD_SRC) v(vdd) v(vcm) v(phi1b) v(phi2b) v(rstb)
echo I2_TRIAL_ONLY_NO_ARCHITECTURE_OR_PVT_PASS
plot v(OUT2_P) v(OUT2_N) cm2
plot vd2
.endc
"}
C {sky130_fd_pr/corner.sym} 2070 1910 0 0 {name=CORNER only_toplevel=false corner=tt}
