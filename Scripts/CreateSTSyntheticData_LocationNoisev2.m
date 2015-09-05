function [] = CreateSTSyntheticData_LocationNoisev2(gt_name,NP,run_num,SCmax,TCmax,LCmax,isSubset)
% gt_name: name of the ground truth dynamics in which noise has to be added
% NP: Noise Percentage (0 - 100)
% run_num: id of the random run. Each run will be saved as a different
% dataset
% SCmax: maximum possible spatial autocorrelation
% TCmax: maximum possible temporal autocorrelation
% LCmax: maximum possible noise blobs in a location
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

TC = 0:TCmax;
SC = 0:SCmax;
LC = 1:LCmax;
mTC = mean(2*TC+1); % mean temporal autocorrelation
mSC = mean(2*SC+1); % mean spatial autocorrelation
mLC = mean(LC); % mean number of noise blobs
mNS = mSC*mSC*mTC*mLC; % mean noise size

rand_inds = randperm(N);
Nmap = GetNmap(R,C,1,R*C);
mapStack = GT;
for i = 1:length(rand_inds)
     if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100
        break;
    end
    cur_ind = rand_inds(i);
    cur_ind = dyn_inds(cur_ind);
    [x, y] = ind2sub([R C],cur_ind);
    
    lc = randperm(length(LC),1);
    lc = LC(lc);
    
    lc_arr = randperm(T,lc);
    for l = 1:length(lc_arr)
        t = lc_arr(l);
        tc_len = randperm(length(TC),1);
        tc_len = TC(tc_len);
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
            cur_label = GT(x,y,cur_ts);
            curW = randperm(length(SC),1);
            curW = SC(curW);
            cur_num = 2*curW +1;
            cur_num = cur_num*cur_num;
            done_mask = mask;
            while sum(sum(mask==1))<cur_num
                %             cur_sel = find(mask==1);
                %             nbrs = Nmap(cur_sel,:);
                %             nbrs = nbrs(:);
                %             nbrs = nbrs(nbrs~=N+1);
                %             rvs = rand(length(nbrs),1);
                %             nbrs = nbrs(rvs>0.5);
                %             mask(nbrs) = 1;
                %                 SE = strel('line', 5, randi(180,1));
                %                 mask = imdilate(mask,SE);
                
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
    end
end

nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T);clear nmask;
tn = tn*100;
disp(['Total Errors Added: ' num2str(tn)])
mapStack = reshape(mapStack,R*C,T);
noise_data_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];
fname = [data_dir noise_data_name '.mat'];
save(fname,'mapStack');





