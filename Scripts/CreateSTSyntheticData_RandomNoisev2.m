function [] = CreateSTSyntheticData_RandomNoisev2(gt_name,NP,run_num,isSubset)
% gt_name: name of the ground truth dynamics in which noise has to be added
% NP: Noise Percentage (0 - 100)
% run_num: id of the random run. Each run will be saved as a different
% dataset
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
CNL = floor(0.01*NP*N*T); % number of location,time pairs that needs to be changed
rand_inds = randperm(N*T,CNL); % selecting random indices for all possible indices
mask = false(R*C,T);
mask(dyn_inds,:) = 1;
mask = mask(:);
main_inds = find(mask==1); % set of (location,time) pairs that be used for noise
mapStack = reshape(GT,R*C*T,1);
mapStack(main_inds(rand_inds)) = 3 - mapStack(main_inds(rand_inds)); % flipping labels of the required amount of pairs
mapStack = reshape(mapStack,R,C,T);
nmask = mapStack~=GT;
tn = sum(sum(sum(nmask)))/(N*T); % noise fraction
tn = tn*100;
% figure;
% for i=1:T
%     imagesc(mapStack(:,:,i));colormap([0 0 0.7;0 0.7 0]);
%     pause(0.01);
% end
disp(['Total Errors Added: ' num2str(tn)])
mapStack = reshape(mapStack,R*C,T);
noise_data_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
fname = [data_dir  noise_data_name '.mat'];
save(fname,'mapStack');






