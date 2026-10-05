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
N 210 -160 210 -120 {lab=Vrefd}
N 390 -220 410 -220 {lab=Vin_p}
N 390 -200 410 -200 {lab=Vin_n}
N 370 -180 370 -120 {lab=Vbias}
N 370 -180 410 -180 {lab=Vbias}
N 210 -210 210 -160 {lab=Vrefd}
N 210 -210 240 -210 {lab=Vrefd}
C {vsource.sym} 30 -90 0 0 {name=V1 value=1.8}
C {vsource.sym} 90 -90 0 0 {name=V2 value=0.9}
C {vsource.sym} 150 -90 0 0 {name=V3 value=1.5}
C {vsource.sym} 210 -90 0 0 {name=V4 value="PULSE(1u 300m 200n 1n 1n 500n 1.2u)"}
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
C {lab_wire.sym} 210 -160 0 0 {name=p3
sig_type=std_logic
lab=Vrefd
}
C {lab_wire.sym} 370 -280 0 0 {name=p4
sig_type=std_logic
lab=Vcmfb1
}
C {lab_wire.sym} 210 -250 0 0 {name=p5
sig_type=std_logic
lab=Vbz
}
C {lab_wire.sym} 390 -220 0 0 {name=p6
sig_type=std_logic
lab=Vin_p
}
C {lab_wire.sym} 390 -200 0 0 {name=p7
sig_type=std_logic
lab=Vin_n
}
C {lab_wire.sym} 400 -180 0 0 {name=p8
sig_type=std_logic
lab=Vbias
}
C {noconn.sym} 210 -160 0 0 {name=NC1}
C {noconn.sym} 390 -220 0 0 {name=NC2}
C {noconn.sym} 390 -200 0 0 {name=NC3}
C {code_shown.sym} -30 -1730 0 0 {name=s1
only_toplevel=true
value="
* ==========================================================
* OTA LARGE-SIGNAL CLOSED-LOOP SLEW-RATE TEST
* ==========================================================

* ----------------------------------------------------------
* CLOSED-LOOP BEHAVIORAL FEEDBACK
*
* OTA polarity:
* Vod = -A*Vid
*
* Feedback:
* Vid = Vod - Vrefd
*
* Vin common-mode maintained near 0.4 V
* ----------------------------------------------------------

BVP vdrv_p 0 V=0.4+0.5*((V(vout_p)-V(vout_n))-V(vrefd))
BVN vdrv_n 0 V=0.4-0.5*((V(vout_p)-V(vout_n))-V(vrefd))

* Numerical isolation
RFBP vdrv_p vin_p 1k
RFBN vdrv_n vin_n 1k

* Weak DC paths
RLEAKP vin_p 0 1G
RLEAKN vin_n 0 1G

* Known healthy operating point
.nodeset V(vin_p)=0.4
.nodeset V(vin_n)=0.4
.nodeset V(vout_p)=0.9184
.nodeset V(vout_n)=0.9184


* ==========================================================
* SIMULATION COMMANDS
* ==========================================================

.control
save all

tran 0.1n 1.4u

let vod = v(vout_p)-v(vout_n)
let vocm = (v(vout_p)+v(vout_n))/2
let dvod = deriv(vod)

echo ===== OTA LARGE SIGNAL SLEW RATE =====

meas tran sr_pos MAX dvod FROM=205n TO=650n
meas tran sr_neg MIN dvod FROM=705n TO=1.15u

meas tran vod_high AVG vod FROM=550n TO=680n
meas tran vod_low AVG vod FROM=1.00u TO=1.20u

meas tran vocm_min MIN vocm FROM=200n TO=1.20u
meas tran vocm_max MAX vocm FROM=200n TO=1.20u

let sr_neg_abs = -sr_neg

let sr_pos_vus = sr_pos*1e-6
let sr_neg_vus = sr_neg_abs*1e-6

echo ===== SLEW RATE RESULTS =====
print sr_pos_vus
print sr_neg_vus
print vod_high
print vod_low
print vocm_min
print vocm_max

plot v(vrefd) vod
plot dvod
plot vocm

.endc
"
}
C {sky130_fd_pr/corner.sym} 780 -400 0 0 {name=CORNER
only_toplevel=false
corner=tt
}
C {blocks/01_OTA/xschem/OTA_experiment.sym} 560 -230 0 0 {name=x1}
