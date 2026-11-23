# Engineering notebook — Day 4: Laplace domain and the double-integrator transfer function

- **Date:** 2026-11-23
- **Learning status:** Completed by learner; repository contains the MATLAB implementation, saved result, generated plot, and Simulink model.
- **Objective:** Derive the transfer function from thrust increment to altitude, interpret its poles and zeros, and compare step, impulse, and delayed-step responses with analytical predictions.
- **MATLAB source:** [matlab/day04_transfer_function.m](../matlab/day04_transfer_function.m)
- **Parameter source:** [matlab/volume1_parameters.m](../matlab/volume1_parameters.m)
- **Simulink model:** [simulink/day04_transfer_function.slx](../simulink/day04_transfer_function.slx)
- **Plot:** [figures/student/day04_tf.png](../figures/student/day04_tf.png)
- **Saved experiment data:** [results/day04.mat](../results/day04.mat)
- **Git evidence:** [Day 4 transfer-function implementation](https://github.com/iamnikhil70/uav-control-engineering-vol1/commit/6362f2410c3d2e7b1a45833e8e954a8a633daebc), [Day 4 Simulink model](https://github.com/iamnikhil70/uav-control-engineering-vol1/commit/1344be0be438d3552d623e69a788223d1a185c5e).

## 1. Starting point: the deviation-form plant

Day 3 established the ideal vertical-motion equation around hover:

\[
m\ddot z=u
\]

where:
- \(z\) is altitude deviation from the selected hover datum, positive upward;
- \(u=\Delta T=T-mg\) is the signed thrust increment in newtons;
- \(m\) is constant vehicle mass.

For the transfer-function derivation, use zero initial conditions. Taking the Laplace transform gives:

\[
m s^2 Z(s)=U(s)
\]

Therefore:

\[
\boxed{G(s)=\frac{Z(s)}{U(s)}=\frac{1}{m s^2}}
\]

For the illustrative mass \(m=2\) kg:

\[
\boxed{G(s)=\frac{1}{2s^2}}
\]

This is a double integrator: thrust increment produces acceleration, integrating acceleration gives velocity, and integrating velocity gives altitude.

### Physical units

Since the input is force and the output is displacement:

\\[
[G(s)]=\\frac{\\mathrm{m}}{\\mathrm{N}}
=\\frac{\\mathrm{m}}{\\mathrm{kg}\\,\\mathrm{m}/\\mathrm{s}^2}
=\\frac{\\mathrm{s}^2}{\\mathrm{kg}}
\\]

This agrees with the units of \\(1/(ms^2)\\): mass contributes \\(\\mathrm{kg}\\) and the Laplace variable squared contributes \\(\\mathrm{s}^{-2}\\), so the reciprocal has units \\(\\mathrm{s}^2/\\mathrm{kg}\\), equivalent to m/N.

**Meaning of zero initial conditions:** in these perturbation coordinates, \\(z_0=0\\) means zero altitude deviation from the chosen hover equilibrium datum, not ground level. Likewise, \\(v_0=0\\) means zero vertical velocity relative to that equilibrium. The vehicle can be at a nonzero physical altitude while its perturbation coordinate is zero.

**Important boundary:** this transfer function maps thrust increment (N) to altitude deviation (m). It does not map normalized motor command, PWM, throttle, or rotor speed to altitude. Those require an actuator/motor/thrust model.

## 2. Poles and zeros

For:

\[
G(s)=\frac{1}{2s^2}
\]

the denominator has two roots at the origin:

\[
p_1=p_2=0
\]

There are no finite zeros because the numerator is a nonzero constant.

The two poles at the origin represent the two integrations in the plant. There is no restoring-force term (such as spring stiffness) and no damping term in this ideal model.

The plant is **not BIBO stable**: a bounded constant force step produces an unbounded quadratic position response. It is also not asymptotically stable. In the pole-location sense, the repeated pole at the origin is not marginally stable under the usual continuous-time LTI definition, which requires simple poles on the imaginary axis. State the stability concept precisely rather than calling the plant simply unstable. This is expected for an unregulated position plant and does not, by itself, determine the stability of a future closed-loop controller.

## 3. Parameters and assumptions

The script uses the shared Volume 1 parameter function:

| Parameter | Value |
|---|---:|
| Mass, \(m\) | 2 kg |
| Gravity, \(g\) | 9.81 m/s² |
| Hover thrust, \(T_0=mg\) | 19.62 N |
| Thrust increment for delayed step, \(U\) | +0.40 N |
| Total thrust during delayed step, \(T_0+U\) | 20.02 N |
| Step start time, \(t_s\) | 1 s |
| Simulation horizon | 0–6 s |
| Output spacing, \(dt\) | 0.01 s |

The model retains the ideal assumptions from previous days: constant mass, vertical translation only, ideal instantaneous thrust, no aerodynamic drag, no actuator lag, no thrust saturation, and no attitude coupling.

## 4. Unit-step response

A unit step in the transfer-function input means a thrust increment of 1 N applied at \(t=0\). It is not the same as the 0.4 N increment used in the delayed-step test.

For a unit step:

\[
U(s)=\frac{1}{s}
\]

\[
Z(s)=G(s)U(s)=\frac{1}{m s^3}
\]

Taking the inverse Laplace transform:

\[
\boxed{z_{step}(t)=\frac{t^2}{2m},\quad t\geq0}
\]

With \(m=2\) kg:

\[
z_{step}(t)=\frac{t^2}{4}
\]

At \(t=6\) s, the analytical position is 9 m. This quadratic response is physically consistent with a constant positive thrust increment: acceleration is constant, velocity increases linearly, and position increases quadratically.

The MATLAB script computes this response using `step(G,t)`.

## 5. Impulse response

The impulse response corresponds to a unit-area impulse in thrust increment:

\[
u(t)=J\delta(t),\qquad J=1\text{ N·s}
\]

The Laplace transform of the impulse is 1, so:

\[
Z(s)=G(s)=\frac{1}{m s^2}
\]

and:

\[
\boxed{z_{impulse}(t)=\frac{t}{m},\quad t\geq0}
\]

For \(m=2\) kg, this is \(z(t)=0.5t\). At 6 s the ideal response is 3 m.

The physical interpretation is important: an ideal force impulse produces an instantaneous change in velocity, after which the position changes linearly if no further thrust increment is applied. The impulse causes an instantaneous velocity jump \\(\\Delta v=J/m=0.5\\) m/s for this 1 N·s, 2 kg case; position remains continuous at the impulse instant. The impulse is an analytical test signal, not a realistic motor command. A real actuator has finite bandwidth and cannot generate an infinitely short, infinitely large force pulse.

The script calculates this response as `J*impulse(G,t)` with `J=1` N·s.

## 6. Delayed 0.4 N step response

The third experiment applies a constant thrust increment of 0.4 N beginning at \(t_s=1\) s:

\[
u(t)=0.4\,H(t-1)
\]

Before the step, the plant remains at the zero deviation state. After the step, acceleration is:

\[
a=\frac{U}{m}=\frac{0.4}{2}=0.2\text{ m/s}^2
\]

Define elapsed time after the step as:

\[
\tau=\max(t-t_s,0)
\]

With zero initial position and velocity:

\[
\boxed{z_{delayed}(t)=\frac{U}{2m}\tau^2}
\]

For these parameters:

\[
z_{delayed}(t)=0.1\,\max(t-1,0)^2
\]

At 1 s the position is still zero; at 6 s it is 2.5 m. The response begins smoothly at the step time, with zero position and velocity at the instant the thrust increment is applied.

The MATLAB script creates the sampled input using `u = p.U*double(t>=p.step_time)`, simulates it with `lsim` using zero-order hold, and compares the result against the analytical expression. The script includes an assertion requiring the maximum absolute difference to be below \(10^{-7}\) m. The learner reports that this assertion passed.

## 7. MATLAB implementation review

The committed script performs these operations:

1. Loads the shared physical and simulation parameters.
2. Creates the transfer function with `tf(1,[p.m 0 0])`.
3. Labels the input as thrust increment in newtons and the output as altitude in metres.
4. Displays the transfer function, poles, and zeros.
5. Calculates the unit-step response using `step`.
6. Calculates the unit-area impulse response using `impulse`.
7. Simulates the delayed 0.4 N step using `lsim` with zero-order hold.
8. Calculates the analytical delayed-step response and asserts agreement.
9. Exports the three-panel plot and saves the transfer function, input, time vector, responses, analytical reference, and parameter structure.

The use of zero-order hold for the discontinuous delayed-step input is appropriate: it keeps each sampled input value constant between samples instead of linearly ramping through the switching instant. See the [MathWorks lsim documentation](https://www.mathworks.com/help/control/ref/dynamicsystem.lsim.html) for the input interpolation options.

## 8. Findings and engineering assessment

The mathematical interpretation is consistent:

- The transfer function \(1/(ms^2)\) follows directly from the Day 3 deviation-form equation under zero initial conditions.
- The double pole at the origin is expected for an ideal position plant with two integrations. Classical settling-time and percentage-overshoot metrics (such as `stepinfo`) are not meaningful for this open-loop response because it has no finite steady-state value.
- A constant step in thrust increment gives a parabolic altitude response.
- An ideal impulse in thrust increment changes velocity instantaneously and gives a linear altitude response afterward.
- Delaying the 0.4 N step by one second shifts the start of the parabolic response by one second.
- The analytical delayed-step expression is an independent check of the `lsim` result.

The repository contains the generated plot and saved MAT result. The learner reports that the delayed-step assertion passed and that the Simulink timeseries comparison produced a maximum absolute residual of \\(8.6153\\times10^{-14}\\) m.

### Simulink model and observed result

The learner reports that `day04_transfer_function.slx` uses a continuous Step block with step time 1 s and final value 0.4 N, feeding a Transfer Fcn block with numerator `[1]` and denominator `[m 0 0]`. This denominator embeds the mass in the transfer function; a separate \\(1/m\\) gain block is not required.

The reported output remains at zero deviation until the step time and reaches 2.5000 m at 6 s, matching the analytical prediction. The timeseries comparison gives the residual recorded above. These Simulink block details and numerical values are learner-reported observations; they have not been independently re-extracted from the binary `.slx` file in this review.

The learner also identified that, with Single simulation output enabled, simulation results are accessed through a `Simulink.SimulationOutput` object (for example, `out` or `simOut`). Generated `slprj/` build/cache files are temporary artifacts and appropriately excluded from version control by `.gitignore` when they are reproducible from the source model.

## 9. Suggested strengthening checks

The current script's explicit numerical assertion is for the delayed-step response. To make the verification more complete in a future refinement, add analytical residual checks for the unit-step and impulse responses as well:

\[
e_{step}=\max_t\left|z_{step}(t)-\frac{t^2}{2m}\right|
\]

\[
e_{impulse}=\max_t\left|z_{impulse}(t)-\frac{t}{m}\right|
\]

Also add explicit MATLAB residual assertions for the unit-step and impulse responses, and save the maximum residual values in the MAT file. The Simulink residual is now recorded in this notebook, but it would be stronger to have the calculation and threshold assertion reproducible in a committed script. These are improvements to the evidence, not corrections to the underlying transfer-function derivation.

## 10. Conclusion and next step

Day 4 connects the time-domain differential equation to the Laplace-domain transfer function:

\[
m\ddot z=u
\quad\Longleftrightarrow\quad
G(s)=\frac{1}{ms^2}
\]

The step, impulse, and delayed-step response shapes follow from the same double-integrator dynamics. The implementation and the learner-reported delayed-step assertion are consistent with the analytical model.

**Next:** Day 5 should compare equivalent representations of the same plant (integrator chain, transfer function, and state-space) using identical inputs, initial conditions, and parameters. Keep the same input/output units and sign convention across all three representations.
