%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

proc={
    '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1'
    };
folders=[11,14:20];
no_folders=[8];
hrf=[3];

job.conspec.titlestr='';
job.conspec.contrasts=Inf;
job.conspec.threshdesc='none';
job.conspec.thresh=0.05;
job.conspec.extent=8;
job.conspec.mask.none=1;
job.units=1;
job.print='ps';
job.export{1}.tspm.basename='005_8';
% job.write.tspm.basename='005_8'; %previous spm version

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

m=1;
for i=1:length(proc)
    for j=1:no_folders(i)
        for k=1:length(hrf)
            job.spmmat={[proc{i} filesep num2str(folders(m)) filesep 'Processed' filesep num2str(hrf(k)) filesep 'SPM.mat']};
            spm_run_results(job);
        end
        m=m+1;
    end
end

