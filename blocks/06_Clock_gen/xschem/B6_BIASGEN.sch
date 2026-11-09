v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
E {}
T {B6_BIASGEN: PVT-tracking bias generator (resistor + mirror + replica diodes), I = (VDD - VBN)/R} -60 -290 0 0 0.45 0.45 {}
T {R = 1.247933 MOhm (xhigh_po); the SKY130 tempco tc1/tc2 is applied in the closed-loop deck, not in this symbol.} -60 -255 0 0 0.3 0.3 {}
T {XBN1 / XBP1 replicate the starving devices of the delay cells (B6_DELAY_CS: MNS and MPS).} -60 -225 0 0 0.3 0.3 {}
C {res.sym} 0 0 0 0 {name=RB1 value=1.247933e6 m=1}
C {sky130_fd_pr/nfet_01v8.sym} 200 0 0 0 {name=BN1 W=0.5
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
spiceprefix=X}
C {sky130_fd_pr/nfet_01v8.sym} 450 0 0 0 {name=BN2 W=0.5
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
spiceprefix=X}
C {sky130_fd_pr/pfet_01v8.sym} 700 0 0 0 {name=BP1 W=1
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
spiceprefix=X}
N 0 -200 0 -30 {}
N 0 -200 760 -200 {}
N 720 -200 720 -30 {}
N 720 0 760 0 {}
N 760 0 760 -200 {}
N 0 30 0 80 {}
N 0 80 120 80 {}
N 120 80 120 -100 {}
N 120 -100 400 -100 {}
N 400 -100 400 0 {}
N 400 0 430 0 {}
N 120 0 180 0 {}
N 220 -30 220 -60 {}
N 220 -60 120 -60 {}
N 220 30 220 150 {}
N 220 0 250 0 {}
N 250 0 250 150 {}
N 220 150 470 150 {}
N 470 30 470 150 {}
N 470 0 500 0 {}
N 500 0 500 150 {}
N 500 150 470 150 {}
N 470 -30 470 -140 {}
N 470 -140 640 -140 {}
N 640 -140 640 0 {}
N 640 0 680 0 {}
N 720 30 720 70 {}
N 720 70 640 70 {}
N 640 70 640 0 {}
C {iopin.sym} -40 -200 0 0 {name=P1 lab=vdd}
N -40 -200 0 -200 {}
C {iopin.sym} 160 150 0 0 {name=P2 lab=GND}
N 160 150 220 150 {}
C {opin.sym} 480 -100 0 0 {name=P3 lab=vbn}
N 400 -100 480 -100 {}
C {opin.sym} 800 70 0 0 {name=P4 lab=vbp}
N 720 70 800 70 {}
T {vbn} 130 -95 0 0 0.3 0.3 {}
T {vbp} 560 -135 0 0 0.3 0.3 {}
