clear all

%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%
proc={
    '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1'
    };
folders=[11,14:20];
no_folders=[8];
search_name = 'wwaiImage';

varargin.fwhm = [0.29,0.29,0.29];
varargin.dtype = 0;
varargin.im = 0;
varargin.prefix = 's';

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

varargin.data={};
m=1;
for i=1:length(proc)
    for j=1:no_folders(i)
        h1 = spm_vol(spm_select('FPList',[proc{i} filesep num2str(folders(m)) filesep 'Processed'],['^' search_name '.*\d\d\d\d.nii']));
        h2 = struct2cell(h1)';
        varargin.data = [varargin.data ; h2(:,1)];
        m=m+1;
    end
end
h=spm_run_smooth(varargin);