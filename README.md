# UAV Control Engineering — Volume 1

A hands-on learning and implementation repository for developing an ideal vertical UAV plant from first principles using MATLAB and Simulink.

The workflow is: understand the physics, derive the equations, implement the model, verify it against analytical results, and preserve the work as reproducible engineering evidence.

## Current status

**Days 1, 2, and 3 are complete. Day 4 is next.**

- [Volume 1 milestone tracker](docs/milestones.md) — the single high-level progress summary.
- [Day 1 engineering notebook](docs/notebook_d01.md) — vertical kinematics.
- [Day 2 engineering notebook](docs/notebook_d02.md) — frames, forces, and hover.
- [Day 3 engineering notebook](docs/notebook_d03.md) — hover equilibrium, deviation variables, numerical ODE verification, and Simulink comparison.

The daily notebooks are the authoritative records of what was studied, implemented, observed, and verified. The presence of companion scripts for later days does not mean those lessons are complete.

## Project scope

Volume 1 develops an ideal vertical-motion plant. It does not yet implement a feedback controller or establish flight readiness.

The core physical model uses an upward-positive vertical coordinate:

- Total-thrust equation: \(m\ddot z=T-mg\)
- Hover thrust: \(T_0=mg\)
- Thrust increment: \(u=\Delta T=T-mg\)
- Deviation-form plant: \(m\ddot z=u\)

The baseline values are illustrative: \(m=2\) kg and \(g=9.81\) m/s². They are not measurements of a physical UAV.

## Repository structure

    docs/                   Engineering notebooks, tracker, templates, continuity record
    experiments/            Independent reference checks and verification plan
    figures/reference/      Teaching/reference illustrations
    figures/student/        Learner-generated plots
    matlab/                 Daily MATLAB scripts, helpers, startup and parameters
    results/                Saved MAT experiment results
    simulink/               Simulink models and optional model builder

The reference illustrations are teaching material, not measurements from a physical UAV. Learner-generated evidence belongs in figures/student and results.

## Completed work

### Day 1 — vertical kinematics

The first model prescribes constant acceleration and integrates it to obtain velocity and altitude:

- \(a(t)=a_0\)
- \(v(t)=v_0+a_0t\)
- \(z(t)=z_0+v_0t+\frac{1}{2}a_0t^2\)

Committed learner evidence:

- MATLAB source: [matlab/day01_kinematics.m](matlab/day01_kinematics.m)
- Simulink model: [simulink/day01_kinematics.slx](simulink/day01_kinematics.slx)
- Plot: [figures/student/day01_kinematics.png](figures/student/day01_kinematics.png)
- Data: [results/day01.mat](results/day01.mat)
- Notebook: [docs/notebook_d01.md](docs/notebook_d01.md)

### Day 2 — frames, forces, and hover

Day 2 derives the vertical force balance and distinguishes total thrust from thrust increment. For the illustrative 2 kg vehicle, hover requires 19.62 N total thrust. The MATLAB exercise compares thrust below, equal to, and above weight.

Committed learner evidence:

- MATLAB source: [matlab/day02_forces.m](matlab/day02_forces.m)
- Plot: [figures/student/day02_forces.png](figures/student/day02_forces.png)
- Data: [results/day02.mat](results/day02.mat)
- Notebook: [docs/notebook_d02.md](docs/notebook_d02.md)

The learner reports that the Day 2 Simulink model and scopes were verified locally. However, [simulink/day02_total_thrust.slx](simulink/day02_total_thrust.slx) is not present in the current GitHub tree, so it is not a committed artifact.

### Day 3 — hover equilibrium, deviation variables, and ODE verification

Day 3 derives the deviation-form plant by subtracting the hover equilibrium thrust from total thrust:

\[
m\ddot z=T-mg,\qquad T_0=mg,\qquad u=T-T_0
\]

Therefore:

\[
m\ddot z=(T_0+u)-mg=u
\]

The cancellation is exact for this ideal one-dimensional vertical model. The second-order equation is also written as the coupled first-order state equations \(\dot z=v\) and \(\dot v=u/m\).

Using the illustrative baseline \(m=2\) kg, \(g=9.81\) m/s², and \(u=0.4\) N gives an acceleration of 0.2 m/s². Starting from rest, the analytical checkpoints at 4 s are \(v(4)=0.8\) m/s and \(z(4)=1.6\) m.

Committed learner evidence:

- MATLAB source: [matlab/day03_ode.m](matlab/day03_ode.m)
- Simulink comparison model: [simulink/day03_ode.slx](simulink/day03_ode.slx)
- Plot: [figures/student/day03_ode.png](figures/student/day03_ode.png)
- Data: [results/day03.mat](results/day03.mat)
- Notebook: [docs/notebook_d03.md](docs/notebook_d03.md)

The learner reports that the MATLAB assertions comparing the ODE solutions with the analytical solution and with each other passed at a threshold of \(10^{-7}\). In the Simulink comparison, a difference of approximately \(2.4\times10^{-15}\) m was observed on the Scope and interpreted as floating-point roundoff. See the Day 3 notebook for the verification method, observations, and limitations.

## Start MATLAB

1. Set MATLAB's Current Folder to the repository root.
2. Run the project startup script:

       run(fullfile(pwd, 'matlab', 'startup_volume1.m'))

3. Run a daily script, for example:

       day01_kinematics
       day02_forces
       day03_ode

The startup script adds the matlab and simulink folders to the MATLAB path, creates the student figure and result folders if needed, and prints the MATLAB release and installed products. Record the exact release and relevant toolbox versions in each notebook.

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

The repository also contains simulink/v1_equivalent.slx and simulink/v1_weekly.slx for later lessons. The optional builder at simulink/build_volume1_models.m creates these models only if they do not already exist; it does not overwrite existing or open models.

## Software requirements

- **MATLAB:** required for the daily numerical scripts.
- **Simulink:** required for the block-diagram exercises.
- **Control System Toolbox:** required for the transfer-function and state-space workflows in later lessons.
- **Python 3 with NumPy and SciPy:** optional; used for independent reference checks in experiments.

## Modeling conventions

- The vertical coordinate \(z\) is positive upward.
- \(v=\dot z\) and \(a=\dot v\).
- The physical state order used later is \(x=[z\;v]^T\).
- Total thrust \(T\) is measured in newtons and acts upward.
- Hover thrust is \(T_0=mg\).
- The signed thrust increment is \(u=T-mg\), so the ideal vertical plant is \(m\ddot z=u\).
- The deviation-model input is a force in newtons, not normalized throttle or rotor speed.

Keep total thrust and thrust increment distinct.

## Verification and limitations

The repository includes analytical reference checks and independent Python numerical validation. Those checks do not establish that every MATLAB script or Simulink model has been executed successfully on every MATLAB release.

This is an **ideal vertical-plant learning project**, not a validated aircraft model. It does not yet establish real vehicle mass or thrust data, actuator dynamics, aerodynamic drag, attitude coupling, sensor behavior, closed-loop controller performance, or flight readiness. ROS 2, Gazebo, PX4/ArduPilot SITL, LQR, and MPC are later-stage topics, not completed components of this Volume 1 repository.

## Source-material and redistribution note

The repository currently contains handbook-derived text and reference teaching material. Keep these files public only if their licence or the rights holder permit redistribution. Your own notebooks, code, plots, and simulation results should be clearly distinguished from supplied teaching material.
