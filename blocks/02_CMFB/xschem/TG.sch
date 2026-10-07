v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 330 -280 360 -280 {lab=VIN}
N 330 -280 330 -220 {lab=VIN}
N 330 -220 330 -210 {lab=VIN}
N 330 -210 360 -210 {lab=VIN}
N 420 -280 450 -280 {lab=OUTPUT}
N 450 -280 450 -210 {lab=OUTPUT}
N 420 -210 450 -210 {lab=OUTPUT}
N 50 -130 50 -110 {lab=VDD}
N 50 -50 50 -40 {lab=0}
N 390 -170 390 -150 {lab=Clk_N}
N 390 -350 390 -320 {lab=Clk_P}
N 130 -150 130 -110 {lab=Clk_N}
N 190 -150 190 -110 {lab=Clk_P}
N 250 -150 250 -110 {lab=VIN}
N 250 -240 330 -240 {lab=VIN}
N 450 -240 510 -240 {lab=OUTPUT}
C {sky130_fd_pr/pfet3_01v8.sym} 390 -300 1 0 {name=M2
W=4
L=0.15
body=VDD
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
C {sky130_fd_pr/nfet3_01v8.sym} 390 -190 3 0 {name=M3
W=2
L=0.15
body=GND
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
C {vsource.sym} 50 -80 0 0 {name=V1 value=1.8 savecurrent=false}
C {vdd.sym} 50 -130 0 0 {name=l1 lab=VDD}
C {gnd.sym} 50 -40 0 0 {name=l2 lab=0}
C {vsource.sym} 130 -80 0 0 {name=V2 value="PULSE(0 1.8 25n 1n 1n 100n 250n)" savecurrent=false}
C {vsource.sym} 190 -80 0 0 {name=V3 value="PULSE(1.8 0 25n 1n 1n 100n 250n)" savecurrent=false}
C {vsource.sym} 250 -80 0 0 {name=V4 value=1.8 savecurrent=false}
C {gnd.sym} 130 -40 0 0 {name=l4 lab=0}
C {gnd.sym} 190 -40 0 0 {name=l5 lab=0}
C {gnd.sym} 250 -40 0 0 {name=l6 lab=0}
C {lab_wire.sym} 390 -150 2 0 {name=p2 sig_type=std_logic lab=Clk_N

}
C {lab_wire.sym} 390 -350 2 0 {name=p3 sig_type=std_logic lab=Clk_P

}
C {lab_wire.sym} 130 -150 2 0 {name=p4 sig_type=std_logic lab=Clk_N

}
C {lab_wire.sym} 190 -150 2 0 {name=p5 sig_type=std_logic lab=Clk_P

}
C {lab_wire.sym} 250 -150 2 0 {name=p6 sig_type=std_logic lab=VIN


}
C {lab_wire.sym} 250 -240 2 0 {name=p7 sig_type=std_logic lab=VIN


}
C {opin.sym} 510 -240 0 0 {name=p8 lab=OUTPUT}
C {code_shown.sym} 10 -850 0 0 {name=s1 only_toplevel=false 
value="
.temp 27
.ic V(OUTPUT)=0.4

.control
save all

tran 0.2n 2u 0 0.2n uic

let track_error = v(output)-v(vin)

echo ===== TG ON =====
meas tran VOUT_ON_HIGH FIND v(output) AT=350n
meas tran ERROR_ON_HIGH FIND track_error AT=350n

meas tran VOUT_ON_LOW FIND v(output) AT=600n
meas tran ERROR_ON_LOW FIND track_error AT=600n

echo ===== TG OFF / HOLD =====
meas tran VOUT_HOLD_LOW FIND v(output) AT=220n
meas tran VOUT_HOLD_HIGH FIND v(output) AT=470n

plot v(vin) v(output)
plot v(clk_n) v(clk_p)
.endc"}
C {sky130_fd_pr/corner.sym} 700 -260 0 0 {name=CORNER only_toplevel=false corner=tt}
