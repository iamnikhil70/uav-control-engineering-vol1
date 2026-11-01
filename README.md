# UAV Control Engineering Volume 1 companion

This project supports the seven-day handbook on ideal vertical UAV dynamics.
The physical input is a thrust increment in newtons, not throttle or rotor speed.
Upward altitude is positive. The state order is `[z; v]`.

## Requirements and execution status

MATLAB, Simulink, and Control System Toolbox are required for all labs.
Days 1–3 and the optional concept plots use base MATLAB for numerical work.
Official MathWorks interfaces were reviewed on 2026-10-05.
No MATLAB or Simulink runtime was available during authorship. The `.m` source
and model builder have not been executed in those products. See
`docs/reference_validation.md` for independently executed mathematical and
SciPy numerical checks. These do not establish native MATLAB/Simulink compatibility.
Run the acceptance checks below on your installation.

## Start

1. Extract the whole folder. Set MATLAB Current Folder to this folder.
2. Run `startup_volume1`. Record the printed release and toolbox list.
3. Read the day's theory, make predictions, and derive checkpoints by hand.
4. Run the corresponding daily script by name in MATLAB.
5. Construct the Simulink model manually using the handbook.
6. Record actual results and discrepancies before committing your work.

Do not use `clear all` halfway through a lab: it removes setup variables such as
`project_root`, `figure_dir`, and `result_dir`. Rerun startup if needed.

## Daily run order

| Day | MATLAB command | Simulink model you create |
|---|---|---|
| 1 | `day01_kinematics` | `day01_kinematics.slx` |
| 2 | `day02_forces` | `day02_total_thrust.slx` |
| 3 | `day03_ode` | `day03_absolute_vs_delta.slx` |
| 4 | `day04_transfer_function` | `day04_transfer_function.slx` |
| 5 | `day05_compare_models` after building the model | `v1_equivalent.slx` |
| 6 | `day06_state_space` | `day06_initial_state.slx` |
| 7 | `day07_weekly_experiment` after building the model | `v1_weekly.slx` |

`plot_weekly_profile` reproduces the weekly four-signal figure.
`make_concept_figures` produces the local-linearization, Euler-error, derivative,
and pole-location illustrations. Review its comments before running.

## Optional reference model builder

After trying manual construction, run `build_volume1_models` from MATLAB.
It creates **new** `v1_equivalent.slx` and `v1_weekly.slx` files under `simulink`.
It skips an existing or open model rather than overwriting it.
No generated `.slx` binaries are supplied as tested artifacts in this bundle.

The builder stores defaults in the model workspace. The daily comparison scripts
use `SimulationInput.setVariable(...,'Workspace',modelname)` to override those
values for each run. Merely changing base-workspace `m` will not override a model
workspace value. If block parameter names differ in an older release, construct
the model manually and use installed block Help. Current Step documentation names
the programmatic level parameters `InitialValue` and `FinalValue`; older releases
may expose `Before` and `After`. Record any adaptation in your notebook.

## Acceptance checks

- Day 1: z(4 s) = 1.6 m under a = 0.2 m/s² from rest.
- Day 3: ODE position and velocity match the analytical solution within 1e-7
  in their respective SI units over the simple baseline test.
- Day 4: the 0.4 N step at 1 s gives z(6 s) = 2.5 m for 2 kg.
- Day 5: all three position branches agree with the reference to within 1e-5 m.
- Day 6: z(t) = 1 + 0.3 t and v(t) = 0.3 with zero increment.
- Day 7: +0.4 N from 1–3 s and -0.4 N from 3–5 s gives final z = 0.8 m,
  v = 0 for 2 kg; the final altitudes for 1 and 4 kg are 1.6 and 0.4 m.
- All Day 7 position residual checks must be finite and below 1e-5 m.

These are numerical implementation checks, not claims about real-aircraft accuracy.
Scripts intentionally stop on failed assertions. Diagnose input, mass, units,
initial conditions, and logging before changing solver tolerances.

## Outputs and documents

Your runs create `results` and `figures/student`. Reference illustrations live in
`figures/reference` and are labelled instructional, not student measurements.
Use `docs/notebook_template.md` and `docs/week1_report_template.md` for your own
evidence. `docs/MASTER_CONTINUITY_RECORD.md` is the handoff to later volumes;
update its learner-status fields honestly. The source manuscript is included as
`docs/handbook_source.md` for searching and annotation.

This bundle neither creates nor publishes a GitHub repository. Daily meaningful
commit messages are provided in the handbook. No ROS 2 or autopilot stack has yet
been chosen or installed.



## Learner progress

As of **1 November 2026**, the learner reports completing all Day 1 activities in the handbook. See [the milestone tracker](docs/milestones.md) and [Day 1 progress record](docs/day01_progress.md). The companion source files are present; sync the learner-generated Simulink model, plot, and MAT-file from the MATLAB computer to complete the repository evidence.

