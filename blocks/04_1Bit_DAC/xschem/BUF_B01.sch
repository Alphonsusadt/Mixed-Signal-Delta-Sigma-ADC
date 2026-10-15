v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 620 -380 620 -290 {lab=#net1}
N 360 -370 360 -280 {lab=#net2}
N 290 -250 320 -250 {lab=IN}
N 290 -400 290 -250 {lab=IN}
N 290 -400 320 -400 {lab=IN}
N 360 -330 550 -330 {lab=#net2}
N 180 -330 290 -330 {lab=IN}
N 360 -450 360 -430 {lab=VCC}
N 360 -450 620 -450 {lab=VCC}
N 620 -450 620 -430 {lab=VCC}
N 560 -260 580 -260 {lab=#net2}
N 550 -260 560 -260 {lab=#net2}
N 550 -400 550 -260 {lab=#net2}
N 550 -400 580 -400 {lab=#net2}
N 330 -450 360 -450 {lab=VCC}
N 360 -220 360 -190 {lab=GND}
N 360 -190 620 -190 {lab=GND}
N 620 -230 620 -190 {lab=GND}
N 330 -190 360 -190 {lab=GND}
N 620 -330 730 -330 {lab=#net1}
C {sky130_fd_pr/nfet_01v8.sym} 340 -250 0 0 {name=M1
W=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 340 -400 0 0 {name=M2
W=1
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
C {sky130_fd_pr/nfet_01v8.sym} 600 -260 0 0 {name=M3
W=1
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
C {sky130_fd_pr/pfet_01v8.sym} 600 -400 0 0 {name=M4
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
C {iopin.sym} 330 -450 2 0 {name=p1 lab=VCC
}
C {iopin.sym} 330 -190 2 0 {name=p2 lab=GND

}
C {ipin.sym} 180 -330 0 0 {name=p4 lab=IN}
C {opin.sym} 730 -330 0 0 {name=p3 lab=OUT}
C {lab_pin.sym} 360 -250 0 1 {name=l_bulk_n1 lab=GND}
C {lab_pin.sym} 360 -400 0 1 {name=l_bulk_p1 lab=VCC}
C {lab_pin.sym} 620 -260 0 1 {name=l_bulk_n2 lab=GND}
C {lab_pin.sym} 620 -400 0 1 {name=l_bulk_p2 lab=VCC}
