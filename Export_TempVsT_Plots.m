function Export_TempVsT_Plots(app,MD)
% ExportAllIvTPlots_ext
% Exports all the Temp vs time plots
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
% MD : struct
%   A data structure containing all measurement data

    % Determine the maximum time to assign units accordingly
    timeEnd = max([MD(1).ExpData.log.Ttime,MD(2).ExpData.log.Ttime,...
        MD(3).ExpData.log.Ttime]); 
    [timeUnit,timeFactor] = adjustTimeUnits(timeEnd);
    
    markers = ["o","s","d","^","v",">","<","p","h"];
    legendLabels = cell(3);
    figureTempvTBtime        = figure;%('visible','off'); 
    set(gca, 'FontSize',14)
    c = flipud(jet(3));
    colormap(c);
    hold on
    % Iterate over all the measurement units
    for k=1:3
        % Determine if we the measurement unit is connected
        isConnected = any(MD(k).PinState);
        if isConnected == 1
            % Get the value of the stress bias
            stressBias      = MD(k).ExpData.Setup.StressBiasValue;            
            % Construct the labels for the line
            legendLabels{k} = sprintf("MU%d, stress Bias = %.1f V",...
                    k,stressBias);
            tTime = MD(k).ExpData.log.Ttime/timeFactor;
            plot(tTime, MD(k).ExpData.log.T,'Marker',markers(k),...
                'LineWidth',2,'Color',c(k,:));
        end
    end % ends for k=1:3
    hold off
    title
    xlabelStr = sprintf("Time (%s)",timeUnit);
    xlabel(xlabelStr);
    ylabel("Temp (°C)");
    leg = legend(legendLabels,'Location','northeast');
    legend('boxoff');
    box on
    
    % Get the working directory from the GUI
    wd = app.FileLoc.Value;
    % Get the time stamp to add to the filetag
    tstamp = TimeStamp;
    % Construct the file tag
    filetag = "Figure_MU_TempVsTime" + tstamp;

    % Save the plot as .fig and as .jpeg
    try
        savefig(figureTempvTBtime,fullfile(wd,strcat(filetag,'.fig')));
        print(figureTempvTBtime,fullfile(wd,strcat(filetag,'.jpg')),'-djpeg','-r300');
    catch e
        display(e.message);
    end % try catch ends
end