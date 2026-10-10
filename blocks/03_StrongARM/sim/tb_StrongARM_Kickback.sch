v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 790 -240 790 -220 {lab=VDD}
N 80 -160 80 -140 {lab=VDD}
N 80 -80 80 -70 {lab=0}
N 170 -80 170 -70 {lab=0}
N 250 -80 250 -70 {lab=0}
N 320 -80 320 -70 {lab=0}
N 790 -160 790 -150 {lab=0}
N 170 -220 360 -220 {lab=CLK}
N 170 -220 170 -140 {lab=CLK}
N 360 -220 510 -220 {lab=CLK}
N 510 -220 590 -220 {lab=CLK}
N 250 -200 250 -140 {lab=Vsrc1}
N 250 -200 300 -200 {lab=Vsrc1}
N 360 -200 510 -200 {lab=Vin1}
N 510 -200 590 -200 {lab=Vin1}
N 320 -180 320 -140 {lab=Vsrc2}
N 320 -180 370 -180 {lab=Vsrc2}
N 430 -180 510 -180 {lab=Vin2}
N 510 -180 590 -180 {lab=Vin2}
N 470 -200 470 -150 {lab=Vin1}
N 530 -180 530 -150 {lab=Vin2}
N 470 -90 470 -80 {lab=0}
N 530 -90 530 -80 {lab=0}
N 790 -200 840 -200 {lab=Vout_P}
N 840 -200 910 -200 {lab=Vout_P}
N 910 -200 960 -200 {lab=Vout_P}
N 790 -180 840 -180 {lab=Vout_N}
N 840 -180 850 -180 {lab=Vout_N}
N 850 -180 960 -180 {lab=Vout_N}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 740 -190 0 0 {name=x1}
C {vsource.sym} 80 -110 0 0 {name=VVDD value=1.8 savecurrent=false}
C {vdd.sym} 80 -160 0 0 {name=l1 lab=VDD}
C {vdd.sym} 790 -240 0 0 {name=l2 lab=VDD}
C {vsource.sym} 250 -110 0 0 {name=VVin1 value=0.895 savecurrent=false}
C {vsource.sym} 320 -110 0 0 {name=VVin2 value=0.905 savecurrent=false}
C {vsource.sym} 170 -110 0 0 {name=VPulse value="PULSE(0 1.8 0 1n 1n 125n 250n)" savecurrent=false}
C {gnd.sym} 80 -70 0 0 {name=l3 lab=0}
C {gnd.sym} 250 -70 0 0 {name=l4 lab=0}
C {gnd.sym} 320 -70 0 0 {name=l5 lab=0}
C {gnd.sym} 170 -70 0 0 {name=l6 lab=0}
C {gnd.sym} 790 -150 0 0 {name=l7 lab=0}
C {opin.sym} 960 -200 0 0 {name=p1 lab=Vout_P}
C {opin.sym} 960 -180 0 0 {name=p2 lab=Vout_N}
C {res.sym} 330 -200 3 0 {name=R1 value=10k footprint=1206 device=resistor m=1}
C {res.sym} 400 -180 3 0 {name=R2 value=10k footprint=1206 device=resistor m=1}
C {capa-2.sym} 470 -120 0 0 {name=C1 m=1 value=100f footprint=1206 device=polarized_capacitor}
C {capa-2.sym} 530 -120 0 0 {name=C2 m=1 value=100f footprint=1206 device=polarized_capacitor}
C {gnd.sym} 470 -80 0 0 {name=l8 lab=0}
C {gnd.sym} 530 -80 0 0 {name=l9 lab=0}
C {lab_wire.sym} 260 -200 0 0 {name=p3 sig_type=std_logic lab=Vsrc1}
C {lab_wire.sym} 330 -180 0 0 {name=p4 sig_type=std_logic lab=Vsrc2}
C {lab_wire.sym} 190 -220 0 0 {name=p5 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 470 -200 0 0 {name=p6 sig_type=std_logic lab=Vin1}
C {lab_wire.sym} 530 -180 0 0 {name=p7 sig_type=std_logic lab=Vin2}
C {sky130_fd_pr/corner.sym} 840 -420 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 80 -370 0 0 {name=s1 only_toplevel=false
value="

.control
save all

* ============================================
* BLOCK 3 - STRONGARM COMPARATOR
* TEST 7B - AUTOMATED KICKBACK SWEEP
* SKY130 TT / VDD 1.8V / CLK 4MHz
* 9 RC COMBINATIONS / 2 POLARITIES
* ============================================

echo ============================================
echo STRONGARM AUTOMATED KICKBACK TEST 7B
echo ============================================

foreach r 1k 10k 100k

  foreach c 50f 100f 500f

    * Apply identical source impedance
    alter R1 $r
    alter R2 $r
    alter C1 $c
    alter C2 $c

    foreach dv -0.01 0.01

      setplot const

      let vip = 0.9 + ($dv / 2)
      let vin = 0.9 - ($dv / 2)

      alter VVin1 $&vip
      alter VVin2 $&vin

      echo
      echo ============================================
      echo RC CONFIGURATION
      echo Rsource = $r
      echo Csource = $c
      echo Differential input = $dv
      echo ============================================

      * Run transient through reset and evaluation
      tran 0.05n 2.25u

      * Input disturbances relative to ideal sources
      let d1 = v(vin1) - v(vsrc1)
      let d2 = v(vin2) - v(vsrc2)

      * Differential and common-mode kickback
      let kbdiff = d1 - d2
      let kbcm = (d1 + d2) / 2

      let absdiff = abs(kbdiff)
      let abscm = abs(kbcm)

      * Before clock evaluation
      meas tran vin1_pre FIND v(vin1) AT=1.99u
      meas tran vin2_pre FIND v(vin2) AT=1.99u

      * Evaluation rising edge at 2us
      meas tran kb_eval MAX absdiff FROM=2u TO=2.02u
      meas tran kb_common MAX abscm FROM=2u TO=2.02u

      * Reset falling edge at 2.125us
      meas tran kb_reset MAX absdiff FROM=2.125u TO=2.145u

      * Check comparator decision
      meas tran vp_eval FIND v(vout_p) AT=2.01u
      meas tran vn_eval FIND v(vout_n) AT=2.01u

      * Check settled decision
      meas tran vp_late FIND v(vout_p) AT=2.08u
      meas tran vn_late FIND v(vout_n) AT=2.08u

      * Check reset
      meas tran vp_reset FIND v(vout_p) AT=2.20u
      meas tran vn_reset FIND v(vout_n) AT=2.20u

      * Convert results to millivolts
      let kb_eval_mV = kb_eval * 1e3
      let kb_reset_mV = kb_reset * 1e3
      let kb_common_mV = kb_common * 1e3

      echo ============================================
      echo KICKBACK RESULTS IN mV
      echo ============================================

      print kb_eval_mV
      print kb_reset_mV
      print kb_common_mV

      echo ============================================
      echo OUTPUT DECISION RESULTS
      echo ============================================

      print vp_eval
      print vn_eval
      print vp_late
      print vn_late

      echo ============================================
      echo END OF CONFIGURATION
      echo ============================================

    end

  end

end

echo
echo ============================================
echo ALL 18 KICKBACK SIMULATIONS COMPLETED
echo ============================================
echo

.endc"}
