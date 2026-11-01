% Run startup_volume1 first. Requires MATLAB, Control System Toolbox, Simulink.
% Fill in your predictions in the notebook BEFORE reading the output.
p = volume1_parameters();
t = (0:p.dt:6)'; masses = [1 2 4];
model_path = fullfile(project_root,'simulink','v1_weekly.slx');
assert(exist(model_path,'file')==2,'Build v1_weekly first.');
load_system(model_path);
metrics = zeros(numel(masses),8); Z = zeros(numel(t),numel(masses));
for k = 1:numel(masses)
    m = masses(k);
    [zr,vr,u] = pulse_reference(t,m,p.U);
    A = [0 1;0 0]; B = [0;1/m]; C = [1 0]; D = 0;
    G = tf(1,[m 0 0]); sys = ss(A,B,C,D);
    ztf = lsim(G,u,t,'zoh');
    [zss,~,xss] = lsim(sys,u,t,[0;0],'zoh');
    xode = piecewise_ode(t,m,p.U,p.rel_tol,p.abs_tol);
    in = Simulink.SimulationInput('v1_weekly');
    in = in.setVariable('m',m,'Workspace','v1_weekly');
    in = in.setVariable('U',p.U,'Workspace','v1_weekly');
    in = in.setVariable('z0',0,'Workspace','v1_weekly');
    in = in.setVariable('v0',0,'Workspace','v1_weekly');
    out = sim(in);
    logs = {out.get('z_int'),out.get('z_tf'),out.get('z_ss')};
    es = zeros(1,3);
    for j = 1:3
        % Evaluate exact position at EACH logged time, avoiding resampling bias.
        zlog = logs{j};
        exact_at_log = pulse_reference(zlog.Time,m,p.U);
        es(j) = max(abs(zlog.Data(:)-exact_at_log));
    end
    e_mat = [max(abs(ztf-zr)),max(abs(zss-zr)), ...
             max(abs(xode(:,1)-zr))];
    assert(max(abs(xss(:,2)-vr))<1e-6,'Velocity mismatch.');
    metrics(k,:) = [m,m*p.g,zr(end),e_mat,es(1),max(es(2:3))];
    assert(all(isfinite([e_mat es])) && all([e_mat es]<1e-5), ...
        'Verification failed; inspect errors before changing tolerance.');
    Z(:,k) = zr;
    run_data = table(t,u,zr,vr,ztf,zss,xode(:,1),xode(:,2), ...
        'VariableNames',{'t_s','deltaT_N','z_exact_m','v_exact_mps', ...
        'z_tf_m','z_ss_m','z_ode_m','v_ode_mps'});
    writetable(run_data,fullfile(result_dir,sprintf('day07_m%g.csv',m)));
    save(fullfile(result_dir,sprintf('day07_m%g.mat',m)), ...
        'out','run_data','es','e_mat','p','m');
end
summary = array2table(metrics,'VariableNames',{'mass_kg','hover_N', ...
    'z_final_m','err_mat_tf_m','err_mat_ss_m','err_ode_m', ...
    'err_sim_int_m','err_sim_tf_ss_max_m'});
disp(summary); writetable(summary,fullfile(result_dir,'day07_summary.csv'));
figure('Name','Day 7 same thrust increment');
plot(t,Z,'LineWidth',1.5); grid on;
title('Identical thrust increment history for different masses');
xlabel('Time (s)'); ylabel('z (m)');
legend('1 kg','2 kg','4 kg','Location','best');
print(gcf,fullfile(figure_dir,'day07_mass_sweep.png'),'-dpng','-r180');
% A different experiment: keep TOTAL thrust fixed at nominal 2 kg hover.
T_fixed = p.m*p.g;
a_fixed = (T_fixed-masses*p.g)./masses;
fixed_total = table(masses',a_fixed','VariableNames',{'mass_kg','a_mps2'});
disp(fixed_total);
writetable(fixed_total,fullfile(result_dir,'day07_fixed_total.csv'));

