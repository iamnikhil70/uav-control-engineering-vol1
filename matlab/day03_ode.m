% PREDICT: total T0+U and deviation U must produce identical motion.
p = volume1_parameters();
t = (0:p.dt:4)';
x0 = [p.z0;p.v0];
T0 = p.m*p.g;
f_delta = @(time,x) [x(2);p.U/p.m];
f_total = @(time,x) [x(2);((T0+p.U)-p.m*p.g)/p.m];
opts = odeset('RelTol',p.rel_tol,'AbsTol',p.abs_tol);
[~,xd] = ode45(f_delta,t,x0,opts);
[~,xt] = ode45(f_total,t,x0,opts);
z_exact = p.z0 + p.v0*t + p.U*t.^2/(2*p.m);
v_exact = p.v0 + p.U*t/p.m;
err_z = max(abs(xd(:,1)-z_exact));
err_v = max(abs(xd(:,2)-v_exact));
err_forms = max(abs(xd(:)-xt(:)));
fprintf('Position error %.3g m; velocity error %.3g m/s\n',err_z,err_v);
assert(err_z<1e-7 && err_v<1e-7,'ODE versus exact mismatch.');
assert(err_forms<1e-7,'Total/deviation model mismatch.');
figure('Name','Day 3 ODE verification');
subplot(2,1,1); plot(t,z_exact,'k-',t,xd(:,1),'b--', ...
    t(1:30:end),xt(1:30:end,1),'ro'); grid on;
title('Total and deviation equations agree');
xlabel('Time (s)'); ylabel('z (m)');
legend('Exact','Deviation ODE','Total thrust ODE','Location','best');
subplot(2,1,2); plot(t,v_exact,'k-',t,xd(:,2),'b--'); grid on;
title('Velocity verification'); xlabel('Time (s)'); ylabel('v (m/s)');
legend('Exact','ODE','Location','best');
print(gcf,fullfile(figure_dir,'day03_ode.png'),'-dpng','-r180');
save(fullfile(result_dir,'day03.mat'),'t','xd','xt','z_exact', ...
    'v_exact','err_z','err_v','err_forms','p');

