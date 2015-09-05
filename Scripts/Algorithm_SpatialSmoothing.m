function [] = Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,SC)

load([data_dir '/Stack_' tile_name '_' lake_id '.mat']);
base_name = ['SS_'  tile_name '_' lake_id '_SC_' num2str(SC)];
rows = er-sr+1;
cols = er-sr+1;
[N,T] = size(mapStack);
mapStack = mapStack(:,1:min(T,600));
[N,T] = size(mapStack);
if sum(sum(mapStack==0))>0
    mapStack = MajorityBasedTemporalSmoothing(mapStack,30,2);
end
mapStack(mapStack==0) = 1;

Nmap = GetNmap(rows,cols,SC,rows*cols);
fmapStack = mapStack;
parfor i = 1:T
        cur_map = mapStack(:,i);
        cur_map(end+1) = 0;
        Lmap = cur_map(Nmap);
        mlabel = mode(Lmap,2);
        bad_inds = mlabel==0;
        mlabel(bad_inds) = mapStack(bad_inds);
        fmapStack(:,i) = mlabel;
        
        
end
fmapStack = uint8(fmapStack);
disp(['Saving data for ' base_name]);
save([output_dir '/' base_name '_data.mat'],'fmapStack');