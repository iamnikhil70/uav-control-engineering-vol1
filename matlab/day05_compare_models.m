% First build manually, or inspect the optional builder after the exercise.
p = volume1_parameters();
if ~exist(fullfile(project_root,'simulink','v1_equivalent.slx'),'file')
    error('Build v1_equivalent first; see Day 5 or build_volume1_models.');
end
load_system(fullfile(project_root,'simulink','v1_equivalent.slx'));
in = Simulink.SimulationInput('v1_equivalent');
in = in.setVariable('m',p.m,'Workspace','v1_equivalent');
in = in.setVariable('U',p.U,'Workspace','v1_equivalent');
in = in.setVariable('t_step',p.step_time,'Workspace','v1_equivalent');
in = in.setVariable('z0',0,'Workspace','v1_equivalent');
in = in.setVariable('v0',0,'Workspace','v1_equivalent');
out = sim(in);
zi = out.get('z_int'); zt = out.get('z_tf'); zs = out.get('z_ss');
tv = zi.Time; y_int = zi.Data(:);
% Compare on one time grid; original grids may differ.
y_tf = interp1(zt.Time,zt.Data(:),tv,'linear');
y_ss = interp1(zs.Time,zs.Data(:),tv,'linear');
y_ref = p.U*max(tv-p.step_time,0).^2/(2*p.m);
err = [max(abs(y_int-y_ref)),max(abs(y_tf-y_ref)), ...
       max(abs(y_ss-y_ref))];
disp(table(err(1),err(2),err(3),'VariableNames', ...
    {'Integrator_m','TF_m','SS_m'}));
assert(all(isfinite(err)) && all(err<1e-5),'Comparison failed.');
figure('Name','Day 5 model equivalence');
subplot(2,1,1); plot(tv,y_int,'b-',tv,y_tf,'r--',tv,y_ss,'g:');
grid on; title('Three implementations of one plant');
xlabel('Time (s)'); ylabel('z (m)');
legend('Integrators','Transfer Fcn','State-Space','Location','best');
subplot(2,1,2); plot(tv,y_int-y_ref,tv,y_tf-y_ref,tv,y_ss-y_ref);
grid on; title('Residuals against the analytical solution');
xlabel('Time (s)'); ylabel('Altitude error (m)');
legend('Integrators','Transfer Fcn','State-Space','Location','best');
print(gcf,fullfile(figure_dir,'day05_equivalence.png'),'-dpng','-r180');
save(fullfile(result_dir,'day05.mat'),'tv','y_int','y_tf','y_ss','y_ref','err','p');

