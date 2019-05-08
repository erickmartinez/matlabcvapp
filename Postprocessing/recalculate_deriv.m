% VfbAve=cell(1,4);
% load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181019\HR3_Na_3_D9D10D11D12');
filename='G:\My Drive\Exp_data_new\20190123\A53_004B_D49D50D51D52_Copy';
% filename='G:\My Drive\#Shared_Jonathan\Experimental Data\20181105\HR3_Na_3_D13D14D15D16_11-12-2018_stitched_smoothed_11-14_usethis';
% filename='G:\My Drive\#Shared_Jonathan\Experimental Data\20180925\A53_004A_D15D16D17D18';
smoothed_file=[filename,'_smoothed_1-24-2019.mat'];
load(filename);

pinArry=[1,2,3,4];
pinArryColor=["b","y","g","m"];

% number of points
m=size(Data(pinArry(1)).tfb,2);

for i=1:4
    [Cby2,V,Vfb,VfbAve,VfbStd] = VFBfitNDeriv(Data(i).C,Data(i).V,m,1);
    % [Cby2,V,Vfb,VfbAve2{k},VfbStd] = VFBfitNDeriv(S2.Data(k).C,S2.Data(k).V,6,1);
    Data(pinArry(i)).Vfb =  Vfb;
    Data(pinArry(i)).VfbAve = VfbAve;
    Data(pinArry(i)).VfbStd = VfbStd;
end
% hold off
% ylim([-0.8 0.6])

hold off
figure(5)
set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)))

figure(5)
for i=1:4
tfb=Data(pinArry(i)).tfb;
errorbar(tfb/3600,Data(pinArry(i)).VfbAve,VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
% errorbar(tfb/3600,VfbAve2{k},VfbStd,char(pinArryColor(k)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
hold on
end
hold off

xlabel('Time (h)');
ylabel('V_{FB} (V)');

% saveas(

save(smoothed_file);