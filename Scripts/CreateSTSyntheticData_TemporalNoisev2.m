function [] = CreateSTSyntheticData_TemporalNoisev2(gt_name,NP,run_num,TCmax,isSubset)
% gt_name: name of the ground truth dynamics in which noise has to be added
% NP: Noise Percentage (0 - 100)
% run_num: id of the random run. Each run will be saved as a different
% dataset
% TCmax: maximum amount of temporal autocorrelation. 
% isSubset: boolean variable whether noise can be added only in dynamic
% locations (isSubset=1) or noise can be added in all the locations
data_dir = './../Data/';

% Initializing variables
load([data_dir gt_name '.mat']);
[R,C,T] = size(GT);
org_GT = GT;
org_GT = reshape(org_GT,R*C,T);
% determining indices that can be used for introducing noise
if isSubset==1
    dyn_inds = find(sum(org_GT==1,2)>0 & sum(org_GT==2,2)>0);
else
    dyn_inds = (1:R*C)';
end

N = length(dyn_inds);
TC = 0:TCmax; % possible values of temporal autocorrelation
rand_inds = randperm(N*T);
mapStack = GT;

% adding temporally correlated noise
for i = 1:length(rand_inds)
    if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100 % reached the required amount of noise level
        break;
    end
    cur_ind = rand_inds(i);
    [loc, t] = ind2sub([N T],cur_ind); % this gives the randomly chosen (location,time) pair
    loc = dyn_inds(loc); % reindex the location to full indexing
    [x, y] = ind2sub([R C],loc); % extracting the 2-D coordinate information of the location
    cur_label = GT(x,y,t);
    
    % randomly selecting the strength of temporal autocorrelation
    curTC = randperm(length(TC),1); 
    curTC = TC(curTC);
        
    sel_ts = max(1,t-curTC):min(T,t+curTC); % set of indices around the timestep of interest
    % flipping labels
    for j = 1:length(sel_ts)
        if cur_label==1
            mapStack(x,y,sel_ts(j)) = 2;
        else
            mapStack(x,y,sel_ts(j)) = 1;
        end
    end
    
end

nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T);clear nmask;
tn = tn*100;
disp(['Total Errors Added: ' num2str(tn)])
mapStack = reshape(mapStack,R*C,T);
noise_data_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
fname = [data_dir noise_data_name '.mat'];
save(fname,'mapStack','R','C','T');





