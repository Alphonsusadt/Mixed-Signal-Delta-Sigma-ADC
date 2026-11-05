#!/usr/bin/env python3
"""make_block6.py - bangkitkan sch/sym Blok 6 (generator clock non-overlap, topologi Spilka et al. DDECS 2012 Fig. 7)
dan testbench-nya, lalu verifikasi statis (tanpa xschem/ngspice):
  (1) tiap terminal MOS/instance punya lab_pin tepat di koordinat pin;
  (2) tabel kebenaran switch-level tiap sel dan kondisi tunak top-level;
  (3) model event untuk memeriksa urutan edge (BUKAN timing analog).
Ukuran W/L = nilai AWAL (placeholder), belum dioptimasi. Tidak ada simulasi ngspice yang dijalankan di sini.
Pemakaian:  python3 tools/make_block6.py [--out REPO_ROOT] [--vbn 0.60]
"""
import argparse, os, sys, itertools

XS = "blocks/06_Clock_gen/xschem"
SIM = "blocks/06_Clock_gen/sim"
HEAD = "v {xschem version=3.4.8RC file_version=1.3}\nG {}\nK {}\nV {}\nS {}\nF {}\nE {}\n"
MOSATTR = '''ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0'''

# ---------------- definisi sel (netlist) ----------------
# MOS: (name, 'n'|'p', D, G, S, B, W, L)
# port: (name, side, dir)  side: L R T B
CELLS = {}
def cell(name, ports, mos=(), inst=(), cap=()):
    CELLS[name] = dict(ports=ports, mos=list(mos), inst=list(inst), cap=list(cap))

# nilai awal ukuran (um) - placeholder, TBD
cell("B6_INV", [("IN","L","in"),("OUT","R","out"),("VDD","T","inout"),("GND","B","inout")],
     mos=[("MP","p","OUT","IN","VDD","VDD",2,0.15),("MN","n","OUT","IN","GND","GND",1,0.15)])
cell("B6_NAND2", [("A","L","in"),("B","L","in"),("OUT","R","out"),("VDD","T","inout"),("GND","B","inout")],
     mos=[("MPA","p","OUT","A","VDD","VDD",2,0.15),("MPB","p","OUT","B","VDD","VDD",2,0.15),
          ("MNA","n","OUT","A","n1","GND",2,0.15),("MNB","n","n1","B","GND","GND",2,0.15)])
cell("B6_NOR2", [("A","L","in"),("B","L","in"),("OUT","R","out"),("VDD","T","inout"),("GND","B","inout")],
     mos=[("MPA","p","p1","A","VDD","VDD",4,0.15),("MPB","p","OUT","B","p1","VDD",4,0.15),
          ("MNA","n","OUT","A","GND","GND",1,0.15),("MNB","n","OUT","B","GND","GND",1,0.15)])
# XOR = AOI21(A,B,C) dengan C = NOR2(A,B):  OUT = ~(A.B + C)
cell("B6_XOR", [("A","L","in"),("B","L","in"),("OUT","R","out"),("VDD","T","inout"),("GND","B","inout")],
     mos=[("MPA","p","pa","A","VDD","VDD",4,0.15),("MPB","p","pa","B","VDD","VDD",4,0.15),
          ("MPC","p","OUT","C","pa","VDD",4,0.15),
          ("MNA","n","OUT","A","na","GND",2,0.15),("MNB","n","na","B","GND","GND",2,0.15),
          ("MNC","n","OUT","C","GND","GND",1,0.15)],
     inst=[("xnor","B6_NOR2",dict(A="A",B="B",OUT="C",VDD="VDD",GND="GND"))])
cell("B6_AND2", [("A","L","in"),("B","L","in"),("OUT","R","out"),("VDD","T","inout"),("GND","B","inout")],
     inst=[("xnand","B6_NAND2",dict(A="A",B="B",OUT="NB",VDD="VDD",GND="GND")),
           ("xinv","B6_INV",dict(IN="NB",OUT="OUT",VDD="VDD",GND="GND"))])
# sel tunda: inverter current-starved (inverting). VBP/VBN = bias (dari testbench; pembangkit bias = tahap berikutnya)
cell("B6_DELAY_CS", [("IN","L","in"),("VBP","T","in"),("VDD","T","inout"),("OUT","R","out"),("VBN","B","in"),("GND","B","inout")],
     mos=[("MPS","p","nps","VBP","VDD","VDD",1,1),("MPI","p","OUT","IN","nps","VDD",1,0.15),
          ("MNI","n","OUT","IN","nns","GND",0.5,0.15),("MNS","n","nns","VBN","GND","GND",0.5,1)],
     cap=[("C1","OUT","GND",4)])   # MIM, MF=4 -> m=4 (model: hanya m yang mengalikan) ~10.6 fF, TBD
