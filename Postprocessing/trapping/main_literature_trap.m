% main_traps

% Detrapping time constant from Ren et al 2011
folder='C:\Users\Guillaume\Documents\#UCSD\1_PVRD1_PID\Results\Na_SiNx_migration_CV\capture_time_constants\literature_trapping_data';

% Blue curve
figpath=[folder,'\Ren_IEEE_2011_blue_curve.csv'];
[coeffs_b,tauC_b,tauC_err_b]=extract_detrapping_literature(figpath,folder,[0 0 1]);

% green curve
figpath=[folder,'\Ren_IEEE_2011_green_curve.csv'];
[coeffs_g,tauC_g,tauC_err_g]=extract_detrapping_literature(figpath,folder,[0.3 1 0.2]);

% purple curve
figpath=[folder,'\Ren_IEEE_2011_purple_curve.csv'];
[coeffs_p,tauC_p,tauC_err_p]=extract_detrapping_literature(figpath,folder,[1 0 1]);

% red curve
figpath=[folder,'\Ren_IEEE_2011_red_curve.csv'];
[coeffs_r,tauC_r,tauC_err_r]=extract_detrapping_literature(figpath,folder,[1 0 0]);

hold off

% Experimental detrapping data
filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181208\A53_004B_D25D26D27D28_detrapping.mat'; % raw data
load(filename);
filepath='C:\Users\Guillaume\Documents\#UCSD\1_PVRD1_PID\Results\Na_SiNx_migration_CV\capture_time_constants';
fitfigpath=[filepath,'\detrapping_100C_12-8-2018']; % Name of the figure to save
[coeff_detrap,tauC_detrap,tauC_detrap_err]=extract_detrapping_xp(Data,[1,2,4],["b","y","m"],figpath);

% Experimental detrapping data
filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181208\A53_004B_D25D26D27D28_detrapping_smoothed_pointcorrected.mat'; % raw data
load(filename);
filepath='C:\Users\Guillaume\Documents\#UCSD\1_PVRD1_PID\Results\Na_SiNx_migration_CV\capture_time_constants';
xpfitfigpath=[filepath,'\detrapping_100C_12-8-2018']; % Name of the figure to save
[xpcoeff_detrap,xptauC_detrap,xptauC_detrap_err]=extract_detrapping_xp(Data,[1,2,3,4],["b","y","g","m"],xpfitfigpath);

x=["Ren 1","Ren 2","Ren 3","Ren 4","This work"];
y=[tauC_b,tauC_g,tauC_p,tauC_r];

xnum=[1, 2, 3, 4];

figure
% Literature detrapping values
semilogy(xnum,y/3600,'ok','MarkerSize',10,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',[0 0 0])
hold on
% UCSD value
errorbar(5,xptauC_detrap/3600,xptauC_detrap_err/3600,'s','MarkerSize',10,...
    'MarkerEdgeColor',[1 0.4 0.25],...
    'MarkerFaceColor',[1 0.4 0.25],'Color',[1 0.4 0.25]);

set(gca,'xticklabel',x.') % Use strings as x-axis
ylabel('Detrapping time constant (h)');
set(gca,'FontSize',18);
set(gca,'YMinorTick','on');
set(gca,'XMinorTick','on');