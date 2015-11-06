%This is a wrapper script that creates synthetic input data by adding noise in the synthetic ground truth
clearvars
close all
gt_name = 'dataset2';
isSubset = 1;
NParr = [1 5 10]; % array of value of noise percentages to be added
run_num_arr = 1:3; % number of random runs
SCmax = 3;
TCmax = 5;
LCmax = 10;
 
for NP = NParr
    for run_num = run_num_arr
        close all
        CreateSTSyntheticData_RandomNoisev2(gt_name,NP,run_num,isSubset);
        CreateSTSyntheticData_SpatialNoisev2(gt_name,NP,run_num,SCmax,isSubset)
        CreateSTSyntheticData_TemporalNoisev2(gt_name,NP,run_num,TCmax,isSubset)
        CreateSTSyntheticData_SpatioTemporalNoisev2(gt_name,NP,run_num,SCmax,TCmax,isSubset)
        CreateSTSyntheticData_LocationNoisev2(gt_name,NP,run_num,SCmax,TCmax,LCmax,isSubset)
    end
end
