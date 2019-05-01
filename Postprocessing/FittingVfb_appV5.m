% Function used in the clean-contaminated method to take the difference
% between clean and contaminated curves. Also recalculates flatband

clear all
clf

%% 70C 1MV/cm Data without prestress
%T1 = load('G:\My Drive\PhD Research\Experimental Data\20181025\A53_004C_D26D27D28D29.mat');
%T2 = load('G:\My Drive\PhD Research\Experimental Data\20181019\HR3_Na_3_D9D10D11D12.mat');

% T1=load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181025\A53_004C_D26D27D28D29'); % clean
% T2=load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181019\HR3_Na_3_D9D10D11D12_smoothed_11-14-2018'); % contaminated

%% 100C 1MV/cm Data With 7V PreSress
%T1 = load('G:\My Drive\PhD Research\Experimental Data\20181010\A53_004C_D22D23D24D25.mat');
%T2 = load('G:\My Drive\PhD Research\Experimental Data\20181015\HR3_Na_3_D5D6D7D8.mat');

%% 100C 1MV/cm Data Without PreStress
% T1 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20180925\A53_004A_D15D16D17D18.mat'); % clean
% T2 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181001\A53_003C_D5D6D7D8.mat'); % contaminated
%  T1 = load('G:\My Drive\PhD Research\Experimental Data\20180925\A53_004A_D15D16D17D18.mat');
%  T2 = load('G:\My Drive\PhD Research\Experimental Data\20181001\A53_003C_D5D6D7D8.mat');


%% 90 C 1MV/cm Data without prestress
%T1 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181031\A53_004B_D1D2D3D4.mat'); % clean
%T2 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181105\HR3_Na_3_D13D14D15D16_11-9-2018_stitched.mat'); % contaminated
T1 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181031\A53_004B_D1D2D3D4.mat'); % clean
T2 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181105\HR3_Na_3_D13D14D15D16_11-12-2018_stitched_smoothed_11-14_usethis_smoothed_11-14-2018.mat'); % contaminated




IterM = 1;
st = 1;

%% T1 Fitting
% pinArry1 = [1,2,3,4];
pinArry1 = [1,2,3,4];
% pinArryColor1 = ["b","y","g","m"];
pinArryColor1 = ["b","y","g","m"];

