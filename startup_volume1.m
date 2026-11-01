% Run once from this extracted project folder, before the daily scripts.
project_root = fileparts(mfilename('fullpath'));
addpath(fullfile(project_root,'config'));
addpath(fullfile(project_root,'matlab'));
addpath(fullfile(project_root,'simulink'));
figure_dir = fullfile(project_root,'figures','student');
result_dir = fullfile(project_root,'results');
if ~exist(figure_dir,'dir'), mkdir(figure_dir); end
if ~exist(result_dir,'dir'), mkdir(result_dir); end
fprintf('Project folder: %s\n',project_root);
fprintf('MATLAB release: %s\n',version('-release'));
ver

