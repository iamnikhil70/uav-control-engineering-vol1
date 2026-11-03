# Day 1 progress — Mathematical language and the first moving model

**Handbook:** UAV Control Engineering, Volume 1, Day 1, printed pages 7–14.  
**Learning status:** Completed by learner.  
**Code source:** Companion bundle's matlab/day01_kinematics.m and config/volume1_parameters.m.

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
| t | Time | s |
| z(t) | Altitude relative to a fixed datum | m |
| v(t) = ż(t) | Upward vertical velocity | m/s |
| a(t) = z̈(t) | Upward vertical acceleration | m/s² |
| z0 = z(0) | Initial altitude | m |
| v0 = v(0) | Initial vertical velocity | m/s |

For the Day 1 exercise, acceleration is prescribed as a constant:

a(t) = a0

Integrating once and applying v(0) = v0:

v(t) = v0 + a0t

Integrating again and applying z(0) = z0:

z(t) = z0 + v0t + ½a0t²

The model is second order in altitude and therefore requires two scalar initial conditions. The integrator outputs retain accumulated input history.

## 3. Baseline case and expected checkpoints

| Parameter | Value |
|---|---:|
| z0 | 0 m |
| v0 | 0 m/s |
| a0 | 0.2 m/s² |
| Time vector | 0:0.01:4 s |

With these values:

a(t) = 0.2, v(t) = 0.2t, z(t) = 0.1t²

| Time | Acceleration | Velocity | Altitude |
|---:|---:|---:|---:|
| 0 s | 0.2 m/s² | 0 m/s | 0 m |
| 2 s | 0.2 m/s² | 0.4 m/s | 0.4 m |
| 4 s | 0.2 m/s² | 0.8 m/s | 1.6 m |

These are analytical reference checkpoints. The learner's actual observations are recorded in docs/notebook_d01.md.

## 4. MATLAB implementation

Run the project setup from the repository root:

    startup_volume1
    day01_kinematics

Relevant files:

- startup_volume1.m — adds project paths and creates student-output folders.
- config/volume1_parameters.m — baseline parameter structure.
- matlab/day01_kinematics.m — computes acceleration, velocity, and altitude, checks the terminal altitude, exports a three-panel plot, and saves a MAT file.

MATLAB implementation details worth retaining:

- t is a column vector.
- t.^2 squares each time-vector element; t^2 would request matrix power.
- ones(size(t)) creates a constant acceleration vector with matching dimensions.
- The assertion checks the hand-derived terminal altitude.
- The plot labels include units; acceleration, velocity, and altitude are shown separately because they have different units.

## 5. Simulink implementation

The committed learner model is simulink/day01_kinematics.slx.

The model uses this signal chain:

    Constant: 0.2 m/s^2
            |
            v
    Integrator: IC = v0 = 0  -> Velocity
            |
            v
    Integrator: IC = z0 = 0  -> Altitude

The acceleration, velocity, and altitude signals are observed separately.

Solver settings recorded in the notebook:

- Start time: 0 s
- Stop time: 4 s
- Variable-step solver
- Solver: ode45
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

The learner reports completing the Day 1 lesson, MATLAB activity, Simulink activity, and associated checks. The Day 1 notebook records terminal values of 1.6000 m and 0.8000 m/s, a passed MATLAB assertion, and Simulink scope verification.

Committed learner evidence:

- simulink/day01_kinematics.slx
- figures/student/day01_kinematics.png
- results/day01.mat
- docs/notebook_d01.md

The exact MATLAB release and installed toolbox versions are not yet recorded in the notebook.

Do not label the real UAV as validated from this exercise. Day 1 prescribes acceleration directly and does not yet model thrust, gravity, motors, sensors, or feedback control.
