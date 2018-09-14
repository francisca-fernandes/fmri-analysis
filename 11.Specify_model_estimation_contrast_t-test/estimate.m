%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

proc={
    '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1'
    };
folders=[11,14:20];
no_folders=[8];
hrf=[3];

job.method.Classical=1;
job.write_residuals=0;

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

m=1;
for i=1:length(proc)
    for j=1:no_folders(i)
        for k=1:length(hrf)
            job.spmmat={[proc{i} filesep num2str(folders(m)) filesep 'Processed' filesep num2str(hrf(k)) filesep 'SPM.mat']};
            spm_run_fmri_est(job);
        end
        m=m+1;
    end
end