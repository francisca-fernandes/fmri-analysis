clear all
close all

%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

spmmouse('load',['/Users/francisca/Documents/MATLAB/code' filesep 'modified' filesep 'mouse-C57.mat']);
global defaults;
nrepetitions = 340;
proc = {
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/11/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/14/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/15/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/16/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/17/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/18/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/19/Processed',...
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/20/Processed'
     }; % Output folder
file_static  = {'/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/6/pdata/1/cImage_0001.nii'}; % Anatomical that was selected to align functional images
func_exps  = [11,14:20];
no_folders = [8];
search_name='aiImage';
calculate_affine_t = 0;
backup = 1;

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

%%% Coregistration %%%
k = 1;
for u=1:length(file_static)
    
    image_static    =   spm_vol(file_static{u});
    
    for m = 1:no_folders(u) 
    
        file_fun        =   fullfile(proc{k},['cmean' search_name '_' num2str(func_exps(k)) '_0001.nii']); % Mean intensity image
        image_fun       =   spm_vol(file_fun);

        [bbfun,vxfun]   =   bbvox_from_V(image_fun);
        rx       =   vxfun(1);
        ry       =   vxfun(2);
        rz       =   vxfun(3);

        dnrm                =   defaults.normalise;
        dnrm.write.vox      =   [rx,ry,rz];
        % [bb2,~]             =   spm_get_bbox(image_fun,'fv',eye(4));  
        % center              =   (bb2(1,3)+bb2(2,3))/2;
        % center2             =   (bbfun(1,3)+bbfun(2,3))/2;
        dnrm.write.bb       =   bbfun;
        % dnrm.write.bb(:,3)  =   bbfun(:,3)+repmat(center-center2,2,1);

        %%% Rigid Body Transformation %%%
        flags       =   defaults.coreg.estimate;
        flags.sep   =   [4 2];
        flags.fwhm  =   [abs(rx)*2 abs(rx)*2];
        flags.tol   =   [0.001,0.001,0.001,0.001,0.001,0.001,0.001,0.001,0.001,0.001,0.001,0.001];
        x           =   spm_coreg(image_static,image_fun,flags);
        % x         =   zeros(1,6); % If I don't want to apply any transformation
        Affine      =   image_fun.mat\spm_matrix(x(:)')*image_static.mat;
        Tr          =   [];
        cd(proc{k});
        VG          =   image_static; 
        VF          =   image_fun;
        save([proc{k} filesep 'coreg1.mat'],'Affine','VG', 'VF', 'Tr');  
        spm_write_sn(image_fun.fname, [proc{k} filesep 'coreg1.mat'], dnrm.write);

        out_folder  =   [fileparts(fileparts(fileparts(file_fun))) filesep num2str(func_exps(k)) filesep 'Processed'];
        V_im        =  spm_vol(spm_select('FPList',out_folder,['^r' search_name '.*\d\d\d\d.nii']));
        for i=1:nrepetitions
            spm_write_sn(V_im(i),[proc{k} filesep 'coreg1.mat'], dnrm.write);
        end
        V_mean      =  spm_vol(spm_select('FPList',out_folder,['^mean' search_name '.*\d\d\d\d.nii']));
        spm_write_sn(V_mean,[proc{k} filesep 'coreg1.mat'], dnrm.write);
        V_mask      =  spm_vol(spm_select('FPList',[fileparts(out_folder) filesep 'Masks'],'brain_mask.nii'));
        spm_write_sn(V_mask,[proc{k} filesep 'coreg1.mat'], dnrm.write);
        
        %%% Affine Transformation %%%
        if calculate_affine_t
            flags.WF        =   [];
            flags.WG        =   [];
            flags.sep       =   flags.sep(1);
            flags.regtype   =   'subj';
            flags.debug     =   0;
            [xaff1,~]    =   spm_affreg(image_static,image_fun,flags,inv(spm_matrix(x(:)')),1); 
            % xaff1 = eye(4); % If I don't want to apply any transformation
            Affine      =   image_fun.mat\inv(xaff1)*image_static.mat;
            Tr          =   [];
            cd(proc{k});
            VG          =   image_static; 
            VF          =   image_fun;
            save([proc{k} filesep 'affreg1.mat'],'Affine','VG', 'VF', 'Tr');        
        end
        k=k+1;
    end
end

%%% Backup original files %%%
if backup
    
    % Save functional images, mean images and masks
    for i=1:size(proc,2)
        V           =   spm_vol(spm_select('FPList',proc{i},['^w' search_name '.*\d\d\d\d.nii']));
        bkpdir      =   fullfile(fileparts(proc{i}),'Processed',['w' search_name]);
        mkdir(bkpdir);
        vols        =   zeros([V(1,1).dim,size(V,1)]);
        for f=1:size(V,1)
           vols(:,:,:,f)    =   spm_read_vols(V(f));
           [path,file,ext]  =   fileparts(V(f).fname);
           V(f).fname       =   fullfile(bkpdir,[file ext]);
           spm_write_vol(V(f),vols(:,:,:,f));
        end

        V           =   spm_vol(spm_select('FPList',proc{i},['^wmean' search_name '.*\d\d\d\d.nii']));
        vols    =   spm_read_vols(V);
        [path,file,ext]  =   fileparts(V.fname);
        V.fname       =   fullfile(bkpdir,[file ext]);
        spm_write_vol(V,vols);
        
        V           =   spm_vol(spm_select('FPList',proc{i},['^wcmean' search_name '.*\d\d\d\d.nii']));
        vols    =   spm_read_vols(V);
        [path,file,ext]  =   fileparts(V.fname);
        V.fname       =   fullfile(bkpdir,[file ext]);
        spm_write_vol(V,vols);
        
        V           =   spm_vol(spm_select('FPList',[fileparts(proc{i}) filesep 'Masks'],'^wbrain_mask.nii'));
        bkpdir      =   fullfile(fileparts(proc{i}),'Masks','wbrain_mask');
        mkdir(bkpdir);
        vols    =   spm_read_vols(V);
        [path,file,ext]  =   fileparts(V.fname);
        V.fname       =   fullfile(bkpdir,[file ext]);
        spm_write_vol(V,vols);
    end

    % Save anatomical images and mask
    for i=1:length(file_static)
        V           =   spm_vol(spm_select('FPList',fileparts(file_static{i}),'^Image.*\d\d\d\d.nii'));
        bkpdir      =   fullfile(fileparts(file_static{i}),'Images');
        mkdir(bkpdir);
        vols    =   spm_read_vols(V);
        [path,file,ext]  =   fileparts(V.fname);
        V.fname       =   fullfile(bkpdir,[file ext]);
        spm_write_vol(V,vols);
         
        V           =   spm_vol(spm_select('FPList',fileparts(file_static{i}),'^cImage.*\d\d\d\d.nii'));
        vols    =   spm_read_vols(V);
        [path,file,ext]  =   fileparts(V.fname);
        V.fname       =   fullfile(bkpdir,[file ext]);
        spm_write_vol(V,vols);
        
        V           =   spm_vol(spm_select('FPList',fileparts(fileparts(fileparts(file_static{i}))),'^brain_mask.nii'));
        bkpdir      =   fullfile(fileparts(fileparts(fileparts(file_static{i}))),'brain_mask');
        mkdir(bkpdir);
        vols    =   spm_read_vols(V);
        [path,file,ext]  =   fileparts(V.fname);
        V.fname       =   fullfile(bkpdir,[file ext]);
        spm_write_vol(V,vols);
    end
end