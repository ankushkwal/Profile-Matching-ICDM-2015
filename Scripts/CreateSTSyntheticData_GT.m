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

% Initiating interactive tool to take maximum extent shape as input from the user
GT = ones(R,C)*2;
f1 = figure;imagesc(GT);title('Draw an arbitary shaped polygon that would represent the maximum extent of the water body')
figure(f1);
h = impoly;
curmask = createMask(h);
GT(curmask) = 1;
figure,imagesc(GT);colormap([0 0 0.7;0 0.7 0]) % blue(1) represents water, green(2) represents land

% Initiating interative tool to take temporal profile of count of water
% pixel from the user. This temporal profile would determine the dynamics
% of the lake

max_water = sum(sum(GT==1)); % amount of water(in terms of number of pixels) in the state of maximum extent of the water body
land_count = N - ones(1,T)*max_water; % initialing amount of land in different timesteps
SM = ones(N,T)*2; % map to take input profile from the user
SM(N-max_water:N,:) = 1;
f1 = figure;imagesc(SM);colormap([0 0 0.7;0 0.7 0]);title('Initialized amount of water. Draw temporal profile')
temp = input('Draw a temporal profile such that the profile is under the blue box. Blue box marks the amount of water at the state of maximum extent. Look at the video if there is any issue. Press any key to continue...');
h = impoly('Closed',false);

pos = getPosition(h); % extracting the coordinates of the input points
% Preparing land count for each timestep by interpolation points provided
% by the user
for i = 1:size(pos,1)-1
    start_ts = max(1,floor(pos(i,1)));
    stop_ts = min(T,floor(pos(i+1,1)));
    start_lc = floor(pos(i,2));
    stop_lc = floor(pos(i+1,2));
    if start_ts==stop_ts
        continue;
    end
    m = (stop_lc - start_lc)/(stop_ts-start_ts);
    c = (stop_lc*start_ts - start_lc*stop_ts)/(start_ts-stop_ts);
    for j = start_ts:stop_ts
        land_count(j) = floor(m*j+c);
    end
end

% Updating map to show the input extent box
parfor i = 1:T
    ind = land_count(i);
    temp = ones(N,1)*2;
    temp(ind:end) = 1;
    SM(:,i) = temp;
end
figure,imagesc(SM);colormap([0 0 0.7;0 0.7 0]);title('Input temporal profile')

%calculating water count in each timestep
water_count = sum(SM==1,1);
figure,plot(water_count);title('temporal profile of amount of water')
hold on
plot([1 T],[max_water max_water],'-r')
hold off


% Preparing Partial Dynamics mapping.
% The idea here is that the water body will grow and shrink from the
init_mask = GT;
contourInfo = {};
while(sum(sum(init_mask==1))>0)
    B = bwboundaries(init_mask==1,8);
    locs = [];
    for i = 1:length(B)
        locs = [ locs; B{i}];
    end
    inds = sub2ind([R C],locs(:,1),locs(:,2));
    inds = inds(randperm(length(inds)));
    contourInfo = [contourInfo inds];
    init_mask(inds)= 2;
    
end


% Preparing Lake Dynamics
init_mask = GT;
mapStack = zeros(R,C,T);
figure;
for i = 1:T
    init_mask = GT;
    
    cur_count = water_count(i);
    max_count = sum(sum(init_mask==1));
    diff_count = max_count-cur_count;
    contourID = 1;
    while diff_count>0
        inds = contourInfo{contourID};
        inds_count = length(inds);
        inds = inds(1:min(diff_count,inds_count));
        init_mask(inds)= 2;
        diff_count = sum(sum(init_mask==1))-cur_count;
        contourID = contourID +1;
    end
    mapStack(:,:,i) = init_mask;
    
    
    
end
GT = mapStack;

figure;
fcount = zeros(1,T);
for i=1:T
    imagesc(GT(:,:,i));colormap([0 0 0.7;0 0.7 0]);
    fcount(i) = sum(sum(GT(:,:,i)==1));
    pause(0.1);
end
figure,plot(fcount);
save(fname,'GT');


