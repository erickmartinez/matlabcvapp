% Main to plot Vfb shift curves at different temperatures
clear all
clf

folder='G:\My Drive\Exp_data_new\file_backup_20190416';

filepath_MU1=folder+"\"+"AC1_D25D26D27D28_ANa1_D1D2D3D4";
pinArray1 = [1,2,3,4];
pinArray2 = [5,6,7,8];
[tfb_MU1,VfbPinAve_diff_30C,VfbStd_tot_30C]=FittingVfb_extendedappV8(filepath_MU1,1,pinArray1,pinArray2,'nosave');

filepath_MU2=folder+"\"+"AC1_D29D30D31D32_ANa1_D5D6D7D8";
pinArray1 = [1,2,3,4];
pinArray2 = [5,6,7];
[tfb_MU2,VfbPinAve_diff_40C,VfbStd_tot_40C]=FittingVfb_extendedappV8(filepath_MU2,2,pinArray1,pinArray2,'nosave');

filepath_MU3=folder+"\"+"AC1_D33D34D35D36_ANa1_D9D10D11D12";
pinArray1 = [1,2,3,4];
pinArray2 = [5,7,8];
[tfb_MU3,VfbPinAve_diff_50C,VfbStd_tot_50C]=FittingVfb_extendedappV8(filepath_MU3,3,pinArray1,pinArray2,'nosave');

% save(folder);

figure
errorbar(tfb_MU1./3500,VfbPinAve_diff_30C,VfbStd_tot_30C,'Marker','s','LineWidth',2,'MarkerSize',10);
hold on
errorbar(tfb_MU2./3500,VfbPinAve_diff_40C,VfbStd_tot_40C,'Marker','s','LineWidth',2,'MarkerSize',10);
hold on
errorbar(tfb_MU3./3500,VfbPinAve_diff_50C,VfbStd_tot_50C,'Marker','s','LineWidth',2,'MarkerSize',10);
xlabel('Time (hours)');
ylabel('Vfb shift (V)');
legend('30 °C','40 °C','50 °C');
set(gca,'FontSize',16);
savefig(folder+"\"+"Flatband_shift_comparison");