S3 = load('G:\Team Drives\FenningLab2\groupMembers\Jonathan Scharf\PhD Research\Experimental Data\20181208\A53_004B_D25D26D27D28_detrapping_smoothed.mat','Data');
S2 = load('G:\Team Drives\FenningLab2\groupMembers\Jonathan Scharf\PhD Research\Experimental Data\20181207\A53_004B_D25D26D27D28_smoothed.mat','Data');
pinArry = [1 2,3,4];
pinArryColor = ["b","y","g","m"];
IterM = 1;
    
for i=1:length(pinArry)
    
    S2_tfb = S2.Data(pinArry(i)).tfb;
    S2_Vfb = S2.Data(pinArry(i)).Vfb;
    S2_VfbAve = S2.Data(pinArry(i)).VfbAve;
    S2_VfbStd = S2.Data(pinArry(i)).VfbStd;
    S2_C = S2.Data(pinArry(i)).C;
    S2_V = S2.Data(pinArry(i)).V;

    S3_tfb = S3.Data(pinArry(i)).tfb;
    S3_Vfb = S3.Data(pinArry(i)).Vfb;
    S3_VfbAve = S3.Data(pinArry(i)).VfbAve;
    S3_VfbStd = S3.Data(pinArry(i)).VfbStd;
    S3_C = S3.Data(pinArry(i)).C;
    S3_V = S3.Data(pinArry(i)).V;
    
    tfb = [S2_tfb(1:end-1),S3_tfb+S2_tfb(end)];
    VfbAve = [S2_VfbAve(1:end-1), S3_VfbAve];
    VfbStd = [S2_VfbStd(1:end-1), S3_VfbStd];
    Vfb = [S2_Vfb(1:end-IterM), S3_Vfb];
    
    C = [S2_C(:,1:end-IterM),S3_C];
    V = [S2_V(:,1:end-IterM),S3_V];

    
    Data(pinArry(i)).tfb =  tfb;    
    Data(pinArry(i)).Vfb =  Vfb;
    Data(pinArry(i)).VfbAve = VfbAve;
    Data(pinArry(i)).VfbStd = VfbStd;
    Data(pinArry(i)).V =  V;    
    Data(pinArry(i)).C =  C;    


    figure(2)
    hold on
    set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)))
    errorbar(tfb/(3600),VfbAve-VfbAve(1),VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1])
    hold off
end
ylabel("Stitched Flatband Voltage (V)")
xlabel("Time (hrs)")
legend("Pin "+pinArry)

% figure(3)
% hold on
% set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)));
% errorbar(S2_tfb/(3600),S2_VfbAve,S2_VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
% hold off
% ylabel("first Flatband Voltage (V)");
% xlabel("Time (hrs)");
% legend("Pin "+pinArry);
% 
% figure(4)
% hold on
% set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)));
% errorbar(S3_tfb/(3600),S3_VfbAve,S3_VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
% hold off
% ylabel("second Flatband Voltage (V)");
% xlabel("Time (hrs)");
% legend("Pin "+pinArry);