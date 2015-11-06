function [] = Algorithm_TemporalSmoothing(input_name,TC)

data_dir = './../Data/';
load([data_dir input_name '.mat']);
output_name = ['TS_'  input_name];
[N,T] = size(mapStack);



fmapStack = mapStack;
parfor i = 1:T
        cur_ts = max(1,i-TC):min(T,i+TC);
        cur_nbrs = mapStack(:,cur_ts);
        mode_nbrs = mode(cur_nbrs,2);
        fmapStack(:,i) = mode_nbrs;
%          sum(isnan(mode_nbrs))
end
fmapStack = uint8(fmapStack);
disp(['Saving data for ' output_name]);
save([data_dir '/' output_name '.mat'],'fmapStack');
