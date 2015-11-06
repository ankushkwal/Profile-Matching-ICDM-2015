clearvars
close all
gt_name = 'dataset2'
isSubset = 1;
NParr = [1 5 10]; % array of value of noise percentages to be added
run_num_arr = 1:3; % number of random runs
SCmax = 3;
TCmax = 5;
LCmax = 10;
 
%% Profile Matching
for NP = NParr
    for run_num = run_num_arr
        close all
        input_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        Algorithm_ProfileMatching_GreedyStart_TWH(input_name)
         
        input_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
        Algorithm_ProfileMatching_GreedyStart_TWH(input_name)
         
        input_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_ProfileMatching_GreedyStart_TWH(input_name)
         
        input_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_ProfileMatching_GreedyStart_TWH(input_name)
         
        input_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];
        Algorithm_ProfileMatching_GreedyStart_TWH(input_name)
        
         
    end
end


%% Spatial Smoothing
Wsize = 2;
for NP = NParr
    for run_num = run_num_arr
        close all
        input_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        Algorithm_SpatialSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
        Algorithm_SpatialSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_SpatialSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_SpatialSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];
        Algorithm_SpatialSmoothing(input_name,Wsize)
        
         
    end
end


%% Temporal Smoothing
Wsize = 2;
for NP = NParr
    for run_num = run_num_arr
        close all
        input_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        Algorithm_TemporalSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
        Algorithm_TemporalSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_TemporalSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_TemporalSmoothing(input_name,Wsize)
         
        input_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];
        Algorithm_TemporalSmoothing(input_name,Wsize)
        
         
    end
end


%% Borda Count
for NP = NParr
    for run_num = run_num_arr
        close all
        input_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        Algorithm_TotalWaterHeuristic(input_name)
         
        input_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
        Algorithm_TotalWaterHeuristic(input_name)
         
        input_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_TotalWaterHeuristic(input_name)
         
        input_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_TotalWaterHeuristic(input_name)
         
        input_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];
        Algorithm_TotalWaterHeuristic(input_name)
        
         
    end
end


%% Preference Based Ordering (Cohen et. al.)
for NP = NParr
    for run_num = run_num_arr
        close all
        input_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        Algorithm_Cohen(input_name)
         
        input_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
        Algorithm_Cohen(input_name)
         
        input_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_Cohen(input_name)
         
        input_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        Algorithm_Cohen(input_name)
         
        input_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];
        Algorithm_Cohen(input_name)
        
         
    end
end
