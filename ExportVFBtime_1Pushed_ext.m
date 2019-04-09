function ExportVFBtime_1Pushed_ext(app)
clf; shg;
try
    VfbTimePlotColors = ["bo-","yo-","go-","mo-"];
    PinState = [app.P1_1.Value, app.P2_1.Value, app.P3_1.Value, app.P4_1.Value];
    StdOff = 0;
    for e = 1:length(PinState)
        if(~PinState(e))
            StdOff = StdOff + 1;
        else
            break;
        end
    end
    ValidColors = fliplr(VfbTimePlotColors(PinState==1))
    for e = length(app.VFBtime_1.Children):-1:1
        errorbar(app.VFBtime_1.Children(e).XData,app.VFBtime_1.Children(e).YData,app.P(e+StdOff).VfbStd,ValidColors(e),'LineWidth', 2)
        title(app.VFBtime_1.Title.String);
        xlabel(app.VFBtime_1.XLabel.String);
        ylabel(app.VFBtime_1.YLabel.String);
        hold on
    end
    hold off
end