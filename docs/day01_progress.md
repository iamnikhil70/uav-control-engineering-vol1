# Day 1 progress — Mathematical language and the first moving model

**Handbook:** UAV Control Engineering, Volume 1, Day 1, printed pages 7–14.  
**Learning status:** Completed by learner, reported 1 November 2026.  
**Code source:** Companion bundle's `matlab/day01_kinematics.m` and `config/volume1_parameters.m`.

## 1. Learning objectives

Day 1 establishes the mathematical language needed to describe vertical UAV motion:

1. Explain functions, derivatives, integrals, and initial conditions using a moving vehicle.
2. Distinguish altitude, velocity, and acceleration by physical meaning and SI units.
3. Implement constant-acceleration kinematics in MATLAB.
4. Construct a Simulink model with two Integrator blocks.
5. Identify the plant as the physical process that a future controller will act on.

## 2. Physical and mathematical model

The vertical coordinate is positive upward.

| Symbol | Meaning | Unit |
|---|---|---|
| (t) | Time | s |
| (z(t)) | Altitude relative to a fixed datum | m |
| (v(t)=\dot z(t)) | Upward vertical velocity | m/s |
| (a(t)=\ddot z(t)) | Upward vertical acceleration | m/s² |
| (z_0=z(0)) | Initial altitude | m |
| (v_0=v(0)) | Initial vertical velocity | m/s |

For the Day 1 exercise, acceleration is prescribed as a constant:

```math
a(t)=a_0
```

Integrating once and applying (v(0)=v_0):

```math
v(t)=v_0+a_0t
```

Integrating again and applying (z(0)=z_0):

```math
z(t)=z_0+v_0t+\frac{1}{2}a_0t^2
```

The model is second order in altitude and therefore requires two scalar initial conditions. The integrator outputs retain accumulated input history.

## 3. Baseline case and expected checkpoints

| Parameter | Value |
|---|---:|
| (z_0) | 0 m |
| (v_0) | 0 m/s |
| (a_0) | 0.2 m/s² |
| Time vector | (0:0.01:4) s |

With these values:

```math
a(t)=0.2,\quad v(t)=0.2t,\quad z(t)=0.1t^2
```

| Time | Acceleration | Velocity | Altitude |
|---:|---:|---:|---:|
| 0 s | 0.2 m/s² | 0 m/s | 0 m |
| 2 s | 0.2 m/s² | 0.4 m/s | 0.4 m |
| 4 s | 0.2 m/s² | 0.8 m/s | 1.6 m |

These are analytical reference checkpoints. The learner's own measured MATLAB/Simulink values belong in the engineering notebook and result files.

## 4. MATLAB implementation

Run the project setup from the repository root:

```matlab
startup_volume1
day01_kinematics
```

Relevant files:

- `startup_volume1.m` — adds project paths and creates student-output folders.
- `config/volume1_parameters.m` — baseline parameter structure.
- `matlab/day01_kinematics.m` — computes (a(t)), (v(t)), and (z(t)), checks the terminal altitude, exports a three-panel plot, and saves a MAT-file.

MATLAB implementation details worth retaining:

- `t` is a column vector.
- `t.^2` squares each time-vector element; `t^2` would request matrix power.
- `ones(size(t))` creates a constant acceleration vector with matching dimensions.
- The assertion checks the hand-derived terminal altitude.
- The plot labels include units; acceleration, velocity, and altitude are shown separately because they have different units.

## 5. Simulink implementation

Build and save `simulink/day01_kinematics.slx`.

```text
Constant: 0.2 m/s^2
        |--------------------------> Acceleration Scope
        |
        v
Integrator: IC = v0 = 0
        |--------------------------> Velocity Scope
        |
        v
Integrator: IC = z0 = 0
        |--------------------------> Altitude Scope
```

Solver settings from the handbook:

- Start time: 0 s
- Stop time: 4 s
- Variable-step solver
- Solver: `ode45`
- Maximum step size: 0.01 s

The first Integrator's output is velocity, not altitude. The second Integrator's output is altitude. The initial condition of an Integrator is its initial output.

## 6. Conceptual checkpoints

- Positive velocity means climbing; negative velocity means descending.
- Positive acceleration means velocity becomes more positive. It can slow a descent while velocity remains negative.
- Zero acceleration means constant velocity, not necessarily zero velocity.
- Altitude alone is not enough to predict future motion; the current velocity and future input/model also matter.
- The altitude curve is curved because it is the integral of a linearly increasing velocity.
- A continuous-time model and the finite set of numerical samples displayed by a computer are different concepts.

## 7. Completion and evidence

The learner reports completing the Day 1 lesson, MATLAB activity, Simulink activity, and associated checks.

Source files are already present in this repository. The following generated learner artifacts should be committed from the local MATLAB project so the work is reproducible and inspectable:

- `simulink/day01_kinematics.slx`
- `figures/student/day01_kinematics.png`
- `results/day01.mat`

Do not label the real UAV as validated from this exercise. Day 1 prescribes acceleration directly and does not yet model thrust, gravity, motors, sensors, or feedback control.
