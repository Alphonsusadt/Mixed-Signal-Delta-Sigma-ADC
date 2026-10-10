v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 -520 220 -490 {lab=Y}
N 220 -490 420 -490 {lab=Y}
N 420 -520 420 -490 {lab=Y}
N 220 -610 220 -580 {lab=xxx}
N 220 -610 420 -610 {lab=xxx}
N 420 -610 420 -580 {lab=xxx}
N 220 -580 220 -550 {lab=xxx}
N 420 -580 420 -550 {lab=xxx}
N 320 -360 320 -280 {lab=#net1}
N 320 -490 320 -420 {lab=Y}
N 320 -220 320 -170 {lab=GND}
N 320 -640 320 -610 {lab=xxx}
N 320 -390 350 -390 {lab=GND}
N 350 -390 350 -190 {lab=GND}
N 320 -190 350 -190 {lab=GND}
N 320 -250 320 -220 {lab=GND}
N 160 -550 180 -550 {lab=A}
N 260 -390 280 -390 {lab=A}
N 260 -250 280 -250 {lab=B}
N 370 -550 380 -550 {lab=B}
N 320 -450 390 -450 {lab=Y}
C {sky130_fd_pr/pfet_01v8.sym} 200 -550 0 0 {name=M1
W=2
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
C {sky130_fd_pr/pfet_01v8.sym} 400 -550 0 0 {name=M2
W=2
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
C {sky130_fd_pr/nfet_01v8.sym} 300 -390 0 0 {name=M3
W=2
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 300 -250 0 0 {name=M4
W=2
L=0.15
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
C {iopin.sym} 320 -640 0 0 {name=p1 lab=VCC
}
C {iopin.sym} 320 -170 0 0 {name=p2 lab=GND}
C {ipin.sym} 130 -420 0 0 {name=p5 lab=A}
C {ipin.sym} 130 -400 0 0 {name=p6 lab=B}
C {opin.sym} 390 -450 0 0 {name=p7 lab=Y}
C {lab_pin.sym} 160 -550 0 0 {name=p3 sig_type=std_logic lab=A}
C {lab_pin.sym} 370 -550 0 0 {name=p4 sig_type=std_logic lab=B}
C {lab_pin.sym} 260 -390 0 0 {name=p8 sig_type=std_logic lab=A}
C {lab_pin.sym} 260 -250 0 0 {name=p9 sig_type=std_logic lab=B}
