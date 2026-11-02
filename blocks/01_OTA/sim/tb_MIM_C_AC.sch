v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {TAHAP 3: UJI KAPASITANSI MIM (AC), multiplisitas MF dan m} 100 -480 0 0 0.4 0.4 {}
T {Kapasitor MIM ada di dalam OTA (kompensasi), bukan di jalur Cs/Cf. C diukur dari -Im(I)/(2*pi*f) pada 1 MHz.} 100 -430 0 0 0.25 0.25 {}
T {REF=1p ideal (kalibrasi metode). SYM100/SYM1000 = simbol sky130 cap_mim_m3_1 (periksa baris netlist yang DIEMIT). A-E = baris SPICE mentah.} 100 -390 0 0 0.25 0.25 {}
N 120 40 120 70 {lab=N_REF}
N 120 130 120 150 {lab=0}
C {lab_pin.sym} 120 40 0 1 {name=lNREF lab=N_REF}
C {gnd.sym} 120 150 0 0 {name=gNREF lab=0}
C {vsource.sym} 120 100 0 0 {name=VREF value="dc 0 ac 1" savecurrent=false}
N 320 40 320 70 {lab=N_SYM100}
N 320 130 320 150 {lab=0}
C {lab_pin.sym} 320 40 0 1 {name=lNSYM100 lab=N_SYM100}
C {gnd.sym} 320 150 0 0 {name=gNSYM100 lab=0}
C {vsource.sym} 320 100 0 0 {name=VSYM100 value="dc 0 ac 1" savecurrent=false}
N 520 40 520 70 {lab=N_SYM1000}
N 520 130 520 150 {lab=0}
C {lab_pin.sym} 520 40 0 1 {name=lNSYM1000 lab=N_SYM1000}
C {gnd.sym} 520 150 0 0 {name=gNSYM1000 lab=0}
C {vsource.sym} 520 100 0 0 {name=VSYM1000 value="dc 0 ac 1" savecurrent=false}
C {capa.sym} 120 -100 0 0 {name=C_REF m=1 value=1p}
C {lab_pin.sym} 120 -130 0 1 {name=lREF1 lab=N_REF}
C {lab_pin.sym} 120 -70 0 1 {name=lREF2 lab=0}
C {sky130_fd_pr/cap_mim_m3_1.sym} 320 -100 3 0 {name=C_SYM100 model=cap_mim_m3_1 W=1 L=1 MF=100 spiceprefix=X}
C {lab_pin.sym} 290 -100 0 1 {name=lSYM1001 lab=N_SYM100}
C {lab_pin.sym} 350 -100 0 1 {name=lSYM1002 lab=0}
C {sky130_fd_pr/cap_mim_m3_1.sym} 520 -100 3 0 {name=C_SYM1000 model=cap_mim_m3_1 W=1 L=1 MF=1000 spiceprefix=X}
C {lab_pin.sym} 490 -100 0 1 {name=lSYM10001 lab=N_SYM1000}
C {lab_pin.sym} 550 -100 0 1 {name=lSYM10002 lab=0}
C {sky130_fd_pr/corner.sym} 940 100 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code.sym} 740 100 0 0 {name=SIM only_toplevel=true value="
* tahap 3: kapasitansi MIM via AC. TT, 27 C. Variabel dibedakan HANYA lewat MF dan m.
.option scale=1e-6
.temp 27
VA N_A 0 dc 0 ac 1
XCA N_A 0 sky130_fd_pr__cap_mim_m3_1 W=1 L=1 MF=100 m=100
VB N_B 0 dc 0 ac 1
XCB N_B 0 sky130_fd_pr__cap_mim_m3_1 W=1 L=1 MF=100 m=1
VC N_C 0 dc 0 ac 1
XCC N_C 0 sky130_fd_pr__cap_mim_m3_1 W=1 L=1 MF=1 m=100
VD N_D 0 dc 0 ac 1
XCD N_D 0 sky130_fd_pr__cap_mim_m3_1 W=1 L=1 MF=1000 m=1
VE N_E 0 dc 0 ac 1
XCE N_E 0 sky130_fd_pr__cap_mim_m3_1 W=1 L=1 MF=1 m=1
.control
set wr_singlescale
set wr_vecnames
set numdgt=12
ac dec 20 1e4 1e8
let w = 2*pi*real(frequency)
let C_REF = -imag(i(VREF))/w
let C_SYM100 = -imag(i(VSYM100))/w
let C_SYM1000 = -imag(i(VSYM1000))/w
let C_A = -imag(i(VA))/w
let C_B = -imag(i(VB))/w
let C_C = -imag(i(VC))/w
let C_D = -imag(i(VD))/w
let C_E = -imag(i(VE))/w
wrdata tb_MIM_C_AC.dat C_REF C_SYM100 C_SYM1000 C_A C_B C_C C_D C_E
echo TB_MIM_DONE
.endc
"}
