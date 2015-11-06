function [ers erp teil] = GetPerformanceValue_CHN(gt_name,input_name,isSubset)

data_dir = './../Data/';

result_name = ['CHN_'  input_name];

gt = load([data_dir  gt_name '.mat']);
inp = load([data_dir input_name '.mat']);
res = load([data_dir result_name '.mat']);

GT = gt.GT;
[R C T] = size(GT);
GT = reshape(GT,R*C,T);
ers = sum(sum(GT~=res.fmapStack));
if isSubset==1
    dyn_inds = find(sum(inp.mapStack==1,2)>0 & sum(inp.mapStack==2,2)>0);
else
    dyn_inds = (1:R*C)';
end
N = length(dyn_inds);
erp = ers/(N*T);
