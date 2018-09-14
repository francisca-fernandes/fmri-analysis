close all
clear all

%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

main_folder = '/Users/francisca/Documents/Data';
study_folder = '20180818_182309_FFF_etomidate3rdform_1_1';
scan_folder = [20];
move_to_processed = 1;

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

for i=1:length(scan_folder)
    Bruker2nifti([main_folder filesep study_folder filesep num2str(scan_folder(i)) filesep 'pdata' filesep '1' filesep '2dseq']);
    if move_to_processed == 1
        origin = [main_folder filesep study_folder filesep num2str(scan_folder(i)) filesep 'pdata' filesep '1' filesep 'Image*.nii'];
        destin = [main_folder filesep study_folder filesep num2str(scan_folder(i)) filesep 'Processed'];
        movefile(origin,destin);
    end
end