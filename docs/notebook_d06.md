# Engineering notebook — Day 6: Physical state-space coordinates and nonzero initial motion

- **Date:** 2026-11-26
- **Milestone:** Day 6 laboratory and matrix verification
- **Learning status:** Completed by learner; reported simulation findings are recorded below.
- **MATLAB source:** [matlab/day06_state_space.m](../matlab/day06_state_space.m)
- **Simulink model:** [simulink/day06_initial_state.slx](../simulink/day06_initial_state.slx)
- **Plot:** [figures/day06_states.png](../figures/day06_states.png)
- **Saved results:** [results/day06.mat](../results/day06.mat)

## 1. Why altitude alone is not a complete dynamic state

A state is a set of variables that contains the system's necessary dynamic memory: given the state at the current time and the future input, the future trajectory can be determined.

For this second-order vertical plant, altitude alone is insufficient. Two vehicles can have the same altitude but different vertical velocities. With zero thrust increment, one may continue climbing while the other descends. Newton's law is second order, so two independent initial conditions are required: initial position and initial velocity.

## 2. Canonical physical state vector

The Volume 1 convention is altitude deviation above vertical velocity:

\[
x(t)=\begin{bmatrix}x_1(t)\\x_2(t)\end{bmatrix}
=\begin{bmatrix}z(t)\\v(t)\end{bmatrix}
\]

- \(x_1=z\): altitude deviation relative to the hover datum, in metres.
- \(x_2=v\): vertical velocity, in metres per second.

The ordering matters: all matrices, initial-condition vectors, and Simulink state configurations must use the same order.

## 3. Derivation of the continuous-time state-space model

Starting with the deviation-form Newton equation:

\[
m\ddot z=u
\]

and using \(v=\dot z\):

\[
\dot x_1=\dot z=v,\qquad
\dot x_2=\dot v=\frac{u}{m}
\]

Therefore:

\[
\dot x=Ax+Bu,\qquad y=Cx+Du
\]

where:

\[
A=\begin{bmatrix}0&1\\0&0\end{bmatrix},\quad
B=\begin{bmatrix}0\\1/m\end{bmatrix},\quad
C=\begin{bmatrix}1&0\end{bmatrix},\quad D=0
\]

For \(m=2\,\mathrm{kg}\), \(B=[0\;0.5]^T\). With this output matrix, the measured output is altitude deviation only. To expose both states as outputs, choose \(C=I_2\) and \(D=[0\;0]^T\).

### Physical interpretation and units

- \(A_{12}=1\) encodes \(\dot z=v\). Its dimensional mapping is consistent because both \(\dot z\) and \(v\) have units m/s.
- The zero second row of \(A\) means the ideal model has no velocity damping or position-restoring term.
- \(B_1=0\): force affects acceleration, not position directly.
- \(B_2=1/m\): converts force (N) into acceleration (m/s²), with units kg⁻¹.
- \(D=0\): there is no instantaneous direct feedthrough from applied force to position.

## 4. Recovering the transfer function from state-space

For zero initial conditions, the state-space transfer function is:

\[
G(s)=C(sI-A)^{-1}B+D
\]

Here:

\[
sI-A=\begin{bmatrix}s&-1\\0&s\end{bmatrix}
\]

and, for \(s\ne0\):

\[
(sI-A)^{-1}
=\frac{1}{s^2}\begin{bmatrix}s&1\\0&s\end{bmatrix}
=\begin{bmatrix}1/s&1/s^2\\0&1/s\end{bmatrix}
\]

Thus:

\[
(sI-A)^{-1}B
=\begin{bmatrix}1/(ms^2)\\1/(ms)\end{bmatrix}
\]

and:

\[
\boxed{G(s)=\frac{Z(s)}{U(s)}=\frac{1}{ms^2}}
\]

At \(s=2\,\mathrm{s^{-1}}\), with \(m=2\,\mathrm{kg}\):

\[
G(2)=\frac{1}{2(2)^2}=0.125\;\mathrm{m/N}
\]

The units are consistent: the transfer function maps force in newtons to position in metres.

## 5. Eigenvalues, nilpotency, and the state-transition matrix

The characteristic equation is:

\[
\det(\lambda I-A)=\lambda^2=0
\]

so both eigenvalues are zero. Also:

\[
A^2=0
\]

Therefore \(A\) is nilpotent of index 2. The matrix exponential series terminates:

\[
e^{At}=I+At
=\begin{bmatrix}1&t\\0&1\end{bmatrix}
\]

For zero input, the state evolves as:

\[
x(t)=e^{At}x(0)
\]

Using the learner's initial condition:

\[
x(0)=\begin{bmatrix}1.0\;\mathrm{m}\\0.3\;\mathrm{m/s}\end{bmatrix}
\]

gives:

\[
\boxed{
z(t)=1.0+0.3t\;\mathrm{m},\qquad
v(t)=0.3\;\mathrm{m/s}
}
\]

The altitude drifts linearly because the vehicle begins with upward velocity and the ideal model contains no damping or restoring force to remove it.

## 6. Reported simulation verification

The learner reports that the unforced Simulink test used \(z_0=1.0\,\mathrm{m}\), \(v_0=0.3\,\mathrm{m/s}\), and \(u=0\).

| Check | Analytical expectation | Reported observation |
|---|---:|---:|
| Altitude at 4 s | 2.2000 m | 2.2000 m |
| Vertical velocity | Constant 0.3000 m/s | 0.3000 m/s |
| Position residual | Below \(10^{-7}\) m | Reported below \(10^{-7}\) m |

This confirms the expected free-motion behavior for the ideal model if reproduced with the stated initial conditions and zero input. The binary Simulink model and numerical MAT data were not independently executed or inspected during this documentation update; these measurements are therefore explicitly retained as learner-reported results.

## 7. Why the zero-state transfer function does not describe this free response

The transfer function \(G(s)=1/(ms^2)\) is obtained under zero initial conditions. With nonzero initial altitude and velocity, the Laplace-domain equation contains additional initial-condition terms:

\[
m\left(s^2Z(s)-sz_0-v_0\right)=U(s)
\]

so:

\[
Z(s)=\frac{U(s)}{ms^2}+\frac{z_0}{s}+\frac{v_0}{s^2}
\]

The first term is the zero-state response due to the input. The other two terms are the zero-input response due to initial position and velocity. For \(u=0\), inverse transformation gives \(z(t)=z_0+v_0t\).

A standard Transfer Fcn block configured only with \(1/(ms^2)\) represents the zero-state input-output map. It does not automatically supply arbitrary physical initial altitude and velocity. A state-space model naturally carries these initial states.

## 8. Engineering findings and limitations

- The physical state order for this project is fixed as \(x=[z\;v]^T\).
- Position and velocity are both required to predict future motion.
- The state-space matrices recover the same zero-state transfer function derived on Day 4.
- The double-integrator's zero eigenvalues and nilpotent state matrix explain the unforced constant-velocity drift.
- A nonzero initial velocity persists indefinitely in this ideal model because no drag or damping is included.
- This is an ideal vertical-motion model, not a complete multirotor model. It excludes actuator dynamics, aerodynamic drag, attitude coupling, sensor dynamics, and disturbances.

## 9. Conclusion and next step

Day 6 connects the physical meaning of state variables to the algebra of state-space models. It also makes the distinction between zero-state input response and nonzero-initial-state free motion explicit.

**Next — Day 7:** use a piecewise thrust-increment input and perform an independent verification and mass sweep. Keep the physical state order, sign convention, units, and initial-condition handling consistent across every implementation.
