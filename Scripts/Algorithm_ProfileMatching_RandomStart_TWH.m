function [] = Algorithm_ProfileMatching_RandomStart_TWH(input_name)
% This algorithm uses TWH criteria to break the ties between locations assigned to same elevation

data_dir = './../Data/';
output_name = ['PMG_TWH'  input_name]; % profile matching with greedy start (PMG) and uses Total Water Heuristic to break ties (TWH)
load([data_dir input_name '.mat']);
[N,T] = size(mapStack);


% Subset locations according to their water content
dyn_inds = find(sum(mapStack==1,2)>0 & sum(mapStack==2,2)>0); % locations that have both water and land in them
water_inds = find(sum(mapStack==1,2)==T); % locations that have only water in them
land_inds = find(sum(mapStack==1,2)==0); % locations that have only land in them

% subsetting the stack to only dynamics locations i.e., locations that have
% both water and land in them. Other locations will have no role in smoothing process.
mapStack = mapStack(dyn_inds,:);
[N,T] = size(mapStack);

% Giving a random start
ix = randperm(N);
emapStack = mapStack(ix,:);
Errors = [];

while(1)
    
    smapStack = CalculatesmapStack(emapStack);
    ers = sum(sum(smapStack~=emapStack));
    fprintf('%d -> ',ers);
    Errors = [Errors ers];
    le = length(Errors);
    if (length(unique(Errors(max(1,le-3):le)))==1 & le>3) | (Errors(end)>Errors(max(length(Errors)-1,1)))
        break;
    end
    Mmat = zeros(N,1);

    parfor i = 1:N
        cur_label = emapStack(i,:);
        cur_label = repmat(cur_label,N,1);
        diff_label = cur_label ~= smapStack;
        diff_count = sum(diff_label,2);
        min_inds = diff_count==min(diff_count);
        last_ind = find(min_inds==1,1,'last');
        Mmat(i) = last_ind;
    end

    tinfo = [Mmat wcount];
    [dummy fix] = sortrows(tinfo);
    emapStack = emapStack(fix,:);
    ix = ix(fix);
    
    wmask = double(emapStack==1);
    wcount = sum(wmask,2);
    
    
    
end
emapStack = mapStack(ix,:);
smapStack = CalculatesmapStack(emapStack);
[dummy fix] = sort(ix,'ascend');
smapStack = smapStack(fix,:);

% creating the complete corrected stack
fmapStack = zeros(R*C,T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = smapStack;

fmapStack = uint8(fmapStack);
disp(['Saving data for ' output_name]);
save([data_dir output_name '.mat'],'ix','Errors','fmapStack');
