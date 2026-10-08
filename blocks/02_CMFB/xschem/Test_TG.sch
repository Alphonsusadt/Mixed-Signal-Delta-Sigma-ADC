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
N 250 -240 330 -240 {lab=VIN}
N 450 -240 510 -240 {lab=OUTPUT}
N 390 -170 390 -150 {lab=Clk_N}
N 390 -350 390 -320 {lab=Clk_P}
N 50 -130 50 -110 {lab=VDD}
N 50 -50 50 -40 {lab=0}
N 130 -150 130 -110 {lab=Clk_N}
N 130 -50 130 -40 {lab=0}
N 190 -150 190 -110 {lab=Clk_P}
N 190 -50 190 -40 {lab=0}
N 250 -150 250 -110 {lab=VIN}
N 250 -50 250 -40 {lab=0}
C {sky130_fd_pr/pfet3_01v8.sym} 390 -300 1 0 {
name=M2
W=4
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
name=M3
W=2
L=0.15
body=0
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
C {vsource.sym} 50 -80 0 0 {
name=V1
value=1.8
savecurrent=false
}
C {vdd.sym} 50 -130 0 0 {
name=l1
lab=VDD
}
C {gnd.sym} 50 -40 0 0 {
name=l2
lab=0
}
C {vsource.sym} 130 -80 0 0 {
name=V2
value="PULSE(0 1.8 100n 1n 1n 400n 1u)"
savecurrent=false
}
C {gnd.sym} 130 -40 0 0 {
name=l4
lab=0
}
C {vsource.sym} 190 -80 0 0 {
name=V3
value="PULSE(1.8 0 100n 1n 1n 400n 1u)"
savecurrent=false
}
C {gnd.sym} 190 -40 0 0 {
name=l5
lab=0
}
C {vsource.sym} 250 -80 0 0 {
name=V4
value="PULSE(0.4 1.4 150n 1n 1n 100n 500n)"
savecurrent=false
}
C {gnd.sym} 250 -40 0 0 {
name=l6
lab=0
}
C {lab_wire.sym} 390 -150 2 0 {
name=p2
sig_type=std_logic
lab=Clk_N
}
C {lab_wire.sym} 390 -350 2 0 {
name=p3
sig_type=std_logic
lab=Clk_P
}
C {lab_wire.sym} 130 -150 2 0 {
name=p4
sig_type=std_logic
lab=Clk_N
}
C {lab_wire.sym} 190 -150 2 0 {
name=p5
sig_type=std_logic
lab=Clk_P
}
C {lab_wire.sym} 250 -150 2 0 {
name=p6
sig_type=std_logic
lab=VIN
}
C {lab_wire.sym} 250 -240 2 0 {
name=p7
sig_type=std_logic
lab=VIN
}
C {opin.sym} 510 -240 0 0 {
name=p8
lab=OUTPUT
}
C {code_shown.sym} 0 -1410 0 0 {C \{code_shown.sym\} 30 -470 0 0 \{
name=s1
only_toplevel=true
value="
CLOAD OUTPUT 0 1p
RLEAK OUTPUT 0 1G

.control
save all

tran 0.5n 2u

meas tran CLK_N_MAX MAX v(clk_n)
meas tran CLK_N_MIN MIN v(clk_n)
meas tran CLK_P_MAX MAX v(clk_p)
meas tran CLK_P_MIN MIN v(clk_p)

* ON STATE - HIGH
meas tran VIN_ON_HIGH FIND v(vin) AT=200n
meas tran VOUT_ON_HIGH FIND v(output) AT=200n

* ON STATE - LOW
meas tran VIN_ON_LOW FIND v(vin) AT=400n
meas tran VOUT_ON_LOW FIND v(output) AT=400n

let ERROR_ON_HIGH = abs(VOUT_ON_HIGH-VIN_ON_HIGH)
let ERROR_ON_LOW = abs(VOUT_ON_LOW-VIN_ON_LOW)

* HOLD CHECK
meas tran VOUT_BEFORE_OFF FIND v(output) AT=490n
meas tran VIN_OFF FIND v(vin) AT=700n
meas tran VOUT_HOLD FIND v(output) AT=700n

let HOLD_ERROR = abs(VOUT_HOLD-VOUT_BEFORE_OFF)

print CLK_N_MAX
print CLK_N_MIN
print CLK_P_MAX
print CLK_P_MIN

print VIN_ON_HIGH
print VOUT_ON_HIGH
print ERROR_ON_HIGH

print VIN_ON_LOW
print VOUT_ON_LOW
print ERROR_ON_LOW

print VOUT_BEFORE_OFF
print VIN_OFF
print VOUT_HOLD
print HOLD_ERROR

plot v(vin) v(output)
plot v(clk_n) v(clk_p)

.endc
"
\}
}
C {sky130_fd_pr/corner.sym} 700 -260 0 0 {
name=CORNER
only_toplevel=false
corner=tt
}