cell("B6_NONOV", [("CLK","L","in"),("PHI1","R","out"),("PHI1B","R","out"),("PHI2","R","out"),("PHI2B","R","out"),
                  ("VDD","T","inout"),("VBP","T","in"),("GND","B","inout"),("VBN","B","in")],
     inst=[("x1","B6_XOR",dict(A="CLK",B="VDD",OUT="CLKB",VDD="VDD",GND="GND")),
           ("x2","B6_XOR",dict(A="CLK",B="GND",OUT="CLKS",VDD="VDD",GND="GND")),
           ("xd1","B6_DELAY_CS",dict(IN="CLKB",OUT="DCLKB",VBP="VBP",VBN="VBN",VDD="VDD",GND="GND")),
           ("xd2","B6_DELAY_CS",dict(IN="CLKS",OUT="DCLKS",VBP="VBP",VBN="VBN",VDD="VDD",GND="GND")),
           ("xa1","B6_AND2",dict(A="CLKB",B="DCLKS",OUT="PHI1S",VDD="VDD",GND="GND")),
           ("xa2","B6_AND2",dict(A="CLKS",B="DCLKB",OUT="PHI2S",VDD="VDD",GND="GND")),
           ("x3","B6_XOR",dict(A="PHI1S",B="VDD",OUT="PHI1B",VDD="VDD",GND="GND")),
           ("x4","B6_XOR",dict(A="PHI1S",B="GND",OUT="PHI1",VDD="VDD",GND="GND")),
           ("x5","B6_XOR",dict(A="PHI2S",B="VDD",OUT="PHI2B",VDD="VDD",GND="GND")),
           ("x6","B6_XOR",dict(A="PHI2S",B="GND",OUT="PHI2",VDD="VDD",GND="GND"))])

