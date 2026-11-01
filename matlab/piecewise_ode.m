function x = piecewise_ode(t,m,U,rel_tol,abs_tol)
% Restart the continuous ODE at known force discontinuities.
% This avoids asking an adaptive solver to discover short pulses blindly.
t = t(:); edges = [0 1 3 5 6]; levels = [0 U -U 0];
assert(abs(t(1))<1e-12 && abs(t(end)-6)<1e-12);
x = zeros(numel(t),2); x_start = [0;0];
opts = odeset('RelTol',rel_tol,'AbsTol',abs_tol);
for j = 1:numel(levels)
    idx = find(t>=edges(j) & t<=edges(j+1));
    local_t = unique([edges(j);t(idx);edges(j+1)]);
    f = @(time,state) [state(2);levels(j)/m];
    [tt,xx] = ode45(f,local_t,x_start,opts);
    x(idx,:) = interp1(tt,xx,t(idx),'linear');
    x_start = xx(end,:)';
end
end

