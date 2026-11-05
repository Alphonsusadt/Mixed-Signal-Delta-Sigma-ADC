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
C {sky130_fd_pr/pfet_01v8.sym} 300 -120 2 1 {name=MPA
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
C {sky130_fd_pr/pfet_01v8.sym} 460 -120 2 1 {name=MPB
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
C {sky130_fd_pr/nfet_01v8.sym} 300 40 0 0 {name=MNA
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
C {sky130_fd_pr/nfet_01v8.sym} 300 160 0 0 {name=MNB
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
C {lab_pin.sym} 230 -210 0 0 {name=l0 lab=VDD}
C {lab_pin.sym} 230 250 0 0 {name=l1 lab=GND}
C {lab_pin.sym} 560 -60 0 1 {name=l2 lab=OUT}
C {lab_pin.sym} 220 -10 0 0 {name=l3 lab=A}
C {lab_pin.sym} 410 -120 0 0 {name=l4 lab=B}
C {lab_pin.sym} 220 160 0 0 {name=l5 lab=B}
N 220 -10 280 -10 {}
N 220 160 280 160 {}
N 230 -210 320 -210 {}
N 230 250 320 250 {}
N 280 -120 280 -10 {}
N 280 -10 280 40 {}
N 320 -210 320 -150 {}
N 320 -210 350 -210 {}
N 320 -120 350 -120 {}
N 320 -90 320 -60 {}
N 320 -60 320 10 {}
N 320 -60 480 -60 {}
N 320 40 350 40 {}
N 320 70 320 130 {}
N 320 160 350 160 {}
N 320 190 320 250 {}
N 320 250 350 250 {}
N 350 -210 350 -120 {}
N 350 -210 480 -210 {}
N 350 40 350 160 {}
N 350 160 350 250 {}
N 410 -120 440 -120 {}
N 480 -210 480 -150 {}
N 480 -210 510 -210 {}
N 480 -120 510 -120 {}
N 480 -90 480 -60 {}
N 480 -60 560 -60 {}
N 510 -210 510 -120 {}
