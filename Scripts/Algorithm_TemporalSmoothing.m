function [] = Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,TC)

load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
base_name = ['TS_'  tile_name '_' lake_id '_TC_' num2str(TC)];
[N,T] = size(mapStack);
mapStack = mapStack(:,1:min(T,600));
[N,T] = size(mapStack);
if sum(sum(mapStack==0))>0
    mapStack = MajorityBasedTemporalSmoothing(mapStack,30,2);
end
mapStack(mapStack==0) = 1;

fmapStack = mapStack;
parfor i = 1:T
        cur_ts = max(1,i-TC):min(T,i+TC);
        cur_nbrs = mapStack(:,cur_ts);
        mode_nbrs = mode(cur_nbrs,2);
        fmapStack(:,i) = mode_nbrs;
%          sum(isnan(mode_nbrs))
end
fmapStack = uint8(fmapStack);
disp(['Saving data for ' base_name]);
save([output_dir '/' base_name '_data.mat'],'fmapStack');