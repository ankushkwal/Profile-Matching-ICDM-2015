function [] = Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
base_name = ['CC_'  tile_name '_' lake_id] % profile matching with Greedy start and TWH as the criteria for breaking ties
load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
[N,T] = size(mapStack);

% removing corrupt time steps in the end
mapStack = mapStack(:,1:min(600,T));
[N,T] = size(mapStack);

% to remove all W and L points

mapStack(mapStack==2) = 0;
s1 = sum(mapStack == 1,2);
s0 = sum(mapStack == 0,2);
f = find(s0 > 0 & s1 > 0);
x = mapStack(f,:);

% calling my function

[finallabel] = selph_recursive_v5(x);


% putting back in original map

newmapStack = mapStack;
newmapStack(f,:) = finallabel;
f1 = find(sum(mapStack==0,2)==0);
f0 = find(sum(mapStack==1,2)==0);
newmapStack(f1,:) = 1;
newmapStack(f0,:) = 0;

mapStack = newmapStack;
mapStack(mapStack==0) = 2;
save([output_dir '/' base_name '_data.mat'],'mapStack');
