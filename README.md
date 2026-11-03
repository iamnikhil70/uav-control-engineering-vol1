# UAV Control Engineering — Volume 1

A hands-on learning and implementation repository for building an ideal vertical UAV model from first principles using MATLAB and Simulink.

The goal is to understand the physics, derive the equations, implement the model, verify it against analytical results, and preserve the work as reproducible engineering evidence.

## Current learning status

| Day | Handbook topic | Learner status | Repository evidence |
|---:|---|---|---|
| 1 | Mathematical language and the first moving model | **Completed** | MATLAB script, Simulink model, plot, MAT result, and engineering notebook are committed |
| 2 | Frames, forces, and hover | **In progress — current focus** | Companion MATLAB script is present; complete the Day 2 exercises and record the results |
| 3 | Operating points, deviations, and numerical integration | Not started | Companion source is included |
| 4 | Laplace transforms and the double integrator | Not started | Companion source is included |
| 5 | Equivalent Simulink representations | Not started | Companion source and optional model builder are included |
| 6 | States, matrices, and initial motion | Not started | Companion source is included |
| 7 | Independent vertical-plant experiment | Not started | Companion source and helper functions are included |

**Important:** MATLAB scripts and reference files for Days 2–7 are included as part of the Volume 1 companion bundle. Their presence in this repository does not mean those lessons have been completed or independently verified by the learner.

See [the milestone tracker](docs/milestones.md), [Day 1 progress record](docs/day01_progress.md), and [Day 1 engineering notebook](docs/notebook_d01.md).

## What this repository contains

- **MATLAB source:** daily scripts for Days 1–7 and supporting functions.
- **Simulink:** the completed Day 1 model and an optional builder for later comparison models.
- **Configuration:** the shared ideal-plant baseline parameters.
- **Documentation:** lesson progress, engineering notebook, report template, continuity record, and handbook source text.
- **Experiments:** verification plan and independent reference calculations.
- **Figures:** instructional reference figures and learner-generated figures.
- **Results:** saved numerical output from completed experiments.

## Repository layout

    config/                 Shared Volume 1 parameters
    docs/                   Progress, notebook, templates, handbook text
    experiments/            Verification plan and reference checks
    figures/reference/      Instructional reference illustrations
    figures/student/        Learner-generated plots
    matlab/                 Daily MATLAB scripts and helper functions
    results/                Saved MAT and CSV experiment results
    simulink/               Simulink models and optional model builder
    startup_volume1.m       Project setup script

The reference illustrations in figures/reference are teaching material, not measurements from a physical UAV. Learner-generated evidence belongs in figures/student and results.

## Day 1 — completed

Day 1 introduced vertical kinematics with upward-positive altitude:

- Acceleration: a(t) = a0
- Velocity: v(t) = v0 + a0 t
- Altitude: z(t) = z0 + v0 t + ½ a0 t²

For the baseline exercise, z0 = 0 m, v0 = 0 m/s, and a0 = 0.2 m/s² over 4 seconds. The analytical terminal values are v(4) = 0.8 m/s and z(4) = 1.6 m.

Committed Day 1 evidence:

- MATLAB source: matlab/day01_kinematics.m
- Simulink model: simulink/day01_kinematics.slx
- Learner plot: figures/student/day01_kinematics.png
- Saved data: results/day01.mat
- Run notes: docs/notebook_d01.md

The notebook records the learner's reported MATLAB assertion and Simulink scope checks. The exact MATLAB release and installed toolbox versions still need to be recorded.

## Start the project

1. Open MATLAB.
2. Set the Current Folder to the repository root.
3. Run the startup script once:

    startup_volume1

This adds the configuration, MATLAB, and Simulink folders to the MATLAB path, prints the MATLAB release and installed products, and creates the student figure and result folders.

To rerun Day 1:

    day01_kinematics

To begin the current lesson, Day 2:

    day02_forces

Follow the handbook in order. Make predictions and derive the expected values before running the script or inspecting the output.

## Daily MATLAB scripts

| Day | Command | Purpose |
|---:|---|---|
| 1 | day01_kinematics | Constant-acceleration kinematics |
| 2 | day02_forces | Total thrust, weight, and hover |
| 3 | day03_ode | Total-thrust and deviation-form ODEs |
| 4 | day04_transfer_function | Transfer function, poles, and response interpretation |
| 5 | day05_compare_models | Compare Integrator, Transfer Fcn, and State-Space models |
| 6 | day06_state_space | Physical states and nonzero initial conditions |
| 7 | day07_weekly_experiment | Piecewise thrust input and mass-sweep verification |

Days 5 and 7 require the corresponding Simulink models to be built first. The optional builder is simulink/build_volume1_models.m; read its comments and follow the handbook's manual-build exercise before using it.

Other helper scripts include make_concept_figures, plot_weekly_profile, piecewise_ode, and pulse_reference. They support later lessons and are not separate learner milestones.

## Software requirements

- **MATLAB:** required for the daily numerical scripts.
- **Simulink:** required for the block-diagram exercises and Simulink model comparisons.
- **Control System Toolbox:** required for the transfer-function and state-space workflows used in later days.
- **Python 3 with NumPy and SciPy:** optional; used only for the independent reference-check script in experiments.

The startup script prints the installed MATLAB release and products. Record the exact versions in your engineering notebook rather than assuming that every MATLAB release exposes identical block parameters or interfaces.

## Modeling conventions

- The vertical coordinate z is positive upward.
- v = dz/dt and a = dv/dt.
- The physical state order used later in Volume 1 is x = [z; v].
- Total thrust T is measured in newtons and acts upward.
- Hover thrust is T0 = mg.
- The signed thrust increment is ΔT = T − mg, so the ideal vertical plant is m z̈ = ΔT.

Keep total thrust and thrust increment distinct. The input used in the deviation model is a force in newtons, not normalized throttle or rotor speed.

## Verification and limitations

The repository includes analytical reference checks and independent Python numerical validation. Those checks do not establish that every MATLAB script or Simulink model has been executed successfully on every MATLAB release.

Day 1 learner evidence is recorded separately in docs/notebook_d01.md. Complete the remaining native MATLAB and Simulink checks as each lesson is studied.

This is an **ideal vertical-plant learning project**, not a validated aircraft model. It does not yet establish real vehicle mass or thrust data, actuator dynamics, aerodynamic drag, attitude coupling, sensor behavior, closed-loop controller performance, or flight readiness. ROS 2, Gazebo, PX4/ArduPilot SITL, LQR, and MPC are later-stage topics, not completed components of this Volume 1 repository.

## Keeping the repository clean

Commit learner-generated plots, models, and numerical results when they provide reproducible evidence. Do not commit temporary Simulink build folders, autosave files, or editor backups; the existing .gitignore excludes common temporary files.

Do not mark a day complete merely because its companion script or reference figure is present. Update docs/milestones.md and the engineering notebook only after completing the lesson and its checks.
