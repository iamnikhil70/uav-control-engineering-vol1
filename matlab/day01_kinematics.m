% PREDICT: a is constant. What shapes will v(t) and z(t) have?
p = volume1_parameters();
t = (0:p.dt:4)';           % column of output times, seconds
a0 = 0.2;                 % prescribed acceleration, m/s^2
v = p.v0 + a0*t;
z = p.z0 + p.v0*t + 0.5*a0*t.^2;
a = a0*ones(size(t));
assert(abs(z(end)-1.6)<1e-12,'Check position formula.');
figure('Name','Day 1 kinematics');
subplot(3,1,1); plot(t,a,'LineWidth',1.5); grid on;
title('Prescribed constant acceleration');
xlabel('Time (s)'); ylabel('a (m/s^2)');
subplot(3,1,2); plot(t,v,'LineWidth',1.5); grid on;
title('Velocity accumulates accelerastion');
xlabel('Time (s)'); ylabel('v (m/s)');
subplot(3,1,3); plot(t,z,'LineWidth',1.5); grid on;
title('Altitude accumulates velocity');
xlabel('Time (s)'); ylabel('z (m)');
print(gcf,fullfile(figure_dir,'day01_kinematics.png'),'-dpng','-r180');
save(fullfile(result_dir,'day01.mat'),'t','a','v','z','a0','p');

