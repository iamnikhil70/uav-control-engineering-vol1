% Optional figures accompanying the mathematical lessons. Base MATLAB only.
% Rotor curve uses NORMALIZED variables, not measured propeller data.
q = linspace(0,1.6,321)'; r = q.^2; r_linear = 1+2*(q-1);
figure; plot(q,r,'b-',q,r_linear,'r--','LineWidth',1.5); grid on;
title('Local thrust approximation about normalized hover speed');
xlabel('Rotor speed / hover speed (dimensionless)');
ylabel('Rotor thrust / hover thrust (dimensionless)');
legend('Quadratic relation','Tangent at hover','Location','best');
print(gcf,fullfile(figure_dir,'local_linearization.png'),'-dpng','-r180');
% Forward Euler: update BOTH states from old values, not updated velocity.
h_values = [0.5 0.25 0.125 0.0625]; errors = zeros(size(h_values));
a = 0.2; tfinal = 4;
for k = 1:numel(h_values)
    h = h_values(k); z = 0; v = 0;
    for n = 1:round(tfinal/h)
        z_next = z+h*v; v_next = v+h*a;
        z = z_next; v = v_next;
    end
    errors(k) = abs(z-0.5*a*tfinal^2);
end
figure; loglog(h_values,errors,'o-','LineWidth',1.5); grid on;
title('Forward Euler position error at 4 s');
xlabel('Numerical integration step h (s)'); ylabel('Absolute error (m)');
print(gcf,fullfile(figure_dir,'euler_convergence.png'),'-dpng','-r180');


% Geometric meaning of the derivative in Figure 2.
t = linspace(0,4,401)'; z = 0.1*t.^2;
t_tangent = linspace(0.8,3.2,100)';
figure; plot(t,z,'b-',t_tangent,0.4+0.4*(t_tangent-2),'r--');
grid on; title('Velocity is the local slope of altitude');
xlabel('Time (s)'); ylabel('Altitude z (m)');
legend('z = 0.1 t^2','Tangent at t = 2 s','Location','best');
print(gcf,fullfile(figure_dir,'derivative.png'),'-dpng','-r180');
% Pole location diagram without requiring Control System Toolbox.
figure; plot(0,0,'rx','MarkerSize',12,'LineWidth',2); grid on;
xlim([-1 1]); ylim([-1 1]);
title('Two coincident poles at the origin; no finite zeros');
xlabel('Real part sigma (1/s)'); ylabel('Imaginary part omega (1/s)');
print(gcf,fullfile(figure_dir,'poles.png'),'-dpng','-r180');
