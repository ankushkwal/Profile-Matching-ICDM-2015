function [] = CreateSTSyntheticData_TemporalNoise(tile_name,lake_id,NP,run_num,TCmax)
data_dir = '/project/kumarv/ankush/Projects/LandsatWaterDynamics/ForVarun/NanAwareSmoothing/Smoothing_WP/Data';
% tile_name = 'h00v00';
% lake_id = 'expST1';

% Initializing variables
load([data_dir '/GTStack_' tile_name '_' lake_id '.mat']);
[R,C,T] = size(GT);
N = R*C;
%NP = 5; % noise percentage
TC = 0:TCmax;
%run_num = '1';
mTC = mean(2*TC+1); % mean temporal autocorrelation

% number of locations that needs to be impacted by noise
CNL = floor(0.01*NP*N*T);
CNL = floor(CNL/mTC);
rand_inds = randperm(R*C*T);
Nmap = GetNmap(R,C,1,N);
mapStack = GT;

% adding temporally correlated noise
for i = 1:length(rand_inds);
    if sum(sum(sum(mapStack~=GT)))/(N*T)>=NP/100
        break;
    end
    cur_ind = rand_inds(i);
    [t1 t] = ind2sub([N T],cur_ind);
    [x y] = ind2sub([R C],t1);
    cur_label = GT(x,y,t);
    
    curTC = randperm(length(TC),1);
    curTC = TC(curTC);
        
    sel_ts = max(1,t-curTC):min(T,t+curTC);
    for j = 1:length(sel_ts)
        if cur_label==1
            mapStack(x,y,sel_ts(j)) = 2;
        else
            mapStack(x,y,sel_ts(j)) = 1;
        end
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
    disp('Rejecting the run because temporal noise is less than required amount');
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
lake_id = [lake_id '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)]
sr = 1;er = R;sc = 1;ec = C;
locs = ones(N,1);
fname = [data_dir '/Stack_' tile_name '_' lake_id '.mat'];
save(fname,'mapStack','locs','sr','er','sc','ec','GT');





