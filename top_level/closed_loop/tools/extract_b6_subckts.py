#!/usr/bin/env python3
"""Ambil semua blok .subckt ... .ends B6_* dari netlist xschem testbench Blok 6
(mis. tb_6D_realload_vbn0p70.spice) -> spice/b6_nonov.spice. Tidak mengubah isi subckt.
Pemakaian: python3 tools/extract_b6_subckts.py <netlist.spice> <out.spice>"""
import re, sys
src, dst = sys.argv[1], sys.argv[2]
lines = open(src, errors="replace").read().splitlines()
out, inside, names = [], False, []
for ln in lines:
    low = ln.strip().lower()
    if low.startswith(".subckt"):
        inside = True
        names.append(ln.split()[1])
    if inside:
        out.append(ln)
    if low.startswith(".ends"):
        inside = False
        out.append("")
if "B6_NONOV" not in [n.upper() for n in names]:
    sys.exit("B6_NONOV tidak ditemukan di " + src)
open(dst, "w").write("* diekstrak dari %s oleh extract_b6_subckts.py (isi subckt tidak diubah)\n" % src + "\n".join(out) + "\n")
print("subckt:", ", ".join(names), "->", dst)
