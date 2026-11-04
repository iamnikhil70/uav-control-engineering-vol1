# Engineering notebook entry

- Experiment identifier and date: Day 1: Vertical Kinematics and First Integrator Model (2026-11-03)
- Objective and question: Understand vertical kinematics, verify constant acceleration in MATLAB, and implement a two-integrator physical memory model in Simulink.
- Script/model path and Git commit: matlab/day01_kinematics.m; simulink/day01_kinematics.slx; model and notebook commit 146f08a; evidence-folder correction commit ba45f3a.
- MATLAB release and installed toolboxes: Exact release and toolbox versions not recorded yet; record the output from startup_volume1.
- Equation, state order, input/output units, and sign convention: ż = v, v̇ = a0; second-order altitude model; acceleration in m/s², position in metres, velocity in m/s; positive upward.
- Assumptions and validity boundary: Constant acceleration (a0 = 0.2 m/s²), zero drag, ideal continuous-time integration.
- Parameters and force history: a0 = 0.2 m/s², constant acceleration over 4 s.
- Initial conditions and time horizon: z(0) = 0 m, v(0) = 0 m/s; t = [0, 4] s.
- Solver, tolerances, maximum step, input interpolation, and logging: Variable-step solver (ode45), maximum step size 0.01 s.
- Prediction written BEFORE running: Velocity at 4 s = 0.8 m/s; altitude at 4 s = 1.6 m.
- Independent analytical checkpoints: v(4) = 0 + (0.2)(4) = 0.8 m/s; z(4) = ½(0.2)(4²) = 1.6 m.
- Actual numerical observations: Final position z(end) = 1.6000 m; final velocity v(end) = 0.8000 m/s.
- Plot and data filenames: figures/student/day01_kinematics.png; results/day01.mat.
- Verification metric and predefined threshold: MATLAB assertion on terminal altitude; the companion script checks |z(end) − 1.6| < 1e-12.
- Actual maximum position error (m): < 10⁻⁶ (reported within floating-point tolerance).
- Actual maximum velocity error (m/s), if checked: < 10⁻⁶ (reported within floating-point tolerance).
- Pass/fail/pending and evidence: Pass, learner-reported. MATLAB assertion passed and Simulink scopes were verified.
- Discrepancy and a test to isolate its cause: None reported.
- Repair and rerun result, if applicable: N/A.
- Conclusion supported by the evidence: Cascaded integrators accumulate acceleration into velocity and position over time, matching the analytical kinematics.
- What remains unvalidated: External disturbances, aerodynamic drag, actuator saturation, thrust generation, and real-aircraft behavior.
- Next justified action: Day 3 — Operating points, deviations, and numerical integration.


## Conceptual checkpoints

- Positive velocity means climbing; negative velocity means descending.
- Positive acceleration means velocity becomes more positive. It can slow a descent while velocity remains negative.
- Zero acceleration means constant velocity, not necessarily zero velocity.
- The second-order altitude model requires two initial conditions: initial altitude and initial vertical velocity.
- Day 1 prescribes acceleration directly; it does not yet derive acceleration from thrust and gravity.
