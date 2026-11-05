v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 60 -420 0 0 {name=p_IN lab=IN}
C {opin.sym} 60 -380 0 0 {name=p_OUT lab=OUT}
C {iopin.sym} 60 -340 0 0 {name=p_VDD lab=VDD}
C {iopin.sym} 60 -300 0 0 {name=p_GND lab=GND}
C {sky130_fd_pr/pfet_01v8.sym} 300 -120 2 1 {name=MP
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
C {sky130_fd_pr/nfet_01v8.sym} 300 120 0 0 {name=MN
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
C {lab_pin.sym} 230 -210 0 0 {name=l0 lab=VDD}
C {lab_pin.sym} 230 210 0 0 {name=l1 lab=GND}
C {lab_pin.sym} 400 0 0 1 {name=l2 lab=OUT}
C {lab_pin.sym} 220 0 0 0 {name=l3 lab=IN}
N 220 0 280 0 {}
N 230 -210 320 -210 {}
N 230 210 320 210 {}
N 280 -120 280 0 {}
N 280 0 280 120 {}
N 320 -210 320 -150 {}
N 320 -210 350 -210 {}
N 320 -120 350 -120 {}
N 320 -90 320 0 {}
N 320 0 320 90 {}
N 320 0 400 0 {}
N 320 120 350 120 {}
N 320 150 320 210 {}
N 320 210 350 210 {}
N 350 -210 350 -120 {}
N 350 120 350 210 {}
