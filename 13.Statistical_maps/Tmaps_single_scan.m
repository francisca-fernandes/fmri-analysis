clear all

%%%%%%%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%

main_folder={
    '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1'
};
scan_folder = [11,14:20];
no_folders=[8];
hrf=3;
name_mouse={'etom3rd1new'};
% anat_folder = 9;     % for anatomical
pvalue='005';
clustersize='8';
%dist_to_bregma={'-4.8','-4.2','-3.6','-3.0','-2.4','-1.8','-1.2','-0.6','0.0','0.6','1.2','1.8','2.4'};
search_name = 'aiImage';

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

y=1;
for j=1:length(main_folder)
    for k=1:no_folders(j)
        for l=1:length(hrf)
            close all

            mas = spm_vol([main_folder{j} filesep num2str(scan_folder(y)) filesep 'Masks' filesep 'wwbrain_mask.nii']);
            mask = logical(spm_read_vols(mas));

            Vpos = spm_vol([main_folder{j} filesep num2str(scan_folder(y)) filesep 'Processed' filesep '3new' filesep 'spmT_0001_' pvalue '_' clustersize '.nii']);
            map_pos = spm_read_vols(Vpos);
            map_pos(~mask) = nan;
            maxpos = max(max(max(map_pos)));
            minpos = min(min(min(map_pos)));

            Vneg = spm_vol([main_folder{j} filesep num2str(scan_folder(y)) filesep 'Processed' filesep '3new' filesep 'spmT_0002_' pvalue '_' clustersize '.nii']);
            map_neg = spm_read_vols(Vneg);
            map_neg(~mask) = nan;
            maxneg = max(max(max(map_neg)));
            minneg = min(min(min(map_neg)));

            final_map = zeros(size(map_pos));
            final_map(~isnan(map_pos))=map_pos(~isnan(map_pos));
            if maxneg ~=0
                final_map(~isnan(map_neg))=-map_neg(~isnan(map_neg));
            end
            final_map(final_map==0)=NaN;

            %
            m = spm_vol([main_folder{j} filesep num2str(scan_folder(y)) filesep 'Processed' filesep 'wwmean' search_name '_' num2str(scan_folder(y)) '_0001.nii']);
            % m = spm_vol([main_folder{j} '/' num2str(anat_folder) '/pdata/1/r' num2str(scan_folder(k)) 'wImage_0001.nii']);     % for anatomical
            mean_image = spm_read_vols(m);

            %
            % Normalize map to [0 32]
            final_map(final_map>0)=final_map(final_map>0)*(32-17)/(maxpos-minpos)+32-(32-17)/(maxpos-minpos)*maxpos;
            final_map(final_map<0)=final_map(final_map<0)*(16-1)/(-minneg-(-maxneg))+16-(16-1)/(-minneg-(-maxneg))*(-minneg);

            % Normalize image to fuse (colormap 64 values, backgd from -32 to -1)
            mean_image_max   =   max(mean_image(:));
            mean_image_min   =   min(mean_image(:));
            mean_image_norm  =   mean_image*(32-1)/(mean_image_max-mean_image_min)+32-(32-1)/(mean_image_max-mean_image_min)*mean_image_max;
            mean_image_c1  =   -mean_image_norm;
            new_colormap = zeros(64,3);
            new_colormap(32:-1:1,:) = repmat(linspace(0,1,32)',[1,3]);

            winter_map = colormap(winter);
            winter_map = winter_map(4:4:64,:); % Blue to green
            new_colormap(33:48,:) = winter_map(16:-1:1,:);

            hot_map = colormap(hot);
            hot_map = hot_map(11:56,:);
            hot_map = hot_map(1:3:46,:); % Red to yellow
            new_colormap(49:64,:) = hot_map;


            v_composite             =   mean_image_c1;
            v_composite(mask~=0 & ~isnan(final_map))    =   final_map(mask~=0 & ~isnan(final_map));
            f       =   figure(1); colormap(new_colormap);
            for i=1:size(final_map,3)  %For each slice
                % set(f,'Position',[120 105 939 600]);
                set(f,'Position',[74    52   961   653]); %normalized images
                if i<6
                    axes('Position',[(i-1)*0.18 0.7 0.2 0.2]);
                elseif i<11
                    axes('Position',[(i-6)*0.18 0.5 0.2 0.2]);
                else
                    axes('Position',[(i-11)*0.18 0.3 0.2 0.2]);
                end

                % h1      =   imagesc(flipdim(imrotate(v_composite(20:end-15,11:end-13,i),-90),2),[-32,32]); axis image;
                % h1      =   imagesc(flipdim(imrotate(v_composite(20:end-20,1:end-20,size(final_map,3)-i+1),90),2),[-32,32]); axis image; %normalized images
                h1      =   imagesc(imrotate(v_composite(1:end,1:end,i),90),[-32,32]); axis image; %normalized images

                % text(68,8,dist_to_bregma{i},'FontSize',12,'Color',[1-eps,1,1],'FontWeight','bold')

                axis off,
                hold on, 
            end
            hold off,
            if maxneg ~=0
                h=colorbar('southoutside','AxisLocation','in','YLim', [1 16],'Ticks',[1,16],...
                     'TickLabels',{num2str(-maxneg,'%.2f'),num2str(-minneg,'%.2f')});
                set(h, 'Position', [0.63 0.43 0.2 0.03]);
            end
            if maxpos ~=0
                p=colorbar('southoutside','YLim', [17 32],'Ticks',[17,32],...
                     'TickLabels',{num2str(minpos,'%.2f'),num2str(maxpos,'%.2f')});
                set(p, 'Position', [0.63 0.35 0.2 0.03]);
                p.Label.String = 't-value';
            else
                h.Label.String = 't-value';
            end


            print(f,'-dtiff','-r300',[main_folder{j} filesep num2str(scan_folder(y)) filesep 'Processed' filesep '3new' filesep 'map_' name_mouse{j} '_' num2str(scan_folder(y)) '_hrf' num2str(hrf(l)) '_' pvalue '_' clustersize '.tif']);
            set(f,'PaperOrientation','landscape');
            print(f,'-dpdf','-r300','-bestfit',[main_folder{j} filesep num2str(scan_folder(y)) filesep 'Processed' filesep '3new' filesep 'map_' name_mouse{j} '_' num2str(scan_folder(y)) '_hrf' num2str(hrf(l)) '_' pvalue '_' clustersize '.pdf']);
        end
        y=y+1;
    end
end