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
     '/Users/francisca/Documents/Data/20180818_182309_FFF_etomidate3rdform_1_1/20/Processed',...
};
scan_folder=[11,14:20];
search_name='rp_aiImage_';

%%
%%%%%%%%%%%%%%%%%% Computations %%%%%%%%%%%%%%%%%%

for i=1:length(files)
    cd(files{i});
    A = fscanf(fopen([search_name num2str(scan_folder(i)) '_0001.txt'],'r'),'%f',[6 Inf])';
    h=figure(1);plot(A)
    set(h,'position',[178   192   895   513]);
    title('Rigid-body transformation parameters');
    xlabel('Volume');
    legend('Tx (mm)','Ty (mm)','Tz (mm)','Rx (rad)','Ry (rad)','Rz (rad)');
    set(legend,'position',[0.0173    0.7851    0.0821    0.1413]);
    saveas(gcf,['rbt_plot_' num2str(scan_folder(i))],'tif');
end