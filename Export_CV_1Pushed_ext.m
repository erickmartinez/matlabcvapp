function Export_CV_1Pushed_ext(app)
clf; shg;
try
    PinState = [app.P1_1.Value, app.P2_1.Value, app.P3_1.Value, app.P4_1.Value];
    CVPlots = [app.CV1_1,app.CV2_1,app.CV3_1,app.CV4_1];
    ValidCVPlots = CVPlots(PinState==1);
    for e1 = 1:length(CVPlots)
        if (PinState(e1))
            subplot(2,2,e1)
            hold on
            set(gca, 'ColorOrder', jet(app.Iter_tot_1.Value+1),'FontSize',14)
            colormap('jet');
            IterM_1 = app.IterM_1.Value;
            map = fliplr(hot(length(CVPlots(e1).Children)/IterM_1+2));
            t_off = tInSec(app, string(app.t_offset_unit_1.Value), app.TimeOffset_1.Value);
            TimeArray = t_off+(0:app.Iter_tot_1.Value).*app.dt_1.Value
            if (app.dt_1.Value == 0)
                lgn = "Iter: " + (0:app.Iter_tot_1.Value);
            else
                lgn = (TimeArray) + " " + string(app.t_inc_unit_1.Value);
            end
            h= [];
            for e2 =  (length(CVPlots(e1).Children)/IterM_1):-1:1
                x = [];
                y = [];
                ind = e2*IterM_1;
                for e3 = 0:1:IterM_1-1
                    x = [(CVPlots(e1).Children(ind-e3).XData)' x]
                    y = [(CVPlots(e1).Children(ind-e3).YData)' y]
                end
                htemp = plot(x,y,'LineWidth', 2,'Color',map(end-e2,:))
                h = [h, htemp(1)];
            end
            legend(h,lgn)
            title("Pin "+e1);
            xlabel(CVPlots(e1).XLabel.String);
            ylabel(CVPlots(e1).YLabel.String);
            hold off
        end
    end
end