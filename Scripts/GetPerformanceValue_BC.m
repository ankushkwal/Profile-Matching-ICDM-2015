function [ers erp teil] = GetPerformanceValue_BC(tile_name,lake_id,isSubset)
output_dir = './../Results';
data_dir = './../Data';


input_name = ['Stack_'  tile_name '_' lake_id];
result_name = ['TWH_OB_'  tile_name '_' lake_id];

inp = load([data_dir '/' input_name '.mat']);
res = load([output_dir '/' result_name '_data.mat']);


fmapStack = res.mapStack;
[N,T] = size(fmapStack);
subStack = res.mapStack(res.dyn_inds,:);
esubStack = subStack(res.ix,:);
ssubStack = CalculatesmapStack(esubStack);

[d fix] = sort(res.ix,'ascend');
ssubStack = ssubStack(fix,:);
fmapStack(res.dyn_inds,:) = ssubStack;

ers = sum(sum(fmapStack~=inp.GT));
if isSubset==1
    dyn_inds = find(sum(inp.GT==1,2)>0 & sum(inp.GT==2,2)>0);
else
    dyn_inds = (1:size(inp.GT,1))';
end
N = length(dyn_inds);
erp = ers/(N*T);
teil = sum(sum(CalculatesmapStack(esubStack)~=esubStack))/(N*T);
