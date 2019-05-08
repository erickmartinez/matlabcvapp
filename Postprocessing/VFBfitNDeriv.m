% Extracts Vfb from the 2nd derivative of the capacitance, uses smoothing
% functions

function [Cby2,V,Vfb,VfbAve,VfbStd] = VFBfitNDeriv(Cfb,V,m,IterM)
        Vi=V(1):0.001:V(end);
        Vfb = [];
        figure
        hold on
        set(gca,'ColorOrder',jet(m*IterM))
                for i = 1:m*IterM
                    %try
                    Vs = smooth(V(:,i));
                    Cfbs = smooth(Cfb(:,i));
                    Ci=interp1(Vs,Cfbs,Vi,'spline');
                    Cby2 = (1./(Ci./max(Ci)).^2);
                    Vicut = Vi(Cby2<10);
                    Cby2cut = Cby2(Cby2<10);
                    d1Cby1 = ((diff(Cby2cut,1))./diff(Vicut,1));

                    Cby2r = (1./(Cfb./max(Cfb)).^2);
                    d1Cby1r  = ((diff(Cby2r,1))./diff(V,1));
                    %d1Cby1s = smooth(Vi(2:end),d1Cby1);
                    
                    [mind1Cby1 minInd1] = min(smooth(d1Cby1));
                    d2Cby2 = (diff(d1Cby1)./diff(Vicut(1:end-1)));
                    
                    d3Cby3 = (diff(d2Cby2)./diff(Vicut(1:end-2)));
                    %ia =  d2Cby2 < 45;
                    %d2Cby2 = d2Cby2(ia);
                    %d2Cby2(~ia) = 0;
                    V_Extract = Vicut(minInd1+2:end);
                    d2Cby2_Extract = d2Cby2(minInd1:end);
                    [maxd2Cby2 maxInd2] = max(d2Cby2_Extract);
                    Vfb = [Vfb V_Extract(maxInd2)];
                    
                    Cmax = 5;
                    Cmin = 3;
                    
                    hold on
                    %plot(Vi(1:end-2),d2Cby2,'LineWidth',2);
                    %plot(Vi,Cby2,'LineWidth',2);
                    %xlim([-7,-2])
                    try
                    plot(Vicut(minInd1:end-2),d2Cby2(minInd1:end),'LineWidth',2);
                    plot(Vfb(end),maxd2Cby2,'k*','LineWidth',1);
                    catch
                        display("Stop")
                    end
                end
                
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
end