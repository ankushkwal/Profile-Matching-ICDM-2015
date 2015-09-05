function [] = Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)

base_name = ['CHN_'  tile_name '_' lake_id];
load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
% mapStack = mapStack(:,1:600);
[N,T] = size(mapStack);
mapStack = mapStack(:,1:min(T,600));
[N,T] = size(mapStack);
if sum(sum(mapStack==0))>0
    mapStack = MajorityBasedTemporalSmoothing(mapStack,30,2);
end
mapStack(mapStack==0) = 1;
dyn_inds = find(sum(mapStack==1,2)>0 & sum(mapStack==2,2)>0);
water_inds = find(sum(mapStack==1,2)==T);
land_inds = find(sum(mapStack==1,2)==0);

mapStack = mapStack(dyn_inds,:);
[N,T] = size(mapStack);
omapStack = mapStack;
% 
% Nmap = GetNmap(rows,cols,sW,rows*cols);
% Weights = ones(1,T)/T;



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
    
    %temp = temp.*repmat(Weights,N,1);
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

ix = FinalOrder;
emapStack = mapStack(ix,:);
smapStack = CalculatesmapStack(emapStack);

Errors = sum(sum(smapStack~=emapStack));
Cors = [];


fmapStack = zeros(length(locs),T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = mapStack;
mapStack = fmapStack;

mapStack = uint8(mapStack);
% ix = [land_inds;dyn_inds(ix');water_inds];
disp(['Saving data for ',base_name]);
save([output_dir '/' base_name '_data.mat'],'mapStack','ix','Cors','Errors','land_inds','water_inds','dyn_inds');

