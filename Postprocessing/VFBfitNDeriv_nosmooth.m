function [Cby2,V,Vfb,VfbAve,VfbStd] = VFBfitNDeriv(Cfb,V,m,IterM)
        Vi=V(1):0.001:V(end);
        Vfb = [];

hold on
figure
        set(gca,'ColorOrder',jet(m*IterM))
                for i = 1:m*IterM
                    %try
                    Ci=interp1(V(:,i),Cfb(:,i),Vi,'spline');
                    Cby2 = (1./(Ci./max(Ci)).^2);
                    Vicut = Vi(Cby2<10);
                    Cby2cut = Cby2(Cby2<10);
                    
                    d1Cby1 = ((diff(Cby2cut,1))./diff(Vicut,1));
                    
                    %%%% capacitance plot and non-cut first and second derivatives
                    
                    
%                     plot(Vi,Cby2,'LineWidth',1.5);
%                     hold on
%                     plot(Vi,1e11*Ci-10,'LineWidth',1.5); % Capacitance rescaled for plotting
                    
                    d1Cby1_nc=((diff(Cby2,1))./diff(Vi,1)); % non cut
%                     plot(Vi(1:end-1),d1Cby1_nc,'LineWidth',1.5);
                    
                    d2Cby2_nc=((diff(d1Cby1_nc,1))./diff(Vi(1:end-1),1)); %non-cut
%                     plot(Vi(1:end-2),d2Cby2_nc,'LineWidth',1.5);
                    %%%%
                    
                    [mind1Cby1 minInd1] = min(d1Cby1);
                    d2Cby2 = (diff(d1Cby1)./diff(Vicut(1:end-1)));
                    
                    V_Extract = Vicut(minInd1+2:end);
                    d2Cby2_Extract = d2Cby2(minInd1:end);
                    
                    [maxd2Cby2 maxInd2] = max(d2Cby2_Extract);
                    Vfb = [Vfb V_Extract(maxInd2)];

                    
                    hold on
                    plot(Vicut(1:end-2),d2Cby2,'LineWidth',2);
                    plot(Vi,Cby2,'LineWidth',2);
                    xlim([-7,-2])
                    try
                    plot(Vicut(minInd1:end-2),d2Cby2(minInd1:end),'LineWidth',2);
                    plot(Vfb(end),maxd2Cby2,'k*','LineWidth',1);
                    catch
                        display("Stop")
                    end
                end
%                 keyboard;
                
                VfbAve = [];
                VfbStd = [];

                for i=1:m
                   ind = i*IterM;
                   VfbAve = [VfbAve mean(Vfb(ind:-1:ind-IterM+1)')];
                   VfbStd = [VfbStd std(Vfb(ind:-1:ind-IterM+1)')];
                end                
                
                hold off
                title("d^2(1/C^2)/d^2V Vs. Voltage");
                xlabel("Voltage(V)");
                ylabel("d^2(1/C^2)/d^2V");
% hold off

