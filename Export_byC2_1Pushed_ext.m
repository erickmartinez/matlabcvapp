function Export_byC2_1Pushed_ext(app, event)

clf; shg;
try
    PinState = [app.P1_1.Value, app.P2_1.Value, app.P3_1.Value, app.P4_1.Value];
    byC2Plots = [app.byC2_1_1,app.byC2_2_1,app.byC2_3_1,app.byC2_4_1];
    ValidbyC2Plots = byC2Plots(PinState==1);
    
    for e1 = 1:length(byC2Plots)
        if (PinState(e1))
            subplot(2,2,e1)
            hold on
            set(gca, 'ColorOrder', fliplr(hot(ceil(length(app.byC2_1_1.Children)./2))))
            IterM_1 = app.IterM_1.Value;
            
            for e2 = ((length(byC2Plots(e1).Children)-1)/IterM_1)-1:-2:1
                plot(byC2Plots(e1).Children(e2).XData,byC2Plots(e1).Children(e2).YData,'-','LineWidth',2)
            end
            for e2 = ((length(byC2Plots(e1).Children)-1)/IterM_1):-2:1
                plot(byC2Plots(e1).Children(e2).XData,byC2Plots(e1).Children(e2).YData,'k*','LineWidth',2)
            end
            
            title("Pin "+e1);
            xlabel(byC2Plots(e1).XLabel.String);
            ylabel(byC2Plots(e1).YLabel.String);
            hold off
        end
    end
end