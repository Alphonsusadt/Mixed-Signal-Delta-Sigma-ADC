v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 210 -880 1290 -880 {lab=VDD}
N 210 -880 210 -840 {lab=VDD}
N 210 -840 210 -810 {lab=VDD}
N 390 -880 390 -840 {lab=VDD}
N 390 -840 390 -810 {lab=VDD}
N 570 -880 570 -840 {lab=VDD}
N 570 -840 570 -810 {lab=VDD}
N 930 -880 930 -840 {lab=VDD}
N 930 -840 930 -810 {lab=VDD}
N 1110 -880 1110 -840 {lab=VDD}
N 1110 -840 1110 -810 {lab=VDD}
N 1290 -880 1290 -840 {lab=VDD}
N 1290 -840 1290 -810 {lab=VDD}
N 750 -930 750 -880 {lab=VDD}
N 130 -810 170 -810 {lab=CLK}
N 310 -810 350 -810 {lab=CLK}
N 1150 -810 1190 -810 {lab=CLK}
N 1330 -810 1370 -810 {lab=CLK}
N 670 -180 710 -180 {lab=CLK}
N 570 -780 570 -540 {lab=Vout_P}
N 930 -780 930 -540 {lab=Vout_N}
N 540 -610 570 -610 {lab=Vout_P}
N 930 -610 960 -610 {lab=Vout_N}
N 610 -810 660 -810 {lab=Vout_N}
N 840 -810 890 -810 {lab=Vout_P}
N 610 -510 660 -510 {lab=Vout_N}
N 840 -510 890 -510 {lab=Vout_P}
N 210 -780 210 -750 {lab=P}
N 390 -780 390 -750 {lab=Vout_P}
N 1110 -780 1110 -750 {lab=Vout_N}
N 1290 -780 1290 -750 {lab=Q}
N 570 -480 570 -340 {lab=P}
N 930 -480 930 -340 {lab=Q}
N 520 -510 570 -510 {lab=GND}
N 930 -510 980 -510 {lab=GND}
N 570 -310 620 -310 {lab=GND}
N 880 -310 930 -310 {lab=GND}
N 750 -180 800 -180 {lab=GND}
N 510 -310 530 -310 {lab=Vin1}
N 970 -310 990 -310 {lab=Vin2}
N 570 -280 570 -250 {lab=TAIL}
N 570 -250 930 -250 {lab=TAIL}
N 930 -280 930 -250 {lab=TAIL}
N 750 -250 750 -210 {lab=TAIL}
N 750 -150 750 -120 {lab=GND}
C {sky130_fd_pr/pfet_01v8.sym} 190 -810 0 0 {name=S1
W=1.5
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} 370 -810 0 0 {name=S3
W=1.5
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} 590 -810 0 1 {name=M5
W=5
L=0.3
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
C {sky130_fd_pr/pfet_01v8.sym} 910 -810 0 0 {name=M6
W=5
L=0.3
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
C {sky130_fd_pr/pfet_01v8.sym} 1130 -810 0 1 {name=S4
W=1.5
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} 1310 -810 0 1 {name=S2
W=1.5
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 590 -510 0 1 {name=M3
W=2
L=0.3
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
C {sky130_fd_pr/nfet_01v8.sym} 910 -510 0 0 {name=M4
W=2
L=0.3
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
C {sky130_fd_pr/nfet_01v8.sym} 550 -310 0 0 {name=M1
W=10
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} 950 -310 0 1 {name=M2
W=10
L=0.5
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
C {sky130_fd_pr/nfet_01v8.sym} 730 -180 0 0 {name=M7
W=1
L=0.3
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
C {iopin.sym} 750 -930 0 0 {name=pVDD lab=VDD}
C {iopin.sym} 750 -120 0 0 {name=pGND lab=GND}
C {ipin.sym} 510 -310 0 0 {name=pVin1 lab=Vin1}
C {ipin.sym} 990 -310 2 0 {name=pVin2 lab=Vin2}
C {ipin.sym} 130 -810 0 0 {name=pCLK lab=CLK}
C {opin.sym} 540 -610 2 0 {name=pOutP lab=Vout_P}
C {opin.sym} 960 -610 0 0 {name=pOutN lab=Vout_N}
C {lab_wire.sym} 310 -810 0 0 {name=L00 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 1190 -810 0 0 {name=L01 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 1370 -810 0 0 {name=L02 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 670 -180 0 0 {name=L03 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 210 -750 0 0 {name=L04 sig_type=std_logic lab=P}
C {lab_wire.sym} 390 -750 0 0 {name=L05 sig_type=std_logic lab=Vout_P}
C {lab_wire.sym} 1110 -750 0 0 {name=L06 sig_type=std_logic lab=Vout_N}
C {lab_wire.sym} 1290 -750 0 0 {name=L07 sig_type=std_logic lab=Q}
C {lab_wire.sym} 660 -810 0 0 {name=L08 sig_type=std_logic lab=Vout_N}
C {lab_wire.sym} 840 -810 0 0 {name=L09 sig_type=std_logic lab=Vout_P}
C {lab_wire.sym} 660 -510 0 0 {name=L10 sig_type=std_logic lab=Vout_N}
C {lab_wire.sym} 840 -510 0 0 {name=L11 sig_type=std_logic lab=Vout_P}
C {lab_wire.sym} 520 -510 0 0 {name=L12 sig_type=std_logic lab=GND}
C {lab_wire.sym} 980 -510 0 0 {name=L13 sig_type=std_logic lab=GND}
C {lab_wire.sym} 620 -310 0 0 {name=L14 sig_type=std_logic lab=GND}
C {lab_wire.sym} 880 -310 0 0 {name=L15 sig_type=std_logic lab=GND}
C {lab_wire.sym} 800 -180 0 0 {name=L16 sig_type=std_logic lab=GND}
C {lab_wire.sym} 570 -420 0 0 {name=L17 sig_type=std_logic lab=P}
C {lab_wire.sym} 930 -420 0 0 {name=L18 sig_type=std_logic lab=Q}
C {lab_wire.sym} 750 -250 0 0 {name=L19 sig_type=std_logic lab=TAIL}
