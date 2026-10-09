#!/usr/bin/env python3
"""SKY130 11T StrongARM mismatch Monte Carlo — parallel independent ngspice jobs.

One ngspice process PER seed; up to --workers seeds run concurrently.
Within each seed, bisection reuses that device realization (NO reset).
PDK tt_mm is the sole stochastic transistor model source.
"""
from __future__ import annotations
import argparse
import os
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
import csv
import hashlib
import json
import math
import re
import shutil
import statistics
import subprocess
import sys
from pathlib import Path
from datetime import datetime, timezone

HERE = Path(__file__).resolve().parent
DEFAULT_LIB = Path('/foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice')
DEF_INC = HERE / 'strongarm_11t.inc'
PATTERN = re.compile(r'MC_BOUNDARY\s+seed=(\d+)\s+lo_V=([^\s]+)\s+hi_V=([^\s]+)')
ERRORS = re.compile(r'(?im)^(?:error:|fatal error|unknown subckt|undefined subcircuit|measurement failed)')
STARTUP_LIB = re.compile(r'(?im)^\s*\.lib:\s+no such command available in ngspice\s*$')


def startup_lib_warnings(log: str) -> int:
    """Only tolerate .lib console warnings BEFORE ngspice's Circuit banner.

    They are emitted during process initialization (e.g. a misplaced .lib
    in ~/.spiceinit), while a valid .lib in the input deck is parsed later.
    Warn explicitly; never hide warnings that occur during deck execution.
    """
    positions = list(STARTUP_LIB.finditer(log))
    circuit = re.search(r'(?im)^\s*Circuit:', log)
    for m in positions:
        if circuit is None or m.start() > circuit.start():
            raise RuntimeError('ngspice .lib command error occurred after circuit loading (fatal)')
    return len(positions)


def check_library(lib: Path) -> str:
    if not lib.is_file():
        raise RuntimeError(f'Model library not found: {lib}\nSupply --pdk <path-to-sky130.lib.spice>.')
    contents = lib.read_text(errors='replace')
    match = re.search(r'(?im)^\s*\.lib\s+tt_mm\b(.*?)(?:^\s*\.endl?\s+tt_mm\b)', contents, re.S | re.M)
    if not match:
        raise RuntimeError('PDK does not contain .lib tt_mm ... .endl tt_mm.')
    if not re.search(r'(?im)^\s*\.param\s+mc_mm_switch\s*=\s*1\b', match.group(1)):
        raise RuntimeError('PDK tt_mm does not explicitly enable mc_mm_switch=1.')
    if not re.search(r'(?im)^\s*\.param\s+mc_pr_switch\s*=\s*0\b', match.group(1)):
        raise RuntimeError('PDK tt_mm does not explicitly set mc_pr_switch=0.')
    return hashlib.sha256(lib.read_bytes()).hexdigest()


def check_subckt(text: str) -> list[str]:
    subckt = re.search(r'(?im)^\s*\.subckt\s+StrongARM\s+(.+)$', text)
    if not subckt or subckt.group(1).split() != ['VDD', 'CLK', 'Vout_P', 'Vout_N', 'Vin1', 'Vin2', 'GND']:
        raise RuntimeError('StrongARM interface must be: VDD CLK Vout_P Vout_N Vin1 Vin2 GND')
    devices = re.findall(r'(?im)^\s*X((?:M[1-7]|S[1-4]))\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(sky130_fd_pr__(?:n|p)fet_01v8)\s+(.*)$', text)
    names = [d[0].upper() for d in devices]
    if len(devices) != 11 or set(names) != {f'M{i}' for i in range(1,8)} | {f'S{i}' for i in range(1,5)}:
        raise RuntimeError(f'Expected exactly 11 SKY130 MOS subcircuit instances. Found: {names}')
    exp = {
        'M1': ('P','Vin1','TAIL','GND'), 'M2': ('Q','Vin2','TAIL','GND'),
        'M3': ('Vout_P','Vout_N','P','GND'), 'M4': ('Vout_N','Vout_P','Q','GND'),
        'M5': ('Vout_P','Vout_N','VDD','VDD'), 'M6': ('Vout_N','Vout_P','VDD','VDD'),
        'M7': ('TAIL','CLK','GND','GND'), 'S1': ('P','CLK','VDD','VDD'),
        'S2': ('Q','CLK','VDD','VDD'), 'S3': ('Vout_P','CLK','VDD','VDD'),
        'S4': ('Vout_N','CLK','VDD','VDD')}
    for d in devices:
        label = d[0].upper()
        if tuple(d[1:5]) != exp[label]:
            raise RuntimeError(f'{label} D-G-S-B mismatch: {d[1:5]} != {exp[label]}')
        needed_type = 'pfet' if label.startswith('S') or label in ('M5','M6') else 'nfet'
        if needed_type not in d[5]:
            raise RuntimeError(f'{label} device type mismatch: {d[5]}')
        if 'W=' not in d[6] or 'L=' not in d[6]:
            raise RuntimeError(f'{label} missing W/L sizing')
    return names


