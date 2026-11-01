% Requires Control System Toolbox. The physical state order is [z;v].
p = volume1_parameters();
A = [0 1;0 0]; B = [0;1/p.m]; C = [1 0]; D = 0;
sys = ss(A,B,C,D);
disp(sys); disp(eig(A)); disp(tf(sys));
t = (0:p.dt:4)';
u = zeros(size(t));
x0 = [1;0.3];              % deliberately nonzero initial motion
[y,~,x] = lsim(sys,u,t,x0,'zoh');
z_exact = x0(1)+x0(2)*t;
assert(max(abs(y-z_exact))<1e-7,'Free-motion mismatch.');
sys_both = ss(A,B,eye(2),zeros(2,1));
y_both = lsim(sys_both,u,t,x0,'zoh');
assert(max(abs(y_both(:)-x(:)))<1e-7,'Output/state mismatch.');
G = tf(1,[p.m 0 0]);
sys_auto = ss(G);          % its states need not be [z;v]
% Compare conversions only under zero IC unless a state transform is known.
u_test = p.U*ones(size(t));
z_phys = lsim(sys,u_test,t,[0;0],'zoh');
z_auto = lsim(sys_auto,u_test,t,'zoh');
assert(max(abs(z_phys-z_auto))<1e-7,'Zero-state conversion mismatch.');
figure('Name','Day 6 initial state');
subplot(2,1,1); plot(t,y,'b-',t,z_exact,'r--'); grid on;
title('Zero thrust increment does not stop existing motion');
xlabel('Time (s)'); ylabel('z (m)');
legend('State space','Exact','Location','best');
subplot(2,1,2); plot(t,x(:,2),'LineWidth',1.5); grid on;
title('Initial upward velocity persists');
xlabel('Time (s)'); ylabel('v (m/s)');
print(gcf,fullfile(figure_dir,'day06_states.png'),'-dpng','-r180');
save(fullfile(result_dir,'day06.mat'),'A','B','C','D','t','u', ...
    'x0','x','y','z_exact','p');

