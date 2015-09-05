clearvars
close all;
data_dir = '/project/kumarv/ankush/Projects/LandsatWaterDynamics/ForVarun/NanAwareSmoothing/Smoothing_WP/Data';
tile_name = 'h00v00';
lake_id = 'expST1';

% Initializing variables
load([data_dir '/GTStack_' tile_name '_' lake_id '.mat']);
[R,C,T] = size(GT);
N = R*C;
NP = 5; % noise percentage
TC = 0:5;
SC = 0:4;
LC = 1:10;
mTC = mean(2*TC+1); % mean temporal autocorrelation
mSC = mean(2*SC+1); % mean spatial autocorrelation
mLC = mean(LC);
mNS = mSC*mSC*mTC*mLC; % mean noise size

% number of locations that needs to be impacted by noise
CNL = floor(0.01*NP*N*T);
CNL = floor(CNL/mNS);
rand_inds = randperm(R*C);
rand_inds = rand_inds(1:CNL);
Nmap = GetNmap(R,C,1,N);
mapStack = GT;
for i = 1:length(rand_inds);
    cur_ind = rand_inds(i);
    [x y] = ind2sub([R C],cur_ind);
    
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
    end
end


tm = reshape(mapStack,R*C*T,1);
tg = reshape(GT,R*C*T,1);
nmask = tm~=tg;
clear tg
stn = sum(nmask)/(N*T);
rn = max(0.01,NP/100 - stn);
RNP = floor(rn*N*T);
good_inds = find(nmask==0);
rand_inds = randperm(length(good_inds));
rn_inds = good_inds(rand_inds(1:RNP));
fm = tm;
fm(rn_inds)= 3 - tm(rn_inds);

mapStack = reshape(fm,R,C,T);
nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T)
clear fm tm
figure;
for i=1:T
    imagesc(mapStack(:,:,i));colormap([0 0 0.7;0 0.7 0]);
    pause(0.05);
end
disp(['Total Errors Added: ' num2str(tn)])
NP = round(tn*100);
mapStack = reshape(mapStack,N,T);
GT = reshape(GT,N,T);
lake_id = [lake_id '_NP_' num2str(NP) ];
sr = 1;er = 1;sc = 1;ec = 1;
locs = ones(N,1);
fname = [data_dir '/Stack_' tile_name '_' lake_id '.mat'];
save(fname,'mapStack','locs','sr','er','sc','ec','GT');





