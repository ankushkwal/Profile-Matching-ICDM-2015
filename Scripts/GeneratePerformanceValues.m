
clearvars
%% Preparing results for Random Noise Process model
gt_name = 'dataset2';
NParr = [1 5 10];
run_num_arr = 1:3;
isSubset = 1;
SCmax = 3;
TCmax = 5;
LCmax = 10;

noise_len = length(NParr);
run_len = length(run_num_arr);
num_algo = 5;
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

         input_name = [gt_name '_RNP_' num2str(NP) '_RR_' num2str(run_num)];
        input_name = [gt_name '_SNP_' num2str(NP) '_SC_' num2str(SCmax) '_RR_' num2str(run_num)];
        input_name = [gt_name '_TNP_' num2str(NP) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        input_name = [gt_name '_STNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_RR_' num2str(run_num)];
        input_name = [gt_name '_LNP_' num2str(NP) '_SC_' num2str(SCmax) '_TC_' num2str(TCmax) '_LC_' num2str(LCmax) '_RR_' num2str(run_num)];

        
        [ers, erp] = GetPerformanceValue_SS(gt_name,input_name,isSubset);
        Counts(1,run_num) = ers;
        Fracs(1,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_TS(gt_name,input_name,isSubset);
        Counts(2,run_num) = ers;
        Fracs(2,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_BC(gt_name,input_name,isSubset);
        Counts(3,run_num) = ers;
        Fracs(3,run_num) = erp;
        
        [ers erp] = GetPerformanceValue_CHN(gt_name,input_name,isSubset);
        Counts(4,run_num) = ers;
        Fracs(4,run_num) = erp;
        
%         [ers erp] = GetPerformanceValue_CC(gt_name,input_name,isSubset);
%         Counts(5,run_num) = ers;
%         Fracs(5,run_num) = erp;
%         
        [ers, erp] = GetPerformanceValue_PMG(gt_name,input_name,isSubset);
        Counts(5,run_num) = ers;
        Fracs(5,run_num) = erp;

         
    end
    mCounts(:,cnt) = mean(Counts,2);
    mFracs(:,cnt) = mean(Fracs,2);
    
    sCounts(:,cnt) = std(Counts,[],2);
    sFracs(:,cnt) = std(Fracs,[],2);
    cnt = cnt + 1;
    
    
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

        
