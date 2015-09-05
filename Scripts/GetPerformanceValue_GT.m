function [ers erp teil] = GetPerformanceValue_GT(tile_name,lake_id,isSubset)
output_dir = './../Results';
data_dir = './../Data';


input_name = ['Stack_'  tile_name '_' lake_id];
result_name = ['PMG_TWH_'  tile_name '_' lake_id];

inp = load([data_dir '/' input_name '.mat']);
res = load([output_dir '/' result_name '_data.mat']);

[N,T] = size(inp.GT);
dyn_inds = find(sum(inp.GT==1,2)>0 & sum(inp.GT==2,2)>0);
[dummy ix] = sort(sum(inp.GT(dyn_inds,:)==1,2),'ascend');
curGT = inp.GT(dyn_inds(ix),:);
curmapStack = inp.mapStack(dyn_inds(ix),:);
cursmapStack = CalculatesmapStack(curmapStack);
ers = sum(sum(cursmapStack~=curGT));
erp = ers/(length(dyn_inds)*T);
teil = sum(sum(cursmapStack~=curmapStack))/(length(dyn_inds)*T);







