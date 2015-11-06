function [] = Algorithm_SpatialSmoothing(input_name,SC)

data_dir = './../Data/';
load([data_dir input_name '.mat']);
output_name = ['SS_'  input_name];

[N,T] = size(mapStack);

Nmap = GetNmap(R,C,SC,R*C);
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
disp(['Saving data for ' output_name]);
save([data_dir '/' output_name '.mat'],'fmapStack');
