function p = volume1_parameters()
% Baseline values for the IDEAL vertical model, not a measured aircraft.
p.m = 2;                 % kg
p.g = 9.81;              % m/s^2, positive magnitude
p.z0 = 0;                % m, relative to the chosen altitude datum
p.v0 = 0;                % m/s, upward positive
p.U = 0.4;               % N, thrust increment
p.step_time = 1;         % s
p.stop_time = 6;         % s
p.dt = 0.01;             % s, OUTPUT grid, not controller sample time
p.rel_tol = 1e-8;
p.abs_tol = 1e-10;       % solver absolute tolerance on numerical states
p.max_step = 0.01;       % s, internal step upper bound
end

