v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {OUTPUT COMMON-MODE FEEDBACK | I2 candidate} 40 -140 0 0 0.4 0.4 {}
T {Original circuit values retained: Rsense 200k each, Iref 10uA} 40 -100 0 0 0.28 0.28 {}
T {Bias / sense pair                 Mirror                  Output correction} 40 -60 0 0 0.28 0.28 {}
N 40 0 1320 0 {}
C {lab_wire.sym} 40 0 0 0 {name=L1 lab=VDD}
N 40 620 1320 620 {}
C {lab_wire.sym} 40 620 0 0 {name=L2 lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} 80 450 0 0 {name=NB W=10 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029}
C {sky130_fd_pr/nfet_01v8.sym} 500 450 0 0 {name=TAIL W=10 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029}
C {sky130_fd_pr/nfet_01v8.sym} 380 270 0 0 {name=IN_S W=20 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/nfet_01v8.sym} 620 270 0 0 {name=IN_R W=20 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/pfet_01v8.sym} 380 100 0 0 {name=PD_S W=20 L=1 nf=1 mult=1 model=pfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__pfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/pfet_01v8.sym} 620 100 0 0 {name=PD_R W=20 L=1 nf=1 mult=1 model=pfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__pfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/pfet_01v8.sym} 820 100 0 0 {name=PCOPY W=20 L=1 nf=1 mult=1 model=pfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__pfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/nfet_01v8.sym} 820 450 0 0 {name=ND W=10 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029}
C {sky130_fd_pr/pfet_01v8.sym} 1040 100 0 0 {name=SOURCE_P W=20 L=1 nf=1 mult=1 model=pfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__pfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/pfet_01v8.sym} 1260 100 0 0 {name=SOURCE_N W=20 L=1 nf=1 mult=1 model=pfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__pfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=5.8 as=5.8 pd=40.58 ps=40.58 nrd=0.0145 nrs=0.0145}
C {sky130_fd_pr/nfet_01v8.sym} 1040 450 0 0 {name=SINK_P W=10 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029}
C {sky130_fd_pr/nfet_01v8.sym} 1260 450 0 0 {name=SINK_N W=10 L=1 nf=1 mult=1 model=nfet_01v8 spiceprefix=X
format="@spiceprefix@name @pinlist sky130_fd_pr__nfet_01v8 L=@L W=@W nf=@nf mult=@mult ad=@ad as=@as pd=@pd ps=@ps nrd=@nrd nrs=@nrs sa=0 sb=0 sd=0"
ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029}
N 400 0 400 70 {}
N 400 100 400 70 {}
N 640 0 640 70 {}
N 640 100 640 70 {}
N 840 0 840 70 {}
N 840 100 840 70 {}
N 1060 0 1060 70 {}
N 1060 100 1060 70 {}
N 1280 0 1280 70 {}
N 1280 100 1280 70 {}
N 100 480 100 620 {}
N 100 450 100 480 {}
N 520 480 520 620 {}
N 520 450 520 480 {}
N 840 480 840 620 {}
N 840 450 840 480 {}
N 1060 480 1060 620 {}
N 1060 450 1060 480 {}
N 1280 480 1280 620 {}
N 1280 450 1280 480 {}
C {isource.sym} 100 100 0 0 {name=IREF_CM value=10u}
N 100 0 100 70 {}
N 100 130 100 420 {}
N 100 350 50 350 {}
N 50 350 50 450 {}
N 50 450 60 450 {}
C {lab_wire.sym} 100 350 0 0 {name=L3 lab=nbias}
N 480 450 460 450 {}
C {lab_wire.sym} 460 450 0 0 {name=L4 lab=nbias}
N 400 300 400 370 {}
N 400 370 640 370 {}
N 640 370 640 300 {}
N 520 370 520 420 {}
C {lab_wire.sym} 520 370 0 0 {name=L5 lab=tail}
N 400 270 430 270 {}
C {lab_wire.sym} 430 270 0 0 {name=L6 lab=GND}
N 640 270 670 270 {}
C {lab_wire.sym} 670 270 0 0 {name=L7 lab=GND}
N 400 130 400 240 {}
N 400 180 340 180 {}
N 340 180 340 100 {}
N 340 100 360 100 {}
N 640 130 640 240 {}
N 640 180 580 180 {}
N 580 180 580 100 {}
N 580 100 600 100 {}
C {lab_wire.sym} 400 180 0 0 {name=L8 lab=d_s}
C {lab_wire.sym} 640 180 0 0 {name=L9 lab=d_r}
N 800 100 770 100 {}
C {lab_wire.sym} 770 100 0 0 {name=L10 lab=d_s}
N 840 130 840 420 {}
N 840 350 780 350 {}
N 780 350 780 450 {}
N 780 450 800 450 {}
C {lab_wire.sym} 840 350 0 0 {name=L11 lab=nsink}
N 1060 130 1060 420 {}
N 1020 100 990 100 {}
C {lab_wire.sym} 990 100 0 0 {name=L12 lab=d_r}
N 1020 450 990 450 {}
C {lab_wire.sym} 990 450 0 0 {name=L13 lab=nsink}
N 1280 130 1280 420 {}
N 1240 100 1210 100 {}
C {lab_wire.sym} 1210 100 0 0 {name=L14 lab=d_r}
N 1240 450 1210 450 {}
C {lab_wire.sym} 1210 450 0 0 {name=L15 lab=nsink}
C {lab_wire.sym} 1060 290 0 0 {name=L16 lab=OUT_P}
C {lab_wire.sym} 1280 290 0 0 {name=L17 lab=OUT_N}
N 600 270 570 270 {}
C {lab_wire.sym} 570 270 0 0 {name=L18 lab=VCM}
C {res.sym} 240 230 0 0 {name=RSP value=200k}
C {res.sym} 240 310 2 0 {name=RSN value=200k}
N 240 200 240 170 {}
C {lab_wire.sym} 240 170 0 0 {name=L19 lab=OUT_P}
N 240 340 240 390 {}
C {lab_wire.sym} 240 390 0 0 {name=L20 lab=OUT_N}
N 240 260 240 280 {}
N 240 270 360 270 {}
C {lab_wire.sym} 280 270 0 0 {name=L21 lab=sense}
C {iopin.sym} 40 0 0 0 {name=P0 lab=VDD}
C {iopin.sym} 40 620 0 0 {name=P1 lab=GND}
C {iopin.sym} 1060 290 0 0 {name=P2 lab=OUT_P}
C {iopin.sym} 1280 290 0 0 {name=P3 lab=OUT_N}
C {iopin.sym} 570 270 0 0 {name=P4 lab=VCM}
