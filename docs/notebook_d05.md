# Engineering notebook — Day 5: Quantitative equivalence of three plant representations

- **Date:** 2026-11-25
- **Milestone:** Day 5 laboratory and model verification
- **Learning status:** Completed by learner; source script, Simulink model, saved MAT data, and generated comparison plot are present in the repository.
- **Objective:** Implement the same ideal vertical plant using an integrator chain, a transfer function, and continuous state-space, then compare each output with an independent closed-form reference.
- **MATLAB source:** [matlab/day05_compare_models.m](../matlab/day05_compare_models.m)
- **Simulink model:** [simulink/v1_equivalent.slx](../simulink/v1_equivalent.slx)
- **Additional Day 5 model:** [simulink/day05_compare_models.slx](../simulink/day05_compare_models.slx)
- **Plot:** [figures/student/day05_equivalence.png](../figures/student/day05_equivalence.png)
- **Saved experiment data:** [results/day05.mat](../results/day05.mat)

## 1. Objective and plant definition

Day 5 tests whether three different Simulink representations implement the same input-output dynamics. The plant is still the ideal one-dimensional vertical model expressed relative to hover:

\[
m\ddot z(t)=u(t),\qquad \ddot z(t)=\frac{u(t)}{m}
\]

where:
- \(m=2.0\,\mathrm{kg}\) is the constant illustrative vehicle mass;
- \(u=\Delta T\) is the thrust increment above hover, in newtons;
- \(T_0=mg=19.62\,\mathrm{N}\) is the hover thrust for \(g=9.81\,\mathrm{m/s^2}\);
- \(z\) is altitude deviation from the hover datum, in metres, positive upward.

The input is thrust increment, not total thrust, throttle, PWM, or motor speed.

## 2. The three representations

### Branch 1 — cascaded integrators

The first branch applies a gain of \(1/m\) to the thrust increment to obtain acceleration, then integrates acceleration to velocity and velocity to altitude:

\[
a=\frac{u}{m},\qquad \dot v=a,\qquad \dot z=v
\]

Both integrators start at zero: \(v(0)=0\) and \(z(0)=0\). This representation makes the physical intermediate variables (acceleration, velocity, and altitude) directly observable.

### Branch 2 — transfer function

Taking the Laplace transform under zero initial conditions gives:

\[
G(s)=\frac{Z(s)}{U(s)}=\frac{1}{ms^2}
\]

For \(m=2\,\mathrm{kg}\), this is \(1/(2s^2)\). The Simulink Transfer Fcn block uses numerator \([1]\) and denominator \([m\;0\;0]\). The mass is already included in the denominator, so a separate gain of \(1/m\) must not be added.

This transfer-function representation is a zero-state input-output description. It does not, by itself, encode arbitrary nonzero initial altitude and velocity.

### Branch 3 — continuous state-space

Choose the state vector:

\[
x=\begin{bmatrix}z\\v\end{bmatrix}
\]

Then:

\[
\dot x=Ax+Bu,\qquad y=Cx+Du
\]

with:

\[
A=\begin{bmatrix}0&1\\0&0\end{bmatrix},\quad
B=\begin{bmatrix}0\\1/m\end{bmatrix},\quad
C=\begin{bmatrix}1&0\end{bmatrix},\quad
D=0
\]

and initial state:

\[
x(0)=\begin{bmatrix}z_0\\v_0\end{bmatrix}
=\begin{bmatrix}0\\0\end{bmatrix}
\]

The output is altitude deviation \(y=z\). These are continuous-time state-space matrices; they belong in a continuous State-Space block, not a Discrete State-Space block.

## 3. Common test input and analytical reference

All branches receive the same delayed step:

\[
u(t)=U H(t-t_s),\qquad U=0.4\,\mathrm{N},\quad t_s=1.0\,\mathrm{s}
\]

The simulation horizon is 0–6 s. Define elapsed time after the step:

\[
\tau(t)=\max(t-t_s,0)
\]

For zero initial position and velocity, the closed-form position reference is:

\[
z_{exact}(t)=\frac{U}{2m}\tau(t)^2
=0.1\max(t-1,0)^2\;\mathrm{m}
\]

The solver configuration recorded for the experiment is variable-step ode45 (Dormand–Prince), relative tolerance \(10^{-8}\), absolute tolerance \(10^{-10}\), and maximum step 0.01 s.

### Hand-check values

| Time | Elapsed time \(\tau\) | Position \(z\) | Velocity \(v\) |
|---:|---:|---:|---:|
| 2 s | 1 s | 0.1000 m | 0.2000 m/s |
| 3 s | 2 s | 0.4000 m | 0.4000 m/s |
| 6 s | 5 s | 2.5000 m | 1.0000 m/s |

These checkpoints follow directly from constant acceleration \(a=U/m=0.2\,\mathrm{m/s^2}\) after the input step.

## 4. Quantitative comparison

The script compares each branch with the analytical reference using the maximum absolute position residual on the common comparison time grid:

\[
E_\infty=\max_k\left|z_{model}(t_k)-z_{exact}(t_k)\right|
\]

