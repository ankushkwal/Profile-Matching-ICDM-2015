function [] = CreateSTSyntheticData_SpatialNoise(tile_name,lake_id,NP,run_num,SCmax)
data_dir = '/project/kumarv/ankush/Projects/LandsatWaterDynamics/ForVarun/NanAwareSmoothing/Smoothing_WP/Data';
% tile_name = 'h00v00';
% lake_id = 'expST1';

% Initializing variables
load([data_dir '/GTStack_' tile_name '_' lake_id '.mat']);
[R,C,T] = size(GT);
N = R*C;
% NP = 5; % noise percentage
SC = 0:SCmax;
% run_num = '1';
mSC = mean(2*SC+1); % mean spatial autocorrelation
mNS = mSC*mSC; % mean noise blob size

% number of locations that needs to be impacted by noise
CNL = floor(0.01*NP*N*T);
CNL = floor(CNL/mNS);
rand_inds = randperm(R*C*T,CNL);
Nmap = GetNmap(R,C,1,N);
mapStack = GT;

% adding spatially correlated noise
for i = 1:length(rand_inds);
    if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100
        break;
    end
    cur_ind = rand_inds(i);
    [t1 t] = ind2sub([N T],cur_ind);
    [x y] = ind2sub([R C],t1);
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
        nbrs = nbrs(nbrs~=N+1);
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


% adding random noise
tm = reshape(mapStack,R*C*T,1);
tg = reshape(GT,R*C*T,1);
nmask = tm~=tg;
clear tg
sn = sum(nmask)/(N*T);
rn = max(0,NP/100 - sn);
if rn > NP/1000;
    disp('Rejecting the run because spatial noise is less than required amount');
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
mapStack = reshape(mapStack,N,T);
GT = reshape(GT,N,T);
lake_id = [lake_id '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)]
sr = 1;er = R;sc = 1;ec = C;
locs = ones(N,1);
fname = [data_dir '/Stack_' tile_name '_' lake_id '.mat'];
save(fname,'mapStack','locs','sr','er','sc','ec','GT');





