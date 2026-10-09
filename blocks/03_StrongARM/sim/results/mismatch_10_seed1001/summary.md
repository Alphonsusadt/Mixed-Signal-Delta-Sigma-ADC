# StrongARM Monte Carlo mismatch — results
**Verdict:** `PILOT_MISMATCH_VARIATION_OBSERVED_REQUIRES_STARTUP_LIB_AUDIT`
**Samples:** 10/10
**Startup .lib warnings:** 10 seed(s); review ~/.spiceinit and actual PDK before trusting MC statistics
**Corner:** `tt_mm` | **Seeds:** 1001 to 1010
**Offset interval width:** 39.062 µV
**Mean offset:** 1.6250005 mV
**Sample SD:** 3.168182920816363 mV
**Min/max:** -5.7226550000000005 / 4.86328 mV

Each offset estimate is the midpoint of a bracketed transition between opposite comparator decisions.
These results do not prove production yield, physical input offset at silicon, or post-layout timing.
**PDK hash:** `48de7c677e2c6e7d09b2559279de9f818be71010a4aa933d728eb4db3b133c84`
