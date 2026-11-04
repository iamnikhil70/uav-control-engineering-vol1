% Run from the repository root with:
% run(fullfile(pwd, 'matlab', 'startup_volume1.m'))

% This script is stored in the matlab folder, so its parent is the repository root.
matlab_dir = fileparts(mfilename('fullpath'));
project_root = fileparts(matlab_dir);

addpath(matlab_dir);
addpath(fullfile(project_root, 'simulink'));

figure_dir = fullfile(project_root, 'figures', 'student');
result_dir = fullfile(project_root, 'results');

if ~exist(figure_dir, 'dir'), mkdir(figure_dir); end
if ~exist(result_dir, 'dir'), mkdir(result_dir); end

fprintf('Project folder: %s\n', project_root);
fprintf('MATLAB release: %s\n', version('-release'));
ver
