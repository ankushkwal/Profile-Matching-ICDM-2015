function [] = CreateSTSyntheticData_BoundaryNoisev2(tile_name,lake_id,NP,run_num,SCmax,TCmax,isSubset)
data_dir = '/project/kumarv/ankush/Projects/LandsatWaterDynamics/ForVarun/NanAwareSmoothing/Smoothing_WP/Data';
% tile_name = 'h00v00';
% lake_id = 'expST1';

%% Preparing Synthetic Input Data
load([data_dir '/GTStack_' tile_name '_' lake_id '.mat']);
[R,C,T] = size(GT);
org_GT = GT;
org_GT = reshape(org_GT,R*C,T);
if isSubset==1
    dyn_inds = find(sum(org_GT==1,2)>0 & sum(org_GT==2,2)>0);
else
    dyn_inds = (1:R*C)';
end
    

N = length(dyn_inds);
% NP = 5; % noise percentage
TC = 0:TCmax;
SC = 0:SCmax;


blabels = false(R*C,T);
for i = 1:T
    bnd = bwboundaries(GT(:,:,i)==1,8);
    locs = bnd{1};
    inds = sub2ind([R C],locs(:,1),locs(:,2));
    blabels(inds,i) = 1; 
end

dinds = find(blabels==1);

rand_inds = dinds(randperm(length(dinds)));
% rand_inds = rand_inds(1:CNP);
Nmap = GetNmap(R,C,1,R*C);
mapStack = GT;
for i = 1:length(rand_inds);
    if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100
        break;
    end
    cur_ind = rand_inds(i);
    [t1 t] = ind2sub([R*C T],cur_ind);
    [x y] = ind2sub([R C],t1);
    cur_label = GT(x,y,t);
    
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
        curW = randperm(length(SC),1);
        curW = SC(curW);
        cur_num = 2*curW +1;
        cur_num = cur_num*cur_num;
        
        done_mask = mask;
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


tm = reshape(mapStack,R*C*T,1);
tg = reshape(GT,R*C*T,1);
nmask = tm~=tg;
clear tg
sn = sum(nmask)/(N*T);
rn = max(0,NP/100 - sn);
if rn > NP/1000;
    disp('Rejecting the run because spatio temporal noise is less than required amount');
    return;
end
RNP = floor(rn*N*T);
good_inds = find(nmask==0);
rand_inds = randperm(length(good_inds));
rn_inds = good_inds(rand_inds(1:RNP));
fm = tm;
fm(rn_inds)= 3 - tm(rn_inds); clear tm;

mapStack = reshape(fm,R,C,T);clear fm;
nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T);clear nmask;
figure;
for i=1:T
    imagesc(mapStack(:,:,i));colormap([0 0 0.7;0 0.7 0]);
    pause(0.01);
end
disp(['Total Errors Added: ' num2str(tn)])
NP = round(tn*100);
mapStack = reshape(mapStack,R*C,T);
[dummy ix] = sort(sum(mapStack==1,2),'ascend');
figure,imagesc(mapStack(ix,:));
GT = reshape(GT,R*C,T);
lake_id = [lake_id '_BNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)]
sr = 1;er = R;sc = 1;ec = C;
locs = ones(R*C,1);
fname = [data_dir '/Stack_' tile_name '_' lake_id '.mat']
save(fname,'mapStack','locs','sr','er','sc','ec','GT');
