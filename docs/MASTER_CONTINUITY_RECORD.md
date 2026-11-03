# MASTER CONTINUITY RECORD FOR FUTURE VOLUMES

This section is designed to be copied into a future request together with your latest notebook and report. It records the course contract and established conventions. **Learner completion is not assumed.** Replace the status fields with your actual evidence before beginning Volume 2.

## Project contract and forty day curriculum

Project title: **UAV Control Engineering — From First-Principles Modeling to MATLAB, Simulink, ROS 2, SITL, LQR and MPC**. Intended learner: undergraduate Electrical Engineering student developing control and robotics competence through derivation, simulation, verification, and documentation. Budget: 3–5 focused hours per day. Forty days is an intensive first implementation plan; unfamiliar integration work may require extra calendar time. Completion gates take priority over the dates.

| Volume | Days | Daily progression and principal phases |
|:--|:--|:--|
| 1 | 1–7 | 1 math/tools; 2 frames/forces; 3 deviations/ODEs; 4 Laplace/TF; 5 equivalent Simulink plants; 6 physical state space; 7 verified experiment. Phases 0–3 |
| 2 | 8–14 | 8 feedback and error; 9 P on the vertical plant; 10 PD and damping; 11 PI and stability limits; 12 PID with gravity support; 13 response metrics and tuning; 14 verified controller comparison. Phase 4 |
| 3 | 15–21 | 15 disturbances; 16 noise and filtering; 17 thrust lag; 18 saturation and antiwindup; 19 mass/model uncertainty; 20 6-DOF and attitude foundations; 21 coupled-model tests. Phases 5–6 |
| 4 | 22–28 | 22 state-space extension; 23 controllability; 24 observability; 25 pole placement; 26 LQR and units/scaling; 27 estimation/reference handling; 28 PID/LQR benchmark. Phase 7 |
| 5 | 29–34 | 29 ROS 2 workspace/nodes; 30 topics/messages/QoS; 31 interfaces/timing; 32 software plant/controller split; 33 one chosen autopilot with compatible simulator; 34 reproducible SITL integration test. Phases 8–9 |
| 6 | 35–40 | 35 discrete prediction model; 36 MPC objective and constraints; 37 solver implementation; 38 PID/LQR/MPC scenarios; 39 integrated failure and timing checks; 40 report and hardware-validation preparation. Phases 10–11 |

The phase inventory is 0 mathematical and tool prerequisites; 1 UAV physics/modeling; 2 MATLAB analysis; 3 Simulink plant; 4 classical feedback/PID; 5 nonidealities; 6 6-DOF/attitude; 7 state-space control/LQR; 8 ROS 2; 9 Gazebo plus PX4 or ArduPilot SITL; 10 MPC; 11 comparative evaluation/integration/future hardware preparation. The autopilot, ROS distribution, simulator release, and middleware bridge are **not selected by Volume 1**. Verify compatible current versions when Volume 5 is requested rather than freezing an untested stack now.

## Terminology notation and parameters to preserve

World axes are east, north, up; body axes are forward, left, up. Main motion is level-attitude vertical translation. Up is positive. z is altitude relative to a fixed datum chosen at nominal hover unless explicitly stated otherwise; v = ż and a = v̇. m is mass in kg; g is positive in m/s²; T is total upward thrust magnitude in N; T0 = mg; u = ΔT = T − T0 is a signed thrust increment in N. Do not reuse u for normalized throttle without an explicit interface conversion.

Baseline values are m = 2 kg, g = 9.81 m/s², z0 = 0 m, v0 = 0 m/s, U = 0.4 N, and T0 = 19.62 N. No measured thrust limit, motor constant, drag coefficient, sensor noise level, or hardware-validated mass has been established. Four equal hover rotor loads would be 4.905 N each under the stated assumptions. The mass is an illustrative baseline, not a measurement of the student's hardware.

Physical state order is x = [z; v]. For altitude output, A = [0 1; 0 0], B = [0; 1/m], C = [1 0], D = 0. State units are metres and metres per second. TF conversions must not silently overwrite those state meanings. Zero-state comparisons use zero initial altitude deviation and velocity.

## Concepts skills and equations already taught in this volume

