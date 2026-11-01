function [z,v,u] = pulse_reference(t,m,U)
% Three step CHANGES: +U at 1, -2U at 3, +U at 5 seconds.
% Zero initial conditions; integrate each shifted step analytically.
t = t(:); assert(m>0,'Mass must be positive.');
r1 = max(t-1,0); r3 = max(t-3,0); r5 = max(t-5,0);
u = U*(double(t>=1)-2*double(t>=3)+double(t>=5));
v = (U/m)*(r1-2*r3+r5);
z = (U/(2*m))*(r1.^2-2*r3.^2+r5.^2);
end

