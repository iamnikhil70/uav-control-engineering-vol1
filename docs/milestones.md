# Volume 1 milestone tracker

This tracker follows the day-by-day sequence in the Volume 1 handbook. A learning milestone is marked complete when the learner has worked through the lesson, implementation, exercises, and completion gate. Repository evidence is tracked separately so that a completed study session is not confused with files already committed to GitHub.

## Volume 1 progress

| Day | Handbook topic | Learning status | Repository evidence |
|---:|---|---|---|
| 1 | Mathematical language and the first moving model | **Completed — learner-reported 1 Nov 2026** | Day 1 source and companion configuration are present; local Simulink model and run outputs still need syncing |
| 2 | Frames, forces, and hover | Not started | Pending |
| 3 | Operating points, deviations, and numerical integration | Not started | Pending |
| 4 | Laplace transforms and the double integrator | Not started | Pending |
| 5 | Equivalent Simulink representations | Not started | Pending |
| 6 | States, matrices, and initial motion | Not started | Pending |
| 7 | Independent vertical-plant experiment | Not started | Pending |

## Day 1 — Mathematical language and the first moving model

**Learning status:** Complete, based on the learner's report that all Day 1 manual activities were completed.

### Learning and implementation checklist

- [x] Answer the prerequisite questions about speed, average acceleration, zero acceleration, and initial position.
- [x] Distinguish altitude, vertical velocity, and vertical acceleration, including sign and units.
- [x] Explain (z(t)) as a time-dependent function.
- [x] Derive instantaneous velocity and acceleration using time derivatives.
- [x] Integrate constant acceleration and retain both initial conditions.
- [x] Check the dimensions of the acceleration, velocity, and altitude terms.
- [x] Run the Day 1 MATLAB script.
- [x] Inspect the three labelled traces: acceleration, velocity, and altitude.
- [x] Build the two-Integrator Simulink model manually.
- [x] Set the first Integrator initial condition to (v_0) and the second to (z_0).
- [x] Verify the 0 s, 2 s, and 4 s analytical checkpoints.
- [x] Complete the Day 1 practice, concept-check, and debugging activities.

### Analytical baseline

```math
a(t)=a_0=0.2\;\mathrm{m/s^2}
```

```math
v(t)=v_0+a_0t=0.2t\;\mathrm{m/s}
```

```math
z(t)=z_0+v_0t+\frac{1}{2}a_0t^2=0.1t^2\;\mathrm{m}
```

| Time | (a(t)) | (v(t)) | (z(t)) |
|---:|---:|---:|---:|
| 0 s | 0.2 m/s² | 0 m/s | 0 m |
| 2 s | 0.2 m/s² | 0.4 m/s | 0.4 m |
| 4 s | 0.2 m/s² | 0.8 m/s | 1.6 m |

### GitHub evidence checklist

- [x] Companion MATLAB source: `matlab/day01_kinematics.m`
- [x] Baseline parameter helper: `config/volume1_parameters.m`
- [x] Project startup script: `startup_volume1.m`
- [x] Day 1 progress documentation
- [ ] Add the learner's actual `simulink/day01_kinematics.slx`
- [ ] Add the learner-generated `figures/student/day01_kinematics.png`
- [ ] Add the learner-generated `results/day01.mat`
- [ ] Record the learner's MATLAB release and any actual deviations from the reference checkpoints

The last four items are repository synchronization/evidence tasks, not a claim that the learner failed to complete the Day 1 activities. Do not replace measured/observed values with reference values.

## Next milestone: Day 2

**Frames, forces, and hover.**

Entry condition: explain why the Day 1 model treats acceleration as prescribed, and distinguish that kinematics exercise from the force-derived plant that Day 2 will build. Preserve the handbook's upward-positive sign convention.
