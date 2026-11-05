v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 60 -420 0 0 {name=p_IN lab=IN}
C {ipin.sym} 60 -380 0 0 {name=p_VBP lab=VBP}
C {iopin.sym} 60 -340 0 0 {name=p_VDD lab=VDD}
C {opin.sym} 60 -300 0 0 {name=p_OUT lab=OUT}
C {ipin.sym} 60 -260 0 0 {name=p_VBN lab=VBN}
C {iopin.sym} 60 -220 0 0 {name=p_GND lab=GND}
C {sky130_fd_pr/pfet_01v8.sym} 300 -210 2 1 {name=MPS
W=1
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
C {sky130_fd_pr/pfet_01v8.sym} 300 -90 2 1 {name=MPI
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
C {sky130_fd_pr/nfet_01v8.sym} 300 60 0 0 {name=MNI
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
C {sky130_fd_pr/nfet_01v8.sym} 300 180 0 0 {name=MNS
W=0.5
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
C {sky130_fd_pr/cap_mim_m3_1.sym} 440 60 0 0 {name=C1 model=cap_mim_m3_1 W=1 L=1 MF=4 spiceprefix=X}
C {lab_pin.sym} 230 -300 0 0 {name=l0 lab=VDD}
C {lab_pin.sym} 230 270 0 0 {name=l1 lab=GND}
C {lab_pin.sym} 520 -30 0 1 {name=l2 lab=OUT}
C {lab_pin.sym} 220 -15 0 0 {name=l3 lab=IN}
C {lab_pin.sym} 250 -210 0 0 {name=l4 lab=VBP}
C {lab_pin.sym} 250 180 0 0 {name=l5 lab=VBN}
N 220 -15 280 -15 {}
N 230 -300 320 -300 {}
N 230 270 320 270 {}
N 250 -210 280 -210 {}
N 250 180 280 180 {}
N 280 -90 280 -15 {}
N 280 -15 280 60 {}
N 320 -300 320 -240 {}
N 320 -300 350 -300 {}
N 320 -210 350 -210 {}
N 320 -180 320 -120 {}
N 320 -90 350 -90 {}
N 320 -60 320 -30 {}
N 320 -30 320 30 {}
N 320 -30 440 -30 {}
N 320 60 350 60 {}
N 320 90 320 150 {}
N 320 180 350 180 {}
N 320 210 320 270 {}
N 320 270 350 270 {}
N 350 -300 350 -210 {}
N 350 -210 350 -90 {}
N 350 60 350 180 {}
N 350 180 350 270 {}
N 350 270 440 270 {}
N 440 -30 440 30 {}
N 440 -30 520 -30 {}
N 440 90 440 270 {}
