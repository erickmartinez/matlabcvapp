% plotCV

filepath_MU1='G:\My Drive\Exp_data_new\file_backup\AC1_D25D26D27D28_ANa1_D1D2D3D4';
load(filepath_MU1,'MD_1');


figure
for i=1:size(MD_1.ExpData.Pin(1).V,2)
plot(MD_1.ExpData.Pin(1).V(:,i),MD_1.ExpData.Pin(1).C(:,i),'LineWidth',2)
hold on
end
set(gca,'FontSize',14);
box on
ylabel('Capacitance (F)');
xlabel('Voltage(V)');
hold off