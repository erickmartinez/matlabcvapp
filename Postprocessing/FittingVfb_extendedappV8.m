% Script to process data by substracting Vfb as a function of time of clean
% samples from contaminated samples (used when no prestress bias is
% applied)
function [tfb,VfbPinAve_diff,VfbStd_tot]=FittingVfb_extendedappV8(filepath,MUnb,pinArray1,pinArray2,save_plot)
% File path is the path of the mat file containing clean and contaminated
% data
% MUnb is the measurement unit number (1, 2 or 3)
% if savefig is 'yes', the figures will be saved

%% 30 C 1MV/cm Data without prestress
% This is assuming the four first pins are clean devices AC1_D25D26D27D28
% and the four last pins are contaminated devices ANa1_D1D2D3D4

load(filepath); % pins 1-4 clean and pins 5-8 contaminated

% The name of the structure loaded is either MD_1, MD_2 or MD_3
switch MUnb
    case 1
        MD=MD_1;
    case 2
        MD=MD_2;
    case 3
        MD=MD_3;
    otherwise
        error('Wrong unit number entered');
end

IterM = 1;
st = 1;

h=figure(MUnb);
%% Clean sample plot
% pinArray1 = [1, 2, 3, 4];
pinArray1Color={[0.5 0.74 0.98],[0.9 0.87 0.53],[0.59 0.92 0.56],[0.89 0.5 0.7]}; % Cell array containing the colors for each clean pin (light blue, light yellow, light green, light pink)
for i=1:length(pinArray1)
    tfb=MD.ExpData.Pin(pinArray1(i)).tfb;
    VfbAve=MD.ExpData.Pin(pinArray1(i)).VfbAve;
    VfbAve_shift=VfbAve(:)-VfbAve(1); % Flatband shift more meaningful to plot as different samples may have different absolute flatband values
    VfbStd=MD.ExpData.Pin(pinArray1(i)).VfbStd;
    figure(MUnb)
    subplot(2,2,1)
    hold on
    set(gca,'FontSize',14);
    errorbar(tfb./3600,VfbAve_shift,VfbStd,'Color',pinArray1Color{i},'Marker','s','LineWidth',2,'MarkerSize',10);
    
     % Create an array with Vfb values from all pins
    VfbAve_clean(i,:)=VfbAve_shift;
    hold off
end
box on
ylabel({'Flatband Voltage','shift (V)'});
xlabel("Time (hrs)");
legend("Pin "+pinArray1);


% [0.1 0.32 0.53] (dark blue)
% [0.22 0.45 0.19] (dark green)
% [0.76 0.7 0.08] (dark yellow)
% [0.58 0.137 0.4] (dark pink)
%% Contaminated sample plot
% pinArray2 = [5,6,7,8];
pinArray2Color={[0.1 0.32 0.53],[0.76 0.7 0.08],[0.22 0.45 0.19],[0.58 0.137 0.4]}; % Cell array containing the colors for each clean pin (light blue, light yellow, light green, light pink)

for i=1:length(pinArray2)
    tfb=MD.ExpData.Pin(pinArray2(i)).tfb;
    VfbAve=MD.ExpData.Pin(pinArray2(i)).VfbAve;
    VfbAve_shift=VfbAve(:)-VfbAve(1); % Flatband shift more meaningful to plot as different samples may have different absolute flatband values
    VfbStd=MD.ExpData.Pin(pinArray2(i)).VfbStd;
    figure(MUnb)
    subplot(2,2,2)
    hold on
    set(gca,'FontSize',14);
    errorbar(tfb./3600,VfbAve_shift,VfbStd,'Color',pinArray2Color{i},'Marker','s','LineWidth',2,'MarkerSize',10);
    hold off
    
    % Create an array with Vfb values from pin i in line i
    VfbAve_cont(i,:)=VfbAve_shift;
    VfbStd_cont(i,:)=VfbStd;
end
box on
ylabel({'Flatband Voltage','shift (V)'});
xlabel("Time (hrs)");
legend("Pin "+pinArray2);

% Plot both graphs at same scale
VfbAve_tot=[VfbAve_clean;VfbAve_cont];
ylim_max=max(VfbAve_tot,[],'all')*1.2;
ylim_min=0; % Ylim_min is 0 as we are considering the flatband shift Vfb(:)-Vfb(1).

subplot(2,2,2)
ylim([ylim_min ylim_max]);
subplot(2,2,1)
ylim([ylim_min ylim_max]);


%% Averaging Flatband plots by Pins
VfbPinAve_clean = mean(VfbAve_clean,1);
VfbPinAve_cont = mean(VfbAve_cont,1);

VfbPinStd_clean = std(VfbAve_clean,1); % Std computes the standard deviation of each column (does not take into account standard deviation obtained from several measurements on each pin)
VfbPinStd_cont = std(VfbAve_cont,1);

% Plot averaged clean and averaged contaminated on same graph
figure(MUnb)
subplot(2,2,3)
errorbar(tfb./3600,VfbPinAve_clean,VfbPinStd_clean);
hold on
errorbar(tfb./3600,VfbPinAve_cont,VfbPinStd_cont);
hold off
set(gca,'FontSize',14);
box on
ylabel({'Flatband Voltage','shift (V)'});
xlabel("Time (hrs)");
legend('Clean','Contaminated');

%% Difference between clean and contaminated
VfbPinAve_diff=VfbPinAve_cont(:)-VfbPinAve_clean(:)-VfbPinAve_cont(1)+VfbPinAve_clean(1);
VfbStd_tot=VfbPinStd_cont+VfbPinStd_cont;

subplot(2,2,4)
errorbar(tfb./3600,VfbPinAve_diff,VfbStd_tot,'Marker','s','LineWidth',2,'MarkerSize',10);
set(gca,'FontSize',14);
box on
ylabel({'Real flatband voltage shift','of contaminated samples (V)'});
xlabel("Time (hrs)");

% save(filepath+"_cont_minus_clean");
if(strcmp(save_plot,'save_figures'))
savefig(h,filepath+"_cont_minus_clean");
end
    