# Engineering notebook — Day 3: Hover equilibrium, deviation variables, and ODE verification

- **Date:** 2026-11-21
- **Learning status:** Completed by learner; implementation and observations recorded from the Day 3 work.
- **Objective:** Express the vertical UAV dynamics relative to the hover operating point, verify that the total-thrust and thrust-increment formulations are equivalent, and compare numerical ODE integration with the analytical solution.
- **MATLAB source:** [matlab/day03_ode.m](../matlab/day03_ode.m)
- **Parameter source:** [matlab/volume1_parameters.m](../matlab/volume1_parameters.m)
- **Simulink model:** [simulink/day03_ode.slx](../simulink/day03_ode.slx)
- **Plot:** [figures/student/day03_ode.png](../figures/student/day03_ode.png)
- **Saved experiment data:** [results/day03.mat](../results/day03.mat)
- **Git evidence:** Day 3 implementation committed in commit [d3aefae](https://github.com/iamnikhil70/uav-control-engineering-vol1/commit/d3aefaececa4a9475b85b4beb9700e310a1402ed).
- **MATLAB release and installed products:** Not recorded in the available experiment notes. Capture the output of `startup_volume1` in a future session.

## 1. Coordinate convention and hover operating point

The vertical coordinate is positive upward. Total thrust acts upward and weight acts downward:

\[
m\ddot z = T-mg
\]

At steady hover, vertical acceleration is zero. Therefore, the equilibrium or trim thrust is:

\[
T_0=mg
\]

Define the thrust increment relative to hover as:

\[
u=\Delta T=T-T_0=T-mg
\]

Substituting this definition into the force equation gives:

\[
m\ddot z=(T_0+u)-mg
\]

Since \(T_0=mg\), the constant gravity and hover-thrust terms cancel exactly:

\[
m\ddot z=u
\qquad\Longrightarrow\qquad
\ddot z=\frac{u}{m}
\]

This is an exact change of input variable for the ideal one-dimensional vertical model. It does not require a small-angle approximation. Small-angle assumptions become relevant in models that include attitude and horizontal/vertical thrust components.

## 2. Equilibrium datum and state representation

The altitude coordinate is measured relative to the selected hover equilibrium datum, with:

\[
z_{eq}=0
\]

Thus, \(z\) is the altitude deviation from that datum. It is not necessarily an absolute altitude above the ground.

Define the two states:

\[
x_1=z,\qquad x_2=v=\dot z
\]

The second-order equation becomes two coupled first-order equations:

\[
\dot x_1=x_2
\]

\[
\dot x_2=\frac{u}{m}
\]

Equivalently:

\[
\dot z=v,\qquad \dot v=\frac{u}{m}
\]

The input \(u\) is a signed thrust increment in newtons, not normalized throttle or rotor speed.

## 3. Parameters, assumptions, and prediction

The shared parameter function uses the following illustrative values:

| Parameter | Value |
|---|---:|
| Vehicle mass, \(m\) | 2 kg |
| Gravitational acceleration, \(g\) | 9.81 m/s² |
| Hover thrust, \(T_0=mg\) | 19.62 N |
| Thrust increment, \(u\) | +0.40 N |
| Total thrust, \(T=T_0+u\) | 20.02 N |
| Initial altitude deviation, \(z_0\) | 0 m |
| Initial vertical velocity, \(v_0\) | 0 m/s |
| Integration interval | 0–4 s |
| Requested output spacing, \(dt\) | 0.01 s |
| Relative tolerance | \(10^{-8}\) |
| Absolute tolerance | \(10^{-10}\) |
| Maximum step parameter | 0.01 s |

Assumptions: constant mass, constant gravitational acceleration, vertical translation only, ideal instantaneous thrust, and no aerodynamic drag or actuator dynamics. These are assumptions of a teaching plant, not measured properties of a physical UAV.

For constant thrust increment, acceleration is constant:

\[
a=\frac{u}{m}=\frac{0.4}{2}=0.2\text{ m/s}^2
\]

The analytical velocity and position are:

\[
v(t)=v_0+\frac{u}{m}t
\]

\[
z(t)=z_0+v_0t+\frac{u}{2m}t^2
\]

With the baseline initial conditions, the predicted values at \(t=4\) s are:

\[
v(4)=0.8\text{ m/s}
\]

\[
z(4)=1.6\text{ m}
\]

## 4. MATLAB implementation and verification

The script `matlab/day03_ode.m` defines two state-derivative functions:

- **Deviation form:** acceleration is calculated directly as \(u/m\).
- **Total-thrust form:** acceleration is calculated as \(((T_0+u)-mg)/m\).

Both systems are integrated using MATLAB's variable-step `ode45` solver from the same initial state and over the same requested time grid. The script then evaluates the analytical position and velocity and calculates:

- Maximum position error between the deviation-form ODE and analytical position.
- Maximum velocity error between the deviation-form ODE and analytical velocity.
- Maximum state difference between the total-thrust and deviation-form ODE solutions.

The script contains assertion gates requiring all three errors to be below \(10^{-7}\) in their corresponding units. The learner reports that these automated assertions passed. The exact numerical residuals were not included in the available notes; the threshold is therefore recorded rather than an invented exact value.

The script exports the comparison plot to `figures/student/day03_ode.png` and saves the time vector, numerical trajectories, analytical references, error metrics, and parameter structure to `results/day03.mat`.

## 5. Simulink implementation and observations

The learner built a parallel comparison of the absolute total-thrust formulation and the deviation formulation. The outputs were combined for visual overlay and subtracted to form a difference signal. The shared parameter function, `volume1_parameters.m`, exports its parameter fields to the MATLAB base workspace so that the MATLAB and Simulink work can use the same parameter definitions.

**Committed Simulink filename:** `simulink/day03_ode.slx`.

The earlier working description used the name `day03_absolute_vs_delta.slx`; the repository contains `day03_ode.slx), not a file with the earlier name. Use the committed filename when referring to this artifact.

### Floating-point roundoff and Scope autoscaling

With zero initial conditions, the difference Scope initially appeared to show a large parabolic curve. Inspection of the vertical axis showed that the displayed difference peaked at approximately:

\[
2.4\times10^{-15}\text{ m}
\]

This is at the scale of floating-point roundoff, not a physically meaningful altitude difference. When the initial conditions were changed to \(z_0=1\) m and \(v_0=0.3\) m/s, the overall trajectory values became larger and the Scope autoscaled to a wider vertical range. The difference then appeared visually flat.

The learner reports that the difference remained well below the handbook's \(10^{-5}\) m verification threshold. The reported peak of approximately \(2.4\times10^{-15}\) m is retained as an observation from the Scope; it is not presented as an independently re-extracted value from the saved model data.

A flat-looking Scope is not, by itself, proof of equivalence. For a reproducible numerical check, log the difference signal and calculate \(\max_t|z_{total}(t)-z_{deviation}(t)|\) from the logged data.

## 6. Model error versus numerical error

This exercise distinguished two different error sources:

- **Model error:** discrepancy caused by the mathematical model omitting real physical effects, such as aerodynamic drag, actuator lag, thrust limits, or attitude coupling.
- **Numerical error:** discrepancy introduced when a computer approximates a continuous-time solution using finite-precision arithmetic and numerical integration steps.

The tiny Simulink difference observed here is consistent with floating-point roundoff. It does not demonstrate that the ideal plant perfectly represents a real UAV.

## 7. Conclusion and validity boundary

For the ideal one-dimensional vertical model, subtracting the hover equilibrium \(T_0=mg\) converts the total-thrust equation into the deviation equation \(m\ddot z=u\). The cancellation is exact under the stated model assumptions. The second-order dynamics can be represented by the two first-order state equations \(\dot z=v\) and \(\dot v=u/m\).

The learner reports that the MATLAB ODE solutions passed the analytical and formulation-equivalence assertion gates, and that the Simulink comparison showed only a roundoff-scale difference. This supports equivalence of the two mathematical formulations in this ideal model; it does not validate real-aircraft dynamics or flight readiness.

Still unvalidated: real vehicle mass and thrust data, aerodynamic drag, motor/propeller dynamics, thrust saturation, attitude coupling, sensor behavior, disturbances, and closed-loop performance.

## 8. Next justified action

Proceed to Day 4: Laplace transforms and the double-integrator transfer function. Preserve the current plant assumptions and sign convention when deriving the transfer-function representation. Do not interpret this open-loop plant exercise as a completed feedback controller.
