function [] = Algorithm_BordaCount(tile_name,lake_id,ILIlist,ILIth,tW,sW,data_dir,output_dir)


base_name = ['BCN_'  tile_name '_' lake_id];
load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
mapStack = mapStack(:,1:600);
[N,T] = size(mapStack);
rows = er-sr+1;
cols = ec-sc+1;
mapStack = MajorityBasedTemporalSmoothing(mapStack,30,2);
mapStack(mapStack==0) = 1;
dyn_inds = find(sum(mapStack==1,2)>0 & sum(mapStack==1,2)<T);
water_inds = find(sum(mapStack==1,2)==T);
land_inds = find(sum(mapStack==1,2)==0);
water_locs = locs(water_inds);
land_locs = locs(land_inds);
dyn_locs = locs(dyn_inds);


mapStack = mapStack(dyn_inds,:);
[N,T] = size(mapStack);
omapStack = mapStack;

BCount = zeros(N,1);
for i = 1:T
	num_land = sum(mapStack(:,i)==2);
	water_inds = mapStack(:,i)==1;	
	BCount(water_inds) = BCount(water_inds) + num_land;
end 

[dummy ix] = sort(BCount,'ascend');
emapStack = mapStack(ix,:);
smapStack = CalculatesmapStack(emapStack);


Errors = sum(sum(smapStack~=emapStack));
Cors = [];
fmapStack = zeros(length(locs),T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = mapStack;
mapStack = fmapStack;
mapStack = uint8(mapStack);
disp(['Saving data for ' base_name]);
save([output_dir '/' base_name '_data.mat'],'mapStack','ix','Cors','Errors','land_inds','water_inds','dyn_inds');




