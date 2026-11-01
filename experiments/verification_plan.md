# Volume 1 verification plan

Use zero initial states for three-branch TF equivalence.
Use explicitly physical states for nonzero-initial-condition experiments.

| Test | Input and state | Independent expectation | Failure detected |
|---|---|---|---|
| Hover | Total T = mg, v0 = 0 | a = 0; z constant | Gravity sign or baseline |
| Free motion | Increment 0, z0 = 1, v0 = 0.3 | z = 1 + 0.3t | State order or ignored IC |
| Positive increment | 0.4 N, m = 2, zero IC | a = 0.2; z = 0.1t² | Sign, mass, integration count |
| Delayed step | 0.4 N at 1 s, m = 2 | z = 0.1 max(t-1,0)² | Event time or interpolation |
| Weekly pulse | Changes +0.4, -0.8, +0.4 N at 1,3,5 s | z(6)=0.8, v(6)=0 | Step changes versus levels |
| Mass sweep | Same increment, m=1,2,4 | Final z=1.6,0.8,0.4 | Stale or duplicate mass |
| Fixed total force | T=19.62 N | a=9.81,0,-4.905 for m=1,2,4 | Wrong experiment definition |

For each Simulink branch evaluate the analytical position at that log's times.
Target max position discrepancy below 1e-5 m; check nonfinite results explicitly.
For the baseline smooth ODE use max position and velocity discrepancies below
1e-7 in SI units. Do not compare acceleration exactly at a discontinuity without
specifying left/right conventions. Restore baseline settings after a fault test.

Record solver refinement as an observation. Smaller maximum steps may not improve
errors already at the roundoff floor. Parameter and unit errors do not disappear
with tighter integration tolerances.

