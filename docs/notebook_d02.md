# Engineering notebook — Day 2: Frames, forces, and hover

- **Date:** 2026-11-04
- **Learning status:** Completed by learner.
- **Objective:** Draw the vertical free-body diagram, derive the equation of motion from Newton's second law, calculate hover thrust, and compare the response for total thrust below, equal to, and above weight.
- **MATLAB source:** matlab/day02_forces.m
- **Simulink model:** simulink/day02_total_thrust.slx — reported as built and verified locally, but this file is not present in the current GitHub repository.
- **Committed plot and data:** figures/student/day02_forces.png; results/day02.mat
- **MATLAB release and installed products:** The exact MATLAB release and toolbox versions have not been recorded. The Day 2 MATLAB exercise uses MATLAB; the block-diagram exercise uses Simulink.
- **Git evidence:** The Day 2 plot and MAT result are present on main. The evidence was added in commit 9bb23397c5f5171cac56a237e6791f7cc8d70616.

## 1. Coordinate convention and force balance

The vertical coordinate z is positive upward. Thrust acts upward and weight acts downward.

Applying Newton's second law:

m z̈ = ΣFz = T − mg

where:

- m is vehicle mass in kilograms.
- z̈ is vertical acceleration in m/s².
- T is total upward thrust in newtons.
- mg is weight in newtons.

At hover, vertical acceleration is zero:

T₀ = mg

For the deviation model, define the signed thrust increment:

ΔT = T − T₀ = T − mg

Therefore:

m z̈ = ΔT

Do not confuse total thrust T with thrust increment ΔT. At hover, total thrust is nonzero while the thrust increment is zero.

## 2. Parameters and assumptions

| Parameter | Value |
|---|---:|
| Mass, m | 2 kg |
| Gravitational acceleration, g | 9.81 m/s² |
| Weight / hover thrust, mg | 19.62 N |
| Initial altitude, z₀ | 0 m |
| Initial vertical velocity, v₀ | 0 m/s |
| Simulation horizon | 0–4 s |

Assumptions: level attitude, constant mass, constant gravitational acceleration, rigid vehicle, no aerodynamic drag, and instantaneous thrust. These assumptions define an ideal vertical-translation model, not a complete aircraft model.

## 3. Predictions before execution

For each constant total-thrust case:

a = (T − mg)/m

v(t) = v₀ + at

z(t) = z₀ + v₀t + ½at²

With z₀ = 0 and v₀ = 0:

| Total thrust T | Net force T − mg | Acceleration | v(4 s) | z(4 s) |
|---:|---:|---:|---:|---:|
| 19.22 N | −0.40 N | −0.20 m/s² | −0.80 m/s | −1.60 m |
| 19.62 N | 0 N | 0 m/s² | 0 m/s | 0 m |
| 20.02 N | +0.40 N | +0.20 m/s² | +0.80 m/s | +1.60 m |

### Nonzero initial-velocity check

For T = 20.02 N, the acceleration is +0.2 m/s². If z₀ = 0 m and v₀ = 0.3 m/s:

- v(4) = 0.3 + (0.2)(4) = **1.1 m/s**
- z(4) = 0 + (0.3)(4) + ½(0.2)(4²) = 1.2 + 1.6 = **2.8 m**

The altitude result is 2.8 m. The earlier 2.75 m value was an arithmetic error.

## 4. MATLAB and Simulink implementation

The MATLAB script computes acceleration, velocity, and altitude from the constant-force analytical equations for the three thrust cases. It exports the learner plot and saves the variables to results/day02.mat.

The Simulink exercise explicitly represents total thrust and gravity, then forms the net vertical force and integrates acceleration to velocity and altitude.

Reported Simulink settings:

- Solver: variable-step ode45
- Maximum step size: 0.01 s
- Initial conditions: z₀ = 0 m and v₀ = 0 m/s for the baseline; v₀ = 0.3 m/s for the secondary check
- Exact solver tolerances: not recorded

## 5. Actual observations and verification

The learner reports that the MATLAB results matched the three predicted thrust cases and that the Simulink scopes were checked against the analytical values.

Reported secondary check with v₀ = 0.3 m/s and T = 20.02 N:

- Final velocity: 1.1000 m/s
- Final altitude: 2.8000 m

The learner reported Simulink position and velocity discrepancies below 10⁻⁶ in their respective SI units. The raw error arrays or a separate error-summary file are not currently committed, so this remains a learner-reported verification result rather than a separately reproducible error report.

**Repository evidence currently available:**

- matlab/day02_forces.m
- figures/student/day02_forces.png
- results/day02.mat

**Evidence still to add if retaining the native Simulink model in GitHub:**

- simulink/day02_total_thrust.slx

## 6. Conclusion and validity boundary

The force balance predicts the expected three cases: thrust below weight produces downward acceleration, thrust equal to weight produces zero vertical acceleration, and thrust above weight produces upward acceleration. Hover requires 19.62 N total thrust for the illustrative 2 kg mass.

This exercise does not validate aerodynamic drag, rotor or motor lag, thrust limits, attitude/translation coupling, sensor behavior, or real-aircraft performance.

## 7. Next justified action

Proceed to Day 3: operating points, deviation variables, and numerical integration.
