"""Independent numerical reference checks, NOT a MATLAB/Simulink execution test.
Optional dependencies: numpy and scipy. Run from any working directory.
Writes docs/reference_validation.md and experiments/reference_checks.csv.
"""
from pathlib import Path
import csv
import platform
import numpy as np
import scipy
from scipy.integrate import solve_ivp
from scipy.signal import lsim, StateSpace, TransferFunction

ROOT=Path(__file__).resolve().parents[1]
t=np.linspace(0,6,601)
rows=[]
U=.4

def reference(t,m):
    r1=np.maximum(t-1,0); r3=np.maximum(t-3,0); r5=np.maximum(t-5,0)
    u=U*((t>=1).astype(float)-2*(t>=3).astype(float)+(t>=5).astype(float))
    z=U/(2*m)*(r1**2-2*r3**2+r5**2)
    v=U/m*(r1-2*r3+r5)
    return z,v,u

for m in [1.,2.,4.]:
    zr,vr,u=reference(t,m)
    A=np.array([[0.,1.],[0.,0.]])
    B=np.array([[0.],[1/m]])
    C=np.array([[1.,0.]])
    D=np.zeros((1,1))
    _,zss,xss=lsim(StateSpace(A,B,C,D),u,t,interp=False)
    _,ztf,_=lsim(TransferFunction([1.],[m,0.,0.]),u,t,interp=False)
    xo=np.zeros((len(t),2)); xstart=np.zeros(2)
    for (left,right),level in zip(zip([0,1,3,5],[1,3,5,6]),[0,U,-U,0]):
        ix=np.flatnonzero((t>=left)&(t<=right))
        sol=solve_ivp(lambda time,x:[x[1],level/m],(left,right),xstart,
                      t_eval=t[ix],rtol=1e-8,atol=1e-10)
        assert sol.success
        xo[ix]=sol.y.T
        xstart=sol.y[:,-1]
    errors=[np.max(np.abs(ztf-zr)),np.max(np.abs(zss-zr)),
            np.max(np.abs(xo[:,0]-zr)),np.max(np.abs(xss[:,1]-vr)),
            np.max(np.abs(xo[:,1]-vr))]
    assert max(errors)<1e-10
    assert abs(zr[-1]-4*U/m)<1e-12 and abs(vr[-1])<1e-12
    assert np.allclose(A@A,0)
    assert np.allclose(np.linalg.eigvals(A),[0,0])
    for s in [1.,2.,3.]:
        value=(C@np.linalg.solve(s*np.eye(2)-A,B)+D).item()
        assert abs(value-1/(m*s*s))<1e-12
    rows.append([m,m*9.81,zr[-1],*errors])

# Separate free initial motion and force convention checks.
A=np.array([[0.,1.],[0.,0.]]);B=np.array([[0.],[.5]])
sys=StateSpace(A,B,[[1.,0.]],[[0.]])
_,y,x=lsim(sys,np.zeros_like(t),t,X0=[1,.3],interp=False)
assert max(abs(y-(1+.3*t)))<1e-12
assert max(abs(x[:,1]-.3))<1e-12
for m in [1,2,4]:
    assert abs(((m*9.81+U)-m*9.81)/m-U/m)<1e-12
assert np.allclose((19.62-np.array([1,2,4])*9.81)/[1,2,4],[9.81,0,-4.905])

# Cross-check selected worked exercises, including the open-loop design.
assert abs(1-.3*1.5+.1*1.5**2-.775)<1e-12
assert abs(2+.5*2-.1*4-2.6)<1e-12
assert abs(1.8*.9/1.5**2-.72)<1e-12
b=(2-2.2)*9.81/2.2
assert abs((4*U/2.2+.5*b*36)-(-15.3254545454545))<1e-10

# Detect two deliberately wrong plants; this verifies discrimination.
u=.4*(t>=1)
zr=.1*np.maximum(t-1,0)**2
_,wrong_gain,_=lsim(TransferFunction([1.],[4.,0.,0.]),u,t,interp=False)
assert max(abs(wrong_gain-zr))>1
_,wrong_order,_=lsim(TransferFunction([1.],[2.,0.]),u,t,interp=False)
assert max(abs(wrong_order-zr))>1

headers=['mass_kg','hover_N','z_final_m','TF_position_error_m',
 'SS_position_error_m','ODE_position_error_m','SS_velocity_error_mps',
 'ODE_velocity_error_mps']
with (ROOT/'experiments/reference_checks.csv').open('w',newline='') as f:
    writer=csv.writer(f);writer.writerow(headers);writer.writerows(rows)

report=['# Reference calculation validation',
 '', 'Scope: mathematical and independent Python numerical checks only.',
 'No MATLAB or Simulink execution was performed. The native source and model',
 'builder remain subject to the learner-side acceptance gates in the handbook.',
 '', f'Environment: Python {platform.python_version()}, NumPy {np.__version__}, SciPy {scipy.__version__}.',
 '', '## Executed checks',
 '', '- Analytical interval solution versus SciPy zero-order-hold TF and SS simulations.',
 '- Analytical interval solution versus restarted RK45 ODE integration.',
 '- Position and velocity checked for masses 1, 2, and 4 kg.',
 '- Zero-input nonzero initial motion checked against z = 1 + 0.3t.',
 '- Matrix-square, eigenvalues, and transfer-function recovery checked.',
 '- Total/deviation force identity and fixed-total-thrust calculations checked.',
 '- Selected exercise and mini-design calculations checked independently.',
 '- Deliberately wrong mass gain and plant order both fail the reference comparison.',
 '', '## Observed maximum errors',
 '', '| Mass kg | TF position m | SS position m | ODE position m | SS velocity m/s | ODE velocity m/s |',
 '|---:|---:|---:|---:|---:|---:|']
for r in rows:
    report.append('| '+f'{r[0]:g}'+' | '+' | '.join(f'{e:.3e}' for e in r[3:])+' |')
report+=['','All listed checks passed the independent numerical threshold of 1e-10',
 'in the respective SI quantity. This threshold describes these Python reference',
 'checks; the handbook defines separate native implementation gates.',
 '', 'The figures in figures/reference are mathematical teaching illustrations',
 'generated independently from the stated equations, not screenshots or outputs',
 'from an executed MATLAB/Simulink session. MATLAB reproduction source is supplied.',
 '', 'Not established: native MATLAB/Simulink runtime compatibility, actual aircraft',
 'mass or propulsion data, physical model validation, controller stability, or flight readiness.', '']
(ROOT/'docs/reference_validation.md').write_text('\n'.join(report))
print('\n'.join(report))
