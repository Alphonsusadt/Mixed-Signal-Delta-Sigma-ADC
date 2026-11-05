v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 60 -420 0 0 {name=p_A lab=A}
C {ipin.sym} 60 -380 0 0 {name=p_B lab=B}
C {opin.sym} 60 -340 0 0 {name=p_OUT lab=OUT}
C {iopin.sym} 60 -300 0 0 {name=p_VDD lab=VDD}
C {iopin.sym} 60 -260 0 0 {name=p_GND lab=GND}
C {sky130_fd_pr/pfet_01v8.sym} 300 -210 2 1 {name=MPA
W=4
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
C {sky130_fd_pr/pfet_01v8.sym} 300 -90 2 1 {name=MPB
W=4
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
C {sky130_fd_pr/nfet_01v8.sym} 300 60 0 0 {name=MNA
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
C {sky130_fd_pr/nfet_01v8.sym} 460 60 0 0 {name=MNB
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
C {lab_pin.sym} 230 -300 0 0 {name=l0 lab=VDD}
C {lab_pin.sym} 230 150 0 0 {name=l1 lab=GND}
C {lab_pin.sym} 560 -30 0 1 {name=l2 lab=OUT}
C {lab_pin.sym} 250 -210 0 0 {name=l3 lab=A}
C {lab_pin.sym} 250 60 0 0 {name=l4 lab=A}
C {lab_pin.sym} 250 -90 0 0 {name=l5 lab=B}
C {lab_pin.sym} 410 60 0 0 {name=l6 lab=B}
N 230 -300 320 -300 {}
N 230 150 320 150 {}
N 250 -210 280 -210 {}
N 250 -90 280 -90 {}
N 250 60 280 60 {}
N 320 -300 320 -240 {}
N 320 -300 350 -300 {}
N 320 -210 350 -210 {}
N 320 -180 320 -120 {}
N 320 -90 350 -90 {}
N 320 -60 320 -30 {}
N 320 -30 320 30 {}
N 320 -30 480 -30 {}
N 320 60 350 60 {}
N 320 90 320 150 {}
N 320 150 350 150 {}
N 350 -300 350 -210 {}
N 350 -210 350 -90 {}
N 350 60 350 150 {}
N 350 150 480 150 {}
N 410 60 440 60 {}
N 480 -30 480 30 {}
N 480 -30 560 -30 {}
N 480 60 510 60 {}
N 480 90 480 150 {}
N 480 150 510 150 {}
N 510 60 510 150 {}