Taught mathematics: functions, derivatives, integral accumulation, first- and second-order ODEs, initial conditions, scalar versus spatial and state vectors, basic matrix multiplication, identity/inverse/determinant, introductory eigenvalues, the Laplace transform and derivative rules, zero-state transfer functions, poles and finite zeros, superposition, time invariance, and continuous-time versus numerical computation.

Taught physics: rotor thrust interpretation, force balance, coordinate conventions, hover and constant-velocity distinctions, operating points, deviation variables, exact cancellation in the affine model, local Taylor approximation, and the limits of the ideal model. Verification and validation are explicitly different.

Derived equations: m z̈ = T − mg; T0 = mg; m z̈ = u; v = v0 + Ut/m and z = z0 + v0t + Ut²/(2m) for constant increment; Z = U(s)/(ms²) + z0/s + v0/s²; G = 1/(ms²); ẋ = Ax + Bu; G = C(sI − A)⁻¹B + D; free response [z0 + v0t; v0]; impulse velocity jump J/m; and the delayed-step superposition formulas for the weekly pulse. Repeated zero poles are not labelled “marginally stable” without examining the coupled free response.

MATLAB skills taught: scripts, comments, structure fields, vectors/matrices, indexing, elementwise operators, basic loops and function handles, plotting with units, saving figures/data, ode45/odeset, tf, ss, pole, zero, eig, step, impulse, lsim with explicit input hold and appropriate initial states, model conversion, parameter sweeps, numerical assertions, and CSV tables.

Simulink skills taught: signals and mathematical blocks; Constant, Step, Sum, Gain, Integrator, Scope, Mux and introductory Demux, Transfer Fcn, State-Space, To Workspace; initial conditions; variable-step continuous solvers and tolerances; timestamped logging; model-workspace parameters; SimulationInput run configuration; and equivalent-model comparison. Three-branch numerical gates must be executed by the learner before being called passed.

## Repository experiments and status

The active directories are config, matlab, simulink, docs, experiments, figures, and run-created results. ros2 is reserved conceptually and is not an empty folder in Volume 1. Daily source filenames match the day numbers. Main reusable models are v1_equivalent.slx and v1_weekly.slx; they are created manually or by the provided builder on the learner's installation. docs/notebook.md and docs/week1_report.md are learner-owned evidence files.

Experiments specified and supported by reference calculations: constant acceleration; hover and ±0.4 N total-thrust cases; total/deviation ODE equivalence; unit-force step and unit-area impulse interpretation; delayed-step three-model equivalence; zero-input nonzero-state drift; accelerate/brake input; masses 1, 2, 4 kg with fixed increment; and fixed total thrust 19.62 N. Optional Euler convergence and normalized rotor-tangent plots are supplied. Reference numerical checks and authored figures exist.

On 2026-11-01, the learner reported completing all Day 1 handbook activities, including MATLAB and Simulink work. As of 2026-11-03, the learner's Day 1 Simulink model, student plot, MAT result, and engineering notebook are committed at simulink/day01_kinematics.slx, figures/student/day01_kinematics.png, results/day01.mat, and docs/notebook_d01.md. The notebook records the terminal position and velocity, a passed MATLAB assertion, and Simulink scope verification. The exact MATLAB release and installed toolbox versions are not recorded yet. Day 2 is now the active lesson; Days 3–7 remain unverified.

Update these fields before requesting Volume 2: MATLAB release and installed toolboxes; Git commit; days independently completed; paths to actual plots and report; maximum equivalence errors; assessment score and missed concepts; unresolved software errors; chosen real vehicle mass if measured. Do not infer these fields from the existence of this handbook.

## Deliberate postponements and next volume entry gate

Postponed: feedback gains, PID tuning and stability proofs, realistic motor/ESC mapping, drag and wind models, saturation/antiwindup, sensor noise and estimation design, full attitude/6-DOF derivations, controllability/observability calculations, LQR design, ROS 2 programming, autopilot bridges, SITL, MPC, and flight testing. Brief motivation in this volume does not mean those subjects have been taught or implemented.

Volume 2 begins only after the learner can reconstruct the force, deviation, TF, and SS models; distinguish total thrust from its increment; explain initial conditions and repeated-origin drift; build the three Simulink branches; and present independent verification evidence. Preserve the gravity support convention in any new controller architecture. The planned Volumes 2–6 should add one layer of fidelity or control reasoning at a time and keep the baseline tests as regression checks.
