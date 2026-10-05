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
N 370 -60 370 -40 {lab=0}
N 640 -240 720 -240 {lab=Vout_n}
N 640 -260 850 -260 {lab=Vout_p}
N 720 -240 720 -190 {lab=Vout_n}
N 850 -260 850 -190 {lab=Vout_p}
N 850 -130 850 -110 {lab=0}
N 720 -130 720 -110 {lab=0}
N 720 -240 900 -240 {lab=Vout_n}
N 850 -260 900 -260 {lab=Vout_p}
N 640 -310 640 -280 {lab=VCC}
N 640 -220 640 -190 {lab=0}
N 30 -150 30 -120 {lab=VCC}
N 90 -280 90 -120 {lab=Vcmfb1}
N 90 -280 410 -280 {lab=Vcmfb1}
N 150 -250 150 -120 {lab=Vbz}
N 150 -250 240 -250 {lab=Vbz}
N 240 -250 240 -240 {lab=Vbz}
N 240 -260 240 -250 {lab=Vbz}
N 240 -260 410 -260 {lab=Vbz}
N 240 -240 410 -240 {lab=Vbz}
N 390 -220 410 -220 {lab=Vin_p}
N 390 -200 410 -200 {lab=Vin_n}
N 370 -180 370 -120 {lab=Vbias}
N 370 -180 410 -180 {lab=Vbias}
N 210 -210 210 -160 {lab=Vin_p}
N 210 -220 390 -220 {lab=Vin_p}
N 210 -220 210 -210 {lab=Vin_p}
N 270 -200 270 -120 {lab=Vin_n}
N 270 -200 390 -200 {lab=Vin_n}
N 270 -60 270 -40 {lab=0}
N 210 -160 210 -120 {lab=Vin_p}
C {vsource.sym} 30 -90 0 0 {name=V1 value=1.8}
C {vsource.sym} 90 -90 0 0 {name=V2 value=0.9}
C {vsource.sym} 150 -90 0 0 {name=V3 value=1.5}
C {vsource.sym} 370 -90 0 0 {name=V6 value=0.507621}
C {gnd.sym} 30 -40 0 0 {name=l1 lab=0}
C {gnd.sym} 90 -40 0 0 {name=l2 lab=0}
C {gnd.sym} 150 -40 0 0 {name=l3 lab=0}
C {gnd.sym} 210 -40 0 0 {name=l4 lab=0}
C {gnd.sym} 370 -40 0 0 {name=l6 lab=0}
C {gnd.sym} 720 -110 0 0 {name=l8 lab=0}
C {gnd.sym} 850 -110 0 0 {name=l9 lab=0}
C {opin.sym} 900 -260 0 0 {name=p1 lab=Vout_p}
C {opin.sym} 900 -240 0 0 {name=p2 lab=Vout_n}
C {vdd.sym} 30 -150 0 0 {name=l10 lab=VCC}
C {vdd.sym} 640 -310 0 0 {name=l11 lab=VCC}
C {gnd.sym} 640 -190 0 0 {name=l7 lab=0}
C {capa-2.sym} 720 -160 0 0 {name=C1
m=1
value=20p
footprint=1206
device=polarized_capacitor
}
C {capa-2.sym} 850 -160 0 0 {name=C2
m=1
value=20p
footprint=1206
device=polarized_capacitor
}
C {lab_wire.sym} 370 -280 0 0 {name=p4
sig_type=std_logic
lab=Vcmfb1
}
C {lab_wire.sym} 210 -250 0 0 {name=p5
sig_type=std_logic
lab=Vbz
}
C {lab_wire.sym} 260 -220 0 0 {name=p6
sig_type=std_logic
lab=Vin_p
}
C {lab_wire.sym} 350 -200 0 0 {name=p7
sig_type=std_logic
lab=Vin_n
}
C {lab_wire.sym} 400 -180 0 0 {name=p8
sig_type=std_logic
lab=Vbias
}
C {code_shown.sym} 0 -1370 0 0 {name=s1
only_toplevel=true
value="
* ==========================================================
* OTA DIFFERENTIAL NOISE CHARACTERIZATION
*
* Differential stimulus:
* VDIFF AC = 1 V
*
* Vin_p = 0.4 + Vdiff/2
* Vin_n = 0.4 - Vdiff/2
*
* Therefore:
* Vin_p - Vin_n = Vdiff
* ==========================================================

VDIFF vdiff 0 DC 0 AC 1

BIP vin_p 0 V=0.4+0.5*V(vdiff)
BIN vin_n 0 V=0.4-0.5*V(vdiff)

.control
save all

* ----------------------------------------------------------
* Check nominal operating point first
* ----------------------------------------------------------
op

echo ===== NOISE TEST OPERATING POINT =====
print v(vin_p)
print v(vin_n)
print v(vout_p)
print v(vout_n)

* ----------------------------------------------------------
* DIFFERENTIAL NOISE ANALYSIS
*
* Target modulator:
* fs  = 4 MHz
* OSR = 80
*
* Baseband BW = fs/(2*OSR) = 25 kHz
* ----------------------------------------------------------

noise v(vout_p,vout_n) VDIFF dec 100 1 25k

* Noise spectral density
setplot noise1

plot onoise_spectrum
plot inoise_spectrum

* Integrated noise
setplot noise2

echo ===== IN-BAND INTEGRATED NOISE 1 Hz - 25 kHz =====
print onoise_total
print inoise_total

.endc
"
}
C {sky130_fd_pr/corner.sym} 780 -400 0 0 {name=CORNER
only_toplevel=false
corner=tt
}
C {blocks/01_OTA/xschem/OTA_experiment.sym} 560 -230 0 0 {name=x1}
C {gnd.sym} 270 -40 0 0 {name=l5 lab=0}
C {vsource.sym} 210 -90 0 0 {name=V4 value=0}
C {vsource.sym} 270 -90 0 0 {name=V5 value=0}
