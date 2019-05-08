% plotCV

% filepath_MU1='G:\My Drive\Exp_data_new\20190423\MU1_ANa1_D13D14D15D16D17D18D19D20';
% load(filepath_MU1,'MD_1');

filepath_MU2='G:\My Drive\Exp_data_new\20190423\MU2_ANa1_D21D22D23D24D25D26D27D28';
load(filepath_MU2,'MD_2');
MD_1=MD_2;

figure
L=length(MD_1.PinState);
CVsize=size(MD_1.ExpData.Pin(1).V,2);
for p=1:L
    if(MD_1.PinState(p)==1)
        subplot(2,4,p)
        for i=1:CVsize
            plot(MD_1.ExpData.Pin(p).V(:,i),MD_1.ExpData.Pin(p).C(:,i)*1e12,'LineWidth',2)
            hold on
            set(gca,'FontSize',12);
            box on
            ylabel('Capacitance (pF)');
            xlabel('Voltage(V)');
            title(sprintf('Pin %d',p));
        end
    end
end
hold off