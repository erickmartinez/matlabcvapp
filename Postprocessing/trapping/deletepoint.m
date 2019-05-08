% Function deleting a wrong experimental point in a data file and saving a
% new data file
% For now the data point will just be replaced by the previous point
% function deletepoint(folderpath,dataname), specifically for the sample A53_004B_D25D26D27D28 from 12/08/2018 

%%
folderpath='G:\My Drive\Exp_data_new\20190117';
dataname='A53_004B_D41D42D43D44_smoothed_1-21-2019';

datapath=[folderpath,'\',dataname,'.mat'];
load(datapath);

% Number of the point to remove (note that a point is taken at t=0)
npoint=20;
% Pin number
npin=1;


%% 

% Remove point and replaced it by an interpolation
Data(npin).VfbAve(npoint)=(Data(npin).VfbAve(npoint+1)+Data(npin).VfbAve(npoint-1))/2; % The point is an experimental error (note that first point at 0 hour). Linear interpolation.
Data(npin).Vfb(npoint)=(Data(npin).Vfb(npoint+1)+Data(npin).Vfb(npoint-1))/2; % We use only VfbAve but do it also for Vfb.


newdatapath=[folderpath,'\',dataname,'_pointcorrected.mat'];
save(newdatapath);

figure
set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)))
errorbar(tfb/(3600),Data(npin).VfbAve-Data(npin).VfbAve(1),Data.VfbStd,char("gs-"),'LineWidth',2,'MarkerFaceColor',[1 1 1])
hold off