function [] = Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
%% Ordering Based
load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
[N,T] = size(mapStack);
% mapStack = mapStack(:,1:min(T,600));
[N,T] = size(mapStack);
if sum(sum(mapStack==0))>0
    mapStack = MajorityBasedTemporalSmoothing(mapStack,30,2);
end
mapStack(mapStack==0) = 1;
dyn_inds = find(sum(mapStack==1,2)>0 & sum(mapStack==2,2)>0);
water_inds = find(sum(mapStack==1,2)==T);
land_inds = find(sum(mapStack==1,2)==0);


mapStack = mapStack(dyn_inds,:);
[N,T] = size(mapStack);


Cors = [];
Errors = [];


% Get the ordering weighted by column weights
wmask = double(mapStack==1);
wcount = sum(wmask,2);
[dummy ix] = sort(wcount,'ascend');
emapStack = mapStack(ix,:);
smapStack = CalculatesmapStack(emapStack);
Errors = sum(sum(smapStack~=emapStack))



base_name = ['TWH_OB_'  tile_name '_' lake_id];

fmapStack = zeros(length(locs),T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = mapStack;
mapStack = fmapStack;

mapStack = uint8(mapStack);
disp(['Saving data for ' base_name]);
save([output_dir '/' base_name '_data.mat'],'mapStack','ix','Cors','Errors','land_inds','water_inds','dyn_inds');