v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}

N 30 -60 30 -40 {lab=0}
N 90 -60 90 -40 {lab=0}
N 150 -60 150 -40 {lab=0}
N 210 -60 210 -40 {lab=0}
N 310 -60 310 -40 {lab=0}
N 370 -60 370 -40 {lab=0}
N 500 -60 500 -40 {lab=0}

N 640 -240 720 -240 {lab=Vout_n}
N 640 -260 850 -260 {lab=Vout_p}

N 720 -240 720 -190 {lab=Vout_n}
N 850 -260 850 -190 {lab=Vout_p}

N 720 -130 720 -110 {lab=0}
N 850 -130 850 -110 {lab=0}

N 720 -240 900 -240 {lab=Vout_n}
N 850 -260 900 -260 {lab=Vout_p}

N 640 -310 640 -280 {lab=VCC}

N 640 -220 640 -190 {lab=VSS}

N 30 -150 30 -120 {lab=VCC}

N 90 -280 90 -120 {lab=Vcmfb1}
N 90 -280 410 -280 {lab=Vcmfb1}

N 150 -250 150 -120 {lab=Vbz}
N 150 -250 240 -250 {lab=Vbz}
N 240 -250 240 -240 {lab=Vbz}
N 240 -260 240 -250 {lab=Vbz}
N 240 -260 410 -260 {lab=Vbz}
N 240 -240 410 -240 {lab=Vbz}

N 210 -220 210 -120 {lab=Vin_p}
N 210 -220 410 -220 {lab=Vin_p}

N 310 -200 310 -120 {lab=Vin_n}
N 310 -200 410 -200 {lab=Vin_n}

N 370 -180 370 -120 {lab=Vbias}
N 370 -180 410 -180 {lab=Vbias}

N 500 -150 500 -120 {lab=VSS}


C {vsource.sym} 30 -90 0 0 {
name=V1
value=1.8
}

C {vsource.sym} 90 -90 0 0 {
name=V2
value=0.9
}

C {vsource.sym} 150 -90 0 0 {
name=V3
value=1.5
}

C {vsource.sym} 210 -90 0 0 {
name=V4
value=0.4
}

C {vsource.sym} 310 -90 0 0 {
name=V5
value=0.4
}

C {vsource.sym} 370 -90 0 0 {
name=V6
value=0.507621
}

C {vsource.sym} 500 -90 0 0 {
name=VSSSRC
value="DC 0 AC 1"
}


C {gnd.sym} 30 -40 0 0 {name=l1 lab=0}
C {gnd.sym} 90 -40 0 0 {name=l2 lab=0}
C {gnd.sym} 150 -40 0 0 {name=l3 lab=0}
C {gnd.sym} 210 -40 0 0 {name=l4 lab=0}
C {gnd.sym} 310 -40 0 0 {name=l5 lab=0}
C {gnd.sym} 370 -40 0 0 {name=l6 lab=0}
C {gnd.sym} 500 -40 0 0 {name=l7 lab=0}

C {gnd.sym} 720 -110 0 0 {name=l8 lab=0}
C {gnd.sym} 850 -110 0 0 {name=l9 lab=0}


C {opin.sym} 900 -260 0 0 {
name=p1
lab=Vout_p
}

C {opin.sym} 900 -240 0 0 {
name=p2
lab=Vout_n
}


C {vdd.sym} 30 -150 0 0 {
name=l10
lab=VCC
}

C {vdd.sym} 640 -310 0 0 {
name=l11
lab=VCC
}


C {capa-2.sym} 720 -160 0 0 {
name=C1
m=1
value=20p
footprint=1206
device=polarized_capacitor
}

C {capa-2.sym} 850 -160 0 0 {
name=C2
m=1
value=20p
footprint=1206
device=polarized_capacitor
}


C {lab_wire.sym} 370 -280 0 0 {
name=p3
sig_type=std_logic
lab=Vcmfb1
}

C {lab_wire.sym} 210 -250 0 0 {
name=p4
sig_type=std_logic
lab=Vbz
}

C {lab_wire.sym} 370 -220 0 0 {
name=p5
sig_type=std_logic
lab=Vin_p
}

C {lab_wire.sym} 370 -200 0 0 {
name=p6
sig_type=std_logic
lab=Vin_n
}

C {lab_wire.sym} 400 -180 0 0 {
name=p7
sig_type=std_logic
lab=Vbias
}

C {lab_wire.sym} 640 -190 0 0 {
name=p8
sig_type=std_logic
lab=VSS
}

C {lab_wire.sym} 500 -150 0 0 {
name=p9
sig_type=std_logic
lab=VSS
}


C {code_shown.sym} 20 -700 0 0 {
name=s1
only_toplevel=true
value="
.control
save all

* ==========================================================
* OTA PSRR- / PSRRN CHARACTERIZATION
*
* Nominal operating conditions:
* VDD      = 1.8 V
* VSS DC   = 0 V
* VSS AC   = 1 V
* Vin_p    = 0.4 V
* Vin_n    = 0.4 V
* Vcmfb1   = 0.9 V
* Vbias    = 0.507621 V
*
* Differential output:
* Vod = Vout_p - Vout_n
* ==========================================================


* ----------------------------------------------------------
* 1. CHECK DC OPERATING POINT
* ----------------------------------------------------------

op

echo
echo ===== PSRR- OPERATING POINT =====

print v(vss)
print v(vin_p)
print v(vin_n)
print v(vout_p)
print v(vout_n)


* ----------------------------------------------------------
* 2. AC SUPPLY-RIPPLE ANALYSIS
* ----------------------------------------------------------

ac dec 100 1 1G

let vod = v(vout_p)-v(vout_n)

* Supply-to-output differential transfer
* VSS AC amplitude = 1 V
let ass = vod/v(vss)

* IMPORTANT:
* Perfect schematic symmetry can make ASS numerically zero.
* Add a very small numerical floor before log10().
let ass_mag = mag(ass)+1e-30

let ass_db = 20*log10(ass_mag)

* Validated nominal differential OTA gain
let Ad_dB = 69.34

* PSRR- expressed relative to differential gain
let psrrn_db = Ad_dB-ass_db


* ----------------------------------------------------------
* 3. MEASURE AT 1 Hz
* ----------------------------------------------------------

meas ac ASS_MAG_1HZ FIND ass_mag AT=1
meas ac ASS_DB_1HZ FIND ass_db AT=1
meas ac PSRRN_1HZ FIND psrrn_db AT=1


echo
echo ===== PSRR- RESULTS =====

print ASS_MAG_1HZ
print ASS_DB_1HZ
print PSRRN_1HZ


* ----------------------------------------------------------
* 4. PLOTS
* ----------------------------------------------------------

plot ass_db
plot psrrn_db

.endc
"
}


C {sky130_fd_pr/corner.sym} 780 -400 0 0 {
name=CORNER
only_toplevel=false
corner=tt
}


C {blocks/01_OTA/xschem/OTA_experiment.sym} 560 -230 0 0 {
name=x1
}
