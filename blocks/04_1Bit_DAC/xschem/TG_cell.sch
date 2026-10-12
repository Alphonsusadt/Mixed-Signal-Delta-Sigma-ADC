v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 330 -280 360 -280 {lab=A}
N 330 -280 330 -210 {lab=A}
N 330 -210 360 -210 {lab=A}
N 420 -280 450 -280 {lab=B}
N 450 -280 450 -210 {lab=B}
N 420 -210 450 -210 {lab=B}
N 390 -350 390 -320 {lab=CLK_P}
N 390 -170 390 -150 {lab=CLK_N}
C {sky130_fd_pr/pfet3_01v8.sym} 390 -300 1 0 {
name=MP
W=8
L=0.15
body=VDD
nf=1
mult=1

ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"

as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"

nrd="expr('0.29 / @W ')"
nrs="expr('0.29 / @W ')"

sa=0
sb=0
sd=0

model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} 390 -190 3 0 {
name=MN
W=4
L=0.15
body=GND
nf=1
mult=1

ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"

as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"

nrd="expr('0.29 / @W ')"
nrs="expr('0.29 / @W ')"

sa=0
sb=0
sd=0

model=nfet_01v8
spiceprefix=X
}
C {iopin.sym} 330 -240 2 0 {
name=p1
lab=A
}
C {iopin.sym} 450 -240 0 0 {
name=p2
lab=B
}
C {ipin.sym} 390 -350 1 0 {
name=p3
lab=CLK_P
}
C {ipin.sym} 390 -150 3 0 {
name=p4
lab=CLK_N
}
C {iopin.sym} 300 -330 2 0 {
name=p5
lab=VDD
}
C {iopin.sym} 300 -130 2 0 {
name=p6
lab=GND
}
