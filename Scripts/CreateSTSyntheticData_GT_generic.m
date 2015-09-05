% This code create synthetic ground truth
% It takes a shape of the lake at its maximum area and a time series from
% the user using the interactive interface and then creates a synthetic
% lake with dynamics

clearvars
close all;
data_dir = './../Data/'; %location where the synthetic dynamics will be stored
fname = [data_dir '/SyntheticDynamics_v1.mat']; % name of the dynamics mat file

% Initializing parameters
R = 100; % number of rows
C = 100; % number of cols
N = R*C; % total number of locations
T = 100; % number of timesteps

temp = N - randi(N,1,T);
GT = ones(N,T);

for i = 1:T
    GT(1:temp(i),i) = 2;
end
figure,imagesc(GT);
GT = reshape(GT,R,C,T);
save(fname,'GT');


