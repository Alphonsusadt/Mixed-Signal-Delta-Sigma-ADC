v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 -240 540 -220 {lab=VDD}
N 80 -160 80 -140 {lab=VDD}
N 80 -80 80 -70 {lab=0}
N 150 -80 150 -70 {lab=0}
N 230 -80 230 -70 {lab=0}
N 300 -80 300 -70 {lab=0}
N 540 -160 540 -150 {lab=0}
N 300 -180 300 -140 {lab=Vin2}
N 300 -180 340 -180 {lab=Vin2}
N 230 -200 340 -200 {lab=Vin1}
N 230 -200 230 -140 {lab=Vin1}
N 150 -220 340 -220 {lab=CLK}
N 150 -220 150 -140 {lab=CLK}
N 540 -200 590 -200 {lab=Vout_P}
N 540 -180 590 -180 {lab=Vout_N}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 490 -190 0 0 {name=x1}
C {vsource.sym} 80 -110 0 0 {name=VVDD value=1.8 savecurrent=false}
C {vdd.sym} 80 -160 0 0 {name=l1 lab=VDD}
C {vdd.sym} 540 -240 0 0 {name=l2 lab=VDD}
C {vsource.sym} 230 -110 0 0 {name=VVin1 value=0.895 savecurrent=false}
C {gnd.sym} 80 -70 0 0 {name=l3 lab=0}
C {gnd.sym} 230 -70 0 0 {name=l4 lab=0}
C {vsource.sym} 300 -110 0 0 {name=VVin2 value=0.905 savecurrent=false}
C {gnd.sym} 300 -70 0 0 {name=l5 lab=0}
C {vsource.sym} 150 -110 0 0 {name=VPulse value="PULSE(0 1.8 0 1n 1n 125n 250n)" savecurrent=false}
C {gnd.sym} 150 -70 0 0 {name=l6 lab=0}
C {gnd.sym} 540 -150 0 0 {name=l7 lab=0}
C {opin.sym} 590 -200 0 0 {name=p1 lab=Vout_P}
C {opin.sym} 590 -180 0 0 {name=p2 lab=Vout_N}
C {code.sym} 80 -370 0 0 {name=s1 only_toplevel=false 
value="
.control
save all

* =========================================
* BLOCK 3 - STRONGARM COMPARATOR
* TEST 6A: NOMINAL INPUT OFFSET SWEEP
* SKY130 / VDD = 1.8 V / CLK = 4 MHz
* Input common mode = 0.9 V
* =========================================

foreach dv 0.001 0.0005 0.0002 0.0001 0.00005 0 -0.00005 -0.0001 -0.0002 -0.0005 -0.001

  setplot const

  let vip = 0.9 + ($dv / 2)
  let vin = 0.9 - ($dv / 2)

  alter VVIN1 $&vip
  alter VVIN2 $&vin

  echo
  echo ======================================
  echo TEST 6A - NOMINAL OFFSET SWEEP
  echo DIFFERENTIAL INPUT = $dv V
  echo ======================================

  tran 0.1n 1u

  * Evaluate second clock cycle
  meas tran vp_eval FIND v(vout_p) AT=362.5n
  meas tran vn_eval FIND v(vout_n) AT=362.5n

  * Check earlier evaluation point
  meas tran vp_early FIND v(vout_p) AT=262.5n
  meas tran vn_early FIND v(vout_n) AT=262.5n

  * Check reset
  meas tran vp_reset FIND v(vout_p) AT=437.5n
  meas tran vn_reset FIND v(vout_n) AT=437.5n

  echo ======================================
  echo END OF OFFSET POINT
  echo ======================================

  reset

end

echo
echo ALL 11 OFFSET POINTS COMPLETED
echo

.endc"}
C {sky130_fd_pr/corner.sym} 580 -380 0 0 {name=CORNER only_toplevel=false corner=tt}
C {lab_wire.sym} 240 -200 0 0 {name=p3 sig_type=std_logic lab=Vin1}
C {lab_wire.sym} 310 -180 0 0 {name=p4 sig_type=std_logic lab=Vin2}
C {lab_wire.sym} 170 -220 0 0 {name=p5 sig_type=std_logic lab=CLK}