The learner reports the following results:

| Representation | Reported maximum position error | Gate | Result |
|---|---:|---:|---|
| Cascaded integrators (\(z_{int}\)) | \(3.9968\times10^{-15}\,\mathrm{m}\) | \(<10^{-5}\,\mathrm{m}\) | Pass |
| Transfer function (\(z_{tf}\)) | \(3.9968\times10^{-15}\,\mathrm{m}\) | \(<10^{-5}\,\mathrm{m}\) | Pass |
| Continuous state-space (\(z_{ss}\)) | \(3.9968\times10^{-15}\,\mathrm{m}\) | \(<10^{-5}\,\mathrm{m}\) | Pass |

The script takes the integrator branch time vector as the comparison grid and linearly interpolates the Transfer Fcn and State-Space outputs onto that grid before calculating residuals. Thus the reported metric is a sampled, common-grid comparison, not a formal proof of equality at every continuous instant.

The residual magnitude is consistent with floating-point roundoff for this particular simulation and is far below the engineering acceptance threshold. It should not be described as literal mathematical exactness or as a universal machine-precision guarantee. Numerical residuals depend on solver settings, time grids, interpolation, signal scale, and floating-point operations.

## 5. Diagnostic case study — discrete versus continuous state-space

During an initial run, the third branch reportedly showed a maximum discrepancy of 2.3 m, while the logged output plateaued near 0.2 m. Inspection with:

\[
\texttt{get\_param(srcBlock,'BlockType')}
\]

identified that the branch contained a Discrete State-Space block rather than the intended continuous State-Space block. Replacing it with the continuous Simulink State-Space block reportedly reduced the residual to \(3.9968\times10^{-15}\,\mathrm{m}\).

**Important technical clarification:** the continuous matrices \(A\) and \(B\) cannot simply be interpreted as discrete-time state-transition matrices. A discrete model requires a specified sample time \(T_s\) and appropriately discretized matrices:

\[
A_d=e^{AT_s},\qquad
B_d=\int_0^{T_s}e^{A\tau}B\,d\tau
\]

for a zero-order-held input. For this double-integrator plant:

\[
A_d=\begin{bmatrix}1&T_s\\0&1\end{bmatrix},\qquad
B_d=\begin{bmatrix}T_s^2/(2m)\\T_s/m\end{bmatrix}
\]

The original diagnosis correctly identified a continuous/discrete block-type mismatch. However, the specific explanation that the discrete block necessarily makes the position shift once and then remain stagnant does not follow from the stated matrices alone: with the usual recurrence \(x[k+1]=Ax[k]+Bu[k]\) and constant nonzero input, the velocity state receives the input contribution at every sample. The observed plateau therefore also depends on the block's actual parameterization, sample time, input/output configuration, or signal logging. Record the plateau as the observed symptom, but do not present that simplified recurrence explanation as a general property of discrete state-space systems.

## 6. MATLAB automation and saved evidence

The committed script:
1. Loads the shared Volume 1 parameters.
2. Checks that \texttt{simulink/v1\_equivalent.slx} exists and loads the model.
3. Sets \(m\), \(U\), \(t_{step}\), \(z_0\), and \(v_0\) in the model workspace through a \texttt{Simulink.SimulationInput}.
4. Runs the model and retrieves the logged outputs \texttt{z\_int}, \texttt{z\_tf}, and \texttt{z\_ss}.
5. Interpolates the transfer-function and state-space outputs onto the integrator branch time vector.
6. Calculates the analytical reference and maximum absolute residuals.
7. Asserts that all three residuals are finite and below \(10^{-5}\,\mathrm{m}\).
8. Generates a two-panel plot showing the trajectories and residuals.
9. Saves the time vector, three model outputs, reference trajectory, error array, and parameter structure in \texttt{results/day05.mat}.

The script and binary model files are present in the repository. The numerical results and diagnostic history above are learner-reported observations; this review did not execute MATLAB/Simulink or independently inspect the internal binary model configuration.

## 7. Engineering findings

- The integrator chain, transfer function, and continuous state-space are three representations of the same ideal plant when their parameters, input, initial conditions, and time interpretation are consistent.
- The integrator chain exposes the physical intermediate states and is intuitive for understanding the mechanics.
- The transfer function is compact and useful for classical input-output analysis, but its standard zero-state form does not directly carry arbitrary initial conditions.
- State-space makes the internal states explicit and provides a natural way to include nonzero initial altitude and velocity.
- Continuous and discrete state-space models are not interchangeable by copying the same \(A,B,C,D\) matrices. Discretization requires a sample time and a defined input-hold assumption.
- The analytical reference provides an independent check beyond visual overlap of plotted trajectories.

## 8. Conclusion and next step

Day 5 demonstrates that different block-diagram structures can represent the same continuous-time physical plant and that quantitative residual checks are more informative than visual agreement alone.

**Next — Day 6:** focus on state-space interpretation and initial conditions. In particular, verify that nonzero \(z_0\) and \(v_0\) produce the expected free-motion terms, and understand why a transfer function alone describes the zero-state input-output response unless initial-condition contributions are added separately.
