v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 -420 520 -420 {lab=VCC}
N 220 -420 220 -330 {lab=VCC}
N 520 -420 520 -330 {lab=VCC}
N 220 -300 270 -300 {lab=VCC}
N 520 -300 570 -300 {lab=VCC}
N 220 -270 220 -210 {lab=Y}
N 520 -270 520 -210 {lab=Y}
N 220 -210 370 -210 {lab=Y}
N 370 -210 520 -210 {lab=Y}
N 520 -210 660 -210 {lab=Y}
N 370 -210 370 -130 {lab=Y}
N 370 -70 370 10 {lab=MID}
N 370 -100 420 -100 {lab=GND}
N 370 70 370 140 {lab=GND}
N 370 40 420 40 {lab=GND}
N 100 -300 180 -300 {lab=A}
N 400 -300 480 -300 {lab=B}
N 260 -100 330 -100 {lab=A}
N 260 40 330 40 {lab=B}
N 420 -460 420 -420 {lab=VCC}
N 370 140 370 170 {lab=GND}
C {sky130_fd_pr/pfet_01v8.sym} 200 -300 0 0 {name=MP1
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
C {sky130_fd_pr/pfet_01v8.sym} 500 -300 0 0 {name=MP2
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
C {sky130_fd_pr/nfet_01v8.sym} 350 -100 0 0 {name=MN1
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
C {sky130_fd_pr/nfet_01v8.sym} 350 40 0 0 {name=MN2
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
C {devices/ipin.sym} 100 -300 0 0 {name=pA lab=A}
C {devices/ipin.sym} 400 -300 0 0 {name=pB lab=B}
C {devices/opin.sym} 660 -210 0 0 {name=pY lab=Y}
C {devices/iopin.sym} 370 170 0 0 {name=pGND lab=GND}
C {devices/iopin.sym} 420 -460 0 0 {name=pVCC lab=VCC}
C {devices/lab_wire.sym} 270 -300 0 0 {name=lVCC1 lab=VCC}
C {devices/lab_wire.sym} 570 -300 0 0 {name=lVCC2 lab=VCC}
C {devices/lab_wire.sym} 260 -100 0 0 {name=lA2 lab=A}
C {devices/lab_wire.sym} 260 40 0 0 {name=lB2 lab=B}
C {devices/lab_wire.sym} 420 -100 0 0 {name=lGND1 lab=GND}
C {devices/lab_wire.sym} 420 40 0 0 {name=lGND2 lab=GND}
