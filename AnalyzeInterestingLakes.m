%This scripts analyzes the selected lakes 
clearvars
close all
tile_name = 'h14v11';
load(['SelectedLakes\' tile_name '_buf0.mat']);
load('modis_dates_736.mat');
fig1 = figure('Position', [1, 400, 300, 200]);
fig2 = figure('Position', [1, 100, 300, 200]);
fig3 = figure('Position', [400, 400, 300, 200]);
fig4 = figure('Position', [400, 100, 300, 200]);
fig5 = figure('Position', [800, 400, 300, 200]);

for i = 1:length(sel_lakes)
    cur_id = sprintf('%04d',sel_lakes(i));
    cur_name = [tile_name '_' cur_id '.mat']
    
    try
        inp = load(['FilledStacks\' cur_name]);
    catch
        continue
    end
    try
        out = load(['SmoothStacks\SmoothStacks\' cur_name]);
    catch
        continue
    end
    rows = inp.er-inp.sr+1;
    cols = inp.ec-inp.sc+1;
    baseStack = inp.mapStack;
    BordaStack = GetBordaStack(inp,out);
    ProfileStack = GetProfileStack(inp,out);
    
    modis_datenums = datenum(dates,'mmm-dd-yyyy');
    diff_dates = abs(modis_datenums-sel_dates(i));
    [dummy cur_modis_ind] = min(diff_dates);
    
    cur_img = imread(['images_' tile_name '\fcc754_' tile_name '_t' num2str(cur_modis_ind) '.jpg']);
    cur_img = cur_img(inp.sr:inp.er,inp.sc:inp.ec,:);
    curBorda = BordaStack(:,cur_modis_ind);
    curBorda = reshape(curBorda,rows,cols);
    curProfile = ProfileStack(:,cur_modis_ind);
    curProfile = reshape(curProfile,rows,cols);
    curBase = baseStack(:,cur_modis_ind);
    curBase = reshape(curBase,rows,cols);
    
    cur_gt = imread(['BrazilLakesGT_500m\' tile_name '.tif']);
    cur_gt = cur_gt(inp.sr:inp.er,inp.sc:inp.ec);
    
    figure(fig1)
    imagesc(curProfile);axis image;title('Profile')
    
    figure(fig2)
    imagesc(curBorda);axis image;title('Borda')
    
    figure(fig3)
    imagesc(cur_img);axis image;title('FCC')
    
    figure(fig4)
    imagesc(curBase);axis image;title('Base')
    
    figure(fig5)
    imagesc(cur_gt);axis image;title('GT');
    pause()
    
end        