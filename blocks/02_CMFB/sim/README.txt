OTA + 8-TG SC-CMFB | PVT screening and common-mode transient stress

Base: validated tb_OTA_CMFB_firststage_closedloop_FIXED.sch.
No change to OTA_CMFB.sch, TG_cell.sch or CMFB.sch.

Place .sch cases at: blocks/02_CMFB/sim/
These schematics reference the existing symbols at
  blocks/01_OTA/xschem/OTA_CMFB.sym
  blocks/02_CMFB/xschem/CMFB.sym

PVT FIRST SCREEN: 7 cases
01 TT / 1.80V / 27C: reference
02 TT / 1.80V / -40C
03 TT / 1.80V / 125C
04 TT / 1.62V / 27C
05 TT / 1.98V / 27C
06 SS / 1.80V / 27C
07 FF / 1.80V / 27C

All PVT variations keep independent Vbias=0.507621V,
Vbz_L=Vbz_R=1.5V, Vcs=0.9V, Vcmo=0.9292742V.
For VDD variation only, the clock logic-HIGH tracks the supply
and clock timing is unchanged.

These fixed bias/reference sources are a STRESS CONDITION and do
not demonstrate that a practical bias/reference generator tracks PVT.
Do not declare PASS just because SPICE converges. Check common-mode,
feedback range, ripple, drift, headroom and excessive output excursions.

The 1.98V case is a proposed +10% stress case, not a statement
that 1.98V is a validated continuous operating rating for every
1.8-V SKY130 device. Verify device limits before sign-off.

Full matrix later: 3 process x 3 supply x 3 temp = 27 runs, plus
SF/FS process corners when needed. These seven are a screening set.

STABILITY TEST:
tb_CMFB_STABILITY_100nA_CMstep_TT.sch
Both first-stage nodes have 100nA current drawn (toward ground)
from 40us to 50us with 1ns nominal transition at TT/1.8V/27C.
Compare before (30-39us), during (42-49us), recovery (90-100us).
A single disturbance response is not a phase-margin proof; SC-CMFB
is sampled/time-varying. Follow with per-cycle recovery and ripple,
and time-varying/sampled loop-stability analysis if needed.

If the symbol isource.sym is missing, use Xschem devices/isource.sym.
Netlist + check current source direction before running.

IMPORTANT: These files have been statically checked but not run in
ngspice here because the SKY130 PDK and ngspice are not installed.

Measurements included in case terminals:
 VO1CM_LAST, VO1CM_ERR, VO1CM_RIPPLE
 CMFB_LAST, CMFB_RIPPLE, VOUTCM_LAST, VOUTCM_RIPPLE
 CM_DRIFT, CTRL_DRIFT, OUT_DRIFT

And for disturbance:
 CM_BASE, CM_DURING, CM_RECOVER, CM_RECOVERY_ERR
 CTRL_BASE, CTRL_DURING, CTRL_RECOVER, CTRL_RECOVERY_ERR
