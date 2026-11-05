# Menghitung gate sakelar yang digerakkan phi1/phi1b/phi2/phi2b di loop (stage1, stage2, 2x FB_SAMP_SWAP). Jalankan dari ROOT repo: python3 tools/count_phi_loads.py
# Hanya hitungan struktural dari .spice; kapasitansi gate diukur terpisah di ngspice.
import re,sys,collections
files=["top_level/closed_loop/spice/stage1_core.spice","top_level/closed_loop/spice/stage2_core.spice","top_level/closed_loop/spice/fb_sampler.spice","top_level/closed_loop/spice/blocks_quantizer_dac.spice"]
sub={}; cur=None
for f in files:
    txt=open(f).read().replace("\n+"," ")
    for line in txt.split("\n"):
        l=line.strip()
        if not l or l[0] in "*": continue
        low=l.lower()
        if low.startswith(".subckt"):
            p=l.split(); cur=p[1].upper(); sub[cur]={"ports":p[2:],"body":[]}
        elif low.startswith(".ends"): cur=None
        elif cur: sub[cur]["body"].append(l)
def kv(tokens):
    d={}
    for t in tokens:
        if "=" in t:
            k,v=t.split("=",1); d[k.lower()]=v
    return d
cnt=collections.Counter()
def walk(name,netmap,mult):
    for l in sub[name]["body"]:
        tok=l.split(); n=tok[0]
        if n[0].lower()=="x":
            rest=[t for t in tok[1:] if "=" not in t]
            model=rest[-1].upper(); nets=rest[:-1]
            if model in sub:
                ports=sub[model]["ports"]
                m={p:netmap.get(nn,nn) for p,nn in zip(ports,nets)}
                # internal nets stay local-unique
                walk(model,m,mult)
            else:
                # primitive via X (sky130 device): nets: d g s b
                d=kv(tok); g=netmap.get(nets[1],nets[1]).lower()
                if g in ("phi1","phi1b","phi2","phi2b"):
                    cnt[(g,model,d.get("w"),d.get("l"))]+=mult
for top,nets,mult in [("STAGE1","vin_p vin_n out_p out_n sum_p sum_n vo1_a vo1_b vcmfb vdd vcm vbias vbz_l vbz_r vcs vcm_stage1 phi1 phi1b phi2 phi2b rst rstb",1),
                      ("STAGE2","vin2_p vin2_n out2_p out2_n sum2_p sum2_n vo1_2a vo1_2b vcmfb2 vdd vcm vbias vbz_l vbz_r vcs vcm_stage1 phi1 phi1b phi2 phi2b rst rstb",1),
                      ("FB_SAMP_SWAP","dac_p dac_n sum_p sum_n vcm phi1 phi1b phi2 phi2b vdd gnd",2)]:
    ports=sub[top]["ports"]; names=nets.split()
    walk(top,{p:n for p,n in zip(ports,names)},mult)
tot=collections.defaultdict(lambda:[0,0.0])
for (g,model,w,l),c in sorted(cnt.items()):
    print(f"{g:6s} {model:32s} W={w:5s} L={l:5s} jumlah={c}")
    tot[g][0]+=c; tot[g][1]+=c*float(w)*float(l)
print()
for g,(c,a) in sorted(tot.items()): print(f"{g}: {c} gate, luas gerbang total = {a:.2f} um^2")
