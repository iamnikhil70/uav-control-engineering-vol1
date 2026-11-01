% PREDICT: use the same m, but thrust below/equal/above mg.
p = volume1_parameters();
t = (0:p.dt:4)';
T0 = p.m*p.g;
T_values = T0 + [-0.4 0 0.4];
labels = {'T = mg - 0.4 N','T = mg','T = mg + 0.4 N'};
z = zeros(numel(t),3); v = z; a = z;
for k = 1:numel(T_values)
    a(:,k) = (T_values(k)-T0)/p.m;
    v(:,k) = p.v0 + a(:,k).*t;
    z(:,k) = p.z0 + p.v0*t + 0.5*a(:,k).*t.^2;
end
fprintf('Hover total thrust = %.3f N\n',T0);
fprintf('Equal load per rotor = %.3f N\n',T0/4);
figure('Name','Day 2 vertical forces');
series = {a,v,z}; units = {'a (m/s^2)','v (m/s)','z (m)'};
for j = 1:3
    subplot(3,1,j); plot(t,series{j},'LineWidth',1.4);
    grid on; title('Same mass with three total thrust values');
    xlabel('Time (s)'); ylabel(units{j});
    legend(labels,'Location','best');
end
print(gcf,fullfile(figure_dir,'day02_forces.png'),'-dpng','-r180');
save(fullfile(result_dir,'day02.mat'),'t','T_values','T0','a','v','z','p');