def make_deck(seed: int, lib: Path, subckt_text: str, *, iterations: int=12, limit_v: float=0.08, sim_step_ns:float=0.2) -> str:
    # PDK library must precede .control. If .control precedes .lib, ngspice
    # interprets .lib as an unsupported interactive command (observed in previous logs).
    lines = [
        f'* StrongARM local mismatch sample; seed={seed}',
        '.option seedinfo',
        f'.option seed={seed}',
        f'.lib "{lib}" tt_mm',
        'VVDD VDD 0 1.8',
        'VVin1 Vin1 0 0.9',
        'VVin2 Vin2 0 0.9',
        'VPulse CLK 0 PULSE(0 1.8 0 1n 1n 125n 250n)',
        'X1 VDD CLK Vout_P Vout_N Vin1 Vin2 0 StrongARM',
        '* Optional realistic latch/input loading must be characterized separately.',
        subckt_text.strip(),
        '.control',
        'set noaskquit',
        'setplot const',
        f'let lo = -{limit_v:.9f}',
        f'let hi = {limit_v:.9f}',
    ]
    # Test lower endpoint and upper endpoint before bisection (do not infer success)
    def trial(xexpr: str, tag: str, store: bool):
        lines.extend([
            'setplot const',
            f'let dv = {xexpr}',
            'let vip = 0.9 + dv/2',
            'let vin = 0.9 - dv/2',
            'alter VVin1 $&vip',
            'alter VVin2 $&vin',
            f'tran {sim_step_ns}n 370n',
            f'meas tran vp_{tag} FIND v(vout_p) AT=362.5n',
            f'meas tran vn_{tag} FIND v(vout_n) AT=362.5n',
        ])
        if store:
            lines.extend([f'echo MC_ENDPOINT_{tag.upper()} seed={seed}'])
    trial('lo', 'lo', True)
    # Low end must give P HIGH / N LOW; high end must give P LOW / N HIGH.
    lines.extend(['if vp_lo < 0.9', '  echo MC_ERROR_BAD_LOW_ENDPOINT', 'end'])
    trial('hi', 'hi', True)
    lines.extend(['if vp_hi > 0.9', '  echo MC_ERROR_BAD_HIGH_ENDPOINT', 'end'])
    # Bipartition, keeping one fixed mismatch instance during all tran calls.
    lines.append(f'repeat {iterations}')
    trial('(lo + hi)/2', 'mid', False)
    lines.extend([
        'if vp_mid < 0.9',
        '  setplot const',
        '  let hi = dv',
        'else',
        '  setplot const',
        '  let lo = dv',
        'end',
        'end',
        'setplot const',
        f'echo MC_BOUNDARY seed={seed} lo_V=$&lo hi_V=$&hi',
        '.endc',
        '.end',
    ])
    return '\n'.join(lines) + '\n'


