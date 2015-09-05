
clearvars
%% Preparing results for Random Noise Process model
tile_name = 'h00v00';
% base_id = 'WPexp3_TotalOrder';
base_id = 'WPexp3_TotalOrder';
% NPname = 'TN';
NParr = [1 5 10 20 40];
run_num_arr = 1:5;
isSubset = 1;
noise_len = length(NParr);
run_len = length(run_num_arr);
num_algo = 6;
Counts = zeros(num_algo,run_len);
Fracs =  zeros(num_algo,run_len);
mCounts = zeros(num_algo,noise_len);
sCounts = zeros(num_algo,noise_len);
mFracs = zeros(num_algo,noise_len);
sFracs = zeros(num_algo,noise_len);
cnt = 1;
for NP = NParr
    for run_num = run_num_arr
        close all

         lake_id = [base_id '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
%         lake_id = [base_id '_SNP_' num2str(NP) '_SC_3_RR_' num2str(run_num)];
%         lake_id = [base_id '_TNP_' num2str(NP) '_TC_5_RR_' num2str(run_num)];
%         lake_id = [base_id '_STNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
%         lake_id = [base_id '_LNP_' num2str(NP) '_SC_3_TC_5_LC_10_RR_' num2str(run_num)];
%         lake_id = [base_id '_BNP_' num2str(NP) '_SC_3_TC_5_RR_' num2str(run_num)];
        
        [ers, erp] = GetPerformanceValue_SS(tile_name,lake_id,2,isSubset);
        Counts(1,run_num) = ers;
        Fracs(1,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_TS(tile_name,lake_id,2,isSubset);
        Counts(2,run_num) = ers;
        Fracs(2,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_BC(tile_name,lake_id,isSubset);
        Counts(3,run_num) = ers;
        Fracs(3,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_CHN(tile_name,lake_id,isSubset);
        Counts(4,run_num) = ers;
        Fracs(4,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_CC(tile_name,lake_id,isSubset);
        Counts(5,run_num) = ers;
        Fracs(5,run_num) = erp;
%         
        [ers, erp] = GetPerformanceValue_PMG(tile_name,lake_id,isSubset);
        Counts(6,run_num) = ers;
        Fracs(6,run_num) = erp;

         
    end
    mCounts(:,cnt) = mean(Counts,2);
    mFracs(:,cnt) = mean(Fracs,2);
    
    sCounts(:,cnt) = std(Counts,[],2);
    sFracs(:,cnt) = std(Fracs,[],2);
    cnt = cnt + 1
    
    
end
temp = mFracs'*100;
% temp = (mCounts'/15708)*100
for i = 1:length(NParr);
    fprintf([num2str(NParr(i)) ' & '])
    for j = 1:num_algo
        if j==num_algo
                fprintf('%0.2f',temp(i,j));
        else
                fprintf('%0.2f & ',temp(i,j));
        end
    end
    fprintf(' \\\\ \\hline');
    fprintf('\n');
end

        
