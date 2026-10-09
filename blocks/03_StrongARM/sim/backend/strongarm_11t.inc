* StrongARM 11T SKY130 snapshot from user's verified Xschem netlist.
* Device order D G S B; W and L use micrometers because SKY130 model sets scale=1u.
.subckt StrongARM VDD CLK Vout_P Vout_N Vin1 Vin2 GND
XS1 P CLK VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 sa=0 sb=0 sd=0 mult=1
XS3 Vout_P CLK VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 sa=0 sb=0 sd=0 mult=1
XM5 Vout_P Vout_N VDD VDD sky130_fd_pr__pfet_01v8 L=0.3 W=5 nf=1 ad=1.45 as=1.45 pd=10.58 ps=10.58 nrd=0.058 nrs=0.058 sa=0 sb=0 sd=0 mult=1
XM6 Vout_N Vout_P VDD VDD sky130_fd_pr__pfet_01v8 L=0.3 W=5 nf=1 ad=1.45 as=1.45 pd=10.58 ps=10.58 nrd=0.058 nrs=0.058 sa=0 sb=0 sd=0 mult=1
XS4 Vout_N CLK VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 sa=0 sb=0 sd=0 mult=1
XS2 Q CLK VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=1.5 nf=1 ad=0.435 as=0.435 pd=3.58 ps=3.58 nrd=0.193333333333333 nrs=0.193333333333333 sa=0 sb=0 sd=0 mult=1
XM3 Vout_P Vout_N P GND sky130_fd_pr__nfet_01v8 L=0.3 W=2 nf=1 ad=0.58 as=0.58 pd=4.58 ps=4.58 nrd=0.145 nrs=0.145 sa=0 sb=0 sd=0 mult=1
XM4 Vout_N Vout_P Q GND sky130_fd_pr__nfet_01v8 L=0.3 W=2 nf=1 ad=0.58 as=0.58 pd=4.58 ps=4.58 nrd=0.145 nrs=0.145 sa=0 sb=0 sd=0 mult=1
XM1 P Vin1 TAIL GND sky130_fd_pr__nfet_01v8 L=0.5 W=10 nf=1 ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029 sa=0 sb=0 sd=0 mult=1
XM2 Q Vin2 TAIL GND sky130_fd_pr__nfet_01v8 L=0.5 W=10 nf=1 ad=2.9 as=2.9 pd=20.58 ps=20.58 nrd=0.029 nrs=0.029 sa=0 sb=0 sd=0 mult=1
XM7 TAIL CLK GND GND sky130_fd_pr__nfet_01v8 L=0.3 W=1 nf=1 ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29 sa=0 sb=0 sd=0 mult=1
.ends StrongARM