def parse_log(log: str, seed: int, *, limit_v:float=0.08) -> tuple[float,float]:
    startup_lib_warnings(log)
    if ERRORS.search(log) or re.search(r'MC_ERROR_BAD_',log):
        raise RuntimeError('ngspice reported an error or endpoint did not bracket threshold')
    m = list(PATTERN.finditer(log))
    if len(m)!=1 or int(m[0].group(1))!=seed:
        raise RuntimeError('Missing/duplicate MC_BOUNDARY sentinel or unexpected seed')
    lo, hi = float(m[0].group(2)),float(m[0].group(3))
    if not (math.isfinite(lo) and math.isfinite(hi) and -limit_v <= lo < hi <= limit_v):
        raise RuntimeError(f'Invalid offset bracket [{lo},{hi}]')
    if not (re.search(r'MC_ENDPOINT_LO\s+', log) and re.search(r'MC_ENDPOINT_HI\s+', log)):
        raise RuntimeError('Missing endpoint measurements')
    def values(label):
        matches = re.findall(rf'(?im)^\s*{label}\s*=\s*([-+0-9.eE]+)', log)
        return [float(x) for x in matches]
    vp_lo, vn_lo = values('vp_lo'), values('vn_lo')
    vp_hi, vn_hi = values('vp_hi'), values('vn_hi')
    if len(vp_lo) != 1 or len(vn_lo) != 1 or len(vp_hi) != 1 or len(vn_hi) != 1:
        raise RuntimeError('Missing or duplicate low/high endpoint voltages')
    if not (vp_lo[0] >= 1.5 and vn_lo[0] <= 0.3 and vp_hi[0] <= 0.3 and vn_hi[0] >= 1.5):
        raise RuntimeError(f'Endpoints do not resolve to complementary full swing: low={vp_lo,vn_lo}, high={vp_hi,vn_hi}')
    mid_p, mid_n = values('vp_mid'), values('vn_mid')
    if len(mid_p) != len(mid_n) or len(mid_p) < 4:
        raise RuntimeError('Missing bisection measurement(s)')
    for j,(a,b) in enumerate(zip(mid_p,mid_n)):
        if not ((a<=0.3 and b>=1.5) or (a>=1.5 and b<=0.3)):
            raise RuntimeError(f'Metastable/non-complementary decision at bisection step {j+1}: Vout_P={a}, Vout_N={b}')
    return lo,hi


def run_seed(seed: int, *, ngspice_bin: str, lib: Path, subckt_text: str,
             decks: Path, logs: Path, iterations: int, bound: float,
             sim_step_ns: float, timeout_s: float) -> dict:
    """Isolated job. Only this worker writes its own deck and log.

    The worker never updates the shared CSV/JSON; main() merges results in
    seed order after every submitted job has finished. Independent OS
    processes provide RNG isolation; threads are just subprocess launchers.
    """
    deck = decks / f'mc_{seed}.spice'
    log_path = logs / f'mc_{seed}.log'
    try:
        deck.write_text(make_deck(seed, lib, subckt_text, iterations=iterations,
                                  limit_v=bound, sim_step_ns=sim_step_ns))
        env = os.environ.copy()
        # Avoid N ngspice subprocesses each spawning additional OpenMP workers.
        env['OMP_NUM_THREADS'] = '1'
        env['OPENBLAS_NUM_THREADS'] = '1'
        proc = subprocess.run([ngspice_bin, '-b', '-o', str(log_path), str(deck)],
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                              text=True, timeout=timeout_s, env=env)
        text_log = log_path.read_text(errors='replace') if log_path.exists() else proc.stdout
        if proc.returncode:
            raise RuntimeError(f'ngspice exited {proc.returncode}; stdout={proc.stdout[-300:]}')
        lo, hi = parse_log(text_log, seed, limit_v=bound)
        sw = startup_lib_warnings(text_log)
        row = {'seed': seed,
               'offset_low_mV': lo * 1e3,
               'offset_high_mV': hi * 1e3,
               'offset_est_mV': (lo + hi) * 500,
               'resolution_uV': (hi - lo) * 1e6,
               'status': 'BRACKETED_WITH_STARTUP_WARNING' if sw else 'BRACKETED',
               'startup_lib_warning': bool(sw)}
        return {'seed': seed, 'row': row, 'warning': bool(sw), 'log': str(log_path)}
    except subprocess.TimeoutExpired:
        msg = f'ngspice timed out after {timeout_s:g} seconds'
    except (RuntimeError, ValueError, OSError) as exc:
        msg = str(exc)
    return {'seed': seed, 'error': msg, 'log': str(log_path)}


