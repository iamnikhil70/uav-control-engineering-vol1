% Requires Control System Toolbox. Predict shapes BEFORE running.
p = volume1_parameters();
t = (0:p.dt:p.stop_time)';
G = tf(1,[p.m 0 0]);      % numerator 1; denominator m*s^2
G.InputName = 'delta_T'; G.InputUnit = 'N';
G.OutputName = 'z'; G.OutputUnit = 'm';
disp(G); disp(pole(G)); disp(zero(G));
z_unit = step(G,t);        % zero-state response to a 1 N step at t=0
J = 1;                    % N*s, numerical impulse area
z_impulse = J*impulse(G,t);
u = p.U*double(t>=p.step_time);
z_delayed = lsim(G,u,t,'zoh'); % hold samples, do not ramp at the jump
tau = max(t-p.step_time,0);
z_exact = p.U*tau.^2/(2*p.m);
assert(max(abs(z_delayed-z_exact))<1e-7,'Delayed step mismatch.');
figure('Name','Day 4 response meaning');
subplot(3,1,1); plot(t,z_unit,'LineWidth',1.5); grid on;
title('1 N thrust increment step at zero');
xlabel('Time (s)'); ylabel('z (m)');
subplot(3,1,2); plot(t,z_impulse,'LineWidth',1.5); grid on;
title('Ideal thrust impulse with area 1 N s');
xlabel('Time (s)'); ylabel('z (m)');
subplot(3,1,3); plot(t,z_delayed,'b-',t,z_exact,'r--'); grid on;
title('0.4 N increment begins at 1 s');
xlabel('Time (s)'); ylabel('z (m)');
legend('Transfer function','Exact','Location','best');
print(gcf,fullfile(figure_dir,'day04_tf.png'),'-dpng','-r180');
save(fullfile(result_dir,'day04.mat'),'G','t','u','z_unit', ...
    'z_impulse','z_delayed','z_exact','p');

