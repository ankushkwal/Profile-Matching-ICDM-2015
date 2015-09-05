function [] = Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
% This algorithm uses TWH criteria to break the ties between locations assigned to same elevation

base_name = ['PMG_TWH_'  tile_name '_' lake_id]; % profile matching with Greedy start and TWH as the criteria for breaking ties
load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
[N,T] = size(mapStack);

% removing corrupt time steps in the end
mapStack = mapStack(:,1:min(600,T));
[N,T] = size(mapStack);
if sum(sum(mapStack==0))>0 % doing smoothing to remove missing values
    mapStack = MajorityBasedTemporalSmoothing(mapStack,30,2);
end
mapStack(mapStack==0) = 1;

% working only on those locations that are not pure..
dyn_inds = find(sum(mapStack==1,2)>0 & sum(mapStack==2,2)>0);
water_inds = find(sum(mapStack==1,2)==T);
land_inds = find(sum(mapStack==1,2)==0);


% subsetting the data
mapStack = mapStack(dyn_inds,:);
[N,T] = size(mapStack);
omapStack = mapStack;
Weights = ones(1,T)/T;

% Giving a greedy start
wmask = double(mapStack==1);
wcount = sum(wmask,2);
[wcount ix] = sort(wcount,'ascend');
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
%     tic
    parfor i = 1:N
        cur_label = emapStack(i,:);
        cur_label = repmat(cur_label,N,1);
        diff_label = cur_label ~= smapStack;
        diff_count = sum(diff_label,2);
        min_inds = diff_count==min(diff_count);
        %% deepest location
                last_ind = find(min_inds==1,1,'last');
        %% closest location
%         cand_inds = find(min_inds==1);
%         [dummy last_ind] = min(abs(cand_inds-i));
%         last_ind = cand_inds(last_ind);
        
        %%
        Mmat(i) = last_ind;
    end
%     toc
    tinfo = [Mmat wcount];
    [dummy fix] = sortrows(tinfo);
    emapStack = emapStack(fix,:);
    ix = ix(fix);
    
    %Weights = WIA2a(emapStack);
    wmask = double(emapStack==1);
    wcount = sum(wmask,2);
    
    
    
end
fmapStack = zeros(length(locs),T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = mapStack;
mapStack = fmapStack;

fmapStack = zeros(length(locs),T);
fmapStack(water_inds,:) = 1;
fmapStack(land_inds,:) = 2;
fmapStack(dyn_inds,:) = omapStack;
omapStack = fmapStack;



set(0, 'DefaulttextInterpreter', 'none')
figure('color','white','Visible','off'),plot(Errors,'-b','LineWidth',2);
xlabel('Iteration','FontSize',15);
ylabel('Number of Errors','FontSize',15);
set(gca,'Fontsize',15);
saveas(gcf,[output_dir '/' base_name '_errors.png']);


omapStack = uint8(omapStack);
mapStack = uint8(mapStack);

disp(['Saving data for' base_name '...']);
save([output_dir '/' base_name '_data.mat'],'omapStack','mapStack','ix','Errors','land_inds','water_inds','dyn_inds');
