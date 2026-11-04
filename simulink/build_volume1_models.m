function build_volume1_models()
% Optional reference builder. Construct Day 5 manually before using this.
% Creates NEW files only. Never overwrites an existing or open model.
% Long-standing add_line syntax is retained for older releases.
root = fileparts(fileparts(mfilename('fullpath')));
folder = fullfile(root,'simulink');
names = {'v1_equivalent','v1_weekly'};
for k = 1:numel(names)
    name = names{k}; file = fullfile(folder,[name '.slx']);
    if exist(file,'file') || bdIsLoaded(name)
        fprintf('Skipping existing/open model: %s\n',name); continue
    end
    new_system(name); % create an empty block diagram in memory
    set_param(name,'SolverType','Variable-step','Solver','ode45', ...
        'StopTime','6','RelTol','1e-8','AbsTol','1e-10', ...
        'MaxStep','0.01','ReturnWorkspaceOutputs','on');
    % Model-workspace defaults make the saved file independently runnable.
    mw = get_param(name,'ModelWorkspace');
    assignin(mw,'m',2); assignin(mw,'U',0.4);
    assignin(mw,'t_step',1); assignin(mw,'z0',0); assignin(mw,'v0',0);
    if k==1
       add_block('simulink/Sources/Step',[name '/ForceStep'], ...
    'Time','t_step','Before','0','After','U','SampleTime','0', ...
    'Position',[30 100 80 130]);
        source = 'ForceStep/1';
    else
        when = {'1','3','5'}; changes = {'U','-2*U','U'};
        add_block('simulink/Math Operations/Sum',[name '/ForceSum'], ...
            'Inputs','+++','Position',[145 95 170 155]);
        for j=1:3
            bn = sprintf('Step%d',j);
           add_block('simulink/Sources/Step',[name '/' bn], ...
    'Time',when{j},'Before','0','After',changes{j}, ...
    'SampleTime','0','Position',[25 30+70*(j-1) 75 60+70*(j-1)]);
            add_line(name,[bn '/1'],sprintf('ForceSum/%d',j),'autorouting','on');
        end
        source = 'ForceSum/1';
    end
    add_block('simulink/Math Operations/Gain',[name '/InverseMass'], ...
        'Gain','1/m','Position',[245 70 310 110]);
    add_block('simulink/Continuous/Integrator',[name '/Velocity'], ...
        'InitialCondition','v0','Position',[355 70 390 110]);
    add_block('simulink/Continuous/Integrator',[name '/Altitude'], ...
        'InitialCondition','z0','Position',[440 70 475 110]);
    add_line(name,source,'InverseMass/1','autorouting','on');
    add_line(name,'InverseMass/1','Velocity/1');
    add_line(name,'Velocity/1','Altitude/1');
    add_block('simulink/Continuous/Transfer Fcn',[name '/TF'], ...
        'Numerator','1','Denominator','[m 0 0]', ...
        'Position',[340 205 475 250]);
    add_block('simulink/Continuous/State-Space',[name '/SS'], ...
        'A','[0 1;0 0]','B','[0;1/m]','C','[1 0]','D','0', ...
        'X0','[z0;v0]','Position',[340 335 475 390]);
    add_line(name,source,'TF/1','autorouting','on');
    add_line(name,source,'SS/1','autorouting','on');
    outputs = {'Altitude/1','TF/1','SS/1'};
    vars = {'z_int','z_tf','z_ss'};
    add_block('simulink/Signal Routing/Mux',[name '/CompareMux'], ...
        'Inputs','3','Position',[670 155 675 315]);
    add_block('simulink/Sinks/Scope',[name '/ComparisonScope'], ...
        'Position',[730 215 780 255]);
    add_line(name,'CompareMux/1','ComparisonScope/1');
    for j=1:3
        bn = ['Log_' vars{j}];
        add_block('simulink/Sinks/To Workspace',[name '/' bn], ...
            'VariableName',vars{j},'SaveFormat','Timeseries', ...
            'MaxDataPoints','inf','Decimation','1','SampleTime','-1', ...
            'Position',[530 40+130*(j-1) 630 70+130*(j-1)]);
        add_line(name,outputs{j},[bn '/1'],'autorouting','on');
        add_line(name,outputs{j},sprintf('CompareMux/%d',j),'autorouting','on');
    end
    save_system(name,file); close_system(name,0);
    fprintf('Created %s\n',file);
end
end