def main(argv=None) -> int:
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--samples',type=int,default=10,help='10 pilot, then 200 main')
    ap.add_argument('--workers','--jobs',type=int,default=4,help='Independent ngspice processes in parallel (default 4)')
    ap.add_argument('--timeout-s',type=float,default=600,help='Timeout per seed in seconds (default 600)')
    ap.add_argument('--seed-start',type=int,default=1001)
    ap.add_argument('--pdk',type=Path,default=DEFAULT_LIB)
    ap.add_argument('--ngspice',default='ngspice')
    ap.add_argument('--subckt',type=Path,default=DEF_INC,help='Optional exported SPICE StrongARM .subckt with same interface and 11 devices')
    ap.add_argument('--out',type=Path,default=HERE.parent/'results')
    ap.add_argument('--iterations',type=int,default=12)
    ap.add_argument('--range-mv',type=float,default=80.0)
    ap.add_argument('--step-ns',type=float,default=0.2)
    args=ap.parse_args(argv)
    if not (1 <= args.samples <= 10000 and args.seed_start>0 and 1<=args.workers<=64 and math.isfinite(args.timeout_s) and 1<=args.timeout_s<=86400 and 4<=args.iterations<=24 and 0.001<=args.range_mv<=300 and 0.05<=args.step_ns<=1):
        ap.error('Invalid samples/seeds/iterations/range/step')
    try:
        pdk_hash = check_library(args.pdk)
        text_subckt = args.subckt.read_text()
        check_subckt(text_subckt)
        ngspice_bin = shutil.which(args.ngspice)
        if not ngspice_bin:
            raise RuntimeError('ngspice not found on PATH')
    except (OSError, RuntimeError) as e:
        print(f'PREFLIGHT FAIL: {e}',file=sys.stderr)
        return 2
    out = args.out.expanduser().resolve()
    campaign=out/f'mismatch_{args.samples}_seed{args.seed_start}'
    decks=campaign/'decks'
    logs=campaign/'logs'
    decks.mkdir(parents=True,exist_ok=True)
    logs.mkdir(parents=True,exist_ok=True)
    rows=[]
    failure=[]
    startup_warnings=[]
    bound = args.range_mv/1000
    print(f'PDK OK: tt_mm mc_mm_switch=1, mc_pr_switch=0 | SHA256={pdk_hash[:16]}')
    print(f'RUN: {args.samples} seeds | {args.workers} worker(s) | delta sweep ±{args.range_mv:g} mV | {args.iterations} bisections | evaluation 362.5 ns', flush=True)
    print(f'OUTPUT: {campaign}', flush=True)
    started = time.perf_counter()
    seeds = range(args.seed_start, args.seed_start + args.samples)
    # as_completed() reports progress as each ngspice job finishes; output order
    # can differ from seed order. Exported CSV is sorted deterministically.
    with ThreadPoolExecutor(max_workers=min(args.workers, args.samples)) as pool:
        futures = {
            pool.submit(run_seed, seed,
                        ngspice_bin=ngspice_bin, lib=args.pdk.resolve(),
                        subckt_text=text_subckt, decks=decks, logs=logs,
                        iterations=args.iterations, bound=bound,
                        sim_step_ns=args.step_ns, timeout_s=args.timeout_s): seed
            for seed in seeds
        }
        for completed, fut in enumerate(as_completed(futures), start=1):
            result = fut.result()
            seed = result['seed']
            if 'error' in result:
                failure.append({'seed': seed, 'error': result['error'], 'log': result['log']})
                print(f'{completed:3}/{args.samples}: seed {seed}: FAIL {result["error"]}', file=sys.stderr, flush=True)
            else:
                row = result['row']
                rows.append(row)
                if result['warning']:
                    startup_warnings.append(seed)
                    print(f'WARNING: seed {seed}: .lib startup console warning; PDK audit required.', flush=True)
                print(f'{completed:3}/{args.samples}: seed {seed}: V_OS in '
                      f'[{row["offset_low_mV"]:+.4f},{row["offset_high_mV"]:+.4f}] mV', flush=True)
    elapsed_s = time.perf_counter() - started
    rows.sort(key=lambda r: r['seed'])
    failure.sort(key=lambda r: r['seed'])
    startup_warnings.sort()
    csv_path=campaign/'offset_samples.csv'
    with csv_path.open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=['seed','offset_low_mV','offset_high_mV','offset_est_mV','resolution_uV','status','startup_lib_warning'])
        writer.writeheader(); writer.writerows(rows)
    offsets=[r['offset_est_mV'] for r in rows]
    unique=len(set(round(x,6) for x in offsets))
    step_mV=(2*bound)*1000/(2**args.iterations)
    if len(rows)<args.samples:
        verdict='INCOMPLETE_FAILED_SAMPLES'
    elif len(rows)<3:
        verdict='INSUFFICIENT_SEEDS'
    elif unique<=1:
        verdict='MISMATCH_NOT_PROVEN_IDENTICAL_OFFSETS'
    elif (max(offsets)-min(offsets))<=step_mV:
        verdict='MISMATCH_UNRESOLVED_AT_GRID_RESOLUTION'
    else:
        verdict='PILOT_MISMATCH_VARIATION_OBSERVED' if args.samples<30 else 'MC_DATA_AVAILABLE_NOT_SILICON_YIELD'
    if startup_warnings and verdict.startswith(('PILOT_MISMATCH','MC_DATA')):
        verdict += '_REQUIRES_STARTUP_LIB_AUDIT'
    summary={
        'timestamp_utc':datetime.now(timezone.utc).isoformat(),
        'parallel_workers': min(args.workers, args.samples), 'wall_time_seconds': elapsed_s,
        'verdict':verdict,'samples_requested':args.samples,'samples_success':len(rows),
        'samples_failed':failure,'startup_lib_warning_seeds':startup_warnings,'seed_start':args.seed_start,'seed_end':args.seed_start+args.samples-1,
        'pdk':str(args.pdk.resolve()),'pdk_sha256':pdk_hash,
        'subckt':str(args.subckt.resolve()),'subckt_sha256':hashlib.sha256(text_subckt.encode()).hexdigest(),
        'corner':'tt_mm','mc_mm_switch':1,'mc_pr_switch':0,
        'iterations':args.iterations,'range_mV':args.range_mv,'transient_step_ns':args.step_ns,
        'input_common_mode_V':0.9,'VDD_V':1.8,'clock_MHz':4,
        'decision_observation_ns':362.5,'offset_sign_definition':'DeltaV=Vin1-Vin2 when Vout_P falls and Vout_N rises',
        'offset_estimation':'midpoint of final bisection bracket, not exact crossing',
        'bracket_width_mV':step_mV,'unique_estimate_values':unique,
        'mean_offset_mV':statistics.mean(offsets) if offsets else None,
        'std_offset_mV':statistics.stdev(offsets) if len(offsets)>1 else None,
        'min_offset_mV':min(offsets) if offsets else None,
        'max_offset_mV':max(offsets) if offsets else None,
        'claims_limitations':['schematic level; no parasitic extraction','no dynamic transistor noise analysis',
            'fixed 0.9 V input common-mode','PDK stochastic equations only; not silicon yield',
            'numerical tolerance and resolution affect small offsets','first complete sampled decision per 4MHz cycle, unloaded outputs']}
    (campaign/'summary.json').write_text(json.dumps(summary,indent=2))
    summary_md=['# StrongARM Monte Carlo mismatch — results',
                f'**Verdict:** `{verdict}`',
                f'**Samples:** {len(rows)}/{args.samples}',
                f'**Parallel workers:** {min(args.workers, args.samples)} | **Wall time:** {elapsed_s:.2f} s',
                f'**Startup .lib warnings:** {len(startup_warnings)} seed(s); review ~/.spiceinit and actual PDK before trusting MC statistics',
                f'**Corner:** `tt_mm` | **Seeds:** {args.seed_start} to {args.seed_start+args.samples-1}',
                f'**Offset interval width:** {step_mV*1000:.3f} µV',
                f'**Mean offset:** {summary["mean_offset_mV"]} mV',
                f'**Sample SD:** {summary["std_offset_mV"]} mV',
                f'**Min/max:** {summary["min_offset_mV"]} / {summary["max_offset_mV"]} mV',
                '', 'Each offset estimate is the midpoint of a bracketed transition between opposite comparator decisions.',
                'These results do not prove production yield, physical input offset at silicon, or post-layout timing.',
                f'**PDK hash:** `{pdk_hash}`']
    (campaign/'summary.md').write_text('\n'.join(summary_md)+'\n')
    print(f'\nFINISHED: {len(rows)}/{args.samples} seeds | {elapsed_s:.1f} s | {min(args.workers,args.samples)} workers')
    print('VERDICT:', verdict)
    print('FILES:',csv_path, campaign/'summary.json', campaign/'summary.md', sep='\n  ')
    return 0 if (verdict.startswith(('PILOT_MISMATCH','MC_DATA')) and not startup_warnings) else 3

if __name__=='__main__':
    sys.exit(main())
