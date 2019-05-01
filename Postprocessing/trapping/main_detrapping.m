% Experimental detrapping data
filename='G:\My Drive\#Shared\#Shared_Jonathan\Experimental Data\20181208\A53_004B_D25D26D27D28_detrapping_smoothed_pointcorrected.mat'; % raw data
load(filename);
filepath='C:\Users\Guillaume\Documents\#UCSD\1_PVRD1_PID\Results\Na_SiNx_migration_CV\capture_time_constants';
fitfigpath=[filepath,'\detrapping_100C_12-8-2018']; % Name of the figure to save
[coeff_detrap,tauC_detrap,tauC_detrap_err]=extract_detrapping_xp(Data,[1,2,3,4],["b","y","g","m"],fitfigpath);