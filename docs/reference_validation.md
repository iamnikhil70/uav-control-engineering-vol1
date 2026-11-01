# Reference calculation validation

Scope: mathematical and independent Python numerical checks only.
No MATLAB or Simulink execution was performed. The native source and model
builder remain subject to the learner-side acceptance gates in the handbook.

Environment: Python 3.12.14, NumPy 2.3.5, SciPy 1.17.0.

## Executed checks

- Analytical interval solution versus SciPy zero-order-hold TF and SS simulations.
- Analytical interval solution versus restarted RK45 ODE integration.
- Position and velocity checked for masses 1, 2, and 4 kg.
- Zero-input nonzero initial motion checked against z = 1 + 0.3t.
- Matrix-square, eigenvalues, and transfer-function recovery checked.
- Total/deviation force identity and fixed-total-thrust calculations checked.
- Selected exercise and mini-design calculations checked independently.
- Deliberately wrong mass gain and plant order both fail the reference comparison.

## Observed maximum errors

| Mass kg | TF position m | SS position m | ODE position m | SS velocity m/s | ODE velocity m/s |
|---:|---:|---:|---:|---:|---:|
| 1 | 1.821e-14 | 1.843e-14 | 8.882e-16 | 6.661e-16 | 3.331e-16 |
| 2 | 9.104e-15 | 9.215e-15 | 5.551e-16 | 3.331e-16 | 1.665e-16 |
| 4 | 4.552e-15 | 4.607e-15 | 2.220e-16 | 1.665e-16 | 8.327e-17 |

All listed checks passed the independent numerical threshold of 1e-10
in the respective SI quantity. This threshold describes these Python reference
checks; the handbook defines separate native implementation gates.

The figures in figures/reference are mathematical teaching illustrations
generated independently from the stated equations, not screenshots or outputs
from an executed MATLAB/Simulink session. MATLAB reproduction source is supplied.

Not established: native MATLAB/Simulink runtime compatibility, actual aircraft
mass or propulsion data, physical model validation, controller stability, or flight readiness.
