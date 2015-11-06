function [] = CreateSTSyntheticData_SpatioTemporalNoisev2(gt_name,NP,run_num,SCmax,TCmax,isSubset)
% gt_name: name of the ground truth dynamics in which noise has to be added
% NP: Noise Percentage (0 - 100)
% run_num: id of the random run. Each run will be saved as a different
% dataset
% SCmax: maximum size of window to be used for adding spatial noise
% TCmax: maximum value of temporal autocorrelation
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
TC = 0:TCmax; % possible temporal autocorrelation values
SC = 0:SCmax; % possible spatial autocorrelation values

rand_inds = randperm(N*T);
Nmap = GetNmap(R,C,1,R*C); % creating the neighborhood map. 
mapStack = GT;
for i = 1:length(rand_inds);
    if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100
        break;
    end
    cur_ind = rand_inds(i);
    [loc, t] = ind2sub([N T],cur_ind); % a (location,time) pair randomly selected 
    loc = dyn_inds(loc);
    [x, y] = ind2sub([R C],loc); % 2-D coordinates of the location
    cur_label = GT(x,y,t);
    
    tc_len = randperm(length(TC),1);
    tc_len = TC(tc_len); % randomly selecting the strength of temporal autocorrelation
    for j = -1*tc_len:tc_len
        mask = zeros(R,C);
        mask(x,y) = 1;
        cur_ts = t+j;
        if cur_ts<1
            cur_ts = 1;
        end
        if cur_ts>T
            cur_ts = T;
        end
        curW = randperm(length(SC),1);
        curW = SC(curW); % randomly selecting strength of spatial autocorrelation
        cur_num = 2*curW +1;
        cur_num = cur_num*cur_num; % maximum number of pixels to be flipped in the neighborhood of the pixel of interest
        
        done_mask = mask;
        % adding pixels to be flipped by doing region growing around the
        % seed pixels. neighbors are added randomly to create more
        % realistic spatial noise
        while sum(sum(mask==1))<cur_num
            cur_sel = find(mask==1);
            nbrs = Nmap(cur_sel,:);
            nbrs = nbrs(:);
            nbrs = nbrs(nbrs~=R*C+1);
            rvs = rand(length(nbrs),1);
            snbrs = nbrs(rvs>0.5 & done_mask(nbrs)==0);
            if sum(snbrs)==0
                sel_nbr = find(mask(nbrs)==0);
                mask(nbrs(sel_nbr(1))) = 1;
            end
            mask(snbrs) = 1;
            done_mask(nbrs) = 1;
            %                 SE = strel('line', 5, randi(180,1));
            %                 mask = imdilate(mask,SE);
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
end
nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T);clear nmask;
tn = tn*100;
disp(['Total Errors Added: ' num2str(tn)])
mapStack = reshape(mapStack,R*C,T);
noise_data_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
fname = [data_dir noise_data_name];
save(fname,'mapStack','R','C','T');
