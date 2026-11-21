function p = volume1_parameters()
% Baseline values for the IDEAL vertical model, not a measured aircraft.

    % 1. Physical Parameters
    p.m = 2;                 % kg, constant vehicle mass
    p.g = 9.81;              % m/s^2, positive gravitational magnitude
    p.T0 = p.m * p.g;        % N, hover operating thrust (19.62 N)
    p.U = 0.4;               % N, thrust increment about hover
    p.T_total = p.T0 + p.U;  % N, total thrust (20.02 N)

    % 2. Initial Conditions
    p.z0 = 0;                % m, initial altitude relative to hover datum
    p.v0 = 0;                % m/s, initial vertical velocity

    % 3. Simulation & Solver Settings
    p.step_time = 1;         % s, event switch time
    p.stop_time = 6;         % s, total simulation horizon
    p.dt = 0.01;             % s, output grid spacing
    p.max_step = 0.01;       % s, internal solver step upper bound
    p.rel_tol = 1e-8;        % relative solver tolerance
    p.abs_tol = 1e-10;       % absolute solver tolerance

    % 4. AUTOMATIC EXPORT TO BASE WORKSPACE (FOR SIMULINK)
    % This unpacks every field of 'p' directly into the base workspace
    % so Simulink blocks can use simple names like 'm', 'U', 'z0', etc.
    fields = fieldnames(p);
    for k = 1:numel(fields)
        assignin('base', fields{k}, p.(fields{k}));
    end
end