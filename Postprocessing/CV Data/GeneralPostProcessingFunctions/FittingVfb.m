clear all
clf

%% Data
S = load('G:\My Drive\PhD Research\Experimental Data\20181128\A53_004B_D9D10D11D12.mat'); 
IterM = 1;
st = 1;
label = "Trapping Data"

%% S Fitting
pinArry1 = [1,2,4]
pinArryColor1 = ["b","y","m"]
for i=1:length(pinArry1)
    C = S.Data(pinArry1(i)).C;
    V = S.Data(pinArry1(i)).V;
    tfb = S.Data(pinArry1(i)).tfb;
    VfbAve = S.Data(pinArry1(i)).VfbAve;
    VfbStd = S.Data(pinArry1(i)).VfbStd;
    
     figure(1)
     subplot(1,2,1)
     [Cby2,Vby2,Vfb,VfbAve,VfbStd] = VFBfitNDeriv(C,V,size(C,2)/IterM,IterM)
     %[Cby2,Vby2,Vfb,VfbAve,VfbStd] = VfbFitNCfb(C,V,size(C,2)/IterM,IterM,30)
 
     S.Data(pinArry1(i)).Vfb = Vfb;
     S.Data(pinArry1(i)).VfbAve = VfbAve;
     S.Data(pinArry1(i)).VfbStd = VfbStd;
     
     S_VfbAve_Mat(i,:) = VfbAve;
    
    subplot(1,2,2)
    hold on
    set(gca,'FontSize',14)
    errorbar(tfb(st:end)/(3600),VfbAve(st:end)-VfbAve(st),VfbStd(st:end),char(pinArryColor1(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1])
    hold off
    ylabel("Flatband Voltage (V)")
    xlabel("Time (hrs)")
    legend("Pin "+pinArry1)
end

%% Averaging Flatband by Pins
S.VfbPinAve = mean(S_VfbAve_Mat,1);
S.VfbPinStd = std(S_VfbAve_Mat);
S.tfb = S.Data(1).tfb;


figure(3)
errorbar(S.tfb/3600,S.VfbPinAve,S.VfbPinStd,'rs-','LineWidth',2,'MarkerFaceColor',[1 1 1])
set(gca,'FontSize',14)
ylabel("Flatband Voltage (V)")
xlabel("Time (hrs)")
legend(label)
%save('G:\My Drive\#Shared_Jonathan\Experimental Data\ZZcleanVScont\80C\CleanCont_80C_comparison_A53_004B_D5D6D7D8_HR3_Na_3_DD17D18D19D20');