tile_name = 'h00v00';
lake_id = 'WPexp6_TotalOrder';
isSubset = 1;
NParr = [1 5 10 20];
run_num_arr = 1:3;
for NP = NParr
    for run_num =run_num_arr
        close all
        CreateSTSyntheticData_RandomNoisev2(tile_name,lake_id,NP,run_num,isSubset);
    end
end


for NP = NParr
    for run_num = run_num_arr
        close all
        CreateSTSyntheticData_SpatialNoisev2(tile_name,lake_id,NP,run_num,3,isSubset)
    end
end


for NP = NParr
    for run_num = run_num_arr
        close all
        CreateSTSyntheticData_TemporalNoisev2(tile_name,lake_id,NP,run_num,5,isSubset)
    end
end

for NP = NParr
    for run_num = run_num_arr
        close all
        CreateSTSyntheticData_SpatioTemporalNoisev2(tile_name,lake_id,NP,run_num,3,5,1)
        %         pause()
    end
end

for NP = NParr
    for run_num =run_num_arr
        close all
        CreateSTSyntheticData_LocationNoisev2(tile_name,lake_id,NP,run_num,3,5,10,1)
        %         pause()
    end
end

for NP = NParr
    for run_num = run_num_arr
        close all
        CreateSTSyntheticData_BoundaryNoisev2(tile_name,lake_id,NP,run_num,3,5,1);
        %         pause()
    end
end



tile_name = 'h00v00';
data_dir = './../Data';
output_dir = './../Results2';
base_id = 'WPexp3_TotalOrder';
NParr = [1 5 10 20];
run_num_arr = 1:3;
% lake_id = [base_id '_NNP_0_RR_1'];
% Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
% Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
% Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
% Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
% Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
% Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)

%% Profile Matching
for NP = NParr
    for run_num = run_num_arr
        close all
        lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
        
%         lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_ProfileMatching_GreedyStart_TWH(tile_name,lake_id,data_dir,output_dir)
%         
    end
end

%% Spatial Smoothing
for NP = NParr
    for run_num = run_num_arr
        close all
%         lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
%         Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
        
        lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
        Algorithm_SpatialSmoothing(tile_name,lake_id,data_dir,output_dir,2)
        
        
    end
end

%% Temporal Smoothing
for NP = NParr
    for run_num =run_num_arr
        close all
%         lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
%         Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
%         
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
        
        lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
        Algorithm_TemporalSmoothing(tile_name,lake_id,data_dir,output_dir,2)
        
    end
end

%% Contour Construction
for NP = NParr
    for run_num = run_num_arr
        close all
%         lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
%         Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
        
        lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
        Algorithm_ContourConstruction(tile_name,lake_id,data_dir,output_dir)
    end
end



%% Borda Count
for NP = NParr
    for run_num = run_num_arr
        close all
%         lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
%         Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
        
        lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
        Algorithm_TotalWaterHeuristic(tile_name,lake_id,data_dir,output_dir)
    end
end

%% Cohen
for NP = NParr
    for run_num = run_num_arr
        close all
%         lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
%         Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)
%         
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)
        
        lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
        Algorithm_Cohen(tile_name,lake_id,data_dir,output_dir)
    end
end



