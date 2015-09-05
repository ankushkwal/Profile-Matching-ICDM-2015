function [] = CreateSTSyntheticData_RandomNoise(tile_name,lake_id,NP,run_num)
data_dir = '/project/kumarv/ankush/Projects/LandsatWaterDynamics/ForVarun/NanAwareSmoothing/Smoothing_WP/Data';
% tile_name = 'h00v00';
% lake_id = 'WPexp1';

% Initializing variables
load([data_dir '/GTStack_' tile_name '_' lake_id '.mat']);
[R,C,T] = size(GT);
N = R*C;
% NP = 5; % noise percentage
% run_num = '1';

% number of location,time pairs that needs to be changed
CNL = floor(0.01*NP*N*T);
rand_inds = randperm(N*T,CNL);
mapStack = reshape(GT,R*C*T,1);
mapStack(rand_inds) = 3 - mapStack(rand_inds);
mapStack = reshape(mapStack,R,C,T);
nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T);
figure;
for i=1:T
    imagesc(mapStack(:,:,i));colormap([0 0 0.7;0 0.7 0]);
    pause(0.01);
end
disp(['Total Errors Added: ' num2str(tn)])
NP = round(tn*100);
mapStack = reshape(mapStack,N,T);
GT = reshape(GT,N,T);
lake_id = [lake_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
sr = 1;er = R;sc = 1;ec = C;
locs = ones(N,1);
fname = [data_dir '/Stack_' tile_name '_' lake_id '.mat'];
save(fname,'mapStack','locs','sr','er','sc','ec','GT');





