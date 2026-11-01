# Verification of an ideal UAV vertical plant

Author, date, MATLAB release, project commit:

## Objective

State which physical and numerical questions this experiment answers.

## Model and assumptions

Insert your own free-body diagram and define the world-up convention.
Derive the total-thrust equation, hover thrust, and deviation equation.
State assumptions and identify unmodeled effects.

## Mathematical representations

Derive the zero-state transfer function and the physical state-space matrices.
Explain each integrator and matrix entry. Identify input/output units.

## Experiment design

Record force levels and switching times, initial states, masses, and horizon.
Distinguish the fixed-increment experiment from fixed-total-thrust analysis.
Record solver, tolerances, logging format, and input interpolation.

## Predictions before execution

Provide analytical boundary values and anticipated graph shapes.
Derive the reference independently from the simulation implementation.

## Observed results

Insert plots exported from YOUR runs, with titles, units, and legends.
Report maximum position errors against the reference for ODE, TF, SS,
and all three Simulink branches. Report velocity checks separately.
Give actual terminal states and compare with predictions.

## Discrepancy and diagnosis

Describe one induced or real fault, the test that isolated it, and the repair.
Record the solver refinement result without inventing a convergence trend.

## Interpretation and limits

Explain the braking interval, final displacement, and mass dependence.
Distinguish implementation verification from physical validation.
State what conclusions the data cannot support.

## Conclusion and reproduction

Answer the original question using your reported errors and assumptions.
List exact file paths and command order for reproduction.
Identify remaining gates before Volume 2.

