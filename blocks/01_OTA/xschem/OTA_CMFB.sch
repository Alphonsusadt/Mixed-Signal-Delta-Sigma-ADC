v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 30 -630 30 -170 {lab=Vout_p}
N 30 -730 30 -690 {lab=VCC}
N 30 -730 1350 -730 {lab=VCC}
N 1350 -730 1350 -690 {lab=VCC}
N 1080 -730 1080 -690 {lab=VCC}
N 300 -730 300 -690 {lab=VCC}
N 300 -630 300 -170 {lab=GM7}
N 30 -110 30 -60 {lab=GND}
N 30 -60 1350 -60 {lab=GND}
N 1350 -110 1350 -60 {lab=GND}
N 1350 -630 1350 -170 {lab=Vout_n}
N 1080 -630 1080 -170 {lab=#net1}
N 810 -110 810 -60 {lab=GND}
N 1080 -110 1080 -60 {lab=GND}
N 570 -110 570 -60 {lab=GND}
N 300 -110 300 -60 {lab=GND}
N 570 -420 570 -170 {lab=Vo1_A}
N 810 -420 810 -170 {lab=Vo1_B}
N 570 -530 570 -480 {lab=#net2}
N 570 -530 810 -530 {lab=#net2}
N 810 -530 810 -480 {lab=#net2}
N 700 -630 700 -530 {lab=#net2}
N 700 -730 700 -690 {lab=VCC}
N 30 -690 30 -660 {lab=VCC}
N 300 -690 300 -660 {lab=VCC}
N 700 -690 700 -660 {lab=VCC}
N 1080 -690 1080 -660 {lab=VCC}
N 1350 -690 1350 -660 {lab=VCC}
N 1350 -140 1350 -110 {lab=GND}
N 1080 -140 1080 -110 {lab=GND}
N 810 -140 810 -110 {lab=GND}
N 570 -140 570 -110 {lab=GND}
N 300 -140 300 -110 {lab=GND}
N 30 -140 30 -110 {lab=GND}
N 30 -380 60 -380 {lab=Vout_p}
N 120 -380 140 -380 {lab=#net3}
N 1330 -380 1350 -380 {lab=Vout_n}
N 1240 -380 1270 -380 {lab=#net4}
N 200 -380 220 -380 {lab=Vo1_B}
N 220 -380 220 -140 {lab=Vo1_B}
N 70 -140 220 -140 {lab=Vo1_B}
N 220 -380 420 -380 {lab=Vo1_B}
N 420 -380 420 -320 {lab=Vo1_B}
N 1160 -380 1180 -380 {lab=Vo1_A}
N 1160 -380 1160 -140 {lab=Vo1_A}
N 1160 -140 1310 -140 {lab=Vo1_A}
N 960 -380 1160 -380 {lab=Vo1_A}
N 960 -380 960 -320 {lab=Vo1_A}
N 170 -380 170 -60 {lab=GND}
N 1210 -380 1210 -60 {lab=GND}
N 160 -660 160 -570 {lab=GM7}
N 160 -570 300 -570 {lab=GM7}
N 1210 -660 1210 -560 {lab=#net1}
N 1080 -560 1210 -560 {lab=#net1}
N 610 -140 770 -140 {lab=Vbias}
N 810 -480 810 -450 {lab=#net2}
N 570 -480 570 -450 {lab=#net2}
N 170 -460 170 -420 {lab=Vbz_L}
N 510 -450 530 -450 {lab=Vin_p}
N 850 -450 870 -450 {lab=Vin_n}
N 1210 -460 1210 -420 {lab=Vbz_R}
N 680 -150 680 -140 {lab=Vbias}
N 1350 -380 1370 -380 {lab=Vout_n}
N 340 -140 420 -140 {lab=Vo1_B}
N 420 -320 420 -140 {lab=Vo1_B}
N 420 -320 620 -320 {lab=Vo1_B}
N 960 -140 1040 -140 {lab=Vo1_A}
N 960 -320 960 -140 {lab=Vo1_A}
N 760 -320 960 -320 {lab=Vo1_A}
N 640 -400 760 -320 {lab=Vo1_A}
N 620 -320 740 -400 {lab=Vo1_B}
N 740 -400 810 -400 {lab=Vo1_B}
N 570 -400 640 -400 {lab=Vo1_A}
N 640 -660 660 -660 {lab=Vcmfb1}
N 10 -380 30 -380 {lab=Vout_p}
N 700 -760 700 -730 {lab=VCC}
N 680 -60 680 -30 {lab=GND}
N 500 -400 570 -400 {lab=Vo1_A}
N 810 -400 880 -400 {lab=Vo1_B}
N 1120 -660 1210 -660 {lab=#net1}
N 1260 -660 1310 -660 {lab=GM7}
N 160 -660 260 -660 {lab=GM7}
N 70 -660 120 -660 {lab=#net5}
C {sky130_fd_pr/pfet_01v8.sym} 550 -450 2 1 {name=M1
W=240
L=0.6
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 830 -450 2 0 {name=M2
W=240
L=0.6
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 590 -140 0 1 {name=M3
W=8
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 790 -140 0 0 {name=M4
W=8
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 320 -140 0 1 {name=M5
W=40
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 1060 -140 0 0 {name=M6
W=40
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 280 -660 2 1 {name=M7
W=60
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1100 -660 2 0 {name=M8
W=60
L=2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 50 -660 2 0 {name=M9
W=60
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1330 -660 2 1 {name=M10
W=60
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 50 -140 0 1 {name=M11
W=80
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 1330 -140 0 0 {name=M12
W=80
L=1
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 680 -660 2 1 {name=M13
W=480
L=1.2
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/cap_mim_m3_1.sym} 90 -380 3 0 {name=C1 model=cap_mim_m3_1 W=1 L=1 MF=1000 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 170 -400 3 1 {name=Mbz1
W=5
L=5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1300 -380 3 1 {name=C2 model=cap_mim_m3_1 W=1 L=1 MF=1000 spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 1210 -400 3 1 {name=M14
W=5
L=5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {ipin.sym} 510 -450 0 0 {name=p1 lab=Vin_p}
C {ipin.sym} 870 -450 2 0 {name=p2 lab=Vin_n}
C {ipin.sym} 680 -150 1 0 {name=p3 lab=Vbias}
C {ipin.sym} 1210 -460 2 0 {name=p4 lab=Vbz_R}
C {ipin.sym} 170 -460 2 0 {name=p5 lab=Vbz_L}
C {ipin.sym} 640 -660 0 0 {name=p6 lab=Vcmfb1}
C {opin.sym} 10 -380 2 0 {name=p7 lab=Vout_p}
C {opin.sym} 1370 -380 0 0 {name=p8 lab=Vout_n}
C {iopin.sym} 700 -760 0 0 {name=p9 lab=VCC}
C {iopin.sym} 680 -30 0 0 {name=p10 lab=GND}
C {opin.sym} 500 -400 2 0 {name=p11 lab=Vo1_A}
C {opin.sym} 880 -400 0 0 {name=p12 lab=Vo1_B}
C {lab_wire.sym} 1290 -660 0 0 {name=p13 sig_type=std_logic lab=GM7}
C {lab_wire.sym} 210 -570 0 0 {name=p14 sig_type=std_logic lab=GM7}
C {lab_wire.sym} 80 -660 0 1 {name=p15 sig_type=std_logic lab=GM8}
C {lab_wire.sym} 1160 -560 0 1 {name=p16 sig_type=std_logic lab=GM8}