# ---------------- geometri simbol ----------------
def sym_geom(name):
    ports = CELLS[name]["ports"]
    sides = {"L":[], "R":[], "T":[], "B":[]}
    for p in ports: sides[p[1]].append(p)
    n = max(len(sides["L"]), len(sides["R"]))
    H = 60 if n <= 3 else 100
    pos = {}
    def ys(k):  # y untuk k pin kiri/kanan, kelipatan 40
        return [(-40*(k-1)//2 + 40*i) if k>1 else 0 for i in range(k)]
    for side in ("L","R"):
        k = len(sides[side]); y0 = ys(k)
        for p, y in zip(sides[side], y0):
            pos[p[0]] = (-80 if side=="L" else 80, int(y))
    for side, yy in (("T",-(H+20)),("B",H+20)):
        k = len(sides[side])
        xs = [-20] if k==1 else [-40+80*i/(k-1) for i in range(k)]
        for p, x in zip(sides[side], xs): pos[p[0]] = (int(x), yy)
    return H, pos

def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w").write(text)

def make_sym(name):
    H, pos = sym_geom(name)
    ports = {p[0]:p for p in CELLS[name]["ports"]}
    s = ('v {xschem version=3.4.8RC file_version=1.3}\nG {}\nK {type=subcircuit\nformat="@name @pinlist @symname"\n'
         'spectre_format="@name ( @pinlist ) @symname"\ntemplate="name=x1"\n}\nV {}\nS {}\nF {}\nE {}\n')
    s += f"T {{@symname}} -48 -6 0 0 0.25 0.25 {{}}\nT {{@name}} 65 {-H-42} 0 0 0.2 0.2 {{}}\n"
    s += f"P 4 5 -60 {-H} 60 {-H} 60 {H} -60 {H} -60 {-H} {{}}\n"
    for pn, (x, y) in pos.items():
        d = ports[pn][2]
        s += f"B 5 {x-2.5} {y-2.5} {x+2.5} {y+2.5} {{name={pn} dir={d}}}\n"
        if x == -80: s += f"L 4 -80 {y} -60 {y} {{}}\nT {{{pn}}} -56 {y-6} 0 0 0.2 0.2 {{}}\n"
        elif x == 80: s += f"L 4 60 {y} 80 {y} {{}}\nT {{{pn}}} 22 {y-6} 0 0 0.2 0.2 {{}}\n"
        elif y < 0: s += f"L 7 {x} {y} {x} {-H} {{}}\nT {{{pn}}} {x+4} {-H+6} 0 0 0.2 0.2 {{}}\n"
        else: s += f"L 7 {x} {H} {x} {y} {{}}\nT {{{pn}}} {x+4} {H-18} 0 0 0.2 0.2 {{}}\n"
    return s

# ---------------- pin MOS / emisi sch ----------------
def mos_pins(kind, x, y):
    # n: rot0 ; p: rot2 flip1 (S di atas, D di bawah)
    if kind == "n": return {"G":(x-20,y),"D":(x+20,y-30),"S":(x+20,y+30),"B":(x+20,y)}
    return {"G":(x-20,y),"D":(x+20,y+30),"S":(x+20,y-30),"B":(x+20,y)}

def lp(x, y, lab, idx):
    return f"C {{lab_pin.sym}} {x} {y} 0 1 {{name=l{idx} lab={lab}}}\n"

def make_sch(name):
    c = CELLS[name]; s = HEAD; k = 0; checks = []   # checks: (x,y,label) harus punya lab_pin
    # port
    y = -300
    for pn, side, d in c["ports"]:
        sym = {"in":"ipin.sym","out":"opin.sym","inout":"iopin.sym"}[d]
        s += f"C {{{sym}}} 100 {y} 0 0 {{name=p_{pn} lab={pn}}}\n"; y += 40
    x = 300
    for (nm, kind, D, G, S, B, W, L) in c["mos"]:
        yy = -250 if kind == "p" else -50
        pins = mos_pins(kind, x, yy)
        sym = "sky130_fd_pr/pfet_01v8.sym" if kind == "p" else "sky130_fd_pr/nfet_01v8.sym"
        rot, flip = (2, 1) if kind == "p" else (0, 0)
        model = "pfet_01v8" if kind == "p" else "nfet_01v8"
        s += (f"C {{{sym}}} {x} {yy} {rot} {flip} {{name={nm}\nW={W}\nL={L}\nnf=1\nmult=1\n{MOSATTR}\nmodel={model}\nspiceprefix=X\n}}\n")
        for t, net in (("D",D),("G",G),("S",S),("B",B)):
            px, py = pins[t]; s += lp(px, py, net, k); checks.append((px,py,net)); k += 1
        x += 140
    # kapasitor MIM
    for (cn, a, b, mf) in c["cap"]:
        cx, cy = x, -150
        s += f"C {{sky130_fd_pr/cap_mim_m3_1.sym}} {cx} {cy} 0 0 {{name={cn} model=cap_mim_m3_1 W=1 L=1 MF={mf} spiceprefix=X}}\n"
        s += lp(cx, cy-30, a, k); k += 1; s += lp(cx, cy+30, b, k); k += 1; x += 140
    # instance hierarki
    ix, iy = x + 100, -150
    for (inm, sub, conn) in c["inst"]:
        H, pos = sym_geom(sub)
        s += f"C {{{XS}/{sub}.sym}} {ix} {iy} 0 0 {{name={inm}}}\n"
        for pn, (px, py) in pos.items():
            s += lp(ix+px, iy+py, conn[pn], k); checks.append((ix+px, iy+py, conn[pn])); k += 1
        ix += 400
    return s

# ---------------- verifikasi statis ----------------
def flatten(name, prefix="", netmap=None):
    c = CELLS[name]; mos = []
    portset = {p[0] for p in c["ports"]}
    def m(n):
        if n in portset and netmap: return netmap[n]
        if n in ("VDD","GND"): return n
        return prefix + n
    for (nm, kind, D, G, S, B, W, L) in c["mos"]:
        mos.append((prefix+nm, kind, m(D), m(G), m(S)))
    for (inm, sub, conn) in c["inst"]:
        nm2 = {pn: m(net) for pn, net in conn.items()}
        mos += flatten(sub, prefix+inm+"/", nm2)
    return mos

def switch_eval(mos, fixed, iters=40):
    val = dict(fixed)
    nodes = {n for t in mos for n in t[2:5]} | set(val)
    for _ in range(iters):
        par = {n: n for n in nodes}
        def f(a):
            while par[a] != a: par[a] = par[par[a]]; a = par[a]
            return a
        for (nm, kind, D, G, S) in mos:
            g = val.get(G)
            if g is None: continue
            if (kind == "n" and g == 1) or (kind == "p" and g == 0): par[f(D)] = f(S)
        new = dict(fixed)
        r1, r0 = f("VDD"), f("GND")
        for n in nodes:
            if n in fixed: continue
            r = f(n)
            if r == r1 and r == r0: new[n] = "X"
            elif r == r1: new[n] = 1
            elif r == r0: new[n] = 0
        if new == val: break
        val = new
    return val

def verify():
    ok = True
    def chk(cond, msg):
        nonlocal ok
        print(("  OK   " if cond else "  FAIL ") + msg); ok = ok and cond
    for nm, ins, fn in (("B6_INV",["IN"],lambda a:1-a[0]), ("B6_NAND2",["A","B"],lambda a:1-(a[0]&a[1])),
                        ("B6_NOR2",["A","B"],lambda a:1-(a[0]|a[1])), ("B6_XOR",["A","B"],lambda a:a[0]^a[1]),
                        ("B6_AND2",["A","B"],lambda a:a[0]&a[1])):
        mos = flatten(nm)
        good = True
        for combo in itertools.product([0,1], repeat=len(ins)):
            fx = {"VDD":1,"GND":0, **dict(zip(ins, combo))}
            v = switch_eval(mos, fx)
            if v.get("OUT") != fn(combo): good = False; print("     ", nm, combo, "->", v.get("OUT"), "diharapkan", fn(combo))
        chk(good, f"{nm}: tabel kebenaran switch-level ({len(mos)} MOS)")
    # delay cell dengan starve ON = inverter
    mos = flatten("B6_DELAY_CS")
    good = all(switch_eval(mos, {"VDD":1,"GND":0,"VBP":0,"VBN":1,"IN":a}).get("OUT") == 1-a for a in (0,1))
    chk(good, "B6_DELAY_CS: berperilaku inverter (starve ON, VBP=0, VBN=1)")
    # top-level kondisi tunak
    mos = flatten("B6_NONOV")
    print(f"  total MOS (flatten, tanpa MIM/buffer keluaran): {len(mos)}")
    for clk, e1, e2 in ((1,0,1),(0,1,0)):   # polaritas Fig.7: phi1 aktif saat CLK rendah, phi2 aktif saat CLK tinggi
        v = switch_eval(mos, {"VDD":1,"GND":0,"VBP":0,"VBN":1,"CLK":clk})
        good = (v["PHI1"]==e1 and v["PHI2"]==e2 and v["PHI1B"]==1-e1 and v["PHI2B"]==1-e2)
        chk(good, f"B6_NONOV tunak CLK={clk}: PHI1={v['PHI1']} PHI1B={v['PHI1B']} PHI2={v['PHI2']} PHI2B={v['PHI2B']}")
    # model event (transport delay, logika murni) -> urutan edge dan jeda; BUKAN timing analog
    def evsim(td, dx=0.1, da=0.1, T=250.0, hi=125.0, dt=0.05):
        clk = lambda t: 1 if (t % T) < hi else 0
        def D(f, d): return lambda t: f(t-d) if t-d >= 0 else f(0.0)
        clkb = D(lambda t: 1-clk(t), dx); clks = D(clk, dx)
        dclkb = D(lambda t: 1-clkb(t), td); dclks = D(lambda t: 1-clks(t), td)
        phi1 = D(lambda t: clkb(t) & dclks(t), da); phi2 = D(lambda t: clks(t) & dclkb(t), da)
        ts = [i*dt for i in range(int(3*T/dt))]
        ovl = sum(1 for t in ts if t > T and phi1(t) and phi2(t))
        ed = {"phi1":{"r":[],"f":[]}, "phi2":{"r":[],"f":[]}}; prev=None
        for t in ts:
            cur = (phi1(t), phi2(t))
            if prev:
                for k,(p,c) in enumerate(zip(prev,cur)):
                    if p != c: ed["phi1" if k==0 else "phi2"]["r" if c else "f"].append(t)
            prev = cur
        return ovl, ed
    td = 15.0
    ovl, ed = evsim(td)
    dead_1f2r = [r - f for f in ed["phi1"]["f"] for r in ed["phi2"]["r"] if 0 < r-f < 100 and f > 250][0]
    dead_2f1r = [r - f for f in ed["phi2"]["f"] for r in ed["phi1"]["r"] if 0 < r-f < 100 and f > 250][0]
    w1 = [f-r for r in ed["phi1"]["r"] for f in ed["phi1"]["f"] if 0 < f-r < 200 and r > 250][0]
    chk(ovl == 0, "model event: tidak ada sampel overlap (phi1 & phi2 tinggi bersamaan)")
    chk(abs(dead_1f2r-td) < 0.3 and abs(dead_2f1r-td) < 0.3,
        f"model event: jeda phi1->phi2 = {dead_1f2r:.2f} ns, phi2->phi1 = {dead_2f1r:.2f} ns (td={td})")
    chk(abs(w1-(125-td)) < 0.3, f"model event: lebar phi1 = {w1:.2f} ns (125 - td = {125-td:.1f}); logika murni, bukan timing analog")
    return ok

# ---------------- testbench ----------------
def vs(x, y, nm, val, net, k):
    t = f"C {{vsource.sym}} {x} {y} 0 0 {{name={nm} value=\"{val}\"}}\n"
    t += lp(x, y-30, net, k) + lp(x, y+30, "0", k+1)
    return t, [(x,y-30,net),(x,y+30,"0")]
def cap(x, y, nm, val, net, k):
    t = f"C {{capa.sym}} {x} {y} 0 0 {{name={nm} value={val}}}\n"
    t += lp(x, y-30, net, k) + lp(x, y+30, "0", k+1)
    return t, [(x,y-30,net),(x,y+30,"0")]

def tb_sch(title, parts, dut_sub, dut_conn, code):
    s = HEAD + f"T {{{title}}} 40 -700 0 0 0.4 0.4 {{}}\n"
    k = 0
    x = 120
    for kind, nm, val, net in parts:
        t, _ = (vs if kind == "v" else cap)(x, -100, nm, val, net, k); s += t; k += 2; x += 160
    H, pos = sym_geom(dut_sub)
    ix, iy = 1500, -300
    s += f"C {{{XS}/{dut_sub}.sym}} {ix} {iy} 0 0 {{name=X1}}\n"
    for pn, (px, py) in pos.items():
        s += lp(ix+px, iy+py, dut_conn[pn], k); k += 1
    s += "C {sky130_fd_pr/corner.sym} 100 -600 0 0 {name=CORNER only_toplevel=false corner=tt}\n"
    s += f'C {{code.sym}} 40 -500 0 0 {{name=SIM only_toplevel=true value="{code}"}}\n'
    return s

HDR = ".option scale=1e-6 reltol=1e-5 abstol=1e-15 vntol=1e-8\n.temp 27\n"
REALLOAD = ("Vm vm 0 0.9\n"
  + "".join(f"XLN{i}A vm PHI{i} vm 0 sky130_fd_pr__nfet_01v8_lvt W=4 L=0.15 nf=1 mult=1 m=16\nXLN{i}B vm PHI{i} vm 0 sky130_fd_pr__nfet_01v8 W=2 L=0.15 nf=1 mult=1 m=8\n"
                  f"XLP{i}A vm PHI{i}B vm vdd sky130_fd_pr__pfet_01v8_lvt W=8 L=0.35 nf=1 mult=1 m=16\nXLP{i}B vm PHI{i}B vm vdd sky130_fd_pr__pfet_01v8 W=4 L=0.15 nf=1 mult=1 m=8\n" for i in (1, 2)))
def code_nonov(tag, realload=False, wirecap=None):
    ldnote = ("Beban = transistor gerbang sakelar nyata (24 gate/net sesuai loop, S=D=0.9 V), TANPA kapasitansi kabel." if realload
              else "Beban 200 fF/keluaran = PLACEHOLDER.")
    if wirecap: ldnote += f" Ditambah kapasitansi kabel {wirecap} per net (PERKIRAAN pra-layout, bukan hasil ekstraksi)."
    return (f"* {tag}: Blok 6 NONOV standalone, TT 1.8 V 27 C. Ukuran sel = nilai awal (TBD). {ldnote}\n{HDR}" + (REALLOAD if realload else "") + ("".join(f"CW{n} {n} 0 {wirecap}\n" for n in ("PHI1","PHI1B","PHI2","PHI2B")) if wirecap else "") +
      ".control\nsave all\nset wr_singlescale\nset wr_vecnames\nset numdgt=15\ntran 0.1n 2u 0 0.1n\n"
      f"wrdata {tag}.dat v(CLK) v(PHI1) v(PHI1B) v(PHI2) v(PHI2B)\n"
      "echo ===== TB6_MEAS =====\n"
      "meas tran DT_1F2R TRIG v(PHI1) VAL=0.9 FALL=2 TARG v(PHI2) VAL=0.9 RISE=2\n"
      "meas tran DT_2F1R TRIG v(PHI2) VAL=0.9 FALL=2 TARG v(PHI1) VAL=0.9 RISE=2\n"
      "meas tran W_PHI1 TRIG v(PHI1) VAL=0.9 RISE=2 TARG v(PHI1) VAL=0.9 FALL=3\n"
      "meas tran W_PHI2 TRIG v(PHI2) VAL=0.9 RISE=2 TARG v(PHI2) VAL=0.9 FALL=2\n"
      "meas tran SKEW_P1R TRIG v(PHI1) VAL=0.9 RISE=2 TARG v(PHI1B) VAL=0.9 FALL=2\n"
      "meas tran SKEW_P1F TRIG v(PHI1) VAL=0.9 FALL=2 TARG v(PHI1B) VAL=0.9 RISE=2\n"
      "meas tran SKEW_P2R TRIG v(PHI2) VAL=0.9 RISE=2 TARG v(PHI2B) VAL=0.9 FALL=2\n"
      "meas tran SKEW_P2F TRIG v(PHI2) VAL=0.9 FALL=2 TARG v(PHI2B) VAL=0.9 RISE=2\n"
      "meas tran TR_PHI1 TRIG v(PHI1) VAL=0.18 RISE=2 TARG v(PHI1) VAL=1.62 RISE=2\n"
      "meas tran TF_PHI1 TRIG v(PHI1) VAL=1.62 FALL=2 TARG v(PHI1) VAL=0.18 FALL=2\n"
      "meas tran TR_PHI2 TRIG v(PHI2) VAL=0.18 RISE=2 TARG v(PHI2) VAL=1.62 RISE=2\n"
      "meas tran TF_PHI2 TRIG v(PHI2) VAL=1.62 FALL=2 TARG v(PHI2) VAL=0.18 FALL=2\n"
      "meas tran TR_PHI1B TRIG v(PHI1B) VAL=0.18 RISE=2 TARG v(PHI1B) VAL=1.62 RISE=2\n"
      "meas tran TF_PHI1B TRIG v(PHI1B) VAL=1.62 FALL=2 TARG v(PHI1B) VAL=0.18 FALL=2\n"
      "meas tran TR_PHI2B TRIG v(PHI2B) VAL=0.18 RISE=2 TARG v(PHI2B) VAL=1.62 RISE=2\n"
      "meas tran TF_PHI2B TRIG v(PHI2B) VAL=1.62 FALL=2 TARG v(PHI2B) VAL=0.18 FALL=2\n"
      "let ovl = v(PHI1)*v(PHI2)\nmeas tran OVL_PROD MAX ovl FROM=500n TO=1.5u\n"
      "meas tran PHI1_MAX MAX v(PHI1) FROM=500n TO=1.5u\nmeas tran PHI1_MIN MIN v(PHI1) FROM=500n TO=1.5u\n"
      "meas tran PHI2_MAX MAX v(PHI2) FROM=500n TO=1.5u\nmeas tran PHI2_MIN MIN v(PHI2) FROM=500n TO=1.5u\n"
      "meas tran IVDD_AVG AVG i(VVDD) FROM=500n TO=1.5u\n"
      "echo TB6_DONE\n.endc\n")

def code_dly(tag):
    return (f"* {tag}: sel tunda current-starved standalone, beban 10 fF = PLACEHOLDER. Variabel = bias VBN; VBP dari tabel VBP_MATCH (arus pull-up ~ pull-down, perkiraan).\n{HDR}"
      ".control\nsave all\nset wr_singlescale\nset wr_vecnames\nset numdgt=15\ntran 0.1n 1.5u 0 0.1n\n"
      f"wrdata {tag}.dat v(IN) v(OUT)\n"
      "echo ===== TB6_MEAS =====\n"
      "meas tran TD_R TRIG v(IN) VAL=0.9 RISE=1 TARG v(OUT) VAL=0.9 FALL=1\n"
      "meas tran TD_F TRIG v(IN) VAL=0.9 FALL=1 TARG v(OUT) VAL=0.9 RISE=1\n"
      "meas tran IVDD_AVG AVG i(VVDD) FROM=100n TO=600n\n"
      "echo TB6_DONE\n.endc\n")

def code_logic(tag):
    pts = [("00",80),("10",180),("01",280),("11",380)]
    m = "".join(f"meas tran XOR_{n} FIND v(XOUT) AT={t}n\nmeas tran AND_{n} FIND v(AOUT) AT={t}n\n" for n,t in pts)
    return (f"* {tag}: tabel kebenaran XOR dan AND2 (sel Blok 6) di ngspice. Beban 20 fF.\n{HDR}"
      ".control\nsave all\nset wr_singlescale\nset wr_vecnames\nset numdgt=15\ntran 0.1n 450n 0 0.1n\n"
      f"wrdata {tag}.dat v(A) v(B) v(XOUT) v(AOUT)\n"
      "echo ===== TB6_MEAS =====\n" + m + "echo TB6_DONE\n.endc\n")

def tb_logic_sch(tag):
    # dua DUT: XOR dan AND2 berbagi A,B -> dua instance; gunakan tb_sch untuk X1 (XOR) lalu tambah X2 (AND2)
    base = tb_sch("Blok 6: logic XOR + AND2", [("v","VVDD","1.8","VDD"),("v","VA","PULSE(0 1.8 100n 1n 1n 99n 200n)","A"),
        ("v","VB","PULSE(0 1.8 200n 1n 1n 199n 400n)","B"),("c","CX","20f","XOUT"),("c","CA","20f","AOUT")],
        "B6_XOR", dict(A="A",B="B",OUT="XOUT",VDD="VDD",GND="0"), code_logic(tag))
    H, pos = sym_geom("B6_AND2")
    ix, iy = 1500, 100; k = 900
    base += f"C {{{XS}/B6_AND2.sym}} {ix} {iy} 0 0 {{name=X2}}\n"
    for pn, (px, py) in pos.items():
        net = dict(A="A",B="B",OUT="AOUT",VDD="VDD",GND="0")[pn]
        base += lp(ix+px, iy+py, net, k); k += 1
    return base

# VBP para VBN: dipilih agar arus pull-up PMOS (W/L 1/1) ~ arus pull-down NMOS (W/L 0.5/1) pada |Vds|=0.9 V,
# dari sapuan DC ngspice di PDK pengguna (2026-11-02): |Id| PMOS Vsg=0.8 -> 1.05e-8 A, NMOS Vgs=0.8 -> 2.68e-6 A (rasio ~255x),
# jadi VBP = 1.8 - VBN (asumsi awal saya) terlalu lemah. Nilai di bawah = interpolasi log, PERKIRAAN awal, bukan hasil optimasi.
VBP_MATCH = {0.50:0.96, 0.55:0.90, 0.60:0.83, 0.65:0.78, 0.70:0.71, 0.75:0.65, 0.80:0.59}
def vbp_for(v):
    v = round(v, 3); ks = sorted(VBP_MATCH)
    if v in VBP_MATCH: return VBP_MATCH[v]
    for a, b in zip(ks, ks[1:]):
        if a < v < b: return round(VBP_MATCH[a] + (VBP_MATCH[b]-VBP_MATCH[a])*(v-a)/(b-a), 3)
    raise ValueError(f"VBN {v} di luar tabel VBP_MATCH")

def emit_tbs(out, vbn_main, vbn_list):
    names = []
    def fmt(v): return f"{v:.2f}".replace(".", "p")
    for vbn_main in sorted(set([0.70,0.71,0.72,vbn_main])):
        tag = f"tb_6A_nonov_vbn{fmt(vbn_main)}"
        conn = dict(CLK="CLK",PHI1="PHI1",PHI1B="PHI1B",PHI2="PHI2",PHI2B="PHI2B",VDD="VDD",VBP="VBP",VBN="VBN",GND="0")
        parts = [("v","VVDD","1.8","VDD"),("v","VCLK","PULSE(0 1.8 20n 1n 1n 124n 250n)","CLK"),
                 ("v","VBNSRC",f"{vbn_main}","VBN"),("v","VBPSRC",f"{vbp_for(vbn_main)}","VBP"),
                 ("c","C1","200f","PHI1"),("c","C1B","200f","PHI1B"),("c","C2","200f","PHI2"),("c","C2B","200f","PHI2B")]
        write(os.path.join(out, SIM, tag+".sch"), tb_sch("Blok 6: generator non-overlap NONOV, standalone nominal", parts, "B6_NONOV", conn, code_nonov(tag))); names.append(tag)
    tag = "tb_6D_realload_vbn0p70"
    conn = dict(CLK="CLK",PHI1="PHI1",PHI1B="PHI1B",PHI2="PHI2",PHI2B="PHI2B",VDD="VDD",VBP="VBP",VBN="VBN",GND="0")
    parts = [("v","VVDD","1.8","VDD"),("v","VCLK","PULSE(0 1.8 20n 1n 1n 124n 250n)","CLK"),
             ("v","VBNSRC","0.7","VBN"),("v","VBPSRC",f"{vbp_for(0.70)}","VBP")]
    write(os.path.join(out, SIM, tag+".sch"), tb_sch("Blok 6: NONOV dengan beban gerbang sakelar nyata (tanpa kabel)", parts, "B6_NONOV", conn, code_nonov(tag, realload=True))); names.append(tag)
    for wc in ("50f", "200f", "500f"):
        tag = f"tb_6E_wire{wc}_vbn0p70"
        conn = dict(CLK="CLK",PHI1="PHI1",PHI1B="PHI1B",PHI2="PHI2",PHI2B="PHI2B",VDD="VDD",VBP="VBP",VBN="VBN",GND="0")
        parts = [("v","VVDD","1.8","VDD"),("v","VCLK","PULSE(0 1.8 20n 1n 1n 124n 250n)","CLK"),
                 ("v","VBNSRC","0.7","VBN"),("v","VBPSRC",f"{vbp_for(0.70)}","VBP")]
        write(os.path.join(out, SIM, tag+".sch"), tb_sch(f"Blok 6: NONOV + beban gerbang nyata + kabel {wc}/net", parts, "B6_NONOV", conn, code_nonov(tag, realload=True, wirecap=wc))); names.append(tag)
    for v in vbn_list:
        tag = f"tb_6B_dly_vbn{fmt(v)}"
        parts = [("v","VVDD","1.8","VDD"),("v","VIN","PULSE(0 1.8 50n 1n 1n 600n 1.5u)","IN"),
                 ("v","VBNSRC",f"{v}","VBN"),("v","VBPSRC",f"{vbp_for(v)}","VBP"),("c","CL","10f","OUT")]
        conn = dict(IN="IN",OUT="OUT",VBP="VBP",VBN="VBN",VDD="VDD",GND="0")
        write(os.path.join(out, SIM, tag+".sch"), tb_sch("Blok 6: sel tunda current-starved, td vs bias", parts, "B6_DELAY_CS", conn, code_dly(tag))); names.append(tag)
    tag = "tb_6C_logic"
    write(os.path.join(out, SIM, tag+".sch"), tb_logic_sch(tag)); names.append(tag)
    return names

# ---------------- cek konektivitas independen dari .sch yang ditulis ----------------
import re
def xform(x, y, rot, flip):
    if flip: x = -x
    return [(x, y), (-y, x), (-x, -y), (y, -x)][rot % 4]

def parse_sch(path):
    comps = []
    txt = open(path).read()
    for m in re.finditer(r"^C \{(.*?)\} (-?\d+) (-?\d+) (\d+) (\d+) \{(.*?)\}\s*$", txt, re.M | re.S):
        comps.append((m.group(1), int(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5)), m.group(6)))
    return comps

def sym_pin_table(out, sub):
    d = {}
    for line in open(os.path.join(out, XS, sub + ".sym")):
        m = re.match(r"B 5 (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) (-?[\d.]+) \{name=(\w+)", line)
        if m:
            x = (float(m.group(1)) + float(m.group(3))) / 2; y = (float(m.group(2)) + float(m.group(4))) / 2
            d[m.group(5)] = (int(round(x)), int(round(y)))
    return d

def check_connectivity(out):
    ok = True
    mos_rel = {"n": {"D":(20,-30),"G":(-20,0),"S":(20,30),"B":(20,0)}}
    for name in CELLS:
        comps = parse_sch(os.path.join(out, XS, name + ".sch"))
        pins = {}   # (x,y) -> net via lab_pin
        for sym, x, y, r, f, rest in comps:
            if sym == "lab_pin.sym":
                lab = re.search(r"lab=(\S+)", rest).group(1); pins[(x, y)] = lab
        got_mos, got_inst, used = set(), set(), set()
        for sym, x, y, r, f, rest in comps:
            nm = re.search(r"name=(\w+)", rest).group(1)
            if "nfet_01v8" in sym or "pfet_01v8" in sym:
                kind = "p" if "pfet" in sym else "n"
                rel = {"G":(-20,0),"B":(20,0)}
                rel["D"], rel["S"] = ((20,-30),(20,30))
                nets = {}
                for t, (rx, ry) in rel.items():
                    px, py = xform(rx, ry, r, f); p = (x+px, y+py); used.add(p)
                    nets[t] = pins.get(p)
                got_mos.add((nm, kind, nets["D"], nets["G"], nets["S"]))
            elif sym.startswith(XS):
                sub = os.path.basename(sym)[:-4]; tbl = sym_pin_table(out, sub); conn = {}
                for pn, (rx, ry) in tbl.items():
                    px, py = xform(rx, ry, r, f); p = (x+px, y+py); used.add(p); conn[pn] = pins.get(p)
                got_inst.add((nm, sub, tuple(sorted(conn.items()))))
        want_mos = {(nm, kind, D, G, S) for (nm, kind, D, G, S, B, W, L) in CELLS[name]["mos"]}
        want_inst = {(inm, sub, tuple(sorted(conn.items()))) for (inm, sub, conn) in CELLS[name]["inst"]}
        # bulk harus: n -> GND, p -> VDD
        bulk_ok = True
        for sym, x, y, r, f, rest in comps:
            if "nfet_01v8" in sym or "pfet_01v8" in sym:
                kind = "p" if "pfet" in sym else "n"
                px, py = xform(20, 0, r, f)
                if pins.get((x+px, y+py)) != ("VDD" if kind == "p" else "GND"): bulk_ok = False
        # PMOS: source di atas (y lebih kecil) dan terhubung ke sisi suplai atas
        good = (got_mos == want_mos and got_inst == want_inst and bulk_ok and all(p in pins for p in used))
        print(("  OK   " if good else "  FAIL ") + f"{name}.sch: konektivitas hasil parsing = definisi sel, bulk benar, semua pin berlabel")
        if not good:
            print("      selisih MOS:", got_mos ^ want_mos); print("      selisih inst:", got_inst ^ want_inst)
        ok = ok and good
    return ok

README = """# Blok 6 - Generator clock non-overlap (STATUS: sch + testbench dibangkitkan; ngspice NOT_RUN)

Dasar: R. Spilka et al., "Generation of Non-Overlapping Clock Signals without using a Feedback Loop", DDECS 2012
(Fig. 7: dua XOR membelah clk -> clk_bar/clk*, inverter silang, dua AND, XOR kembar untuk phi/phi_bar).
Perubahan terhadap makalah (keputusan pemilik proyek 2026-11-02): inverter penunda diganti sel current-starved (B6_DELAY_CS)
agar jeda = td ~ 15 ns (makalah: jeda = delay satu inverter). Tahap 1: tanpa early clock; clk komparator dan rst/rstb di luar blok.

Polaritas (hasil switch-level, Fig. 7): phi1 AKTIF saat CLK RENDAH, phi2 AKTIF saat CLK TINGGI. Untuk integrasi: loop sekarang
memakai clk komparator tinggi bersamaan dengan phi1, jadi clk komparator = CLKB (master terbalik) atau sumber terpisah - diputuskan saat integrasi.

## Isi
| Berkas | Fungsi |
|---|---|
| xschem/B6_INV, B6_NAND2, B6_NOR2, B6_XOR (NOR2 + AOI21, 10T), B6_AND2 | sel logika (ukuran awal, TBD) |
| xschem/B6_DELAY_CS | inverter current-starved + MIM; pin VBP/VBN dari testbench (pembangkit bias = tahap berikutnya) |
| xschem/B6_NONOV | top-level, 80 MOS (tanpa buffer keluaran) |
| sim/tb_6C_logic | tabel kebenaran XOR/AND2 (ngspice) |
| sim/tb_6B_dly_vbn* | td sel tunda terhadap bias VBN (VBP dari tabel VBP_MATCH, perkiraan arus sepadan); eksploratori |
| sim/tb_6A_nonov_vbnXpXX | NONOV standalone nominal; ukur jeda, lebar, skew phi/phib, tepi |
| tools/make_block6.py | pembangkit + verifikasi statis |
| tools/run_block6.py | netlist (xschem), sim (ngspice), analyze (tabel) |

## Urutan pakai (satu variabel per eksperimen)
```
python3 tools/make_block6.py            # tulis ulang sch/sym/tb + verifikasi statis (tanpa xschem)
python3 tools/run_block6.py netlist     # butuh xschem
python3 tools/run_block6.py sim         # butuh ngspice + PDK
python3 tools/run_block6.py analyze
```
Urutan eksperimen: 6C (logika sel) -> 6B (td vs bias; pilih bias untuk td ~ 15 ns) -> 6A (NONOV pada bias terpilih).

## Yang SUDAH diperiksa (statis, tanpa simulator)
- Tabel kebenaran switch-level: INV, NAND2, NOR2, XOR, AND2; kondisi tunak NONOV; model event logika murni (jeda = td, lebar = 125 - td, tanpa overlap).
- Konektivitas hasil parsing .sch = definisi sel.
## Yang BELUM
- Netlist xschem, ngspice, dan semua angka analog (td, skew, tepi, daya): NOT_RUN. Ukuran W/L, bias, beban 200 fF dan 10 fF = placeholder.
- Beban gate nyata per fasa belum dihitung. PVT, mismatch, layout: belum.
- Simbol PMOS dipasang rot2/flip1 (S di atas, D di bawah): pastikan di netlist xschem sumber PMOS ke VDD.
Status label: tidak ada klaim PASS. Hasil numerik nantinya = MEASURED_NOT_FINAL.
"""

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    ap.add_argument("--vbn", type=float, default=0.73)
    ap.add_argument("--no-verify", action="store_true")
    a = ap.parse_args()
    print("== verifikasi statis ==")
    ok = verify()
    if not ok: print("GAGAL verifikasi - berkas tidak ditulis"); sys.exit(2)
    for n in CELLS:
        write(os.path.join(a.out, XS, n + ".sym"), make_sym(n))
        write(os.path.join(a.out, XS, n + ".sch"), make_sch(n))
    print("sel ditulis:", ", ".join(CELLS))
    names = emit_tbs(a.out, a.vbn, [0.50,0.55,0.60,0.65,0.70,0.71,0.72,0.73,0.74,0.75,0.80])
    print("testbench ditulis:", ", ".join(names))
    print("== cek konektivitas dari berkas tertulis ==")
    if not check_connectivity(a.out): print("GAGAL konektivitas"); sys.exit(3)
    write(os.path.join(a.out, "blocks/06_Clock_gen/README_BLOCK6.md"), README)
