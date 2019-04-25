function ExportAllIVsTPlots_ext(app)
% ExportAllIvTPlots_ext
% Exports all the I vs time plots
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
%
    % Determine the maximum time to assign units accordingly
    timeEnd = max(MD(1).ExpData.log.Itime);
    [timeUnit,timeFactor] = adjustTimeUnits(timeEnd);
    
    % Create the VFB figure
    figureIvTBtime        = figure;%('visible','off'); 
    set(gca, 'FontSize',14);
    hold on
    % Iterate over one (all) the measurement units
    for k=1:1
        % Determine if we the measurement unit is connected
        isConnected = any(app.MD(k).PinState);
        if isConnected == 1
            stressBias      = app.MD(k).ExpData.Setup.StressBiasValue;
            iTime = MD(1).ExpData.log.Itime./timeFactor;
            plot(iTime,MD(k).ExpData.log.I,'o-','LineWidth',2);
        end
    end % ends for k=1:3
    hold off
    title("I vs time");
    xlabelStr = sprintf("Time (%s)",timeUnit);
    xlabel(xlabelStr);
    ylabel("I (A)");
    box on
    
    % Add some info to the plot
    info_str = sprintf("Bias = %.1f V",...
        stressBias);
    info_txt = text(0.1,0.95,info_str,...
        'Units','normalized',...
        'HorizontalAlignment','left',...
        'VerticalAlignment','top');
    info_txt.Color  = 'k';
    info_txt.FontSize = 12;
    
    % Get the working directory from the GUI
    wd = app.FileLoc.Value;
    % Get the time stamp to add to the filetag
    tstamp = TimeStamp;
    % Construct the file tag
    filetag = "Figure_MU_IvsTime" + tstamp;
    % Save the plot as .fig and as .jpeg
    try
        savefig(figureIvTBtime,fullfile(wd,strcat(filetag,'.fig')));
        print(figureIvTBtime,fullfile(wd,strcat(filetag,'.jpg')),'-djpeg','-r300');
    catch e
        display(e.message);
    end % try catch ends
end