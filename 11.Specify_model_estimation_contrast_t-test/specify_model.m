%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

proc={
    '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1'
    };
folders=[11,14:20];
no_folders=[8];
hrf=3; %go to spm_get_bf and change it - line 164
search_name = 'aiImage';

job.timing.units='scans';
job.timing.RT=1;
job.timing.fmri_t=100;  % Own HRF: Microtime resolution = (time-bins of hrf)/(hrf duration in seconds) * (TR in seconds)/ 1 scan = 2000/20 * 1/1 = 100 time-bins/scan
                        % Default SPM HRF: Microtime resolution = number of slices
job.timing.fmri_t0=56; % Own HRF: Microtime onset = round((microtime resolution)/(number of slices)* ((reference slice position in sliceorder)- 1/2))
                      % Default SPM HRF: Microtime onset = reference slice position in sliceorder
job.sess.cond.name='visual';
job.sess.cond.onset=[40,100,160,220,280]; % On either scale, the (start of the) first scan will be timepoint zero (not 1!).
job.sess.cond.duration=[20,20,20,20,20];
job.sess.cond.tmod=0;
job.sess.cond.pmod=struct([]);
job.sess.cond.orth=1;
job.sess.multi=cell(1);
job.sess.regress=struct([]);
job.sess.hpf=80;
job.fact=struct([]);
job.bases.hrf.derivs=[0,0]; %job.bases.none=1;
job.volt=1;
job.global='None';
job.mthresh=1.000000000000000e-04;
job.cvi='AR(1)';

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

m=1;
for i=1:length(proc)
    for j=1:no_folders(i)
        job.dir={[proc{i} filesep num2str(folders(m)) filesep 'Processed' filesep num2str(hrf)]};
        h1 = spm_vol(spm_select('FPList',[proc{i} filesep num2str(folders(m)) filesep 'Processed'],['^sww' search_name '.*\d\d\d\d.nii']));
        h2 = struct2cell(h1)';
        job.sess.scans = h2(:,1);
        job.sess.multi_reg={[proc{i} filesep num2str(folders(m)) filesep 'Processed' filesep 'rp_' search_name '_' num2str(folders(m)) '_0001.txt']};
        job.mask={[proc{i} filesep num2str(folders(m)) filesep 'Masks' filesep 'wwbrain_mask.nii,1']};
        spm_run_fmri_spec(job);
        m=m+1;
    end
end