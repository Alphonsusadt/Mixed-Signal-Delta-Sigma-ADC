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
C {sky130_fd_pr/pfet_01v8.sym} 300 -250 2 1 {name=MPA
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
C {sky130_fd_pr/pfet_01v8.sym} 460 -250 2 1 {name=MPB
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
C {sky130_fd_pr/pfet_01v8.sym} 300 -120 2 1 {name=MPC
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
C {sky130_fd_pr/nfet_01v8.sym} 300 30 0 0 {name=MNA
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
C {sky130_fd_pr/nfet_01v8.sym} 300 150 0 0 {name=MNB
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
C {sky130_fd_pr/nfet_01v8.sym} 460 30 0 0 {name=MNC
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
C {lab_pin.sym} 230 -330 0 0 {name=l0 lab=VDD}
C {lab_pin.sym} 560 -60 0 1 {name=l1 lab=OUT}
C {lab_pin.sym} 230 240 0 0 {name=l2 lab=GND}
C {lab_pin.sym} 250 -250 0 0 {name=l3 lab=A}
C {lab_pin.sym} 250 30 0 0 {name=l4 lab=A}
C {lab_pin.sym} 410 -250 0 0 {name=l5 lab=B}
C {lab_pin.sym} 250 150 0 0 {name=l6 lab=B}
C {lab_pin.sym} 250 -120 0 0 {name=l7 lab=C}
C {lab_pin.sym} 410 30 0 0 {name=l8 lab=C}
C {blocks/06_Clock_gen/xschem/B6_NOR2.sym} 760 -100 0 0 {name=xnor}
C {lab_pin.sym} 670 -120 0 0 {name=l9 lab=A}
C {lab_pin.sym} 670 -80 0 0 {name=l10 lab=B}
C {lab_pin.sym} 850 -100 0 1 {name=l11 lab=C}
C {lab_pin.sym} 760 -180 0 1 {name=l12 lab=VDD}
C {lab_pin.sym} 760 -20 0 1 {name=l13 lab=GND}
N 230 -330 320 -330 {}
N 230 240 320 240 {}
N 250 -250 280 -250 {}
N 250 -120 280 -120 {}
N 250 30 280 30 {}
N 250 150 280 150 {}
N 320 -330 320 -280 {}
N 320 -330 350 -330 {}
N 320 -250 350 -250 {}
N 320 -220 320 -190 {}
N 320 -190 320 -150 {}
N 320 -190 480 -190 {}
N 320 -120 530 -120 {}
N 320 -90 320 -60 {}
N 320 -60 320 0 {}
N 320 -60 480 -60 {}
N 320 30 350 30 {}
N 320 60 320 120 {}
N 320 150 350 150 {}
N 320 180 320 240 {}
N 320 240 350 240 {}
N 350 -330 350 -250 {}
N 350 -330 480 -330 {}
N 350 30 350 150 {}
N 350 150 350 240 {}
N 350 240 480 240 {}
N 410 -250 440 -250 {}
N 410 30 440 30 {}
N 480 -330 480 -280 {}
N 480 -330 530 -330 {}
N 480 -250 530 -250 {}
N 480 -220 480 -190 {}
N 480 -60 480 0 {}
N 480 -60 560 -60 {}
N 480 30 510 30 {}
N 480 60 480 240 {}
N 480 240 510 240 {}
N 510 30 510 240 {}
N 530 -330 530 -250 {}
N 530 -250 530 -120 {}
N 670 -120 700 -120 {}
N 670 -80 700 -80 {}
N 760 -180 760 -150 {}
N 760 -50 760 -20 {}
N 820 -100 850 -100 {}
