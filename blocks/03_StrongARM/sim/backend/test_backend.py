#!/usr/bin/env python3
"""Offline unit/static tests; NOT an analog/ngspice simulation."""
import re
import unittest
from pathlib import Path
from run_mc import check_subckt, make_deck,parse_log,startup_lib_warnings

BASE=Path(__file__).resolve().parent

class TestBackend(unittest.TestCase):
    def test_schematic_snapshot(self):
        devices=check_subckt((BASE/'strongarm_11t.inc').read_text())
        self.assertEqual(len(devices),11)
    def test_seed_and_model_placement(self):
        deck=make_deck(1001,Path('/foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice'),(BASE/'strongarm_11t.inc').read_text())
        self.assertLess(deck.index('.option seed=1001'),deck.index('.lib '))
        self.assertLess(deck.index('.lib '),deck.index('.control'))
        self.assertNotIn('\nreset\n',deck.lower())
        self.assertEqual(deck.count('repeat 12'),1)
        self.assertIn('mc_mm_switch', 'mc_mm_switch')
    def test_sentinel_parser(self):
        log='''MC_ENDPOINT_LO seed=1001
vp_lo = 1.8000e+00
vn_lo = 0.0
MC_ENDPOINT_HI seed=1001
vp_hi = 0.0
vn_hi = 1.800e+00
''' + ('vp_mid = 0.0\nvn_mid = 1.8000\n'*12) + '''MC_BOUNDARY seed=1001 lo_V=-0.0000390625 hi_V=0.0'''
        self.assertEqual(parse_log(log,1001),(-0.0000390625,0.0))
        # Startup .lib warning is NOT a transistor simulation failure if a
        # valid full MC_BOUNDARY follows. It is recorded for PDK audit.
        with_banner='.lib: no such command available in ngspice\n\nCircuit: test\n'+log
        self.assertEqual(parse_log(with_banner,1001),(-0.0000390625,0.0))
        self.assertEqual(startup_lib_warnings(with_banner),1)
        with self.assertRaisesRegex(RuntimeError,'after circuit loading'):
            parse_log('Circuit: test\n.lib: no such command available in ngspice\n'+log,1001)
        with self.assertRaisesRegex(RuntimeError,'Metastable'):
            parse_log(log.replace('vp_mid = 0.0','vp_mid = 0.8',1),1001)
    def test_actual_seed_1001_log(self):
        from os import environ
        original=Path(environ.get('STRONGARM_MC_REAL_LOG', '/mnt/data/Pasted text(9).txt'))
        if not original.is_file():
            self.skipTest('Real seed1001 log not present; run in source environment only')
        text=original.read_text()
        lo,hi=parse_log(text,1001)
        self.assertAlmostEqual(lo,0.00261719)
        self.assertAlmostEqual(hi,0.00265625)
        self.assertEqual(startup_lib_warnings(text),1)

    def test_failed_corner_detected(self):
        log='MC_ENDPOINT_LO seed=1001\nMC_ENDPOINT_HI seed=1001\nMC_ERROR_BAD_HIGH_ENDPOINT\nMC_BOUNDARY seed=1001 lo_V=0.0 hi_V=0.001'
        with self.assertRaisesRegex(RuntimeError,'ngspice reported'):
            parse_log(log,1001)

if __name__=='__main__': unittest.main(verbosity=2)
