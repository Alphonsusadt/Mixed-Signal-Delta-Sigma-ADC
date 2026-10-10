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
N 250 -200 250 -140 {lab=Vin1}
N 250 -200 300 -200 {lab=Vin1}
N 360 -200 510 -200 {lab=Vin1}
N 510 -200 590 -200 {lab=Vin1}
N 320 -180 320 -140 {lab=Vin2}
N 320 -180 370 -180 {lab=Vin2}
N 430 -180 510 -180 {lab=Vin2}
N 510 -180 590 -180 {lab=Vin2}
N 830 -200 830 -150 {lab=Vout_P}
N 890 -180 890 -150 {lab=Vout_N}
N 830 -90 830 -80 {lab=0}
N 890 -90 890 -80 {lab=0}
N 790 -200 840 -200 {lab=Vout_P}
N 840 -200 910 -200 {lab=Vout_P}
N 910 -200 960 -200 {lab=Vout_P}
N 790 -180 840 -180 {lab=Vout_N}
N 840 -180 850 -180 {lab=Vout_N}
N 850 -180 960 -180 {lab=Vout_N}
N 300 -200 360 -200 {lab=Vin1}
N 370 -180 430 -180 {lab=Vin2}
C {blocks/03_StrongARM/xschem/StrongARM.sym} 740 -190 0 0 {name=x1}
C {vsource.sym} 80 -110 0 0 {name=VVDD value="\{PVT_VDD\}" savecurrent=false}
C {vdd.sym} 80 -160 0 0 {name=l1 lab=VDD}
C {vdd.sym} 790 -240 0 0 {name=l2 lab=VDD}
C {vsource.sym} 250 -110 0 0 {name=VVin1 value=0.895 savecurrent=false}
C {vsource.sym} 320 -110 0 0 {name=VVin2 value=0.905 savecurrent=false}
C {vsource.sym} 170 -110 0 0 {name=VPulse value="PULSE(0 \{PVT_VDD\} 0 5n 5n 125n 250n)" savecurrent=false}
C {gnd.sym} 80 -70 0 0 {name=l3 lab=0}
C {gnd.sym} 250 -70 0 0 {name=l4 lab=0}
C {gnd.sym} 320 -70 0 0 {name=l5 lab=0}
C {gnd.sym} 170 -70 0 0 {name=l6 lab=0}
C {gnd.sym} 790 -150 0 0 {name=l7 lab=0}
C {opin.sym} 960 -200 0 0 {name=p1 lab=Vout_P}
C {opin.sym} 960 -180 0 0 {name=p2 lab=Vout_N}
C {capa-2.sym} 830 -120 0 0 {name=C1 m=1 value=20f footprint=1206 device=polarized_capacitor}
C {capa-2.sym} 890 -120 0 0 {name=C2 m=1 value=20f footprint=1206 device=polarized_capacitor}
C {gnd.sym} 830 -80 0 0 {name=l8 lab=0}
C {gnd.sym} 890 -80 0 0 {name=l9 lab=0}
C {lab_wire.sym} 190 -220 0 0 {name=p5 sig_type=std_logic lab=CLK}
C {lab_wire.sym} 470 -200 0 0 {name=p6 sig_type=std_logic lab=Vin1}
C {lab_wire.sym} 530 -180 0 0 {name=p7 sig_type=std_logic lab=Vin2}
C {sky130_fd_pr/corner.sym} 840 -420 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 80 -370 0 0 {name=s1 only_toplevel=false
value="

* ==========================================
* BLOCK 3 - STRONGARM COMPARATOR
* TEST 8 - AUTOMATED PVT VERIFICATION
* SKY130 / 4MHz / 20fF OUTPUT LOADS
* VDD: 1.62 / 1.80 / 1.90 V
* TEMP: -40 / 27 / 125 CELSIUS
* VIN COMMON MODE: FIXED 0.9 V
* ==========================================

.param PVT_VDD=1.8

.control
save all

echo ==========================================
echo STRONGARM AUTOMATED PVT VERIFICATION
echo ==========================================

foreach v 1.62 1.80 1.90

  foreach temp_c -40 27 125

    * Reload the circuit with new supply
    alterparam PVT_VDD=$v
    reset

    * Apply temperature after reset
    set temp=$temp_c

    foreach dv -0.01 0.01

      setplot const

      let vip = 0.9 + ($dv / 2)
      let vin = 0.9 - ($dv / 2)

      alter VVin1 $&vip
      alter VVin2 $&vin

      echo
      echo ==========================================
      echo PVT_CASE_BEGIN
      echo VDD = $v
      echo TEMP_C = $temp_c
      echo DIFFERENTIAL_V = $dv
      echo ==========================================

      tran 0.2n 2.5u
	* Audit transistor S3

let s3_vgs = abs(v(clk)-v(vdd))
let s3_vgd = abs(v(clk)-v(vout_p))
let s3_vds = abs(v(vout_p)-v(vdd))

meas tran s3_vgs_max MAX s3_vgs FROM=1.99u TO=2.15u
meas tran s3_vgd_max MAX s3_vgd FROM=1.99u TO=2.15u
meas tran s3_vds_max MAX s3_vds FROM=1.99u TO=2.15u

      * Rail tracking verification
      meas tran supply_hi FIND v(vdd) AT=2.01u
      meas tran clk_hi FIND v(clk) AT=2.01u

      * Dynamic logic threshold: 50 percent VDD
      let vhalf = $v / 2

      * Decision delay on the expected falling side
      if $dv < 0
        meas tran decision_delay TRIG v(clk) VAL=$&vhalf RISE=9 TARG v(vout_n) VAL=$&vhalf FALL=9
      else
        meas tran decision_delay TRIG v(clk) VAL=$&vhalf RISE=9 TARG v(vout_p) VAL=$&vhalf FALL=9
      end

      * Evaluated logic levels
      meas tran vp_eval FIND v(vout_p) AT=2.01u
      meas tran vn_eval FIND v(vout_n) AT=2.01u

      * Later decision check
      meas tran vp_late FIND v(vout_p) AT=2.08u
      meas tran vn_late FIND v(vout_n) AT=2.08u

      * Reset verification
      meas tran vp_reset FIND v(vout_p) AT=2.20u
      meas tran vn_reset FIND v(vout_n) AT=2.20u

      * Supply current
      meas tran ivdd_avg AVG i(VVDD) FROM=500n TO=2.5u

      * Power and energy
      let power_uw = -$v * ivdd_avg * 1e6
      let energy_pj = power_uw / 4

      * Decision time
      let delay_ns = decision_delay * 1e9

      echo ==========================================
      echo PVT TIMING
      echo ==========================================
      print delay_ns

      echo ==========================================
      echo PVT POWER
      echo ==========================================
      print power_uw
      print energy_pj

      echo ==========================================
      echo OUTPUT EXTREMA
      echo ==========================================

      meas tran vp_max MAX v(vout_p) FROM=500n TO=2.5u
      meas tran vp_min MIN v(vout_p) FROM=500n TO=2.5u

      meas tran vn_max MAX v(vout_n) FROM=500n TO=2.5u
      meas tran vn_min MIN v(vout_n) FROM=500n TO=2.5u

      echo ==========================================
      echo PVT_CASE_END
      echo ==========================================

    end

  end

end

echo
echo ==========================================
echo ALL 18 PVT CASES COMPLETED
echo ==========================================
echo

.endc"}
