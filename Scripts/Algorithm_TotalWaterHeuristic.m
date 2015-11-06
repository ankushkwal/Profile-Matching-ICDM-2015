function [] = Algorithm_BordaCount(input_name)
data_dir = './../Data/';
output_name = ['BC_'  input_name]; % profile matching with greedy start (PMG) and uses Total Water Heuristic to break ties (TWH)
load([data_dir input_name '.mat']);
[N,T] = size(mapStack);


% Subset locations according to their water content
dyn_inds = find(sum(mapStack==1,2)>0 & sum(mapStack==2,2)>0); % locations that have both water and land in them
water_inds = find(sum(mapStack==1,2)==T); % locations that have only water in them
land_inds = find(sum(mapStack==1,2)==0); % locations that have only land in them

% subsetting the stack to only dynamics locations i.e., locations that have
% both water and land in them. Other locations will have no role in smoothing process.
mapStack = mapStack(dyn_inds,:);
[N,T] = size(mapStack);

Errors = [];


% Get the ordering weighted by column weights
wmask = double(mapStack==1);
wcount = sum(wmask,2);
[dummy ix] = sort(wcount,'ascend');
emapStack = mapStack(ix,:);
smapStack = CalculatesmapStack(emapStack);
Errors = sum(sum(smapStack~=emapStack));


[dummy fix] = sort(ix,'ascend');
smapStack = smapStack(fix,:);

% creating the complete corrected stack
fmapStack = zeros(R*C,T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = smapStack;

fmapStack = uint8(fmapStack);
disp(['Saving data for ' output_name]);
save([data_dir output_name '.mat'],'ix','Errors','fmapStack');