for i=1:length(pinArry1)
    C = T1.Data(pinArry1(i)).C;
    V = T1.Data(pinArry1(i)).V;
    tfb = T1.Data(pinArry1(i)).tfb;
    VfbAve = T1.Data(pinArry1(i)).VfbAve;
    VfbStd = T1.Data(pinArry1(i)).VfbStd;

    figure(1)
    subplot(1,2,1)
    
    % Why recalculate Vfb since it is available already??
    % Because there may be something wrong with the fitting
    % Post-Process Re-Fitting allows you to take a closer look on the
    % fitting ability
    %{
    [Cby2,Vby2,Vfb,VfbAve,VfbStd] = VFBfitNDeriv_smooth(C,V,size(C,2)/IterM,IterM);
    %[Cby2,Vby2,Vfb,VfbAve,VfbStd] = VfbFitNCfb(C,V,size(C,2)/IterM,IterM,30)

    T1.Data(pinArry1(i)).Vfb = Vfb;
    
    T1.Data(pinArry1(i)).VfbAve = VfbAve;
    T1.Data(pinArry1(i)).VfbStd = VfbStd;
    %}
    
    T1_VfbAve_Mat(i,:) = VfbAve;
    
    
    figure(2)
    subplot(1,2,1)
    hold on
    set(gca,'FontSize',14)
    errorbar(tfb(st:end)/(3600),VfbAve(st:end)-VfbAve(st),VfbStd(st:end),char(pinArryColor1(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1])
    hold off
    ylabel("Flatband Voltage (V)")
    xlabel("Time (hrs)")
    legend("Pin "+pinArry1)
end

%% T2 Fitting
pinArry1 = [1,2,3,4];
pinArryColor1 = ["b","y","g","m"];
for i=1:length(pinArry1)
    C = T2.Data(pinArry1(i)).C;
    V = T2.Data(pinArry1(i)).V;
    tfb = T2.Data(pinArry1(i)).tfb;
    VfbAve = T2.Data(pinArry1(i)).VfbAve;
    VfbStd = T2.Data(pinArry1(i)).VfbStd;

    
    % Why recalculate Vfb since it is available already??
    % Because there may be something wrong with the fitting
    % Post-Process Re-Fitting allows you to take a closer look on the
    % fitting ability
    
    %{
     figure(1)
     subplot(1,2,2)
     [Cby2,Vby2,Vfb,VfbAve,VfbStd] = VFBfitNDeriv_smooth(C,V,size(C,2)/IterM,IterM);
     %[Cby2,Vby2,Vfb,VfbAve,VfbStd] = VfbFitNCfb(C,V,size(C,2)/IterM,IterM,30)
 
     T2.Data(pinArry1(i)).Vfb = Vfb;
     T2.Data(pinArry1(i)).VfbAve = VfbAve;
     T2.Data(pinArry1(i)).VfbStd = VfbStd;
     %}
     T2_VfbAve_Mat(i,:) = VfbAve;
    
    
    figure(2)
    subplot(1,2,2)
    hold on
    set(gca,'FontSize',14)
    errorbar(tfb(st:end)/(3600),VfbAve(st:end)-VfbAve(st),VfbStd(st:end),char(pinArryColor1(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1])
    hold off
    %ylabel("Flatband Voltage (V)")
    xlabel("Time (hrs)")
    legend("Pin "+pinArry1)
end

%% Averaging Flatband by Pins
T1.VfbPinAve = mean(T1_VfbAve_Mat);
T2.VfbPinAve = mean(T2_VfbAve_Mat);

T1.VfbPinStd = std(T1_VfbAve_Mat);
T2.VfbPinStd = std(T2_VfbAve_Mat);

T1.tfb = T1.Data(1).tfb;
T2.tfb = T2.Data(1).tfb;


figure(3)
subplot(1,2,1)
errorbar(T1.tfb/3600,T1.VfbPinAve,T1.VfbPinStd,'bs-','LineWidth',2,'MarkerFaceColor',[1 1 1])
hold on
set(gca,'FontSize',14)
errorbar(T2.tfb/3600,T2.VfbPinAve,T2.VfbPinStd,'rs-','LineWidth',2,'MarkerFaceColor',[1 1 1])
hold off
ylabel("Flatband Voltage (V)")
xlabel("Time (hrs)")
legend("Clean","Contaminated")

minTime = min([length(T1.tfb) length(T2.tfb)])
T12VfbPinAve = T2.VfbPinAve(1:minTime) - T1.VfbPinAve(1:minTime);
T12VfbPinAveShift = T12VfbPinAve-T12VfbPinAve(1)
T12VfbPinMaxStd = max([T1.VfbPinStd(1:minTime); T2.VfbPinStd(1:minTime)])
T12tfbPinAveShift = T1.tfb(1:minTime);
T1T2VfbAveStd = sqrt(T1.VfbPinStd(1:minTime).^2+T2.VfbPinStd(1:minTime).^2);


LEind = find(T12VfbPinMaxStd>1)
T12VfbPinAveShift(LEind) = [];
T12VfbPinMaxStd(LEind) = [];
T12tfbPinAveShift(LEind) = [];
subplot(1,2,2)
errorbar(T12tfbPinAveShift/3600,T12VfbPinAveShift,T1T2VfbAveStd,'ms-','LineWidth',2,'MarkerFaceColor',[1 1 1])

%
% hold on
% plot(T12tfbPinAveShift/3600,T12VfbPinAve,'ms-','LineWidth',2,'MarkerFaceColor',[1 0 1]);
% hold off
% %

set(gca,'FontSize',14)
title("Outliers Removed")
ylabel("V_F_B_ _C_o_n_t - V_F_B_ _C_l_e_a_n (V)")
xlabel("Time (hrs)")

save('G:\My Drive\#Shared_Jonathan\Experimental Data\ZZcleanVScont\90C\comparison_A53_004B_D1D2D3D4_HR3_Na_3_D13D14D15D16_11-12-2018_stitched_smoothed_11-14_usethis_smoothed_11-14-2018.mat');