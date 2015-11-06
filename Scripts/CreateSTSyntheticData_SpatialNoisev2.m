function [] = CreateSTSyntheticData_SpatialNoisev2(gt_name,NP,run_num,SCmax,isSubset)
% gt_name: name of the ground truth dynamics in which noise has to be added
% NP: Noise Percentage (0 - 100)
% run_num: id of the random run. Each run will be saved as a different
% dataset
% SCmax: maximum size of the spatial window to be used for adding spatial noise
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
SC = 0:SCmax;

rand_inds = randperm(N*T);
Nmap = GetNmap(R,C,1,R*C);
mapStack = GT;

% adding spatially correlated noise
for i = 1:length(rand_inds)
    if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100
        break;
    end
    cur_ind = rand_inds(i);
    [loc, t] = ind2sub([N T],cur_ind);
    loc = dyn_inds(loc);
    [x, y] = ind2sub([R C],loc);
    cur_label = GT(x,y,t);
    
    
    
    mask = zeros(R,C);
    mask(x,y) = 1;
    cur_ts = t;
    curW = randperm(length(SC),1);
    curW = SC(curW);
    cur_num = 2*curW +1;
    cur_num = cur_num*cur_num;
    
    done_mask = mask;
    while sum(sum(mask==1))<cur_num
        cur_sel = find(mask==1);
        nbrs = Nmap(cur_sel,:);
        nbrs = nbrs(:);
        nbrs = nbrs(nbrs~=size(Nmap,1)+1);
        rvs = rand(length(nbrs),1);
        snbrs = nbrs(rvs>0.5 & done_mask(nbrs)==0);
        if sum(snbrs)==0
            sel_nbr = find(mask(nbrs)==0);
            mask(nbrs(sel_nbr(1))) = 1;
        end
        mask(snbrs) = 1;
        done_mask(nbrs) = 1;
    end
    
    mask = logical(mask);
    
    if cur_label==1
        temp = mapStack(:,:,cur_ts);
        temp(mask) = 2;
        mapStack(:,:,cur_ts) = temp;
    else
        temp = mapStack(:,:,cur_ts);
        temp(mask) = 1;
        mapStack(:,:,cur_ts) = temp;
    end
    
end

nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T);clear nmask;
tn = tn*100;
disp(['Total Errors Added: ' num2str(tn)])
mapStack = reshape(mapStack,R*C,T);
noise_data_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
fname = [data_dir noise_data_name];
save(fname,'mapStack','R','C','T');





