clear all
close all

%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

files   =   { ...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/11/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/14/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/15/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/16/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/17/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/18/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/19/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/20/Processed'
};
search_name = 'iImage';
TR      =   1; % (seconds)
sliceorder  =   [1 3 4 5 2 4 6 8];       
refslice    =   2; % Most people will opt for the slice that was acquired halfway the scan. This way you minimize the timing corrections that are made to your data.
                   % If you have a structure you're interested in a priori, it may be wise to choose a slice close to that structure, to minimize what small interpolation errors may crop up.
backup = 1;

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

%%% Read first dataset %%%
V       =   spm_vol(spm_select('FPList',files{1},['^' search_name '.*\d\d\d\d.nii']));
nx      =   V(1,1).dim(1);
ny      =   V(1,1).dim(2);
nsl     =   V(1,1).dim(3);
NR      =   size(V,1);

%%% Slice timing %%%
 
for i=1:size(files,2)
    % with SPM
    V           =   spm_vol(spm_select('FPList',files{i},['^' search_name '.*\d\d\d\d.nii']));
    vols_pre    =   spm_read_vols(V);
    spm_slice_timing(V, sliceorder, refslice, [TR/nsl TR/nsl], 'a');
end

%%% Backup original files %%%
if backup
    for i=1:size(files,2)
        V           =   spm_vol(spm_select('FPList',files{i},['^a' search_name '.*\d\d\d\d.nii']));
        bkpdir      =   fullfile(fileparts(files{i}),'Processed',['a' search_name]);
        mkdir(bkpdir);
        vols        =   zeros([V(1,1).dim,size(V,1)]);
        for f=1:size(V,1)
           vols(:,:,:,f)    =   spm_read_vols(V(f));
           [path,file,ext]  =   fileparts(V(f).fname);
           V(f).fname       =   fullfile(bkpdir,[file ext]);
           spm_write_vol(V(f),vols(:,:,:,f));
        end
    end
end