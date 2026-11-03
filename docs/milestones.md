# Volume 1 milestone tracker

This tracker separates learner progress from the presence of companion source files. A day is complete only after the learner has studied the lesson, performed its implementation, completed the exercises, and passed the completion gate.

## Volume 1 progress

| Day | Handbook topic | Learning status | Repository evidence |
|---:|---|---|---|
| 1 | Mathematical language and the first moving model | **Completed** | MATLAB script, Simulink model, learner plot, MAT result, and notebook are committed |
| 2 | Frames, forces, and hover | **In progress — current focus as of 3 Nov 2026** | Companion source is present; learner evidence is pending |
| 3 | Operating points, deviations, and numerical integration | Not started | Companion source is present |
| 4 | Laplace transforms and the double integrator | Not started | Companion source is present |
| 5 | Equivalent Simulink representations | Not started | Companion source and optional model builder are present |
| 6 | States, matrices, and initial motion | Not started | Companion source is present |
| 7 | Independent vertical-plant experiment | Not started | Companion source and helper functions are present |

## Day 1 — Mathematical language and the first moving model

**Learning status:** Complete, based on the learner's report and the Day 1 engineering notebook.

### Learning and implementation checklist

- [x] Answer the prerequisite questions about speed, average acceleration, zero acceleration, and initial position.
- [x] Distinguish altitude, vertical velocity, and vertical acceleration, including sign and units.
- [x] Explain z(t) as a time-dependent function.
- [x] Derive instantaneous velocity and acceleration using time derivatives.
- [x] Integrate constant acceleration and retain both initial conditions.
- [x] Check the dimensions of the acceleration, velocity, and altitude terms.
- [x] Run the Day 1 MATLAB script.
- [x] Inspect the three labelled traces: acceleration, velocity, and altitude.
- [x] Build the two-Integrator Simulink model.
- [x] Set the first Integrator initial condition to v0 and the second to z0.
- [x] Verify the 0 s, 2 s, and 4 s analytical checkpoints.
- [x] Complete the Day 1 practice, concept-check, and debugging activities.

### Analytical baseline

a(t) = 0.2 m/s²

v(t) = 0.2t m/s

z(t) = 0.1t² m

| Time | Acceleration | Velocity | Altitude |
|---:|---:|---:|---:|
| 0 s | 0.2 m/s² | 0 m/s | 0 m |
| 2 s | 0.2 m/s² | 0.4 m/s | 0.4 m |
| 4 s | 0.2 m/s² | 0.8 m/s | 1.6 m |

### Day 1 repository evidence

- [x] Companion MATLAB source: matlab/day01_kinematics.m
- [x] Baseline parameter helper: config/volume1_parameters.m
- [x] Project startup script: startup_volume1.m
- [x] Simulink model: simulink/day01_kinematics.slx
- [x] Learner-generated plot: figures/student/day01_kinematics.png
- [x] Learner-generated data: results/day01.mat
- [x] Day 1 progress record: docs/day01_progress.md
- [x] Day 1 engineering notebook: docs/notebook_d01.md
- [ ] Record the exact MATLAB release and installed toolbox versions in the notebook.

The model, plot, and MAT file are now stored in the standard project output folders. Their presence records the Day 1 implementation; it does not validate a physical aircraft.

## Day 2 — current milestone

**Topic:** Frames, forces, and hover.

The next lesson should connect the coordinate convention to the vertical force balance. Preserve the upward-positive sign convention and distinguish total thrust from the thrust increment.

Before marking Day 2 complete:

- [ ] Work through the handbook's frame and force definitions.
- [ ] Derive the vertical force equation and identify the hover condition.
- [ ] Predict the motion for thrust below, equal to, and above weight.
- [ ] Run matlab/day02_forces.m and compare the results with the analytical predictions.
- [ ] Build and inspect the Day 2 Simulink model required by the handbook.
- [ ] Record actual observations, MATLAB release, and any discrepancies in the engineering notebook.
- [ ] Commit the Day 2 evidence and update this tracker.

Companion files for later days are included in the repository, but their presence is not evidence that those lessons have been completed.
