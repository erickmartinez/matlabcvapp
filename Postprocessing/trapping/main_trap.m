% main_trap
% Extract trap data


% For workfunction calculation
%{  
%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%
q=1.60218e-19; % C
k=1.38e-23; % J/K, Boltzmann constant
T=293.15; % K
ni=9.65e9; % cm-3
Eg=1.12; % eV

% ND=4.5e15; % cm-3, doping of silicon (n-type)
ND=4.5e15;
WAl=4.1; % eV, workfunction of aluminum
ksi_s=4.05; % eV, electronic affinity of silicon

Wms=WAl-ksi_s-Eg/2+k*T/q*log(ND/ni); % eV, Workfunction difference between Al and Si
disp(Wms);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

filepath='C:\Users\Guillaume\Documents\#UCSD\1_PVRD1_PID\Results\Na_SiNx_migration_CV\capture_time_constants'; % Folder to save the results

% Data at 100 °C, four clean pins, 12/07/2018
% filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181207\A53_004B_D25D26D27D28_smoothed.mat'; % raw data
% load(filename);
% fitfigpath=[filepath,'\CaptTimeConst_100C_12-11-2018']; % Name of the figure to save
% [coeffs_100_2,tauC100_2,tauC_err100_2]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,0);

% Data at 100 °C, four clean pins, 9/25/2018
filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20180925\A53_004A_D15D16D17D18.mat'; % raw data
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_100C']; % Name of the figure to save
[coeffs_100,tauC100,tauC_err100]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,0);

% Data at 90 °C, four clean pins, 10/31/2018
filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181031\A53_004B_D1D2D3D4.mat';
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_90C'];
[coeffs_90,tauC90,tauC_err90]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,0);

% % Data at 80 °C, three clean pins, 11/13/2018
% filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181113\A53_004B_D5D6D7D8_smoothed.mat';
% load(filename);
% fitfigpath=[filepath,'\CaptTimeConst_80C_old'];
% [coeffs_80_old,tauC80_old,tauC_err80_old]=extract_trap(Data,[1,2,3],["b","y","g"],fitfigpath,0);

% Data at 80 °C, four clean pins, 01/17/2019
filename='G:\My Drive\Exp_data_new\20190117\A53_004B_D41D42D43D44_smoothed_1-21-2019_pointcorrected.mat';
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_80C'];
[coeffs_80,tauC80,tauC_err80]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,0);

% Data at 70 °C, three clean pins
filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181025\A53_004C_D26D27D28D29.mat';
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_70C'];
[coeffs_70,tauC70,tauC_err70]=extract_trap(Data,[1,3,4],["b","g","m"],fitfigpath,0);

% Data at 30 °C, four clean pins, 12/21/2018
filename='G:\My Drive\Exp_data_new\20181221\A53_004B_D29D30D31D32_smoothed_1-4-2018';
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_30C'];
[coeffs_30,tauC30,tauC_err30]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,0);

% Data at 50 °C, four clean pins, 12/21/2018
filename='G:\My Drive\Exp_data_new\20190109\A53_004B_D33D34D35D36_smoothed_1-11-2018';
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_50C'];
[coeffs_50,tauC50,tauC_err50]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,0);

% Data at 60 °C, four clean pins, 12/24/2018
filename='G:\My Drive\Exp_data_new\20190123\A53_004B_D49D50D51D52_Copy_smoothed_1-24-2019';
load(filename);
fitfigpath=[filepath,'\CaptTimeConst_60C'];
[coeffs_60,tauC60,tauC_err60]=extract_trap(Data,[1,2,3,4],["b","y","g","m"],fitfigpath,1);


%% Plotting

T=[30, 50, 60, 70, 80, 90, 100]; % °C, Temperature table
coeffsT=[tauC30,tauC50,tauC60,tauC70,tauC80,tauC90,tauC100]; % s, Table of coeffs as a function of temperature
coeffsErr=[tauC_err30,tauC_err50,tauC_err60,tauC_err70,tauC_err80,tauC_err90,tauC_err100]; % s, Table of coeffs as a function of temperature

% Plot summary of capture time-constants
fig_tau=figure;
errorbar(T,coeffsT/3600,coeffsErr/3600,'s','Color',[0.6 0.8 0.5],'LineWidth',3,'MarkerSize',12);
xlabel('Temperature (°C)');
ylabel('Capture time-constants (h)');

set(gca,'FontSize',18);
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');

taufigpath_fig=[filepath,'\capture_time-constants.fig'];
saveas(fig_tau,taufigpath_fig);
taufigpath_emf=[filepath,'\capture_time-constants.emf'];
saveas(fig_tau,taufigpath_emf);