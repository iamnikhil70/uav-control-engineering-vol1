% Four physical signals from the analytical weekly experiment.
p = volume1_parameters(); t = (0:p.dt:6)';
[z,v,u] = pulse_reference(t,p.m,p.U);
signals = {u,u/p.m,v,z};
labels = {'delta T (N)','a (m/s^2)','v (m/s)','z (m)'};
figure;
for k = 1:4
    subplot(4,1,k); plot(t,signals{k},'LineWidth',1.5);
    grid on; title('Accelerate then brake the ideal vertical plant');
    xlabel('Time (s)'); ylabel(labels{k});
end
print(gcf,fullfile(figure_dir,'weekly_profile.png'),'-dpng','-r180');
