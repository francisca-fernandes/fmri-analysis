% Load residual variance estimate matrix
r = spm_vol('/Users/francisca/Documents/Data/20170807_145926_FFF_etom_4_loop_visual_freqint_1_1/32/Processed/ResMS.nii');
res = flipdim(imrotate(spm_read_vols(r),-90),2);

% Load mask
m = spm_vol('/Users/francisca/Documents/Data/20170807_145926_FFF_etom_4_loop_visual_freqint_1_1/32/Masks/brain_mask.nii');
mask = flipdim(imrotate(spm_read_vols(m),-90),2);

masked = res;
masked(~mask) = nan;
residuals_score = nansum(masked(:));