function [] = Algorithm_Cohen(input_name)

data_dir = './../Data/';
output_name = ['CHN_'  input_name];
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


labels = mapStack;
[N,T] = size(labels);
labels(labels==2) = 0;
PREF = zeros(N,N);
parfor i = 1:N
    U = repmat(labels(i,:),N,1);
    temp = zeros(N,T);
    temp(U==1 & labels==0) = 1;
    temp(U==0 & labels==1) = 0;
    temp(U==1 & labels==1) = 0.5;
    temp(U==0 & labels==0) = 0.5;
    
    temp = sum(temp,2);
    PREF(i,:) = temp';
    
end
for i = 1:N
    PREF(i,i) = 0;
end


isDone = false(N,1);
for i = N:-1:1
    
    outArr = sum(PREF,2);
    inArr = sum(PREF,1);
    P = outArr - inArr';
    P(isDone) = -Inf;
    [max_val max_pos] = max(P);
    FinalOrder(i) = max_pos;
    PREF(max_pos,:) = 0;
    PREF(:,max_pos) = 0;
    isDone(max_pos)=1;
    
end

ix = FinalOrder; % final ordering of locations
emapStack = mapStack(ix,:);
smapStack = CalculatesmapStack(emapStack); % corrected stack

Errors = sum(sum(smapStack~=emapStack)); % number of errors estimated by the algorithm
[dummy fix] = sort(ix,'ascend'); % arranging the corrected stack according to original order
smapStack = smapStack(fix,:);

% creating the complete corrected stack
fmapStack = zeros(R*C,T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = smapStack;

fmapStack = uint8(fmapStack);
disp(['Saving data for ' output_name]);
save([data_dir output_name '.mat'],'ix','Errors','fmapStack');


